//OPIS: Naizmenicni inkrement u dvostruko ugnjezdenom num_exp-u
//RETURN: 117

int main() {
    int x,y;
    x = 2;
    y = 6;
    y = x++ + (x + (y++ + y)) * y++ ;
    return x + y;
}
