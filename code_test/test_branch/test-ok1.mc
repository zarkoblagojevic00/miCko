//OPIS: Test svih grana 
//RETURN: 20

int main() {
	int a, b, c, d;
	a = 1;
	b = 5;
	c = 10;
	d = 0;
	
	branch (a -> 1 ->5 -> 10)
		first -> d = d + a;
		second -> d = d + b;
		third -> d = d + c;
		otherwise -> d = d + 0;
	end_branch
	
	branch (b -> 1 ->5 -> 10)
		first -> d = d + a;
		second -> d = d + b;
		third -> d = d + c;
		otherwise -> d = d + 0;
	end_branch
	
	branch (c -> 1 ->5 -> 10)
		first -> d = d + a;
		second -> d = d + b;
		third -> d = d + c;
		otherwise -> d = d + 0;
	end_branch
	
	branch (d -> 1 ->5 -> 10)
		first -> d = d + a;
		second -> d = d + b;
		third -> d = d + c;
		otherwise -> d = d + 4;
	end_branch
	
	return d;
}
