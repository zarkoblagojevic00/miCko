//OPIS: Vise uzastopnih inkrementa
//RETURN: 14

int main() {
    int x,y;
    x = 2;
    y = 6;
    y = x++ + x++ + x++ ;
    return x + y;
}

