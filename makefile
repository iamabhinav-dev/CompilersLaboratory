
all: clean compile run p_clean

clean:
	rm -f lex.yy.c a.out

compile:ass3_22CS30029_22CS30005.l ass3_22CS30029_22CS30005.c
	flex ass3_22CS30029_22CS30005.l
	gcc ass3_22CS30029_22CS30005.c

run:a.out
	./a.out < ass3_22CS30029_22CS30005_test.c
	
p_clean:
	rm -f lex.yy.c a.out
