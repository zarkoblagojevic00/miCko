//OPIS: Inkrementirane promenljive u izrazu iz uslova neodgovarajuceg tipa
int main() {
    int a, b;
    unsigned du;
    
    if (a == b++ + du++)
    	b = a;
    	
    return 5;
}
