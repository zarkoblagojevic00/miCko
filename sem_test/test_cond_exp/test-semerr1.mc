//OPIS: Nedeklarisana promenljiva kao cond operand
int main() {
	int a;
	int b;
	
	a = 1;
	b = 2;
	a = (a < b) ? c:b;
	return a;
}

