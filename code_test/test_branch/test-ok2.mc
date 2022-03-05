//OPIS: Slozeni iskazi u granama 
//RETURN: 47

int main() {
	int a, b, c, d;
	a = 1;
	b = 5;
	c = 10;
	d = 0;
	
	for (int i in range 1:4)
	branch (i -> 1 -> 2 -> 3)
		first -> {
			d = d + a;
			if (d > 2)
				a++;
			else
				d++; 
		}
		second -> {
			for (unsigned j in range 1u:5u)
				d++;
		}
		third -> d = d + c;
		otherwise -> d = d + 30;
	end_branch
	
	return d;
}
