//OPIS: Rekurzivno pozivanje funkcija kao argument
//RETURN: 20

int f(int x, int y) {
	return x - y;
}

int main() {
	int a, c;
	a = 5;
	c = 10;
	
	c = f(a, f(f(a, c), c));
	return c;
}
