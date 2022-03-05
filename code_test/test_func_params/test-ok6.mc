//OPIS: Vise kompleksnih argumenata razlicitog tipa - funkcije
//RETURN: -23

int f(int a, unsigned b, int c, unsigned d) {
	return (b < d) ? a:c;
}

int f2(int x, int y) {
	return x - y;
}

int main() {
	int a, c;
	a = 5;
	c = 10;
	
	c = f2(5, 3) + a * f(f2(a, c), 5u, f2(c, a), 10u);
	return c;
}
