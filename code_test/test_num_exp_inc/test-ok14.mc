//OPIS: Naizmenicni inkrement u dvostruko ugnjezdenom num_exp-u
//RETURN: 258

int main() {
    int x,y;
    x = 2;
    y = 6;
    y = x++ + ((y++ + x++) * x) * y++ ;
    return x + y;
}
