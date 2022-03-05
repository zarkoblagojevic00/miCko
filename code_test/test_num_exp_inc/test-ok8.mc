//OPIS: Naizmenicni inkrementa
//RETURN: 12

int main() {
    int x,y;
    x = 2;
    y = 6;
    y = x++ + x + x++ ;
    return x + y;
}
