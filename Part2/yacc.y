%{
include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "lib.h"
int yylex();
void yyerror(char *s);
%}

%code requires{
    struct Node {
    char data[100];   // String data for the node
    struct Node* child;
    struct Node* sibling;
};

}
%union {
    char* string;
    int integer;
    float floating;
    char character;
    struct Node* node;
}

%token <string> IDENTIFIER STRING_LITERAL CONSTANT

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
%token QUESTION_MARK COLON SEMICOLON COMMA DOT ARROW ELLIPSIS

%start start

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


%type<node> primary_expression expression postfix_expression  primary_expression 
type_name argument_expression_list_opt argument_expression_list unary_expression
unary_operator cast_expression multiplicative_expression additive_expression
shift_expression relational_expression equality_expression AND_expression
exclusive_OR_expression inclusive_OR_expression logical_AND_expression 
logical_OR_expression conditional_expression assignment_expression
assignment_operator constant_expression declaration declaration_specifiers

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
    /* empty */ {$$=createNode('ε');}
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
    exclusive_OR_expression
    | inclusive_OR_expression BITWISE_OR exclusive_OR_expression
;

logical_AND_expression:
    inclusive_OR_expression
    | logical_AND_expression LOGICAL_AND inclusive_OR_expression
;

logical_OR_expression:
    logical_AND_expression
    | logical_OR_expression LOGICAL_OR logical_AND_expression
;

conditional_expression:
    logical_OR_expression
    | logical_OR_expression QUESTION_MARK expression COLON conditional_expression
;

assignment_expression:
    conditional_expression
    | unary_expression assignment_operator assignment_expression
;

assignment_operator:
    '=' | '*=' | '/=' | '%=' | '+=' | '-=' | '<<=' | '>>=' | '&=' | '^=' | '|='
;

expression:
    assignment_expression
    | expression ',' assignment_expression
;

constant_expression:
    conditional_expression
;

// 2. Declarations
declaration:
    declaration_specifiers init_declarator_list_opt SEMICOLON
;

declaration_specifiers:
    storage_class_specifier declaration_specifiers_opt
    | type_specifier declaration_specifiers_opt
    | type_qualifier declaration_specifiers_opt
    | function_specifier declaration_specifiers_opt
;

init_declarator_list:
    init_declarator
    | init_declarator_list ',' init_declarator
;

init_declarator:
    declarator
    | declarator '=' initializer
;

storage_class_specifier:
    AUTO | ENUM | RESTRICT | UNSIGNED | BREAK | EXTERN | RETURN | VOID
;

type_specifier:
    VOID | CHAR | SHORT | INT | LONG | FLOAT | DOUBLE | SIGNED | UNSIGNED | BOOL | COMPLEX | IMAGINARY
;

specifier_qualifier_list:
    type_specifier specifier_qualifier_list_opt
    | type_qualifier specifier_qualifier_list_opt
;

type_qualifier:
    CONST | RESTRICT | VOLATILE
;

function_specifier:
    INLINE
;

declarator:
    pointer_opt direct_declarator
;

direct_declarator:
    IDENTIFIER
    | LEFT_PAREN declarator RIGHT_PAREN
    | direct_declarator LEFT_BRACKET type_qualifier_list_opt assignment_expression_opt RIGHT_BRACKET
    | direct_declarator LEFT_PAREN parameter_type_list RIGHT_PAREN
    | direct_declarator LEFT_PAREN identifier_list_opt RIGHT_PAREN
;

pointer:
    '*' type_qualifier_list_opt
    | '*' type_qualifier_list_opt pointer
;

type_qualifier_list:
    type_qualifier
    | type_qualifier_list type_qualifier
;

parameter_type_list:
    parameter_list
    | parameter_list ',' "..."
;

parameter_list:
    parameter_declaration
    | parameter_list ',' parameter_declaration
;

parameter_declaration:
    declaration_specifiers declarator
    | declaration_specifiers IDENTIFIER
;

identifier_list:
    IDENTIFIER
    | identifier_list ',' IDENTIFIER
;

type_name:
    specifier_qualifier_list
;

initializer:
    assignment_expression
    | LEFT_BRACE initializer_list RIGHT_BRACE
    | LEFT_BRACE initializer_list ',' RIGHT_BRACE
;

initializer_list:
    designation_opt initializer
    | initializer_list ',' designation_opt initializer
;

designation:
    designator_list '='
;

designator_list:
    designator
    | designator_list designator
;

designator:
    LEFT_BRACKET constant_expression RIGHT_BRACKET
    | DOT IDENTIFIER
;

// 3. Statements
statement:
    labeled_statement
    | compound_statement
    | expression_statement
    | selection_statement
    | iteration_statement
    | jump_statement
;

labeled_statement:
    IDENTIFIER ':' statement
    | CASE constant_expression ':' statement
    | DEFAULT ':' statement
;

compound_statement:
    LEFT_BRACE block_item_list_opt RIGHT_BRACE
;

block_item_list:
    block_item
    | block_item_list block_item
;

block_item:
    declaration
    | statement
;

expression_statement:
    expression_opt SEMICOLON
;

selection_statement:
    IF LEFT_PAREN expression RIGHT_PAREN statement
    | IF LEFT_PAREN expression RIGHT_PAREN statement ELSE statement
    | SWITCH LEFT_PAREN expression RIGHT_PAREN statement
;

iteration_statement:
    WHILE LEFT_PAREN expression RIGHT_PAREN statement
    | DO statement WHILE LEFT_PAREN expression RIGHT_PAREN SEMICOLON
    | FOR LEFT_PAREN expression_opt SEMICOLON expression_opt SEMICOLON expression_opt RIGHT_PAREN statement
    | FOR LEFT_PAREN declaration expression_opt SEMICOLON expression_opt RIGHT_PAREN statement
;

jump_statement:
    GOTO IDENTIFIER SEMICOLON
    | CONTINUE SEMICOLON
    | BREAK SEMICOLON
    | RETURN expression_opt SEMICOLON
;

// 4. External definitions
translation_unit:
    external_declaration
    | translation_unit external_declaration
;

external_declaration:
    function_definition
    | declaration
;

function_definition:
    declaration_specifiers declarator declaration_list_opt compound_statement
;

declaration_list:
    declaration
    | declaration_list declaration
;

%%