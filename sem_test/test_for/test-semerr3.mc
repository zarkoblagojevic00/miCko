//OPIS: Ugnjezdena for petlja, isto nazvani FIT
int main()
{
	int a;
	a = 0;
	for (int i in range 1:5)
		for (unsigned j in range 1u:5u)
			for (unsigned i in range 1u:5u)
				a++;
	
	return a;
}
