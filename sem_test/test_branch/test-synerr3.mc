//OPIS: Branch fali end_branch 
int main () {
	int a;
	int b;
	a = 0;
	b = 1;
	
	branch (a -> 5 -> 6 -> 10)
	first  -> a++;
	second -> b++;
	third  -> a = a / b++;
	otherwise -> b = b * a++;  
	
	return a;
}