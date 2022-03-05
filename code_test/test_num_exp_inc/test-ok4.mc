//OPIS: inkrement u numexp-u, mnozenje
//RETURN: 135

int main() {
    int x;
    int y;
    x = 3;
    y = x++ * 42 + x++ ;
    return x + y;
}
