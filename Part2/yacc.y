%{
#include <stdio.h>
extern int yylex();
void yyerror(char *s);
%}

%union {
    char* string;
    int integer;
    float floating;
    char character;
}


