//OPIS: Branch sa const1 neodgovarajuceg tipa 
int main () {
	int a;
	int b;
	a = 0;
	b = 1;
	
	branch (a -> 5u -> 6 -> 10)
	first  -> a++;
	second -> b++;
	third  -> a = a / b++;
	otherwise -> a = a * b;
	end_branch  
	
	return a;
}
