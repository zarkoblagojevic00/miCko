//OPIS: Ugnjezdeni branch
//RETURN: 25

int main() {
	int a, b, c, d;
	a = 1;
	b = 5;
	c = 10;
	d = 0;
	
	for (int i in range 1:4)
	branch (i -> 1 -> 2 -> 3)
		first -> {
			branch (b -> 1 ->5 -> 10)
				first -> d = d + a;
				second -> d = d + b;
				third -> d = d + c;
				otherwise -> d = d + 0;
			end_branch
		}
		second -> d = d + b;
		third -> {
			branch (b -> 1 ->5 -> 10)
				first -> d = d + a;
				second -> d = d + b;
				third -> d = d + c;
				otherwise -> d = d + 0;
			end_branch
		}
		otherwise -> {
			branch (c -> 1 ->5 -> 10)
				first -> d = d + a;
				second -> d = d + b;
				third -> d = d + c;
				otherwise -> d = d + 0;
			end_branch
		}
		end_branch
	
	
	return d;
}
