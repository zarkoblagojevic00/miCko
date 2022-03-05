//OPIS: Trostruki branch i for-ovi
//RETURN: 71

int main() {
	int a, b, c, d;
	a = 1;
	b = 5;
	c = 10;
	d = 0;
	
	for (int i in range 1:4)
	branch (i -> 1 -> 2 -> 3)
		first -> {
			for (int j in range 1:4) {
				branch (j -> 1 -> 2 -> 3)
					first -> {
						branch (c -> 1 ->5 -> 10)
							first -> d = d + a;
							second -> d = d + b;
							third -> d = d + c;
							otherwise -> d = d + 0;
						end_branch
					}
					second -> d = d + b;
					third -> d = d + c;
					otherwise -> d = d + 1;
				end_branch
			}
		}
		second -> {
			for (unsigned j in range 1u:5u)
				d++;
		}
		third -> d = d + c;
		otherwise -> d = d + 30;
	end_branch
	
	//10 + 5 + 10 + 1 + 5 + 10 + 30 = 71
	return d;
}			
