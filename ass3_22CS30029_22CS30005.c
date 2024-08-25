#include "lex.yy.c"
#include <stdio.h>
#include <string.h>

// Global variable to keep track of token indices
int indexVariable = 1;

// Structure to represent a token
struct Token
{
    int index;
    char tokenname[256];
    char lexeme[256];
} typedef Token;

// Function to print a single token
void printToken(Token token)
{
    printf("<%s,%s> ", token.tokenname, token.lexeme);
}

// Node structure for the linked list of tokens
struct node
{
    Token token;
    struct node *next;
} typedef node;

// Function to create a new node for the token list
node *createNode(Token entry)
{
    node *newNode = (node *)malloc(sizeof(node));
    if (newNode == NULL)
    {
        printf("Memory Allocation Failed\n");
        exit(1);
    }
    newNode->token = entry;
    newNode->next = NULL;
    return newNode;
}

// Function to insert a new node at the end of the token list
void insertNode(node **head, Token entry)
{
    node *newNode = createNode(entry);
    if (*head == NULL)
    {
        *head = newNode;
        return;
    }
    node *temp = *head;
    while (temp->next != NULL)
    {
        temp = temp->next;
    }
    temp->next = newNode;
}

// Function to print the entire stream of tokens
void printLexeme(node *head)
{
    printf("Stream of Tokens:\n\n");
    while (head != NULL)
    {
        printToken(head->token);
        head = head->next;
    }
}

// Function to free memory allocated for the token list
void freeSpace(node **head)
{
    node *current = *head;
    node *next;

    while (current != NULL)
    {
        next = current->next;
        free(current);
        current = next;
    }

    *head = NULL;
}

// Structure for symbol table entries
struct tableEntry{
    Token token;
    int count;
    struct tableEntry* next;
}typedef tableEntry;

// Function to print a single symbol table entry
void printTableEntry(tableEntry* TableEntry)
{
    printf("%d| %s | %s |%d\n", TableEntry->token.index, TableEntry->token.tokenname, TableEntry->token.lexeme, TableEntry->count);
}

// Function to create a new symbol table entry
tableEntry* creatTableEntry(Token entry){
    tableEntry *newTableEntry = (tableEntry*)malloc(sizeof(tableEntry));
    newTableEntry->token = entry;
    newTableEntry->count = 1;
    newTableEntry->next = NULL;
    return newTableEntry;
}

// Function to insert or update an entry in the symbol table
/* 
   SymbolTable contains unique token and if the token is repeated
   in token stream the count of that token in symbol table is 
   increased.
*/
tableEntry* insertTableEntry(tableEntry** head, Token entry) {
    tableEntry* current = *head;
    while (current != NULL) {
        if (strcmp(current->token.lexeme, entry.lexeme) == 0 &&
            strcmp(current->token.tokenname, entry.tokenname) == 0) {
            current->count++;
            return current;
        }
        current = current->next;
    }
    tableEntry* newEntry = creatTableEntry(entry);
    if (*head == NULL) {
        *head = newEntry;
    } else {
        current = *head;
        while (current->next != NULL) {
            current = current->next;
        }
        current->next = newEntry;
    }
    return newEntry;
}

// Function to print the entire symbol table
void printSymbolTable(tableEntry* head)
{
    printf("Symbol Table:\n");
    printf("---------------------------------------------------\n");
    printf("\nSerial No. | Token Name | Lexeme | CountOfLexeme \n");
    printf("---------------------------------------------------\n");

    while (head != NULL)
    {
        printTableEntry(head);
        head = head->next;
    }
}

// Function to free memory allocated for the symbol table
void freeSpaceTable(tableEntry **head)
{
    tableEntry *current = *head;
    tableEntry *next;

    while (current != NULL)
    {
        next = current->next;
        free(current);
        current = next;
    }

    *head = NULL;
}

int main()
{
    int nexttok;
    node *start = NULL;
    tableEntry* TableEntry = NULL;
    Token entry;

    // Main loop to process tokens
    while ((nexttok = yylex()))
    {
        // Identify token type
        if (nexttok == KW)
        {
            strcpy(entry.tokenname, "Keyword");
        }
        else if (nexttok == ID)
        {
            strcpy(entry.tokenname, "Identifier");
        }
        else if (nexttok == CONST)
        {
            strcpy(entry.tokenname, "Constant");
        }
        else if (nexttok == SL)
        {
            strcpy(entry.tokenname, "String literal");
        }
        else if (nexttok == PUNC)
        {
            strcpy(entry.tokenname, "Punctuator");
        }
        else
        {
            printf("Error: Unrecognized character\n");
            continue;
        }

        // Set token properties
        entry.index = indexVariable;
        indexVariable++;
        strcpy(entry.lexeme, yytext);

        // Insert token into both lists
        insertNode(&start, entry);
        insertTableEntry(&TableEntry, entry);
    }

    // Print results
    printLexeme(start);
    printSymbolTable(TableEntry);

    // Free allocated memory
    freeSpace(&start);
    freeSpaceTable(&TableEntry);

    return 0;
}