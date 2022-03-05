//OPIS: Branch iskaz sa blokom naredbi
int main () {
	int a;
	int b;
	a = 0;
	b = 1;
	
	for (unsigned i in range 1u:3u)
		branch (i -> 1u -> 2u -> 3u)
			first  -> {
				a++;
				i++;
			}
			second -> b++;
			third  -> a = a / b++;
			otherwise -> i++;
		end_branch  
	
	return a;
}
