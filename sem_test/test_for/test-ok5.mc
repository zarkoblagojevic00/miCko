//OPIS: Jedna for petlja sa blokom naredbi sa uslovima
int main()
{
	int a, b, c;
	a = 0;
	b = 1;
	c = 2;

	for (int i in range 1:5)
	{
			if (a < b)
				b = b - 1;
			else
				a = a - 1 ;
			
			c++;
	}
		
	
	return a;
}
