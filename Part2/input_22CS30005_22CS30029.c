// Test file for TinyC grammar
// Filename: test_input_complete.c

// Global variable declarations
int globalVar = 10;
const float PI = 3.14159;

// Function prototype
int calculateSum(int a, int b);
void displayMessage();

// Function with multiple parameters and local variables
int complexFunction(int a, float b, char c) {
    int localVar1 = 5;
    static int staticVar = 0;
    
    // Compound statement with declarations and expressions
    {
        int innerVar = a + localVar1;
        float result = b * PI;
        char uppercase = c - 32; // ASCII manipulation
    }
    
    // Conditional statements
    if (a > 0) {
        return a;
    } else if (a < 0) {
        return -a;
    } else {
        return 0;
    }
}

// Main function to test various constructs
int main() {
    // Variable declarations
    int x = 5, y = 10;
    float z = 3.14;
    char ch = 'A';
    
    // Array declaration and initialization
    int arr[5] = {1, 2, 3, 4, 5};
    
    // Pointer declaration
    int *ptr = &x;
    
    // Function call
    int sum = calculateSum(x, y);
    
    // Arithmetic expressions
    int result = (x + y) * z / 2;
    
    // Bitwise operations
    int bitwiseResult = x & y;
    
    // Logical expressions
    int logicalResult = (x > y) && (z < 5.0) || (ch == 'A');
    
    // Loop constructs
    for (int i = 0; i < 5; i++) {
        if (i == 3) continue;
        printf("%d ", arr[i]);
    }
    
    int j = 0;
    while (j < 5) {
        printf("%d ", j);
        j++;
    }
    
    do {
        printf("Do-while loop\n");
    } while (0);
    
    // Ternary operator
    int max = (x > y) ? x : y;
    
    // Return statement
    return 0;
}

// Function definition
int calculateSum(int a, int b) {
    return a + b;
}

void displayMessage() {
    printf("Welcome to TinyC!\n");
}
