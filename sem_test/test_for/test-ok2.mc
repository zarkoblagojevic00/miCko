//OPIS: Tri for petlje sa istim iteratorom 
int main()
{
	int a;
	a = 0;
	
	for (int i in range 1:5)
		a++;
	
	for (unsigned i in range 1u:5u)
		a = a*a;
	
	for (int i in range 1:5)
		a = a/a;
	
	return a;
}
