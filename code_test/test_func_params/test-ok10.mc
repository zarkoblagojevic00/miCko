//OPIS: Vise argumenata - samo literali
//RETURN: 12

int x;

int f(int a, unsigned b, int c, unsigned d, unsigned f1, int g, int h) {
	return a + c + (b * f1 == d) ? g:h;
}

int f2() {
	return x++; 
}

int main() {
	x = 5;
	return f(1, 5u, f2(), 10u, 2u, f2(), 30);
}
