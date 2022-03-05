//OPIS: Kombinacije svih aritmetickih operacija - neodgovarajuci tipovi

int f(int a) {
	return a + 1;
}

unsigned fu(unsigned a) {
	return a + 1u;
}

int main () {
	int a, b, c, d, f;
	unsigned i, j, k, l;
	
	a = b++ + i * d;
	b = (c/d + fu(j)) / d;
	c = a + (j / d);
	d = ((a * i) + c); 
	
	i = a - b / l;
	j = (i - b) * l;	
	k = fu(i) * j * c;
	l = j++ / b++ - i++;
	return 5;
}
