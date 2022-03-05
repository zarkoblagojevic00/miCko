//OPIS: inkrement u numexp-u, mnozenje
//RETURN: 257

int main() {
    int x,y;
    x = 2;
    y = 6;
    y = x++ + y++ * 42;
    return x + y;
}


