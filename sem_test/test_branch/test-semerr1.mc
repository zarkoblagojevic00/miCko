//OPIS: Branch sa nedeklarisanom promenljivom
int main () {
	int a;
	int b;
	a = 0;
	b = 1;
	
	branch (c -> 5 -> 6 -> 10)
	first  -> a++;
	second -> b++;
	third  -> a = a / b++;
	otherwise -> a = a * b;
	end_branch  
	
	return a;
}
