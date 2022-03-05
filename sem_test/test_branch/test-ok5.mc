//OPIS: Branch sa return 
int main () {
	int a;
	int b;
	a = 0;
	b = 1;
	
	branch (a -> 5 -> 6 -> 10)
	first  -> a++;
	second -> return a;
	third  -> return b;
	otherwise -> return a + b;
	end_branch  
}
