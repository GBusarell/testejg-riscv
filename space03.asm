#BMP, PXWidth 4x4, display 128x256
#passar cores pra algum vetor
#jr ra -> return
.data 
char: 0x000000, 0x000000, 0x090000, 0x000000, 0x000000, 0x000000, 0x000000, 0x090000, 0x000000, 0x000000, 0x000000, 0x090000, 0x090000, 0x090000, 0x000000, 0x000000, 0x090000, 0x29329c, 0x090000, 0x000000, 0x090000, 0x090000, 0x29329c, 0x090000, 0x090000, 0x090000, 0x090000, 0x090000, 0x090000, 0x090000, 0x177d36, 0x000000, 0x000000, 0x000000, 0x9b0d14

.text
li s0, 0x10040000 #memoryadress
li s1, 0x15011f #background
li s2, 0xff6ead #char
li s3, 0xffffff #branco
li s4, 0xc3ff0000 #ray
li s10, 32 #tam [X]
li s11, 64 #tam [Y]
li s9, +2112 #s9 = pos
mv s8, s9

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
clearchar:
li t0, 5
li t1, 7
li t5, 0xffffff

add t2, s0, s8 #t2 = matriz+expos
addi t2, t2, -520
exforchary:
	exforcharx:
	sw s1, (t2) #s1 = bckgrnd
	addi t2, t2, 4 #m[x++]
	
	addi t0, t0, -1 #x
	bgtz t0, exforcharx
addi t2, t2, 108 #m[y++]
li t0, 5
addi t1, t1, -1 #y
bgtz t1, exforchary

jr ra
#=====#


#=====#
drawchar:
#char[5][7]
#canvas [32][64]
#s9 = pos, s8 = expos
li t0, 5 #charX
li t1, 7 #charY
li t2, 0
li t3, 0
li t4, 0
li t5, 0
la t6, char

forchary:
li t0, 5
	forcharx:
	addi t0, t0, -1
	
	lw t5, (t6) #loadsprite
	addi t6, t6, 4
	add t3, s0, s9 ###
	addi t3, t3, -520
	add t4, t2, t2
	add t4, t4, t4 #cont*4
	add t3, t3, t4
	beq t5, zero, skip
	sw t5, (t3)
	skip:
	
	
	addi t2, t2, 1 #!counterxy
	bgtz t0, forcharx
addi t1, t1, -1
addi t2, t2, 27
bgtz t1, forchary
	
jr ra
#=====#


#=====#
keystroke:
li t6, 0xffff0004 #inputbuffer
lw t0, (t6) #t0 <- keyboardinput

li t1, 119 #check w
beq t0, t1, cima #if(w)
li t1, 100 #check d
beq t0, t1, direita #if(d)
li t1, 115 #check s
beq t0, t1, baixo #if(s)
li t1, 97 #check a
beq t0, t1, esquerda #if(a)
li t1, 114 #check r
beq t0, t1, fim #if(r)
li t1, 32
beq t0, t1, tiro #if( )


jr ra

#switch
cima:
mv s8, s9
addi s9, s9, -128
b charprep

direita:
mv s8, s9
addi s9, s9, +4
b charprep

esquerda:
mv s8, s9
addi s9, s9, -4
b charprep

baixo:
mv s8, s9
addi s9, s9, +128
b charprep

tiro:
mv a0, ra
li t0, 0
sw zero, (t6)
b spawntiro
jr ra

charprep:
li t0, 0 #clearinput
sw zero, (t6) #clearinputcache

mv a0, ra #leaf+
jal clearchar
mv ra, a0 #leaf-

mv a0, ra
jal drawchar
mv ra, a0
jr ra
#=====#

#=====#
spawntiro:
add t0, s0, s9
addi t0, t0, -640
sw s4, (t0)
jr ra
#=====#

#=====#
drawtime:
addi s5, s5, 1
andi t0, s5, 1

beqz t0, drawtimepar

drawtimeimpar:
li t0, 0x000000
sw t0, +8(s0)
jr ra

drawtimepar:
li t0, 0xffffff
sw t0, +8(s0)
jr ra

#=====#

#=====#
runrays:
li t0, 0
li t1, 0
li t4, 0x00ff0000
add t6, s0, zero
forrayy:
	forrayx:
	lw t2, (t6)
	slli t2, t2, 8
	srli t2, t2, 8
	beq t2, t4, pray
	prayrtrn:
	#---
	addi t6, t6, 4
	addi t0, t0, 1
	blt t0, s10, forrayx
addi t1, t1, 1
li t0, 0
blt t1, s11, forrayy

jr ra

pray: 
sw s4, -128(t6)
sw s1, (t6)
b prayrtrn

#=====#


#=====#
main:
jal drawall
jal drawchar
#gameloop
loop:
jal keystroke
jal drawtime
jal runrays
b loop
fim:
li a7, 10
ecall
#=====#





