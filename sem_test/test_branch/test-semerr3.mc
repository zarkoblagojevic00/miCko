//OPIS: Branch sa const2 neodgovarajuceg tipa 
int main () {
	int a;
	int b;
	a = 0;
	b = 1;
	
	branch (a -> 5 -> 6u -> 10)
	first  -> a++;
	second -> b++;
	third  -> a = a / b++;
	otherwise -> a = a * b;
	end_branch  
	
	return a;
}
