//OPIS: Branch u branch-u
int main () {
	int a;
	int b;
	a = 0;
	b = 1;
	
	branch (a -> 5 -> 6 -> 10)
	first  -> 
		branch (b -> 1 -> 2 -> 3)
			first  -> b++;
			second -> a++;
			third  -> a = a + b;
			otherwise -> b = a + b;
		end_branch
	second -> b++;
	third  -> a = a / b++;
	otherwise -> a = a * b;
	end_branch 
	
	return a; 
}
