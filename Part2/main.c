#include <stdio.h>
#include <stdlib.h>
#include <string.h>

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
struct Node* insertChild(struct Node* root, struct Node* childNode) {
    if (root->child == NULL) {
        root->child = childNode;
    } else {
        struct Node* temp = root->child;
        while (temp->sibling != NULL) {
            temp = temp->sibling;
        }
        temp->sibling = childNode;
    }
    return root;
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

// Function to print the tree in the specified format
void printTree(struct Node* root, int* levels, int level) {
    if (root == NULL) return;

    // Skip printing if node data is 'E'
    if (strcmp(root->data, "'E'") != 0) {
        // Print the node with the appropriate indentation
        printIndent(levels, level);
        if (level > 0) {
            printf("|-");
        }
        printf("%s\n", root->data);
    }

    // Recursively print children and siblings
    struct Node* child = root->child;
    if (child != NULL) {
        levels[level] = 1; // There are more nodes at this level
        while (child != NULL) {
            struct Node* sibling = child->sibling;
            levels = realloc(levels, (level + 2) * sizeof(int));  // Dynamically extend the levels array as needed
            levels[level + 1] = (sibling != NULL); // Check if there are siblings at the next level
            printTree(child, levels, level + 1);
            child = sibling;
        }
        levels[level] = 0; // Reset after finishing this level
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