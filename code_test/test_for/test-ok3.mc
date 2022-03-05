//OPIS: Ugnjezdena for petlja - jednostavna
//RETURN: 30

int main() {
	int a, b, c;
	a = 0;
	b = 0;

	for (int i in range 1:5) {
		a++;
		for (int j in range 1:5) 
			b++;
	}

	return a + b;
}
