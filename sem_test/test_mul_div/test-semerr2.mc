//OPIS: Samo puta i podeljeno - neodgovarajuci tipovi

int f(int a) {
	return a + 1;
}

unsigned fu(unsigned a) {
	return a + 1u;
}

int main () {
	int a, b, c, d, f;
	unsigned i, j, k, l;
	
	a = b++ * i / d;
	b = (c/d / fu(j)) * d;
	c = a / (j * i);
	d = ((k / i) * c); 
	
	i = a * k / l;
	j = (i / b) * l;	
	k = fu(i) * c / k;
	l = j++ / c++ * i++;
	return 5;
}
