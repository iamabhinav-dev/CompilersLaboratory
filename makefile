
all: lexer

lexer: lex.yy.c ass3_22CS30029_22CS30005.c
	gcc   ass3_22CS30029_22CS30005.c

lex.yy.c: ass3_22CS30029_22CS30005.l
	flex ass3_22CS30029_22CS30005.l

clean:
	rm -f lexer lex.yy.c

.PHONY: all clean