//OPIS: Funkciji sa vise parametara prosledjen parametar pogresnog tipa
int f (int a, unsigned b, int c, unsigned d, unsigned f) {
	return 5;
}

int main () {
	int a;
	unsigned b;
	int c;
	unsigned d;
	unsigned f;
	c = f(a, b, c, d, a);
	return c;
}
