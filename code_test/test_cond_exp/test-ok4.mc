//OPIS: Uslovni izraz, kompleksniji izrazi, gvar, par
//RETURN: 9
int y;

int f(int x) {
	return ((y<x) ? x:y);
}

int main() {
	int a;
	int b;
	int c;
	y = 0;
	a = 1;
	b = 2;
	c = a + (a == b) ? 1 : 0 + 3 + f(5);
	
	return c;
}
