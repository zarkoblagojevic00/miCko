//OPIS: Jednostavniji num_exp u rel_exp-u
//RETURN: 7

int main() {
    int x,y;
    x = 5;
    y = 5;
    
    if (x++ == y++)
    	if (x < y++)
    		return x;
    	else
    		return y;
   	
   	return 0;
    
}
