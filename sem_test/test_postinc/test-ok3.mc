//OPIS: Inkrement u uslovu
int main() {
	int a, b, c;
	a = 5;
	b = 6;
	c = 10;
	
	if (c > a++ + b++)
		c = 5;
		
	return 5;
}
