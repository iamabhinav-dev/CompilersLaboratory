// test.c - Comprehensive test file for tinyC lexer

/* Testing multi-line comment */
// Testing single-line comment

// Testing keywords
auto enum restrict unsigned break extern return void
case float short volatile char for signed while
const goto sizeof Bool continue if static Complex
default inline struct Imaginary do int switch
double long typedef else register union

// Testing identifiers
int main() {
    int a123;
    float _b456;
    char c_789;

    // Testing constants
    int i = 42;  // Integer constant
    float f = 3.14159;  // Floating constant
    float f2 = 2e-3;  // Floating constant with exponent
    char ch = 'A';  // Character constant
    char esc = '\n';  // Escape sequence in character constant

    // Testing string literals
    char* str1 = "Hello, World!";
    char* str2 = "Escape sequences: \n \t \\ \" \a\b ";

    // Testing punctuators
    int arr[10];  // [ ]
    int* ptr = &i;  // & *
    i++;  // ++
    i--;  // --
    int j = i + 1;  // + -
    int k = i * 2;  // *
    int l = i / 2;  // /
    int m = i % 2;  // %
    int n = i << 1;  // 
    int o = i >> 1;  // >>
    if (i < j && j <= k) {}  // < <= && 
    if (i > j || j >= k) {}  // > >= ||
    int p = (i == j) ? i : j;  // == ? :
    i += 5;  // +=
    j -= 3;  // -=
    k *= 2;  // *=
    l /= 2;  // /=
    m %= 3;  // %=
    n <<= 1;  // <<=
    o >>= 1;  // >>=
    int q = ~p;  // ~
    int r = !q;  // !
    float complex = 1.0 + 2.0i;  // Testing 'Complex' keyword and punctuators

    // Testing more complex expressions
    int result = (i + j) * (k - l) / (m % n);
    
    // Testing ellipsis
    void function(int arg, ...);

    // Testing arrow operator
    struct Point {
        int x;
        int y;
    };
    struct Point* point = malloc(sizeof(struct Point));
    point->x = 10;
    point->y = 20;

    return 0;
}

// Additional tests for potential edge cases
#define MACRO 100  // Testing '#' punctuator
float z = .5;    // Floating constant starting with dot
char* str3 = "String with \"escaped quotes\"";
