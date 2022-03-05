//OPIS: Uslovni izraz u num_exp
//RETURN: 3
unsigned main() {
	unsigned a;
	unsigned b;
	unsigned c;
	
	a = 1u;
	b = 2u;
	c = (a > b) ? a:b  + (a < b) ? a:b;
	return c;
}
