#BMP, PXWidth 4x4, display 128
#passar cores pra algum vetor
#jr ra -> return
.text
li s0, 0x10010000 #memoryadress
li s1, 0xa497ce #background
li s2, 0xff6ead #char
li s3, 0 #reservado pra alguma cor
li s4, 500 #flashes
li s10, 32 #tam [X]
li s11, 32 #tam [Y]
li s9, +2112 #s9 = pos

b main

#=====#
drawall:
li t0, 0 #reset i count
li t1, 0 #reset j count
mv t2, s0 #t2 <- basematriz
mv t3, s1 #t3 <- corprint

sety:
addi t1, t1, 1
setx:
addi t0, t0, 1
#Code+
sw t3, (t2)
addi t2, t2, 4 #offset [x]+1
#Code-
blt t0, s10, setx #loopx
li t0, 0 #resetx
blt t1, s11, sety #loopy
jr ra
#=====#


#=====#
drawchar:
mv t0, s0 #t0 <- basematriz
mv t1, s2 #colorchar
add t0, t0, s9 #t0 = matriz ++ poschar
#printchar
sw t1, (t0)
sw t1, -4(t0)
sw t1, +4(t0)
sw t1, -128(t0)
sw t1, -256(t0)
#pos pas
jr ra
#=====#

#=====#
keystroke:
li t6, 0xffff0004 #inputbuffer

lw t0, (t6) #t0 <- keyboardinput
li t1, 119 #t1 = ascii (w)
li t2, 100 #t2 = ascii (d)
li t3, 115 #t3 = ascii (s)
li t4, 97 #t4 = ascii (a)
li t5, 114 #t5 = ascii (r)
beq t0, t1, cima #if(input = w)
beq t0, t2, direita #if(input = d)
beq t0, t3, baixo
beq t0, t4, esquerda
beq t0, t5, fim
jr ra

#switch
cima:
addi s9, s9, -128
b charprep

direita:
addi s9, s9, +4
b charprep

esquerda:
addi s9, s9, -4
b charprep

baixo:
addi s9, s9, +128
b charprep

charprep:
li t0, 0 #clearinput
sw zero, (t6) #clearinputcache

mv a0, ra #leaf+
jal drawchar
mv ra, a0 #leaf-
jr ra
#=====#


#=====#
main:
jal drawall
jal drawchar
loop:
jal keystroke
b loop
fim:
li a7, 10
ecall
#=====#





