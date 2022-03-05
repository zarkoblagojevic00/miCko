//OPIS: ponovljen inkrement u numexp-u
//RETURN: 51

int y;

int main() {
    int x;
    x = 2;
    y = 6;
    y = x++ + 42 + x++;
    return x + y;
}
