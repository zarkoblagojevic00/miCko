//OPIS: Naizmenicni inkrement u ugnjezdenom num_exp-u
//RETURN: 68

int main() {
    int x,y;
    x = 2;
    y = 6;
    y = x++ + (y++ + x) * y ;
    return x + y;
}
