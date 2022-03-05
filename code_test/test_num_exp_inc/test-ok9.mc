//OPIS: Naizmenicni inkrement, vezane prom bez inkrementa
//RETURN: 15

int main() {
    int x,y;
    x = 2;
    y = 6;
    y = x++ + x + x + x++ ;
    return x + y;
}
