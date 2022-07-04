cd src/
#00
./mind -l 5 /home/jzh/compiler-dev/minidecaf/hello.sy >test.s
riscv64-unknown-elf-gcc -march=rv32im -mabi=ilp32 test.s
qemu-riscv32 a.out
echo $?
#01
# ./mind -l 5 /home/jzh/compiler-dev/minidecaf/testfile/02_var_defn2.sy >test.s
# riscv64-unknown-elf-gcc -march=rv32im -mabi=ilp32 test.s
# qemu-riscv32 a.out
# echo $?
# #02
# ./mind -l 5 /home/jzh/compiler-dev/minidecaf/testfile/02_var_defn3.sy >test.s
# riscv64-unknown-elf-gcc -march=rv32im -mabi=ilp32 test.s
# qemu-riscv32 a.out
# echo $?
# #03
# ./mind -l 5 /home/jzh/compiler-dev/minidecaf/testfile/03_arr_defn2.sy >test.s
# riscv64-unknown-elf-gcc -march=rv32im -mabi=ilp32 test.s
# qemu-riscv32 a.out
# echo $?
# #04
# ./mind -l 5 /home/jzh/compiler-dev/minidecaf/testfile/04_arr_defn3.sy >test.s
# riscv64-unknown-elf-gcc -march=rv32im -mabi=ilp32 test.s
# qemu-riscv32 a.out
# echo $?