//OPIS: Trostruka ugnjezdena for petlja - jednostavna
//RETURN: 39

int main() {
	int a, b, c;
	a = 0;
	b = 0;
	c = 0;

	for (int i in range 1:3) {
		a++;
		for (int j in range 1:3) {
			b++;
			for (int k in range 1:3)
				c++;
		}
	}

	return a + b + c;
}
