//OPIS: Jedna for petlja sa blokom naredbi
int main()
{
	int a;
	int b;
	a = 0;
	b = 0;
	for (int i in range 1:5)
	{
		b = i - 1;
		a = b * i;
		b = a/i;
	}
	
	return a;
}
