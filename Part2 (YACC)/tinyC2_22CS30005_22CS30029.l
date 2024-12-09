%{
    #include "tinyC2_22CS30005_22CS30029.tab.h"
    #include <string.h>
%}

%option yylineno

/* Comments */
MULTISEQ    [^*]|[*][^/]
MULTI_LINE  "/*"({MULTISEQ})*"/"
SINGLE_LINE "//".*
COMMENT {MULTI_LINE}|{SINGLE_LINE}

/* Keyword Definition */
KW   "auto"|"enum"|"restrict"|"unsigned"|"break"|"extern"|"return"|"void"|"case"|"float"|"short"|"volatile"|"char"|"for"|"signed"|"while"|"const"|"goto"|"sizeof"|"_Bool"|"continue"|"if"|"static"|"_Complex"|"default"|"inline"|"struct"|"_Imaginary"|"do"|"int"|"switch"|"double"|"long"|"typedef"|"else"|"register"|"union"

/* Identifier Definition */
ID_ND  [a-zA-Z_]
DIGIT   [0-9]
ID  {ID_ND}({ID_ND}|{DIGIT})*

/* Constant Definition */
INT_CONST   {DIGIT}+
DIGIT_SEQ     {DIGIT}+|\'{C_CHAR_SEQ}\'
FRACTIONAL_CONST    {DIGIT_SEQ}?\.{DIGIT_SEQ}|{DIGIT_SEQ}\.
EXPONENT    [eE][+-]?{DIGIT_SEQ}
FLOAT_CONST {FRACTIONAL_CONST}{EXPONENT}?|{DIGIT_SEQ}{EXPONENT}
ESCAPE_SEQ  \'|\"|\?|\[abfnrtv]|\\
C_CHAR  [^'\\\n]|{ESCAPE_SEQ}
C_CHAR_SEQ  {C_CHAR}+ 
CHAR_CONST  \'{C_CHAR_SEQ}\'
CONST   {INT_CONST}|{FLOAT_CONST}|{CHAR_CONST}

/* String Literal */
S_CHAR  [^"\\\n]|{ESCAPE_SEQ}
S_CHAR_SEQ  {S_CHAR}+
STRING_LIT  \"{S_CHAR_SEQ}?\"


/* Punctuators */
PUNC    "["|"]"|"("|")"|"{"|"}"|"."|"->"|"++"|"--"|"&"|"*"|"+"|"-"|"~"|"!"|"/"|"%"|"<<"|">>"|"<"|">"|"<="|">="|"=="|"!="|"^"|"|"|"&&"|"||"|"?"|":"|";"|"..."|"="|"*="|"/="|"%="|"+="|"-="|"<<="|">>="|"&="|"^="|"|="|","|"#"


%%

{KW}  { 
    /* Return the specific keyword token */
    if (strcmp(yytext, "auto") == 0) return AUTO;
    if (strcmp(yytext, "enum") == 0) return ENUM;
    if (strcmp(yytext, "restrict") == 0) return RESTRICT;
    if (strcmp(yytext, "unsigned") == 0) return UNSIGNED;
    if (strcmp(yytext, "break") == 0) return BREAK;
    if (strcmp(yytext, "extern") == 0) return EXTERN;
    if (strcmp(yytext, "return") == 0) return RETURN;
    if (strcmp(yytext, "void") == 0) return VOID;
    if (strcmp(yytext, "case") == 0) return CASE;
    if (strcmp(yytext, "float") == 0) return FLOAT;
    if (strcmp(yytext, "short") == 0) return SHORT;
    if (strcmp(yytext, "volatile") == 0) return VOLATILE;
    if (strcmp(yytext, "char") == 0) return CHAR;
    if (strcmp(yytext, "for") == 0) return FOR;
    if (strcmp(yytext, "signed") == 0) return SIGNED;
    if (strcmp(yytext, "while") == 0) return WHILE;
    if (strcmp(yytext, "const") == 0) return CONST;
    if (strcmp(yytext, "goto") == 0) return GOTO;
    if (strcmp(yytext, "sizeof") == 0) return SIZEOF;
    if (strcmp(yytext, "_Bool") == 0) return BOOL;
    if (strcmp(yytext, "continue") == 0) return CONTINUE;
    if (strcmp(yytext, "if") == 0) return IF;
    if (strcmp(yytext, "static") == 0) return STATIC;
    if (strcmp(yytext, "_Complex") == 0) return COMPLEX;
    if (strcmp(yytext, "default") == 0) return DEFAULT;
    if (strcmp(yytext, "inline") == 0) return INLINE;
    if (strcmp(yytext, "struct") == 0) return STRUCT;
    if (strcmp(yytext, "_Imaginary") == 0) return IMAGINARY;
    if (strcmp(yytext, "do") == 0) return DO;
    if (strcmp(yytext, "int") == 0) return INT;
    if (strcmp(yytext, "switch") == 0) return SWITCH;
    if (strcmp(yytext, "double") == 0) return DOUBLE;
    if (strcmp(yytext, "long") == 0) return LONG;
    if (strcmp(yytext, "typedef") == 0) return TYPEDEF;
    if (strcmp(yytext, "else") == 0) return ELSE;
    if (strcmp(yytext, "register") == 0) return REGISTER;
    if (strcmp(yytext, "union") == 0) return UNION;

}

{ID}  { 
    yylval.strVal = strdup(yytext);
    return IDENTIFIER; 
}


{CONST} { 
    yylval.strVal= strdup(yytext);
    return CONSTANT; 
}

{STRING_LIT} { 
    yylval.strVal = strdup(yytext);
    return STRING_LITERAL; 
}

{PUNC}  { 

    /* Brackets */
    if (strcmp(yytext, "[") == 0) return LEFT_BRACKET;
    if (strcmp(yytext, "]") == 0) return RIGHT_BRACKET;
    if (strcmp(yytext, "(") == 0) return LEFT_PAREN;
    if (strcmp(yytext, ")") == 0) return RIGHT_PAREN;
    if (strcmp(yytext, "{") == 0) return LEFT_BRACE;
    if (strcmp(yytext, "}") == 0) return RIGHT_BRACE;

    /* Arithmetic Operators */
    if (strcmp(yytext, "++") == 0) return INCREMENT;
    if (strcmp(yytext, "--") == 0) return DECREMENT;
    if (strcmp(yytext, "*") == 0) return STAR;
    if (strcmp(yytext, "/") == 0) return DIVIDE;
    if (strcmp(yytext, "%") == 0) return MODULO;
    if (strcmp(yytext, "+") == 0) return PLUS;
    if (strcmp(yytext, "-") == 0) return MINUS;

    /* Relational Operators */
    if (strcmp(yytext, "<") == 0) return LESS_THAN;
    if (strcmp(yytext, ">") == 0) return GREATER_THAN;
    if (strcmp(yytext, "<=") == 0) return LESS_THAN_EQUAL;
    if (strcmp(yytext, ">=") == 0) return GREATER_THAN_EQUAL;
    if (strcmp(yytext, "==") == 0) return EQUAL;
    if (strcmp(yytext, "!=") == 0) return NOT_EQUAL;


    /* Logical Operators */
    if (strcmp(yytext, "&&") == 0) return LOGICAL_AND;
    if (strcmp(yytext, "||") == 0) return LOGICAL_OR;
    if(strcmp(yytext, "!") == 0) return LOGICAL_NOT;

    /* Bitwise Operators */
    if (strcmp(yytext, "&") == 0) return BITWISE_AND;
    if (strcmp(yytext, "|") == 0) return BITWISE_OR;
    if (strcmp(yytext, "^") == 0) return BITWISE_XOR;
    if (strcmp(yytext, "~") == 0) return BITWISE_NOT;
    if (strcmp(yytext, "<<") == 0) return LEFT_SHIFT;
    if (strcmp(yytext, ">>") == 0) return RIGHT_SHIFT;

    /* Assignment Operators */
    if (strcmp(yytext, "=") == 0) return ASSIGN;
    if (strcmp(yytext, "+=") == 0) return PLUS_ASSIGN;
    if (strcmp(yytext, "-=") == 0) return MINUS_ASSIGN;
    if (strcmp(yytext, "*=") == 0) return STAR_ASSIGN;
    if (strcmp(yytext, "/=") == 0) return DIVIDE_ASSIGN;
    if (strcmp(yytext, "%=") == 0) return MODULO_ASSIGN;
    if (strcmp(yytext, "&=") == 0) return BITWISE_AND_ASSIGN;
    if (strcmp(yytext, "|=") == 0) return BITWISE_OR_ASSIGN;
    if (strcmp(yytext, "^=") == 0) return BITWISE_XOR_ASSIGN;
    if (strcmp(yytext, "<<=") == 0) return LEFT_SHIFT_ASSIGN;
    if (strcmp(yytext, ">>=") == 0) return RIGHT_SHIFT_ASSIGN;

    /* Other Punctuators */
    if (strcmp(yytext, "?") == 0) return QUESTION_MARK;
    if (strcmp(yytext, ":") == 0) return COLON;
    if (strcmp(yytext, ";") == 0) return SEMICOLON;
    if (strcmp(yytext, ",") == 0) return COMMA;
    if (strcmp(yytext, ".") == 0) return DOT;
    if (strcmp(yytext, "->") == 0) return ARROW;
    if (strcmp(yytext, "...") == 0) return ELLIPSIS;

    if(strcmp(yytext, "#") == 0) return HASH;


}

{COMMENT}   { /* Ignore comments */ }

[ \t\n]+    { /* Ignore whitespace */ }

.           { printf("ERROR in Line %d : Invalid token %s\n", yylineno, yytext);  }

%%


int yywrap(void) {
    return 1;
}