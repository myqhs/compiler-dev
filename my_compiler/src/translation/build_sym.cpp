/*****************************************************
 *  Implementation of the first semantic analysis pass.
 *
 *  In the first pass, we will:
 *    1. create appropriate type::Type instances for the types;
 *    2. create and manage scope::Scope instances;
 *    3. create symb::Symbol instances;
 *    4. manage the symbol tables.
 *  After this pass, the ATTR(sym) or ATTR(type) attributs of the visited nodes
 *  should have been set.
 *
 *  Keltin Leung
 */

#include "ast/ast.hpp"
#include "ast/visitor.hpp"
#include "compiler.hpp"
#include "config.hpp"
#include "scope/scope.hpp"
#include "scope/scope_stack.hpp"
#include "symb/symbol.hpp"
#include "type/type.hpp"

using namespace mind;
using namespace mind::scope;
using namespace mind::symb;
using namespace mind::type;
using namespace mind::err;

/* Pass 1 of the semantic analysis.
 */
class SemPass1 : public ast::Visitor {
public:
  // visiting declarations
  virtual void visit(ast::FuncDefn *);
  virtual void visit(ast::Program *);
  virtual void visit(ast::IfStmt *);
  virtual void visit(ast::WhileStmt *);
  virtual void visit(ast::CompStmt *);
  virtual void visit(ast::ForStmt *);
  virtual void visit(ast::VarDecl *);
  // visiting types
  virtual void visit(ast::IntType *);
};

/* Visiting an ast::Program node.
 *
 * PARAMETERS:
 *   prog  - the ast::Progarm node to visit
 */
// 从程序的Program根节点进行遍历
void SemPass1::visit(ast::Program *prog) {
  // 新建一个全局作用域
  prog->ATTR(gscope) = new GlobalScope();
  // open作用域
  scopes->open(prog->ATTR(gscope));

  // 循环访问每个全局变量和函数声明
  for (auto it = prog->func_and_globals->begin();
       it != prog->func_and_globals->end(); ++it) {
    (*it)->accept(this); // 采用accept方法对节点进行访问

    // 访问到名为main的主函数FUNC_DEFN定义节点
    if ((*it)->getKind() == mind::ast::ASTNode::FUNC_DEFN &&
        std::string("main") == dynamic_cast<mind::ast::FuncDefn *>(*it)->name)
      //建立节点与符号表的联系
      prog->ATTR(main) = dynamic_cast<mind::ast::FuncDefn *>(*it)->ATTR(sym);
  }
  // 关闭作用域
  scopes->close();
}

/* Visiting an ast::FunDefn node.
 *
 * NOTE:
 *   tasks include:
 *   1. build up the Function symbol
 *   2. build up symbols of the parameters
 *   3. build up symbols of the local variables
 *
 *   we will check Declaration Conflict Errors for symbols declared in the SAME
 *   class scope, but we don't check such errors for symbols declared in
 *   different scopes here (we leave this task to checkOverride()).
 * PARAMETERS:
 *   fdef  - the ast::FunDefn node to visit
 */
void SemPass1::visit(ast::FuncDefn *fdef) {
  // 访问并保存返回类型
  fdef->ret_type->accept(this);
  Type *t = fdef->ret_type->ATTR(type);
  // 新建一个符号表Function节点，传入函数名和位置参数
  Function *f = new Function(fdef->name, t, fdef->getLocation());
  fdef->ATTR(sym) = f;

  // 在符号表中检查是否已出现同一定义，未出现则在符号表中声明
  Symbol *sym = scopes->lookup(fdef->name, fdef->getLocation(), false);
  if (NULL != sym)
    issue(fdef->getLocation(), new DeclConflictError(fdef->name, sym));
  else
    scopes->declare(f);

  // 检查完成后，为新声明的函数新建函数作用域
  scopes->open(f->getAssociatedScope());

  // 循环访问，添加参数至符号表
  for (ast::VarList::iterator it = fdef->formals->begin();
       it != fdef->formals->end(); ++it) {
    (*it)->accept(this);
    f->appendParameter((*it)->ATTR(sym));
  }

  // 添加局部变量
  for (auto it = fdef->stmts->begin(); it != fdef->stmts->end(); ++it)
    (*it)->accept(this);

  // 关闭函数作用域
  scopes->close();
}

/* Visits an ast::IfStmt node.
 *
 * PARAMETERS:
 *   e     - the ast::IfStmt node
 */
void SemPass1::visit(ast::IfStmt *s) {
  // 访问条件语句
  s->condition->accept(this);
  // 访问true分支
  s->true_brch->accept(this);
  // 访问false分支
  s->false_brch->accept(this);
}

/* Visits an ast::WhileStmt node.
 *
 * PARAMETERS:
 *   e     - the ast::WhileStmt node
 */
void SemPass1::visit(ast::WhileStmt *s) {
  // 访问条件语句
  s->condition->accept(this);
  // 访问循环体
  s->loop_body->accept(this);
}

/* Visits an ast::ForStmt node.
 *
 * PARAMETERS:
 *   e     - the ast::ForStmt node
 */
void SemPass1::visit(ast::ForStmt *s) {
  // 为for语句新建局部作用域
  Scope *scope = new LocalScope();
  s->ATTR(scope) = scope;
  scopes->open(scope);
  // 访问定义语句
  if (s->init != NULL)
    s->init->accept(this);
  // 访问条件语句
  if (s->condition != NULL)
    s->condition->accept(this);
  // 访问更新语句
  if (s->update != NULL)
    s->update->accept(this);
  // 访问循环体
  s->loop_body->accept(this);
  scopes->close();
}
/* Visiting an ast::CompStmt node.
 */
void SemPass1::visit(ast::CompStmt *c) {
  // opens function scope
  Scope *scope = new LocalScope();
  c->ATTR(scope) = scope;
  scopes->open(scope);

  // adds the local variables
  for (auto it = c->stmts->begin(); it != c->stmts->end(); ++it)
    (*it)->accept(this);

  // closes function scope
  scopes->close();
}
/* Visiting an ast::VarDecl node.
 *
 * NOTE:
 *   we will check Declaration Conflict Errors for symbols declared in the SAME
 *   function scope, but we don't check such errors for symbols declared in
 *   different scopes here (we leave this task to checkOverride()).
 * PARAMETERS:
 *   vdecl - the ast::VarDecl node to visit
 */
void SemPass1::visit(ast::VarDecl *vdecl) {
  Type *t = NULL;
  // 访问变量类型的节点
  vdecl->type->accept(this);
  // 获取变量的维度，判断是否为数组类型
  if (vdecl->dim != NULL) {
    int length = 1;
    for (int d : *(vdecl->dim)) {
      length *= d;
    }
    // 若长度为0，报错
    if (length == 0) {
      issue(vdecl->getLocation(), new ZeroLengthedArrayError());
      return;
    }
    // 若为数组类型，新建ArrayType节点
    vdecl->type->ATTR(type) = new ArrayType(vdecl->type->ATTR(type), length);
  }
  t = vdecl->type->ATTR(type);
  // 新建Variable节点
  vdecl->ATTR(sym) =
      new Variable(vdecl->name, t, vdecl->dim, vdecl->getLocation());
  // 在当前作用域的符号表中查找是否已出现变量定义
  Symbol *s = scopes->lookup(vdecl->name, vdecl->getLocation(), 0);
  if (s != NULL) {
    issue(vdecl->getLocation(), new DeclConflictError(vdecl->name, s));
  }
  scopes->declare(vdecl->ATTR(sym));
}

/* Visiting an ast::IntType node.
 *
 * PARAMETERS:
 *   itype - the ast::IntType node to visit
 */
void SemPass1::visit(ast::IntType *itype) { itype->ATTR(type) = BaseType::Int; }

// 遍历第一遍AST，生成符号表
void MindCompiler::buildSymbols(ast::Program *tree) {
  tree->accept(new SemPass1());
}
