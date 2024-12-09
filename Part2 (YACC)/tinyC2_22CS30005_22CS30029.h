extern int yyparse();
extern int yylex();
extern int yylineno;
extern char* yytext;


struct Node* createNode(char data[]);
void insertChild(struct Node* root, struct Node* childNode) ;
void printIndent(int levels[], int level);
void printTree(struct Node* root, int level, int isLast);
void freeTree(struct Node *node);
