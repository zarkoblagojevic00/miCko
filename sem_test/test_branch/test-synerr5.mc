//OPIS: Branch fali treca konstanta
int main () {
	int a;
	int b;
	a = 0;
	b = 1;
	
	branch (a -> 5 -> 6)
	first  -> a++;
	second -> b++;
	third  -> a = a / b++;
	otherwise -> b = b * a++;  
	end_branch
	
	return a;
}
