//OPIS: Uslovni izraz, kompleksniji izrazi, gvar, par
//RETURN: 19
int y;

int bar(int x) {
	return x++;
}

int foo(int x) {
	return ((y<x) ? x:y) + bar(bar(5 - 5 + 5)) + bar(bar(5 - 5 + 5)); 
}

int main() {
	int a;
	int b;
	int c;
	y = 0;
	a = 1;
	b = 2;
	c = a + (a == b) ? 1 : 0 + 3 + foo(5);
	
	return c;
}
