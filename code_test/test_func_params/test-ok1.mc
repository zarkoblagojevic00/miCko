//OPIS: Jedan argument
//RETURN: 11

int f(int a) {
	return a + 1;
}

int main() {
	int a, b, c;
	a = 5;
	b = 5;
	c = b + f(a);
	return c;
}
