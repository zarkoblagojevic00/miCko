//OPIS: Branch sa for-om u otherwise
int main () {
	int a;
	int b;
	a = 0;
	b = 1;
	
	branch (a -> 5 -> 6 -> 10)
	first  -> a++;
	second -> b++;
	third  -> a = a / b++;
	otherwise -> 
		for (unsigned i in range 1u:5u) {
			if (a > b)
				a++;
			else 
				b++;
		}
	end_branch  
	
	return a;
}
