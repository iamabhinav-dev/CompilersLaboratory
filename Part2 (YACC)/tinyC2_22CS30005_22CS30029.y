%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "tinyC2_22CS30005_22CS30029.h"

int yylex();
void yyerror(const char *s);
%}

%code requires{
    struct Node {
    char data[100];   // String data for the node
    struct Node* child;
    struct Node* sibling;
};

}
%union {
    char* strVal;
    int integer;
    float floating;
    char character;
    struct Node* node;
}

%token <strVal> IDENTIFIER STRING_LITERAL CONSTANT

%token AUTO ENUM RESTRICT UNSIGNED BREAK EXTERN RETURN VOID CASE
%token FLOAT SHORT VOLATILE CHAR FOR SIGNED WHILE CONST GOTO SIZEOF BOOL
%token CONTINUE IF STATIC COMPLEX DEFAULT INLINE STRUCT IMAGINARY DO
%token INT SWITCH DOUBLE LONG TYPEDEF ELSE REGISTER UNION

%token LEFT_BRACKET RIGHT_BRACKET LEFT_PAREN RIGHT_PAREN LEFT_BRACE RIGHT_BRACE
%token INCREMENT DECREMENT STAR DIVIDE MODULO PLUS MINUS 
%token LESS_THAN GREATER_THAN LESS_THAN_EQUAL GREATER_THAN_EQUAL EQUAL NOT_EQUAL 
%token LOGICAL_AND LOGICAL_OR LOGICAL_NOT
%token BITWISE_AND BITWISE_OR BITWISE_XOR BITWISE_NOT LEFT_SHIFT RIGHT_SHIFT
%token ASSIGN PLUS_ASSIGN MINUS_ASSIGN STAR_ASSIGN DIVIDE_ASSIGN MODULO_ASSIGN BITWISE_AND_ASSIGN BITWISE_OR_ASSIGN BITWISE_XOR_ASSIGN LEFT_SHIFT_ASSIGN RIGHT_SHIFT_ASSIGN
%token QUESTION_MARK COLON SEMICOLON COMMA DOT ARROW ELLIPSIS HASH

%start translation_unit

%left PLUS MINUS STAR DIVIDE MODULO           
%left LEFT_SHIFT RIGHT_SHIFT       
%left LESS_THAN GREATER_THAN LESS_THAN_EQUAL GREATER_THAN_EQUAL 
%left EQUAL NOT_EQUAL      
%left BITWISE_AND         
%left BITWISE_XOR       
%left BITWISE_OR       
%left LOGICAL_AND        
%left LOGICAL_OR          
%right ASSIGN            
%right PLUS_ASSIGN MINUS_ASSIGN STAR_ASSIGN DIVIDE_ASSIGN MODULO_ASSIGN 

%nonassoc LOWER_THAN_ELSE 
%nonassoc ELSE            
%nonassoc QUESTION_MARK COLON 
%right LOGICAL_NOT       
%define parse.error verbose

%type <node> primary_expression postfix_expression argument_expression_list_opt argument_expression_list unary_expression unary_operator cast_expression multiplicative_expression additive_expression shift_expression relational_expression equality_expression AND_expression exclusive_OR_expression inclusive_OR_expression logical_AND_expression logical_OR_expression conditional_expression assignment_expression assignment_operator expression constant_expression declaration declaration_specifiers init_declarator_list_opt init_declarator_list init_declarator storage_class_specifier type_specifier specifier_qualifier_list specifier_qualifier_list_opt type_qualifier function_specifier declarator direct_declarator pointer type_qualifier_list parameter_type_list parameter_list parameter_declaration identifier_list type_name initializer initializer_list designation designator_list designator statement labeled_statement compound_statement block_item_list block_item expression_statement selection_statement iteration_statement jump_statement translation_unit external_declaration function_definition declaration_list pointer_opt type_qualifier_list_opt assignment_expression_opt identifier_list_opt designation_opt block_item_list_opt expression_opt declaration_list_opt declaration_specifiers_opt


%%

primary_expression:
    IDENTIFIER {$$=createNode($1);}
    | CONSTANT {$$=createNode($1);}
    | STRING_LITERAL {$$=createNode($1);}
    | LEFT_PAREN expression RIGHT_PAREN{
        $$=createNode("primary_expression");
        insertChild($$, createNode("("));
        insertChild($$, $2);
        insertChild($$, createNode(")"));
    }
;

postfix_expression:
    primary_expression{
        $$=createNode("postfix_expression"); 
        insertChild($$, $1);
        }
    | postfix_expression LEFT_BRACKET expression RIGHT_BRACKET{
        $$=createNode("postfix_expression"); 
        insertChild($$, $1);
        insertChild($$, createNode("["));
        insertChild($$, $3);
        insertChild($$, createNode("]"));
    }
    | postfix_expression LEFT_PAREN argument_expression_list_opt RIGHT_PAREN{
        $$=createNode("postfix_expression"); 
        insertChild($$, $1);
        insertChild($$, createNode("("));
        insertChild($$, $3);
        insertChild($$, createNode(")"));
    }
    | postfix_expression DOT IDENTIFIER{
        $$=createNode("postfix_expression"); 
        insertChild($$, $1);
        insertChild($$, createNode("."));
        insertChild($$, createNode($3));
    }
    | postfix_expression ARROW IDENTIFIER{
        $$=createNode("postfix_expression"); 
        insertChild($$, $1);
        insertChild($$, createNode("->"));
        insertChild($$, createNode($3));
    }
    | postfix_expression INCREMENT{
        $$=createNode("postfix_expression"); 
        insertChild($$, $1);
        insertChild($$, createNode("++"));
    }
    | postfix_expression DECREMENT{
        $$=createNode("postfix_expression"); 
        insertChild($$, $1);
        insertChild($$, createNode("--"));
    }
    | LEFT_PAREN type_name RIGHT_PAREN LEFT_BRACE initializer_list RIGHT_BRACE{
        $$=createNode("postfix_expression"); 
        insertChild($$, createNode("("));
        insertChild($$, ($2));
        insertChild($$, createNode(")"));
        insertChild($$, createNode("{"));
        insertChild($$, $5);
        insertChild($$, createNode(","));
        insertChild($$, createNode("}"));
    }
    | LEFT_PAREN type_name RIGHT_PAREN LEFT_BRACE initializer_list COMMA RIGHT_BRACE{
        $$=createNode("postfix_expression"); 
        insertChild($$, createNode("("));
        insertChild($$, ($2));
        insertChild($$, createNode(")"));
        insertChild($$, createNode("{"));
        insertChild($$, $5);
        insertChild($$, createNode(","));
        insertChild($$, createNode("}"));
    }
;

argument_expression_list_opt:
    /* empty */ {$$=createNode("ε");}
    | argument_expression_list {
        $$=createNode("argument_expression_list");
        insertChild($$, $1);
        }


argument_expression_list:
    assignment_expression{
        $$=createNode("argument_expression_list");
        insertChild($$, $1);
    }
    | argument_expression_list COMMA assignment_expression{
        $$=createNode("argument_expression_list");
        insertChild($$, $1);
        insertChild($$, createNode(","));
        insertChild($$, $3);
    }
;

unary_expression:
    postfix_expression{
        $$=createNode("unary_expression");
        insertChild($$, $1);
    }
    | INCREMENT unary_expression{
        $$=createNode("unary_expression");
        insertChild($$, createNode("++"));
        insertChild($$, $2);
    }
    | DECREMENT unary_expression{
        $$=createNode("unary_expression");
        insertChild($$, createNode("--"));
        insertChild($$, $2);
    }
    | unary_operator cast_expression{
        $$=createNode("unary_expression");
        insertChild($$, $1);
        insertChild($$, $2);
    }
    | SIZEOF unary_expression{
        $$=createNode("unary_expression");
        insertChild($$, createNode("sizeof"));
        insertChild($$, $2);
    }
    | SIZEOF LEFT_PAREN type_name RIGHT_PAREN{
        $$=createNode("unary_expression");
        insertChild($$, createNode("sizeof"));
        insertChild($$, createNode("("));
        insertChild($$, $3);
        insertChild($$, createNode(")"));
    }
;

unary_operator:
    BITWISE_AND{
        $$=createNode("&");
    }
    | STAR{
        $$=createNode("*");
    }
    | PLUS{
        $$=createNode("+");
    } 
    | MINUS{
        $$=createNode("-");
    } 
    | BITWISE_NOT{
        $$=createNode("~");
    } 
    | LOGICAL_NOT{
        $$=createNode("!");
    }
;

cast_expression:
    unary_expression{
        $$=createNode("cast_expression");
        insertChild($$, $1);
    }
    | LEFT_PAREN type_name RIGHT_PAREN cast_expression{
        $$=createNode("cast_expression");
        insertChild($$, createNode("("));
        insertChild($$, $2);
        insertChild($$, createNode(")"));
        insertChild($$, $4);
    }
;

multiplicative_expression:
    cast_expression{
        $$=createNode("multiplicative_expression");
        insertChild($$, $1);
    }
    | multiplicative_expression STAR cast_expression{
        $$=createNode("multiplicative_expression");
        insertChild($$, $1);
        insertChild($$, createNode("*"));
        insertChild($$, $3);
    }
    | multiplicative_expression DIVIDE cast_expression{
        $$=createNode("multiplicative_expression");
        insertChild($$, $1);
        insertChild($$, createNode("/"));
        insertChild($$, $3);
    }
    | multiplicative_expression MODULO cast_expression{
        $$=createNode("multiplicative_expression");
        insertChild($$, $1);
        insertChild($$, createNode("%"));
        insertChild($$, $3);
    }
;

additive_expression:
    multiplicative_expression{
        $$=createNode("additive_expression");
        insertChild($$, $1);
    }
    | additive_expression PLUS multiplicative_expression{
        $$=createNode("additive_expression");
        insertChild($$, $1);
        insertChild($$, createNode("+"));
        insertChild($$, $3);
    }
    | additive_expression MINUS multiplicative_expression{
        $$=createNode("additive_expression");
        insertChild($$, $1);
        insertChild($$, createNode("-"));
        insertChild($$, $3);
    }
;

shift_expression:
    additive_expression{
        $$=createNode("shift_expression");
        insertChild($$, $1);
    }
    | shift_expression LEFT_SHIFT additive_expression{
        $$=createNode("shift_expression");
        insertChild($$, $1);
        insertChild($$, createNode("<<"));
        insertChild($$, $3);
    }
    | shift_expression RIGHT_SHIFT additive_expression{
        $$=createNode("shift_expression");
        insertChild($$, $1);
        insertChild($$, createNode(">>"));
        insertChild($$, $3);
    }
;

relational_expression:
    shift_expression{
        $$=createNode("relational_expression");
        insertChild($$, $1);
    }
    | relational_expression LESS_THAN shift_expression{
        $$=createNode("relational_expression");
        insertChild($$, $1);
        insertChild($$, createNode("<"));
        insertChild($$, $3);
    }
    | relational_expression GREATER_THAN shift_expression{      
        $$=createNode("relational_expression");
        insertChild($$, $1);
        insertChild($$, createNode(">"));
        insertChild($$, $3);
    }
    | relational_expression LESS_THAN_EQUAL shift_expression{
        $$=createNode("relational_expression");
        insertChild($$, $1);
        insertChild($$, createNode("<="));
        insertChild($$, $3);
    }
    | relational_expression GREATER_THAN_EQUAL shift_expression{
        $$=createNode("relational_expression");
        insertChild($$, $1);
        insertChild($$, createNode(">="));
        insertChild($$, $3);
    }
;

equality_expression:
    relational_expression{
        $$=createNode("equality_expression");
        insertChild($$, $1);
    }
    | equality_expression EQUAL relational_expression{
        $$=createNode("equality_expression");
        insertChild($$, $1);
        insertChild($$, createNode("=="));
        insertChild($$, $3);
    }
    | equality_expression NOT_EQUAL relational_expression{
        $$=createNode("equality_expression");
        insertChild($$, $1);
        insertChild($$, createNode("!="));
        insertChild($$, $3);
    }
;

AND_expression:
    equality_expression{
        $$=createNode("AND_expression");
        insertChild($$, $1);
    }
    | AND_expression BITWISE_AND equality_expression{
        $$=createNode("AND_expression");
        insertChild($$, $1);
        insertChild($$, createNode("&"));
        insertChild($$, $3);
    }
;

exclusive_OR_expression:
    AND_expression{
        $$=createNode("exclusive_OR_expression");
        insertChild($$, $1);
    }
    | exclusive_OR_expression BITWISE_XOR AND_expression{
        $$=createNode("exclusive_OR_expression");
        insertChild($$, $1);
        insertChild($$, createNode("^"));
        insertChild($$, $3);
    }
;

inclusive_OR_expression:
    exclusive_OR_expression{
        $$=createNode("inclusive_OR_expression");
        insertChild($$, $1);
    }
    | inclusive_OR_expression BITWISE_OR exclusive_OR_expression{
        $$=createNode("inclusive_OR_expression");
        insertChild($$, $1);
        insertChild($$, createNode("|"));
        insertChild($$, $3);
    }
;

logical_AND_expression:
    inclusive_OR_expression{
        $$=createNode("logical_AND_expression");
        insertChild($$, $1);
    }
    | logical_AND_expression LOGICAL_AND inclusive_OR_expression{
        $$=createNode("logical_AND_expression");
        insertChild($$, $1);
        insertChild($$, createNode("&&"));
        insertChild($$, $3);
    }
;

logical_OR_expression:
    logical_AND_expression{
        $$=createNode("logical_OR_expression");
        insertChild($$, $1);
    }
    | logical_OR_expression LOGICAL_OR logical_AND_expression{
        $$=createNode("logical_OR_expression");
        insertChild($$, $1);
        insertChild($$, createNode("||"));
        insertChild($$, $3);
    }
;

conditional_expression:
    logical_OR_expression{
        $$=createNode("conditional_expression");
        insertChild($$, $1);
    }
    | logical_OR_expression QUESTION_MARK expression COLON conditional_expression{
        $$=createNode("conditional_expression");
        insertChild($$, $1);
        insertChild($$, createNode("?"));
        insertChild($$, $3);
        insertChild($$, createNode(":"));
        insertChild($$, $5);
    }
;

assignment_expression:
    conditional_expression{
        $$=createNode("assignment_expression");
        insertChild($$, $1);
    }
    | unary_expression assignment_operator assignment_expression{
        $$=createNode("assignment_expression");
        insertChild($$, $1);
        insertChild($$, $2);
        insertChild($$, $3);
    }
;

assignment_operator:
    ASSIGN {$$=createNode("=");}
    | STAR_ASSIGN {$$=createNode("*=");}
    | DIVIDE_ASSIGN {$$=createNode("/=");}
    | MODULO_ASSIGN {$$=createNode("%=");}
    | PLUS_ASSIGN {$$=createNode("+=");}
    | MINUS_ASSIGN {$$=createNode("-=");}
    | LEFT_SHIFT_ASSIGN {$$=createNode("<<=");}
    | RIGHT_SHIFT_ASSIGN {$$=createNode(">>=");}
    | BITWISE_AND_ASSIGN {$$=createNode("&=");}
    | BITWISE_XOR_ASSIGN {$$=createNode("^=");}
    | BITWISE_OR_ASSIGN{$$=createNode("|=");}
;

expression:
    assignment_expression{
        $$=createNode("expression");
        insertChild($$, $1);
    }
    | expression COMMA assignment_expression{
        $$=createNode("expression");
        insertChild($$, $1);
        insertChild($$, createNode(","));
        insertChild($$, $3);
    }
;

constant_expression:
    conditional_expression{
        $$=createNode("constant_expression");
        insertChild($$, $1);
    }
;

// 2. Declarations
declaration:
    declaration_specifiers init_declarator_list_opt SEMICOLON{
        $$=createNode("declaration");
        insertChild($$, $1);
        insertChild($$, $2);
        insertChild($$, createNode(";"));
    }
;

declaration_specifiers:
    storage_class_specifier declaration_specifiers_opt{
        $$=createNode("declaration_specifiers");
        insertChild($$, $1);
        insertChild($$, $2);
    }
    | type_specifier declaration_specifiers_opt{
        $$=createNode("declaration_specifiers");
        insertChild($$, $1);
        insertChild($$, $2);
    }
    | type_qualifier declaration_specifiers_opt{
        $$=createNode("declaration_specifiers");
        insertChild($$, $1);
        insertChild($$, $2);
    }
    | function_specifier declaration_specifiers_opt{
        $$=createNode("declaration_specifiers");
        insertChild($$, $1);
        insertChild($$, $2);
    }
;

init_declarator_list_opt
    : init_declarator_list {
        $$ = createNode("init_declarator_list");
        insertChild($$, $1);
    }
    | {$$ = createNode("ε");}
    ;

init_declarator_list:
    init_declarator{
        $$=createNode("init_declarator_list");
        insertChild($$, $1);
    }
    | init_declarator_list COMMA init_declarator{
        $$=createNode("init_declarator_list");
        insertChild($$, $1);
        insertChild($$, createNode(","));
        insertChild($$, $3);
    }
;

init_declarator:
    declarator{
        $$=createNode("init_declarator");
        insertChild($$, $1);
    }
    | declarator ASSIGN initializer {
        $$=createNode("init_declarator");
        insertChild($$, $1);
        insertChild($$, createNode("="));
        insertChild($$, $3);
    }
;

storage_class_specifier:
    AUTO {$$=createNode("auto");}
    | EXTERN {  $$=createNode("extern");}
    | STATIC {  $$=createNode("static");}
    | REGISTER{  $$=createNode("register");}
;

type_specifier:
    VOID {  $$=createNode("void");}
    | CHAR {  $$=createNode("char");}
    | SHORT {  $$=createNode("short");}
    | INT {  $$=createNode("int");}
    | LONG {  $$=createNode("long");}
    | FLOAT {  $$=createNode("float");}
    | DOUBLE {  $$=createNode("double");}
    | SIGNED {  $$=createNode("signed");}
    | UNSIGNED {  $$=createNode("unsigned");}
    | BOOL {  $$=createNode("_Bool");}
    | COMPLEX {  $$=createNode("_Complex");}
    | IMAGINARY{  $$=createNode("_Imaginary");}
;


specifier_qualifier_list:
    type_specifier specifier_qualifier_list_opt{
        $$=createNode("specifier_qualifier_list");
        insertChild($$, $1);
        insertChild($$, $2);
    }
    | type_qualifier specifier_qualifier_list_opt{
        $$=createNode("specifier_qualifier_list");
        insertChild($$, $1);
        insertChild($$, $2);
    }
;

specifier_qualifier_list_opt
    : specifier_qualifier_list {
        $$ = createNode("specifier_qualifier_list");
        insertChild($$, $1);
    }
    | {$$=createNode("ε");}
    ;

type_qualifier:
    CONST {  $$=createNode("const");} 
    | RESTRICT {  $$=createNode("restrict");}
    | VOLATILE {  $$=createNode("volatile");}
;

function_specifier:
    INLINE{  $$=createNode("inline");}
;

declarator:
    pointer_opt direct_declarator{
        $$=createNode("declarator");
        insertChild($$, $1);
        insertChild($$, $2);
    }
;

direct_declarator:
    IDENTIFIER{
        $$=createNode($1);
    }
    | LEFT_PAREN declarator RIGHT_PAREN{
        $$=createNode("direct_declarator");
        insertChild($$, createNode("("));
        insertChild($$, $2);
        insertChild($$, createNode(")"));
    }
    | direct_declarator LEFT_BRACKET type_qualifier_list_opt assignment_expression_opt RIGHT_BRACKET{
        $$=createNode("direct_declarator");
        insertChild($$, $1);
        insertChild($$, createNode("["));
        insertChild($$, $3);
        insertChild($$, $4);
        insertChild($$, createNode("]"));
    }
    | direct_declarator LEFT_BRACKET STATIC type_qualifier_list_opt assignment_expression RIGHT_BRACKET{
        $$=createNode("direct_declarator");
        insertChild($$, $1);
        insertChild($$, createNode("["));
        insertChild($$, createNode("static"));
        insertChild($$, $4);
        insertChild($$, $5);
        insertChild($$, createNode("]"));
    }
    | direct_declarator  LEFT_BRACKET type_qualifier_list STATIC assignment_expression RIGHT_BRACKET{
        $$=createNode("direct_declarator");
        insertChild($$, $1);
        insertChild($$, createNode("["));
        insertChild($$, $3);
        insertChild($$, createNode("static"));
        insertChild($$, $5);
        insertChild($$, createNode("]"));
    }
    | direct_declarator LEFT_BRACKET type_qualifier_list_opt STAR RIGHT_BRACKET{
        $$=createNode("direct_declarator");
        insertChild($$, $1);
        insertChild($$, createNode("["));
        insertChild($$, $3);
        insertChild($$, createNode("*"));
        insertChild($$, createNode("]"));
    }
    | direct_declarator LEFT_PAREN parameter_type_list RIGHT_PAREN{
        $$=createNode("direct_declarator");
        insertChild($$, $1);
        insertChild($$, createNode("("));
        insertChild($$, $3);
        insertChild($$, createNode(")"));
    }
    | direct_declarator LEFT_PAREN identifier_list_opt RIGHT_PAREN{
        $$=createNode("direct_declarator");
        insertChild($$, $1);
        insertChild($$, createNode("("));
        insertChild($$, $3);
        insertChild($$, createNode(")"));
    }

pointer:
    STAR type_qualifier_list_opt {
        $$=createNode("pointer");
        insertChild($$, createNode("*"));
        insertChild($$, $2);
    }
    | STAR type_qualifier_list_opt pointer{
        $$=createNode("pointer");
        insertChild($$, createNode("*"));
        insertChild($$, $2);
        insertChild($$, $3);
    }
;

type_qualifier_list:
    type_qualifier{
        $$=createNode("type_qualifier_list");
        insertChild($$, $1);
    }
    | type_qualifier_list type_qualifier{
        $$=createNode("type_qualifier_list");
        insertChild($$, $1);
        insertChild($$, $2);
    }
;

parameter_type_list:
    parameter_list{
        $$=createNode("parameter_type_list");
        insertChild($$, $1);
    }
    | parameter_list COMMA ELLIPSIS{
        $$=createNode("parameter_type_list");
        insertChild($$, $1);
        insertChild($$, createNode(","));
        insertChild($$, createNode("..."));
    }
;

parameter_list:
    parameter_declaration{
        $$=createNode("parameter_list");
        insertChild($$, $1);
    }
    | parameter_list COMMA parameter_declaration{
        $$=createNode("parameter_list");
        insertChild($$, $1);
        insertChild($$, createNode(","));
        insertChild($$, $3);
    }
;

parameter_declaration:
    declaration_specifiers declarator{
        $$=createNode("parameter_declaration");
        insertChild($$, $1);
        insertChild($$, $2);
    }
    | declaration_specifiers {
        $$=createNode("parameter_declaration");
        insertChild($$, $1);
    }
;

identifier_list:
    IDENTIFIER{
        $$=createNode($1);
    }
    | identifier_list COMMA IDENTIFIER{
        $$=createNode("identifier_list");
        insertChild($$, $1);
        insertChild($$, createNode(","));
        insertChild($$, createNode($3));
    }
;

type_name:
    specifier_qualifier_list{
        $$=createNode("type_name");
        insertChild($$, $1);
    }
;

initializer:
    assignment_expression{
        $$=createNode("initializer");
        insertChild($$, $1);
    }
    | LEFT_BRACE initializer_list RIGHT_BRACE{
        $$=createNode("initializer");
        insertChild($$, createNode("{"));
        insertChild($$, $2);
        insertChild($$, createNode("}"));
    }
    | LEFT_BRACE initializer_list COMMA RIGHT_BRACE{
        $$=createNode("initializer");
        insertChild($$, createNode("{"));
        insertChild($$, $2);
        insertChild($$, createNode(","));
        insertChild($$, createNode("}"));
    }
;

initializer_list:
    designation_opt initializer{
        $$=createNode("initializer_list");
        insertChild($$, $1);
        insertChild($$, $2);
    }
    | initializer_list COMMA designation_opt initializer{
        $$=createNode("initializer_list");
        insertChild($$, $1);
        insertChild($$, createNode(","));
        insertChild($$, $3);
    }
;

designation:
    designator_list ASSIGN {
        $$=createNode("designation");
        insertChild($$, $1);
        insertChild($$, createNode("="));
    }
;

designator_list:
    designator{
        $$=createNode("designator_list");
        insertChild($$, $1);
    }
    | designator_list designator{
        $$=createNode("designator_list");
        insertChild($$, $1);
        insertChild($$, $2);
    }
;

designator:
    LEFT_BRACKET constant_expression RIGHT_BRACKET{
        $$=createNode("designator");
        insertChild($$, createNode("["));
        insertChild($$, $2);
        insertChild($$, createNode("]"));
    }
    | DOT IDENTIFIER{
        $$=createNode("designator");
        insertChild($$, createNode("."));
        insertChild($$,createNode($2));
    }
;

// 3. Statements
statement:
    labeled_statement{
        $$=createNode("statement");
        insertChild($$, $1);
    }
    | compound_statement{
        $$=createNode("statement");
        insertChild($$, $1);
    }
    | expression_statement{
        $$=createNode("statement");
        insertChild($$, $1);
    }
    | selection_statement{
        $$=createNode("statement");
        insertChild($$, $1);
    }
    | iteration_statement{
        $$=createNode("statement");
        insertChild($$, $1);
    }
    | jump_statement{   
        $$=createNode("statement");
        insertChild($$, $1);
    }
;

labeled_statement:
    IDENTIFIER COLON statement{
        $$=createNode("labeled_statement");
        insertChild($$, createNode($1));
        insertChild($$, createNode(":"));
        insertChild($$, $3);
    }
    | CASE constant_expression COLON statement{
        $$=createNode("labeled_statement");
        insertChild($$, createNode("case"));
        insertChild($$, $2);
        insertChild($$, createNode(":"));
        insertChild($$, $4);
    }
    | DEFAULT COLON statement{
        $$=createNode("labeled_statement");
        insertChild($$, createNode("default"));
        insertChild($$, createNode(":"));
        insertChild($$, $3);
    }
;

compound_statement:
    LEFT_BRACE block_item_list_opt RIGHT_BRACE {
        $$=createNode("compound_statement");
        insertChild($$, createNode("{"));
        insertChild($$, $2);
        insertChild($$, createNode("}"));
    }
;

block_item_list:
    block_item{
        $$=createNode("block_item_list");
    }
    | block_item_list block_item{
        $$=createNode("block_item_list");
        insertChild($$, $1);
        insertChild($$, $2);
    }
;

block_item:
    declaration{
        $$=createNode("block_item");
        insertChild($$, $1);
    }
    | statement{
        $$=createNode("block_item");
        insertChild($$, $1);
    }
;

expression_statement:
    expression_opt SEMICOLON{
        $$=createNode("expression_statement");
        insertChild($$, $1);
        insertChild($$, createNode(";"));
    }
;

selection_statement:
    IF LEFT_PAREN expression RIGHT_PAREN statement %prec LOWER_THAN_ELSE{
        $$=createNode("selection_statement");
        insertChild($$,createNode("if"));
        insertChild($$,createNode("("));
        insertChild($$,$3);
        insertChild($$,createNode(")"));
        insertChild($$,$5);
    }
    | IF LEFT_PAREN expression RIGHT_PAREN statement ELSE statement{
        $$=createNode("selection_statement");
        insertChild($$,createNode("if"));
        insertChild($$,createNode("("));
        insertChild($$,$3);
        insertChild($$, createNode(")"));
        insertChild($$, $5);
        insertChild($$, createNode("else"));
        insertChild($$, $7);
    }
    | SWITCH LEFT_PAREN expression RIGHT_PAREN statement{
        $$ = createNode("selection_statement");
        insertChild($$, createNode("switch"));
        insertChild($$, createNode("("));
        insertChild($$, $3);
        insertChild($$, createNode(")"));
        insertChild($$, $5);
    }
;

iteration_statement:
    WHILE LEFT_PAREN expression RIGHT_PAREN statement{
        $$ = createNode("iteration_statement");
        insertChild($$, createNode("while"));  
        insertChild($$, createNode("("));
        insertChild($$, $3);
        insertChild($$, createNode(")"));
        insertChild($$, $5);   
    }
    | DO statement WHILE LEFT_PAREN expression RIGHT_PAREN SEMICOLON{
        $$ = createNode("iteration_statement");
        insertChild($$, createNode("do"));
        insertChild($$, $2);
        insertChild($$, createNode("while"));
        insertChild($$, createNode("("));
        insertChild($$, $5);
        insertChild($$, createNode(")"));
        insertChild($$, createNode(";"));
    }
    | FOR LEFT_PAREN expression_opt SEMICOLON expression_opt SEMICOLON expression_opt RIGHT_PAREN statement{
        $$ = createNode("iteration_statement");
        insertChild($$, createNode("for"));
        insertChild($$, createNode("("));
        insertChild($$, $3);
        insertChild($$, createNode(";"));
        insertChild($$, $5);
        insertChild($$, createNode(";"));
        insertChild($$, $7);
        insertChild($$, createNode(")"));
        insertChild($$, $9);
    }
    | FOR LEFT_PAREN declaration expression_opt SEMICOLON expression_opt RIGHT_PAREN statement{
        $$ = createNode("iteration_statement");
        insertChild($$, createNode("for"));
        insertChild($$, createNode("("));
        insertChild($$, $3);
        insertChild($$, $4);
        insertChild($$, createNode(";"));
        insertChild($$, $6);
        insertChild($$, createNode(")"));
        insertChild($$, $8);
    }
;

jump_statement
    : GOTO IDENTIFIER SEMICOLON {
        $$ = createNode("jump_statement");
        insertChild($$, createNode("goto"));
        insertChild($$, createNode($2));
        insertChild($$, createNode(";"));
    }
    | CONTINUE SEMICOLON {
        $$ = createNode("jump_statement");
        insertChild($$, createNode("continue"));
        insertChild($$, createNode(";"));
    }
    | BREAK SEMICOLON {
        $$ = createNode("jump_statement");
        insertChild($$, createNode("break"));
        insertChild($$, createNode(";"));
    }
    | RETURN expression_opt SEMICOLON {
        $$ = createNode("jump_statement");
        insertChild($$, createNode("return"));
        insertChild($$, $2);
        insertChild($$, createNode(";"));
    }
    ;

// 4. External definitions
translation_unit:
    external_declaration{
        $$=createNode("translation_unit");
        insertChild($$,$1);
         printTree($$, 0, 1); 
    }
    | translation_unit external_declaration{
        $$=createNode("translation_unit");
        insertChild($$,$1);
        insertChild($$,($2));
        printTree($$, 0, 1); 
    }
;

external_declaration:
    function_definition{
        $$=createNode("external_declaration");
        insertChild($$,$1);
    }
    | declaration{
        $$=createNode("external_declaration");
        insertChild($$,$1);
    }
;

function_definition:
    declaration_specifiers declarator declaration_list_opt compound_statement{
        $$=createNode("function_definition");
        insertChild($$,$1);
        insertChild($$,$2);
        insertChild($$,$3);
        insertChild($$,$4);
    }
;

declaration_list:
    declaration{
        $$=createNode("declaration_list");
        insertChild($$,$1);
    }
    | declaration_list declaration{
        $$=createNode("declaration_list");
        insertChild($$,$1);
        insertChild($$,$2);
    }
;

pointer_opt:
    pointer{$$=createNode("pointer");
    insertChild($$,$1);}
    |{$$=createNode("ε");}
;

type_qualifier_list_opt:
    type_qualifier_list{$$=createNode("type_qualifier_list");
    insertChild($$,$1);}
    |{$$=createNode("ε");}
    ;

assignment_expression_opt
    : assignment_expression {$$ = createNode("assignment_expression");insertChild($$, $1);}
    | {$$=createNode("ε");}
    ;

identifier_list_opt
    : identifier_list {$$ = createNode("identifier_list");insertChild($$, $1);}
    | {$$=createNode("ε");}
    ;

designation_opt
    : designation {$$ = createNode("designation");insertChild($$, $1);}
    | {$$=createNode("ε");}
    ;

block_item_list_opt
    : block_item_list{$$ = createNode("block_item_list");insertChild($$, $1);}
    | {$$=createNode("ε");}
    ;

expression_opt
    : expression {$$ = createNode("expression");insertChild($$, $1);}
    | {$$=createNode("ε");}
    ;

declaration_list_opt
    : declaration_list{$$ = createNode("declaration_list");insertChild($$, $1);}
    | {$$=createNode("ε");}
    ;

declaration_specifiers_opt
    : declaration_specifiers{$$ = createNode("declaration_specifiers");
    insertChild($$, $1);
    }
    | {$$=createNode("ε");}
    ;


%%

void yyerror(const char *s) {
    fprintf(stderr, "Parser error:at line no %d %s token was %s\n", yylineno,s,yytext);
}