//OPIS: 'Ne void' funkcija sa return;
int f() {
	int a;
	return;
}

int main() {
	int a;
	f();
	a = 5;
	return a;
}
