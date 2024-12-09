# Makefile for TinyC Parser and Lexer

# Compiler and Flags
CC = gcc
CFLAGS = -lfl

# Source Files
BISON_FILE = tinyC2_22CS30005_22CS30029.y
LEX_FILE = tinyC2_22CS30005_22CS30029.l
C_FILE = tinyC2_22CS30005_22CS30029.c
HEADER_FILE = tinyC2_22CS30005_22CS30029.h

# Output Binary and Generated Files
EXE = myprogram
BISON_OUTPUT = tinyC2_22CS30005_22CS30029.tab.c
BISON_HEADER = tinyC2_22CS30005_22CS30029.tab.h
LEX_OUTPUT = lex.yy.c
OUTPUT_FILE = output.txt
INPUT = input_22CS30005_22CS30029.c

# Default target
all: $(EXE)

# Rule to build the executable
$(EXE): $(BISON_OUTPUT) $(LEX_OUTPUT) $(C_FILE)
	$(CC) -o $(EXE) $(C_FILE) $(LEX_OUTPUT) $(BISON_OUTPUT) $(CFLAGS)

# Rule to generate parser from Bison
$(BISON_OUTPUT): $(BISON_FILE)
	bison -d -o $(BISON_OUTPUT) $(BISON_FILE)

# Rule to generate lexer from Flex
$(LEX_OUTPUT): $(LEX_FILE)
	flex -o $(LEX_OUTPUT) $(LEX_FILE)

# Rule to run the program
run: $(EXE)
	./$(EXE) < $(INPUT) > $(OUTPUT_FILE)

# Clean target to remove generated files
clean:
	rm -f $(EXE) $(BISON_OUTPUT) $(LEX_OUTPUT) $(BISON_HEADER) $(OUTPUT_FILE)

# Phony targets
.PHONY: all run clean
