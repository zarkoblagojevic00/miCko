//OPIS: Uslovni izraz, kompleksniji num_exp, gvar
//RETURN: 0

int a;
int b;

int main() {
	int c;
	
	a = 1;
	b = 1;
	c = (a >= b) ? a:b * (a == b) ? 0:b / (a <= b) ? a:b;
	return c;
}
