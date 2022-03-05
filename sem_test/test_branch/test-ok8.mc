//OPIS: Branch iskaz sa pozivom funkcije 
int f(int a, int b, unsigned c) {
	if (c > 0u)
		return a + b;
	else
		return a - b;
}

int main () {
	int a;
	int b;
	unsigned c;
	a = 0;
	b = 1;
	c = 5u;
	
	branch (a -> 1 -> 2 -> 3)
		first  -> a = f(a, b, c);
		second -> b++;
		third  -> a = a / b++;
		otherwise -> a++;
	end_branch  

	return a;
}
