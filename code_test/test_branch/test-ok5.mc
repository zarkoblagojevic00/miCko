//OPIS: Slozeni iskazi u granama 
//RETURN: 31

int x;
int y;
int z;

int f() {
	return x + y + z;	
}

int main() {
	int a, b, c, d;
	x = 1;
	y = 5;
	z = 10;
	d = 0;
	
	for (int i in range 1:10)
		branch (i -> 1 -> 2 -> 3)
			first -> d = d + f();
			second -> d = d + y;
			third -> d = d + z;
			otherwise -> d = d * x;
		end_branch 
	return d;
}
