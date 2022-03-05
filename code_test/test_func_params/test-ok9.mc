//OPIS: Vise argumenata - samo literali
//RETURN: 26

int f(int a, unsigned b, int c, unsigned d, unsigned f1, int g, int h) {
	return a + c + (b * f1 == d) ? g:h;
}

int main() {
	return f(1, 5u, 5, 10u, 2u, 20, 30);
}
