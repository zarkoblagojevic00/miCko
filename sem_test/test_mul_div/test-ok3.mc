//OPIS: Kombinacije svih aritmetickih operacija

int f(int a) {
	return a + 1;
}

unsigned fu(unsigned a) {
	return a + 1u;
}

int main () {
	int a, b, c, d, f;
	unsigned i, j, k, l;
	
	a = b++ + c * d;
	b = (c/d + f(a)) / d;
	c = a + (b / d);
	d = ((a * b) + c); 
	
	i = j - k / l;
	j = (i - k) * l;	
	k = fu(i) + j * k;
	l = j++ / k++ - i++;
	return 5;
}
