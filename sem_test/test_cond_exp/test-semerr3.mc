//OPIS: Tip parametra i gvar u cond izrazu ne odgovara

unsigned x;

int f(int a, int b) {
	x = 5u;
	return (a < b) ? a:x;
}

int main() {
	int a;
	int b;
	int c;
	
	a = 1;
	b = 2;
	c = (a < b) ? a:b;
	return c;
}
