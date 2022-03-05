//OPIS: Vise kompleksnih argumenata razlicitog tipa
//RETURN: -30

int f(int a, unsigned b, int c, unsigned d) {
	return (b < d) ? a:c;
}

int f2(int x, int y) {
	return x - y;
}

int main() {
	int a, c;
	unsigned b, d;
	a = 5;
	b = 5u;
	c = 10;
	d = 25u;
	
	c = f2(a, c) + a * f(f2(a, c), b, a + c, d);
	return c;
}
