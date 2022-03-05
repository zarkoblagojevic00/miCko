//OPIS: Ugnjezdena for petlja - slozenija
//RETURN: 60

int main() {
	int a, b, c;
	a = 0;
	b = 0;

	for (int i in range 1:20) {
		if (i <= 10)
			a++;
		else
			for (int j in range 1:5) 
				b++;
	}

	return a + b;
}
