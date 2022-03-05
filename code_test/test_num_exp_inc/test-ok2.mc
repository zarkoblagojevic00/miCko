//OPIS: Ugnjezdeni num_exp
//RETURN: 59

int main()
{
    int x, y;
    x = 2;
    y = 6;
    y = x++ + (x + y/1) * y++ ;
    return x + y;
}

