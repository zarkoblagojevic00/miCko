//OPIS: Dva argumenta
//RETURN: 15

int f(int a, int b) {
	return a + b;
}

int main() {
	int a, b, c;
	a = 5;
	b = 5;
	c = a + f(a, b);
	return c;
}
