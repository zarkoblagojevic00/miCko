//OPIS: Slozeni num_exp u rel_exp-u
//RETURN: 1237

int main() {
    int x,y;
    x = 2;
    y = 6;
    
    if ((x++ + ((y++ + x++) * x)* y++) < 
    		(x++ + (x + (y++ + y)) * y++))
    	y = (x++ + (x + (y++ + y)) * y++);
    else
    	y = (x++ + ((y++ + x++) * x)* y++); 
    
    return y;
}
