//OPIS: Branch iskaz sa FIT kao branch variable
int main () {
	int a;
	int b;
	a = 0;
	b = 1;
	
	for (int i in range 1:3)
		branch (i -> 1 -> 2 -> 3)
			first  -> a++;
			second -> b++;
			third  -> a = a / b++;
			otherwise -> a = a * b;
		end_branch  
	
	return a;
}
