
#include "TinyC3_22CS30005_22CS30029_translator.h"
#include <sstream>
using namespace std;

quadArray q;
string Type;
symtable *table;
sym *currentSymbol;
symtable *globalTable;

symtype::symtype(string type, symtype *ptr, int width) : type(type),
														 ptr(ptr),
														 width(width){};

quad::quad(string result, string arg1, string op, string arg2) : result(result), arg1(arg1), arg2(arg2), op(op){};

quad::quad(string result, int arg1, string op, string arg2) : result(result), arg2(arg2), op(op)
{
	stringstream strs;
	strs << arg1;
	string temp_str = strs.str();
	char *intStr = (char *)temp_str.c_str();
	string str = string(intStr);
	this->arg1 = str;
}

quad::quad(string result, float arg1, string op, string arg2) : result(result), arg2(arg2), op(op)
{
	std::ostringstream buff;
	buff << arg1;
	this->arg1 = buff.str();
}

void quad::print()
{

	if (op == "LEFTOP")
		std::cout << result << " = " << arg1 << " << " << arg2;
	else if (op == "RIGHTOP")
		std::cout << result << " = " << arg1 << " >> " << arg2;
	else if (op == "EQUAL")
		std::cout << result << " = " << arg1;

	else if (op == "ADD")
		std::cout << result << " = " << arg1 << " + " << arg2;
	else if (op == "SUB")
		std::cout << result << " = " << arg1 << " - " << arg2;
	else if (op == "MULT")
		std::cout << result << " = " << arg1 << " *" << arg2;
	else if (op == "DIVIDE")
		std::cout << result << " = " << arg1 << " / " << arg2;
	else if (op == "MODOP")
		std::cout << result << " = " << arg1 << " % " << arg2;
	else if (op == "XOR")
		std::cout << result << " = " << arg1 << " ^ " << arg2;
	else if (op == "INOR")
		std::cout << result << " = " << arg1 << " | " << arg2;
	else if (op == "BAND")
		std::cout << result << " = " << arg1 << " &" << arg2;

	else if (op == "ADDRESS")
		std::cout << result << " = &" << arg1;
	else if (op == "PTRR")
		std::cout << result << " = *" << arg1;
	else if (op == "PTRL")
		std::cout << "*" << result << " = " << arg1;
	else if (op == "UMINUS")
		std::cout << result << " = -" << arg1;
	else if (op == "BNOT")
		std::cout << result << " = ~" << arg1;
	else if (op == "LNOT")
		std::cout << result << " = !" << arg1;

	else if (op == "EQOP")
		std::cout << "if " << arg1 << " == " << arg2 << " goto " << result;
	else if (op == "NEOP")
		std::cout << "if " << arg1 << " != " << arg2 << " goto " << result;
	else if (op == "LT")
		std::cout << "if " << arg1 << "<" << arg2 << " goto " << result;
	else if (op == "GT")
		std::cout << "if " << arg1 << " > " << arg2 << " goto " << result;
	else if (op == "GE")
		std::cout << "if " << arg1 << " >= " << arg2 << " goto " << result;
	else if (op == "LE")
		std::cout << "if " << arg1 << " <= " << arg2 << " goto " << result;
	else if (op == "GOTOOP")
		std::cout << "goto " << result;

	else if (op == "ARRR")
		std::cout << result << " = " << arg1 << "[" << arg2 << "]";
	else if (op == "ARRL")
		std::cout << result << "[" << arg1 << "]"
				  << " = " << arg2;
	else if (op == "RETURN")
		std::cout << "ret " << result;
	else if (op == "PARAM")
		std::cout << "param " << result;
	else if (op == "CALL")
		std::cout << result << " = "
				  << "call " << arg1 << ", " << arg2;
	else if (op == "FUNC")
		std::cout << result << ": ";
	else if (op == "FUNCEND")
		std::cout << "";
	else
		std::cout << "op";
	std::cout << endl;
}

void quadArray::print()
{
	std::cout << setw(30) << setfill('=') << "=" << endl;
	std::cout << "Quad Translation" << endl;
	std::cout << setw(30) << setfill('-') << "-" << setfill(' ') << endl;
	for (vector<quad>::iterator it = Array.begin(); it != Array.end(); it++)
	{
		if (it->op == "FUNC")
		{
			std::cout << "\n";
			it->print();
			std::cout << "\n";
		}
		else if (it->op == "FUNCEND")
		{
		}
		else
		{
			std::cout << "\t" << setw(4) << it - Array.begin() << ":\t";
			it->print();
		}
	}

	std::cout << setw(30) << setfill('-') << "-" << endl;
}

sym::sym(string name, string t, symtype *ptr, int width) : name(name)
{
	type = new symtype(t, ptr, width);
	nested = NULL;
	initial_value = "";
	category = "";
	offset = 0;
	size = size_type(type);
}

sym *sym::update(symtype *t)
{
	type = t;
	this->size = size_type(t);
	return this;
}

symtable::symtable(string name) : name(name), count(0) {}

void symtable::print()
{
	list<symtable *> tablelist;
	std::cout << setw(120) << setfill('=') << "=" << endl;
	std::cout << "Symbol Table: " << setfill(' ') << left << setw(50) << this->name;
	std::cout << right << setw(25) << "Parent: ";
	if (this->parent != NULL)
		std::cout << this->parent->name;
	else
		std::cout << "null";
	std::cout << endl;
	std::cout << setw(120) << setfill('-') << "-" << endl;
	std::cout << setfill(' ') << left << setw(15) << "Name";
	std::cout << left << setw(25) << "Type";
	std::cout << left << setw(15) << "Category";
	std::cout << left << setw(30) << "Initial Value";
	std::cout << left << setw(12) << "Size";
	std::cout << left << setw(12) << "Offset";
	std::cout << left << "Nested" << endl;
	std::cout << setw(120) << setfill('-') << "-" << setfill(' ') << endl;

	for (list<sym>::iterator it = table.begin(); it != table.end(); it++)
	{
		std::cout << left << setw(15) << it->name;
		string stype = print_type(it->type);
		std::cout << left << setw(25) << stype;
		std::cout << left << setw(15) << it->category;
		std::cout << left << setw(30) << it->initial_value;
		std::cout << left << setw(12) << it->size;
		std::cout << left << setw(12) << it->offset;
		std::cout << left;
		if (it->nested == NULL)
		{
			std::cout << "null" << endl;
		}
		else
		{
			std::cout << it->nested->name << endl;
			tablelist.push_back(it->nested);
		}
	}

	std::cout << setw(120) << setfill('-') << "-" << setfill(' ') << endl;
	std::cout << endl;
	for (list<symtable *>::iterator iterator = tablelist.begin(); iterator != tablelist.end();
		 ++iterator)
	{
		(*iterator)->print();
	}
}

void symtable::update()
{
	list<symtable *> tablelist;
	int off = 0;
	for (list<sym>::iterator it = table.begin(); it != table.end(); it++)
	{
		it->offset = off;
		off = it->offset + it->size;
		if (it->nested != NULL)
			tablelist.push_back(it->nested);
	}

	for (list<symtable *>::iterator iterator = tablelist.begin(); iterator != tablelist.end(); ++iterator)
	{
		(*iterator)->update();
	}
}

sym *symtable::lookup(string name)
{
	sym *s;
	for (list<sym>::iterator it = table.begin(); it != table.end(); it++)
	{
		if (it->name == name)
			return &*it;
		;
	}

	s = new sym(name);
	s->category = "local";
	table.push_back(*s);
	return &table.back();
}

void emit(string op, string result, string arg1, string arg2)
{
	q.Array.push_back(*(new quad(result, arg1, op, arg2)));
}

void emit(string op, string result, int arg1, string arg2)
{
	q.Array.push_back(*(new quad(result, arg1, op, arg2)));
}

void emit(string op, string result, float arg1, string arg2)
{
	q.Array.push_back(*(new quad(result, arg1, op, arg2)));
}

sym *conv(sym *s, string t)
{
	sym *temp = gentemp(new symtype(t));
	if (s->type->type == "INTEGER")
	{
		if (t == "DOUBLE")
		{
			emit("EQUAL", temp->name, "int2double(" + s->name + ")");
			return temp;
		}
		else if (t == "CHAR")
		{
			emit("EQUAL", temp->name, "int2char(" + s->name + ")");
			return temp;
		}

		return s;
	}
	else if (s->type->type == "DOUBLE")
	{
		if (t == "INTEGER")
		{
			emit("EQUAL", temp->name, "double2int(" + s->name + ")");
			return temp;
		}
		else if (t == "CHAR")
		{
			emit("EQUAL", temp->name, "double2char(" + s->name + ")");
			return temp;
		}

		return s;
	}
	else if (s->type->type == "CHAR")
	{
		if (t == "INTEGER")
		{
			emit("EQUAL", temp->name, "char2int(" + s->name + ")");
			return temp;
		}

		if (t == "DOUBLE")
		{
			emit("EQUAL", temp->name, "char2double(" + s->name + ")");
			return temp;
		}

		return s;
	}

	return s;
}

bool typecheck(sym *&s1, sym *&s2)
{

	symtype *type1 = s1->type;
	symtype *type2 = s2->type;
	if (typecheck(type1, type2))
		return true;
	else if (s1 = conv(s1, type2->type))
		return true;
	else if (s2 = conv(s2, type1->type))
		return true;
	else
		return false;
}

bool typecheck(symtype *t1, symtype *t2)
{

	if (t1 != NULL || t2 != NULL)
	{
		if (t1 == NULL)
			return false;
		if (t2 == NULL)
			return false;
		if (t1->type == t2->type)
			return typecheck(t1->ptr, t2->ptr);
		else
			return false;
	}

	return true;
}

void backpatch(list<int> l, int addr)
{
	stringstream strs;
	strs << addr;
	string temp_str = strs.str();
	char *intStr = (char *)temp_str.c_str();
	string str = string(intStr);
	for (list<int>::iterator it = l.begin(); it != l.end(); it++)
	{
		q.Array[*it].result = str;
	}
}

list<int> makelist(int i)
{
	list<int> l(1, i);
	return l;
}

list<int> merge(list<int> &a, list<int> &b)
{
	a.merge(b);
	return a;
}

expr *convertInt2Bool(expr *e)
{

	if (e->type != "BOOL")
	{
		e->falselist = makelist(nextinstr());
		emit("EQOP", "", e->loc->name, "0");
		e->truelist = makelist(nextinstr());
		emit("GOTOOP", "");
	}

	return e;
}

expr *convertBool2Int(expr *e)
{

	if (e->type == "BOOL")
	{
		e->loc = gentemp(new symtype("INTEGER"));
		backpatch(e->truelist, nextinstr());
		emit("EQUAL", e->loc->name, "true");
		stringstream strs;
		strs << nextinstr() + 1;
		string temp_str = strs.str();
		char *intStr = (char *)temp_str.c_str();
		string str = string(intStr);
		emit("GOTOOP", str);
		backpatch(e->falselist, nextinstr());
		emit("EQUAL", e->loc->name, "false");
	}

	return e;
}

void changeTable(symtable *newtable)
{

	table = newtable;
}

int nextinstr()
{
	return q.Array.size();
}


sym *gentemp(symtype *t, string init)
{
	char n[10];
	sprintf(n, "t%02d", table->count++);
	sym *s = new sym(n);
	s->type = t;
	s->size = size_type(t);
	s->initial_value = init;
	s->category = "temp";
	table->table.push_back(*s);
	return &table->table.back();
}

int size_type(symtype *t)
{
	if (t->type == "VOID")
		return 0;
	else if (t->type == "ARR")
		return t->width * size_type(t->ptr);
	else if (t->type == "PTR")
		return POINTER_SIZE;
	else if (t->type == "CHAR")
		return CHAR_SIZE;
	else if (t->type == "FUNC")
		return 0;
	else if (t->type == "DOUBLE")
		return DOUBLE_SIZE;
	else if (t->type == "INTEGER")
		return INT_SIZE;
	return -1;
}

string print_type(symtype *t)
{
	if (t == NULL)
		return "null";
	if (t->type == "VOID")
		return "void";
	else if (t->type == "CHAR")
		return "char";
	else if (t->type == "INTEGER")
		return "integer";
	else if (t->type == "DOUBLE")
		return "double";
	else if (t->type == "PTR")
		return "ptr(" + print_type(t->ptr) + ")";
	else if (t->type == "ARR")
	{
		stringstream strs;
		strs << t->width;
		string temp_str = strs.str();
		char *intStr = (char *)temp_str.c_str();
		string str = string(intStr);
		return "arr(" + str + ", " + print_type(t->ptr) + ")";
	}
	else if (t->type == "FUNC")
		return "function";
	else
		return "_";
}