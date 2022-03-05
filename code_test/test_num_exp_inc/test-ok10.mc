//OPIS: Naizmenicni inkrement u ugnjezdenom num_exp-u
//RETURN: 35

int main() {
    int x,y;
    x = 2;
    y = 6;
    y = x++ + (x++ + x) * x++ ;
    return x + y;
}
