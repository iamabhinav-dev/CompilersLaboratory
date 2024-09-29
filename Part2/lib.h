extern int yyparse();
extern int yylex();


struct Node* createNode(char data[]);
struct Node* insertChild(struct Node* root, struct Node* childNode) ;
void printIndent(int levels[], int level);
void printTree(struct Node* root, int levels[], int level);
void freeTree(struct Node *node);
