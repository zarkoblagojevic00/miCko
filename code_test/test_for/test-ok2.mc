//OPIS: for petlja sa slozenijim statementom
//RETURN: 10

unsigned main() {
	unsigned a, b, c;
	a = 0u;
	b = 5u;

	for (unsigned i in range 1u:5u) {
		if (a < b)
			a++;
		else
			b = b - 1u; 
	}

	return a + b;
}
