#BMP, PXWidth 4x4, display 128
.text
li s0, 0x10010000 #memoryadress
li s1, 0xa497ce #background
li s2, 0x0000FF #cor2
li s3, 0 #reservado pra alguma cor
li s4, 500 #flashes

li s10, 32 #tam [X]
li s11, 32 #tam [Y]

#loops
loopao:
fory:
beq s11, t1, fim
forx:
#--------
andi t5, s4, 1
beqz t5, par
b impar
lw a6, 0xffff0004

par:
mv s3, s1
b print
impar:
mv s3, s2
b print
print:
sw s3, (s0)
addi s0, s0, +4
#--------
addi t0, t0, 1 #x++
bne t0, s10 forx #t0!=X -> loopx
addi t1, t1, 1 #y++
li t0, 0 #resetX
b fory

fim:
addi s4, s4, -1
li t0, 0
li t1, 0
li s0, 0x10010000
bge s4, zero, loopao

li a7,10
ecall




