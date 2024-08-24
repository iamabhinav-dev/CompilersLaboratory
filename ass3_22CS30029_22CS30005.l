%{
    #define KW 1
    #define ID 2
    #define CONST 3
    #define SL 4
    #define PUNC 5
%}

%%

// Keyword Definition

KW   "auto"|"enum"|"restrict"|"unsigned"|"break"|"extern"|"return"|"void"|"case"|"float"|"short"|"volatile"|"char"|"for"|"signed"|"while"|"const"|"goto"|"sizeof"|"Bool"|"continue"|"if"|"static"|"Complex"|"default"|"inline"|"struct"|"Imaginary"|"do"|"int"|"switch"|"double"|"long"|"typedef"|"else"|"register"|"union"

// Identifier Definition

ID_ND  [a-zA-Z_]
DIGIT   [0-9]
ID  {ID_ND}|{ID}{ID_ND}|{ID}{DIGIT}

// Constant Definition

NONZERO_DIG   [1-9]
INT_CONST   {NONZERO_DIG}|{INT_CONST}{DIGIT}
DIGIT_SEQ     {DIGIT}+ //REMOVED LEFT RECURSION {DIGIT}|{DIGIT_SEQ}{DIGIT}
FRACTIONAL_CONST    {DIGIT_SEQ}?.{DIGIT_SEQ}|{DIGIT_SEQ}.
EXPONENT    e?{DIGIT_SEQ}|E?{DIGIT_SEQ}
FLOAT_CONST {FRACTIONAL_CONST}{EXPONENT}?|{DIGIT_SEQ}{EXPONENT}
ENUM_CONST  {ID}
ESCAPE_SEQ  "\'"|"\""|"\?"|"\\"|"\a"|"\b"|"\f"|"\n"|"\r"|"\t"|"\v"
// C_CHAR  [^\'\\\n]|{ESCAPE_SEQ}
C_CHAR_SEQ  {C_CHAR}+ //REMOVED LEFT RECURSION {C_CHAR}|{C_CHAR_SEQ}{C_CHAR}
CHAR_CONST  \'{C_CHAR_SEQ}\'
CONST   {INT_CONST}|{FLOAT_CONST}|{ENUM_CONST}|{CHAR_CONST}
// String Literal

// S_CHAR  {ESCAPE_SEQ}|[^\"\\\n]
S_CHAR_SEQ  {S_CHAR}+ //REMOVED LEFT RECURSION {S_CHAR}|{S_CHAR_SEQ}{S_CHAR}
STRING_LIT  "{S_CHAR_SEQ}?"

// Punctuators

PUNC    "["|"]"|"("|")"|"{"|"}"|"."|"->"|"++"|"--"|"&"|"*"|"+"|"-"|"~"|"!"|"/"|"%"|"<<"|">>"|"<"|">"|"<="|">="|"=="|"!="|"^"|"|"|"&&"|"||"|"?"|":"|";"|"..."|"="|"*="|"/="|"%="|"+="|"-="|"<<="|">>="|"&="|"^="|"|="|","|"#"

// Comments

MULTI_LINE  "/*"([^*]|[\r\n]|(\*+([^*/]|[\r\n])))*\*+"/"
SINGLE_LINE "//".*
COMMENT {MULTI_LINE}|{SINGLE_LINE}



{KW}  {return KW;}
{ID}  {return ID;}
{CONST} {return CONST;}
{STRING_LIT}    {return SL;}
{PUNC}  {return PUNC;}
{COMMENT}   {/*nothing returned*/}

int yywrap(void){
    return 1;
}