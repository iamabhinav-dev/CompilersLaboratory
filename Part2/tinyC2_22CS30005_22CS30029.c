#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "tinyC2_22CS30005_22CS30029.h"

// Definition of a node in the tree
struct Node {
    char data[100];   // String data for the node
    struct Node* child;
    struct Node* sibling;
};

// Function to create a new node
struct Node* createNode(char data[]) {
    struct Node* newNode = (struct Node*)malloc(sizeof(struct Node));
    strcpy(newNode->data, data);
    newNode->child = NULL;
    newNode->sibling = NULL;
    return newNode;
}

// Function to insert a child node
void insertChild(struct Node* root, struct Node* childNode) {
    if (root->child == NULL) {
        root->child = childNode;
    } else {
        struct Node* temp = root->child;
        while (temp->sibling != NULL) {
            temp = temp->sibling;
        }
        temp->sibling = childNode;
    }
}

// Helper function to print the indentation
void printIndent(int levels[], int level) {
    for (int i = 0; i < level; i++) {
        if (levels[i]) {
            printf("|  ");
        } else {
            printf("   ");
        }
    }
}

// Function to print the tree with proper indentation
void printTree(struct Node* root, int level, int isLast) {
    if (root == NULL) return;

    // Skip printing if node data is 'ε'
    if (root->data == NULL || strcmp(root->data, "ε") != 0) {
        // Print indentation based on level
        for (int i = 0; i < level - 1; i++) {
            printf("|   ");  // Print vertical line for previous levels
        }

        // Print branch
        if (level > 0) {
            if (isLast) {
                printf("└── ");  // Last child at this level
            } else {
                printf("├── ");  // Not the last child
            }
        }

        // Print the current node's data
        printf("%s\n", root->data);
    }

    // Recursively print the children of the current node
    struct Node* child = root->child;
    while (child != NULL) {
        // Check if the current child is the last one
        struct Node* sibling = child->sibling;
        int isLastChild = (sibling == NULL);  // No more siblings
        printTree(child, level + 1, isLastChild);  // Recur for child nodes
        child = sibling;  // Move to the next sibling
    }
}


void freeTree(struct Node *node){
    if(node == NULL){
        return;
    }
    freeTree(node->child);
    freeTree(node->sibling);
    free(node);
}

void deleteTree(struct Node* node){
    if(node == NULL){
        return;
    }
    freeTree(node->child);
    freeTree(node->sibling);
    free(node);
}




int main(){
    yyparse();
    return 0;
}