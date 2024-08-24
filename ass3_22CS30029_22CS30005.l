%{
    #include <stdio.h>
    #define KW 1
    #define ID 2
    #define CONST 3
    #define SL 4
    #define PUNC 5
%}


/*Keyword Definition*/

KW   "auto"|"enum"|"restrict"|"unsigned"|"break"|"extern"|"return"|"void"|"case"|"float"|"short"|"volatile"|"char"|"for"|"signed"|"while"|"const"|"goto"|"sizeof"|"Bool"|"continue"|"if"|"static"|"Complex"|"default"|"inline"|"struct"|"Imaginary"|"do"|"int"|"switch"|"double"|"long"|"typedef"|"else"|"register"|"union"

/*Identifier Definition*/

ID_ND  [a-zA-Z_]
DIGIT   [0-9]
ID  {ID_ND}({ID_ND}|{DIGIT})*

/* Constant Definition*/

INT_CONST   {DIGIT}+
DIGIT_SEQ     {DIGIT}+
FRACTIONAL_CONST    {DIGIT_SEQ}?.{DIGIT_SEQ}|{DIGIT_SEQ}.
EXPONENT    [eE][+-]?{DIGIT_SEQ}
FLOAT_CONST {FRACTIONAL_CONST}{EXPONENT}?|{DIGIT_SEQ}{EXPONENT}
ESCAPE_SEQ  \\(['"\?\\abfnrtv])
C_CHAR  [^'\\\n]|{ESCAPE_SEQ}
C_CHAR_SEQ  {C_CHAR}+ 
CHAR_CONST  \'{C_CHAR_SEQ}\'
CONST   {INT_CONST}|{FLOAT_CONST}|{CHAR_CONST}
/*String Literal*/

S_CHAR  {ESCAPE_SEQ}|[^"\\\n]
S_CHAR_SEQ  {S_CHAR}+
STRING_LIT  \"{S_CHAR_SEQ}?\"

/*Punctuators*/

PUNC    "["|"]"|"("|")"|"{"|"}"|"."|"->"|"++"|"--"|"&"|"*"|"+"|"-"|"~"|"!"|"/"|"%"|"<<"|">>"|"<"|">"|"<="|">="|"=="|"!="|"^"|"|"|"&&"|"||"|"?"|":"|";"|"..."|"="|"*="|"/="|"%="|"+="|"-="|"<<="|">>="|"&="|"^="|"|="|","|"#"

/*Comments*/

MULTI_LINE  "/*"([^*]|[\r\n]|(\*+([^*/]|[\r\n])))*\*+"/"
SINGLE_LINE "//".*
COMMENT {MULTI_LINE}|{SINGLE_LINE}


%%

{KW}  {return KW;}
{ID}  {return ID;}
{CONST} {return CONST;}
{STRING_LIT}    {return SL;}
{PUNC}  {return PUNC;}
{COMMENT}   {/*nothing returned*/}
[ \t\n]+    {/* ignore whitespace */}
.           { printf("Error: Unrecognized character %s\n", yytext); }

%%

int main() {
    int token;
    while ((token = yylex()) != 0) {
        switch(token) {
            case KW:
                printf("KEYWORD: %s\n", yytext);
                break;
            case ID:
                printf("IDENTIFIER: %s\n", yytext);
                break;
            case CONST:
                printf("CONSTANT: %s\n", yytext);
                break;
            case SL:
                printf("STRING LITERAL: %s\n", yytext);
                break;
            case PUNC:
                printf("PUNCTUATOR: %s\n", yytext);
                break;
            default:
                printf("UNKNOWN TOKEN: %s\n", yytext);
        }
    }
    return 0;
}
int yywrap(void){
    return 1;
}