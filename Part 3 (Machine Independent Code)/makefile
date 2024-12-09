assembly: tinyC libTinyC3_22CS30005_22CS30029.a
	@echo "-------------------Please wait! Generation of quads in progress---------------"

	./tinyC 1 > TinyC3_22CS30005_22CS30029_quads1.out
	./tinyC 2 > TinyC3_22CS30005_22CS30029_quads2.out
	./tinyC 3 > TinyC3_22CS30005_22CS30029_quads3.out
	./tinyC 4 > TinyC3_22CS30005_22CS30029_quads4.out
	./tinyC 5 > TinyC3_22CS30005_22CS30029_quads5.out
	./tinyC 6 > TinyC3_22CS30005_22CS30029_quads6.out
	./tinyC 7 > TinyC3_22CS30005_22CS30029_quads7.out
	@echo "----------------Assembly and quads have been generated successfully, use make run to compile the test cases------------"
libTinyC3_22CS30005_22CS30029.a:
	gcc -c TinyC3_22CS30005_22CS30029.c
	ar -rcs libTinyC3_22CS30005_22CS30029.a TinyC3_22CS30005_22CS30029.o

tinyC: lex.yy.o TinyC3_22CS30005_22CS30029.tab.o TinyC3_22CS30005_22CS30029_translator.o TinyC3_22CS30005_22CS30029_target_translator.o
	g++ lex.yy.o TinyC3_22CS30005_22CS30029.tab.o TinyC3_22CS30005_22CS30029_translator.o \
	TinyC3_22CS30005_22CS30029_target_translator.o -o tinyC

TinyC3_22CS30005_22CS30029_target_translator.o: TinyC3_22CS30005_22CS30029_target_translator.cxx
	g++ -c TinyC3_22CS30005_22CS30029_target_translator.cxx

TinyC3_22CS30005_22CS30029_translator.o: TinyC3_22CS30005_22CS30029_translator.cxx TinyC3_22CS30005_22CS30029_translator.h
	g++ -c TinyC3_22CS30005_22CS30029_translator.h
	g++ -c TinyC3_22CS30005_22CS30029_translator.cxx

lex.yy.o: lex.yy.c
	g++ -c lex.yy.c

TinyC3_22CS30005_22CS30029.tab.o: TinyC3_22CS30005_22CS30029.tab.c
	g++ -c TinyC3_22CS30005_22CS30029.tab.c

lex.yy.c: TinyC3_22CS30005_22CS30029.l TinyC3_22CS30005_22CS30029.tab.h TinyC3_22CS30005_22CS30029_translator.h
	flex TinyC3_22CS30005_22CS30029.l

TinyC3_22CS30005_22CS30029.tab.c: TinyC3_22CS30005_22CS30029.y
	bison -dtv TinyC3_22CS30005_22CS30029.y -W

TinyC3_22CS30005_22CS30029.tab.h: TinyC3_22CS30005_22CS30029.y
	bison -dtv TinyC3_22CS30005_22CS30029.y -W
	
clean:
	rm -f lex.yy.c\
	   TinyC3_22CS30005_22CS30029.tab.c\
	   TinyC3_22CS30005_22CS30029.tab.h\
	   *.o\
	   *.out\
	   *.s\
	   tinyC\
	   TinyC3_22CS30005_22CS30029_translator.h.gch\
	   libTinyC3_22CS30005_22CS30029.a 
run:

	@echo "\n-------------    Please wait! Generation of object files in progress ---------------\n"

	gcc -c TinyC3_22CS30005_22CS30029_1.s
	gcc -c TinyC3_22CS30005_22CS30029_2.s
	gcc -c TinyC3_22CS30005_22CS30029_3.s
	gcc -c TinyC3_22CS30005_22CS30029_4.s
	gcc -c TinyC3_22CS30005_22CS30029_5.s
	gcc -c TinyC3_22CS30005_22CS30029_6.s
	gcc -c TinyC3_22CS30005_22CS30029_7.s

	@echo "\n-------------    Please Wait! Compilation of test files in progress  ---------------\n"

	gcc TinyC3_22CS30005_22CS30029_1.o -o test1.out -L. -lTinyC3_22CS30005_22CS30029 -no-pie
	gcc TinyC3_22CS30005_22CS30029_2.o -o test2.out -L. -lTinyC3_22CS30005_22CS30029 -no-pie
	gcc TinyC3_22CS30005_22CS30029_3.o -o test3.out -L. -lTinyC3_22CS30005_22CS30029 -no-pie
	gcc TinyC3_22CS30005_22CS30029_4.o -o test4.out -L. -lTinyC3_22CS30005_22CS30029 -no-pie
	gcc TinyC3_22CS30005_22CS30029_5.o -o test5.out -L. -lTinyC3_22CS30005_22CS30029 -no-pie
	gcc TinyC3_22CS30005_22CS30029_6.o -o test6.out -L. -lTinyC3_22CS30005_22CS30029 -no-pie
	gcc TinyC3_22CS30005_22CS30029_7.o -o test7.out -L. -lTinyC3_22CS30005_22CS30029 -no-pie

	@echo "\n###########  Use ./test<i>.out for testing the ith file  ##########\n"

