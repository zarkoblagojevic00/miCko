//OPIS: Branch sa sve tri konstante neodgovarajuceg tipa 
int main () {
	unsigned a;
	unsigned b;
	a = 0u;
	b = 1u;
	
	branch (a -> 5 -> 6 -> 10)
	first  -> a++;
	second -> b++;
	third  -> a = a / b++;
	otherwise -> a = a * b;
	end_branch  
	
	return 5;
}
