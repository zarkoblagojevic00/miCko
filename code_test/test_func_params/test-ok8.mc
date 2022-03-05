//OPIS: Vise argumenata - samo literali
//RETURN: 27

int f(int a, unsigned b, int c, unsigned d) {
	return (b < d) ? a:c;
}

int f2(int x, int y) {
	return x - y;
}

int main() {
	
	return f2(5, 3) + 25 * f(1, 5u, f2(5,3), 10u);
}
