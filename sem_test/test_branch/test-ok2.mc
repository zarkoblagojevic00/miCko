//OPIS: Branch sa unsigned var
int main () {
	unsigned a;
	unsigned b;
	a = 1u;
	b = 2u;
	
	branch (a -> 5u -> 6u -> 10u)
	first  -> a++;
	second -> b++;
	third  -> a = a / b++;
	otherwise -> a = a * b;
	end_branch
	
	return 5;  
}
