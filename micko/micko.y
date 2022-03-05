%{
  #include <stdio.h>
  #include <stdlib.h>
  #include "defs.h"
  #include "symtab.h"
  #include "codegen.h"

  int yyparse(void);
  int yylex(void);
  int yyerror(char *s);
  void warning(char *s);

	extern int yylineno;
	int out_lin = 0;
  char char_buffer[CHAR_BUFFER_LENGTH];
  int error_count = 0;
  int warning_count = 0;
  int fun_idx = -1;
  int fcall_idx = -1;
  int branch_var_idx = -1;
  int var_type = NO_TYPE;
  bool return_occurred = FALSE;
  bool in_num_exp = FALSE;
  int var_num = 0;
  int par_num = 0;
  int arg_num = 0;
  int for_num = -1;
  int lab_num = -1;
  int branch_num = -1;
  int inc_num = 0;
  int root_inc_idx = -1;
  int first_inc_idx = -1;
  int first_arg_idx = -1;
  
  FILE *output;
  //int cb_num = 0;		// otkomentarisati za test blok komentara
  
%}

%union {
  int i;
  char *s;
}

%token <i> _TYPE
%token _IF
%token _ELSE
%token _RETURN
%token _FOR
%token _IN
%token _RANGE
%token _BRANCH 
%token _FIRST 
%token _SECOND 
%token _THIRD 
%token _OTHERWISE  
%token _END_BRANCH 
%token _ARROW
%token <s> _ID
%token <s> _INT_NUMBER
%token <s> _UINT_NUMBER
%token _LPAREN
%token _RPAREN
%token _LBRACKET
%token _RBRACKET
%token _COLON
%token _SEMICOLON
%token _COMMA
%token _QMARK
%token _ASSIGN
%token <i> _AROP		// '+' i '-'
%token <i> _PAROP 	// '*' i '/' (priority arop)
%token <i> _RELOP
%token _INCREMENT
//%token _COMMENT_BLOCK		// otkomentarisati za test blok komentara


%type <i> num_exp root_num_exp num_exp_inc mul_div_exp exp literal increment_exp cond_operand  
%type <i> function_call argument arguments rel_exp if_part condition_part conditional_exp

%nonassoc ONLY_IF
%nonassoc _ELSE

%%

program
  : global_list function_list
      {  
        if(lookup_symbol("main", FUN) == NO_INDEX)
          err("undefined reference to 'main'");
      }
  ;

global_list
	: /* empty */
	| global_list global_var
	;
	
global_var
	: _TYPE _ID _SEMICOLON
		{
			if ($1 == VOID)
  			err("declaration of global variable of type: VOID");
  			
			if(lookup_symbol($2, GVAR) == NO_INDEX) {
				 insert_symbol($2, GVAR, $1, NO_ATR, NO_ATR);
				 code("\n%s:\n\t\tWORD\t1", $2);
			}
			else 
				 err("redefinition of global variable'%s'", $2);
		
		}
	;
	
function_list
  : function
  | function_list function
  ;

function
  : _TYPE _ID
      {
        fun_idx = lookup_symbol($2, FUN);
        if(fun_idx == NO_INDEX)
          fun_idx = insert_symbol($2, FUN, $1, NO_ATR, NO_ATR);
        else 
          err("redefinition of function '%s'", $2);
          
        code("\n%s:", $2);
        code("\n\t\tPUSH\t%%14");
        code("\n\t\tMOV \t%%15,%%14");
      }
    _LPAREN parameters _RPAREN body
      {
        if(!return_occurred)
        {
        	if(get_type(fun_idx) != VOID)
  	  	    warn("no return statement in non void function '%s'", $2);
        }
        else
   				return_occurred = FALSE;
        
        set_atr1(fun_idx, par_num);
        //print_symtab();
        clear_symbols(fun_idx + par_num + 1);
        //print_symtab();
        par_num = 0;
        var_num = 0;
        
        code("\n@%s_exit:", $2);
        code("\n\t\tMOV \t%%14,%%15");
        code("\n\t\tPOP \t%%14");
        code("\n\t\tRET");
      }
  ;

parameters
  : /* empty */
      { set_atr1(fun_idx, 0); }

  | parameter_list
  ;
  
parameter_list
  : parameter
  | parameter_list _COMMA parameter
  ;
 
parameter
  : _TYPE _ID
      {
      	if ($1 == VOID)
      		err("function '%s' has parameter '%s' of type: VOID", get_name(fun_idx), $2);
      	else
      	{
      		if(lookup_symbol_from(fun_idx, $2, PAR) == NO_INDEX)
		   			insert_symbol($2, PAR, $1, ++par_num, NO_ATR);
					else 
		   			err("function '%s' already has parameter named '%s'", get_name(fun_idx), $2);
      	}
		    
      }
  ;
  
body
  : _LBRACKET variable_list
      {
        if(var_num)
          code("\n\t\tSUBS\t%%15,$%d,%%15", 4*var_num);
        code("\n@%s_body:", get_name(fun_idx));
      }
    statement_list _RBRACKET
  ;

variable_list
  : /* empty */
  | declarat_multilist 
  ;

declarat_multilist
	: declarat_list
	| declarat_multilist declarat_list
	;

declarat_list
	: _TYPE  
  	{ 
  		if ($1 == VOID)
  			err("declaration of variable(s) of type: VOID");
  		else
  			var_type = $1; 
  	} 
  	
  	var_ids _SEMICOLON
  ;
	
var_ids
	: var_id
	| var_ids _COMMA var_id

var_id
	: _ID
	{
			if(lookup_symbol_from(fun_idx, $1, VAR|PAR) == NO_INDEX)
				 insert_symbol($1, VAR, var_type, ++var_num, NO_ATR);
			else 
				 err("redefinition of '%s'", $1);
	}
	;

statement_list
  : /* empty */
  | statement_list statement
  ;

statement
  : compound_statement
  | increment_statement
  | function_call_statement		// dodato radi lakseg testiranja funkcija sa vise parametara
  | for_statement
  | branch_statement
  | assignment_statement
  | if_statement
  | return_statement
  //| comment_block			// otkomentarisati za test blok komentara (dodao ovde samo da bih testirao, ako je zakomentarisano blok komentar moze biti bilo gde u tekstu programa, ne samo kao statement)
  ;

compound_statement
  : _LBRACKET statement_list _RBRACKET
  ;

increment_statement
  : _ID _INCREMENT _SEMICOLON
  	{
			int idx = lookup_symbol_local_global(fun_idx, $1, VAR|PAR);  
      if(idx == NO_INDEX) 
    		err("'%s' undeclared", $1);
      else 
      	gen_inc(idx);	
  	}
  ;
  
function_call_statement
  : function_call _SEMICOLON
  ;
  
for_statement
  : _FOR _LPAREN _TYPE _ID
  	{
  		$<i>$ = -1;	// stavljam default vrednost akcije, zbog kasnijeg clear, da ne bi izbacivao compiler_error
  		
  		if ($3 == VOID)
  			err("iterator of type: VOID");
  		else
  			if(lookup_symbol_local_global(fun_idx, $4, VAR|PAR) != NO_INDEX)
          err("redefinition of '%s' as for iterator", $4);
        else 
        	$<i>$ = insert_symbol($4, VAR, $3, ++var_num, ++for_num);  // odmah ga stvaram da bi se u tabeli nalazio iznad konstanti 1 i 2(zbog kasnijeg brisanja for scope - a)
        																										 				 // var_num cuvam zbog generisanja promenljive, for_num zbog generisanja labela for statementa
  	}
  	
  	_IN _RANGE literal _COLON literal _RPAREN
  	{
  		if (get_type($8) != $3 || get_type($10) != $3)
  			err("constants type incompatible with for iterator");
  		else 
  			if (atoi(get_name($8)) >= atoi(get_name($10)))
  				err("for statement: const1 must be less than const2");
  		
  		if ($<i>5 != -1) {	// naznaka da li je prosao semanticke provere 
				code("\n@for_begin%d:", for_num);
				code("\n\t\tSUBS\t%%15,$4,%%15");	// zauzimanje mesta za iterator
				gen_mov($8, $<i>5);
				code("\n@for_loop%d:", for_num);
				gen_cmp($<i>5, $10);
				int relop = GT + ((get_type($8) - 1) * RELOP_NUMBER);
				code("\n\t\t%s\t@for_exit%d", jumps[relop], for_num);
			}	
  		// Kontrolni printovi	
  		//print_symtab();
  		//printf("\nFOR NUM BEGIN: %d", for_num);
  	}
  	
  	statement
  	{
  		if ($<i>5 != -1) {	// naznaka da li je prosao semanticke provere 
				int current_for_num = get_atr2($<i>5);
				gen_inc($<i>5);
				code("\n\t\tJMP \t@for_loop%d", current_for_num);
				code("\n@for_exit%d:", current_for_num);
				code("\n\t\tADDS\t%%15,$4,%%15");	// oslobadjanje mesta koje je iterator drzao (sprecava prazan rast steka kod ugnjezdene petlje)
				
				clear_symbols($<i>5);
			}
			// Kontrolni printovi
			//print_symtab();
			//printf("\nFOR NUM END: %d", for_num);
  	}
  ;

branch_statement
	: _BRANCH _LPAREN _ID
		{
			branch_var_idx = lookup_symbol_local_global(fun_idx, $3, VAR);
			if(branch_var_idx == NO_INDEX)
		      err("branch variable '%s' undeclared", $3);
		      
		  code("\n@branch_begin%d:", ++branch_num);
		  $<i>$ = branch_num;
		}
		_ARROW literal _ARROW literal _ARROW literal _RPAREN
		{
			if (get_type($6)	!= get_type(branch_var_idx) || 
					get_type($8)	!= get_type(branch_var_idx) || 
					get_type($10) != get_type(branch_var_idx))
				err("constants type incompatible with branch variable");
			
			
			gen_cmp(branch_var_idx, $6);
			code("\n\t\tJEQ\t@branch_first%d", $<i>4);
			gen_cmp(branch_var_idx, $8);
			code("\n\t\tJEQ\t@branch_second%d", $<i>4);
			gen_cmp(branch_var_idx, $10);
			code("\n\t\tJEQ\t@branch_third%d", $<i>4);
			code("\n\t\tJMP\t@branch_otherwise%d", $<i>4);
			
			code("\n@branch_first%d:", $<i>4);
		}
		
		_FIRST _ARROW	statement
			{
				code("\n\t\tJMP\t@branch_exit%d", $<i>4);
				code("\n@branch_second%d:", $<i>4);
			}
		_SECOND	_ARROW	statement
			{
				code("\n\t\tJMP\t@branch_exit%d", $<i>4);
				code("\n@branch_third%d:", $<i>4);
			}
		_THIRD _ARROW	statement
			{
				code("\n\t\tJMP\t@branch_exit%d", $<i>4);
				code("\n@branch_otherwise%d:", $<i>4);
			}
		_OTHERWISE	_ARROW	statement
			{
				code("\n@branch_exit%d:", $<i>4);
			}
		_END_BRANCH
	;

assignment_statement
  : _ID _ASSIGN root_num_exp _SEMICOLON
      {
        int idx = lookup_symbol_local_global(fun_idx, $1, VAR|PAR);
        if(idx == NO_INDEX)
          err("invalid lvalue '%s' in assignment", $1);
        else
          if(get_type(idx) != get_type($3))
            err("incompatible types in assignment");
        gen_mov($3, idx);
      }
  ;

root_num_exp
 	: num_exp
		{ root_inc_idx = -1; }
	;
	

num_exp 
	:	{ 
			$<i>$ = first_inc_idx;
			
			if (first_inc_idx != NO_INDEX) 
				first_inc_idx = -1; 
		}
		 num_exp_inc
		{
			if (first_inc_idx != NO_INDEX) {
  	    gen_yielded_inc(first_inc_idx);
  	    //print_symtab();
	      clear_symbols(first_inc_idx);
	      //print_symtab();
      }
      
      first_inc_idx = $<i>1;
      $$ = $2;
		} 
	;
	
	
num_exp_inc
  : mul_div_exp
  | num_exp_inc _AROP mul_div_exp
      {
        if(get_type($1) != get_type($3))
          err("invalid operands: arithmetic operation '+'/'-'");
        
        $$ = gen_arop($1, $2, $3);
      }
  ;

mul_div_exp
	: exp
	|	mul_div_exp _PAROP exp
			{
		    if(get_type($1) != get_type($3))
		      err("invalid operands: arithmetic operation '*'/'/'");
		      
		    $$ = gen_arop($1, $2, $3);
		  }
	;

exp
  : literal

  | _ID 
      {
        $$ = lookup_symbol_local_global(fun_idx, $1, VAR|PAR);
        if($$ == NO_INDEX)
          err("'%s' undeclared", $1); 
        
        if (root_inc_idx != NO_INDEX) {	// ako postoji bar jedan inkrement u citavom ugnjezdenom num_expu
		      int idx = lookup_symbol_from(root_inc_idx - 1, $1 ,INC);	// proveri da li negde u num_expu(od root-a) postoji INC sa datim _ID

		  		if (idx != NO_INDEX && get_atr2(idx) == 0) {	// ako postoji i ako nije vec generisan inkrement za nju
		  			gen_inc($$);				// generisi inkrement za nju
		  			set_atr2(idx, 1);		// setuj flag da je generisan inkrement (daje do znanja funkciji gen_yielded_inc() da li treba ponovo da ga generise)
		  		}
    		}
      }

	| increment_exp
	
  | function_call
      {
        $$ = take_reg();
        gen_mov(FUN_REG, $$);
      }
  
  | _LPAREN num_exp _RPAREN
      { $$ = $2; }
      
  | conditional_exp
  ;

literal
  : _INT_NUMBER
      { $$ = insert_literal($1, INT); }

  | _UINT_NUMBER
      { $$ = insert_literal($1, UINT); }
  ;

increment_exp
	: _ID _INCREMENT
		{
			int ref_idx = lookup_symbol_local_global(fun_idx, $1, VAR|PAR);
        if(ref_idx == NO_INDEX)
          err("'%s' undeclared", $1);
     	
     	if (root_inc_idx == NO_INDEX) {
     		root_inc_idx = insert_symbol($1, INC, NO_TYPE, ref_idx, NO_ATR);
     		first_inc_idx = root_inc_idx;
     	}
     	else{
     		int idx = lookup_symbol_from(root_inc_idx - 1, $1 ,INC);	// proveri da li je promenljiva vec inkrementirana u tekucem num_expu
     		
		 		if (first_inc_idx == NO_INDEX && idx == NO_INDEX)	// ako u tekucem num_expu, kao i u root_num_expu nije bilo inkrementa datog _ID, init index prve inkrementirane promenljive tekuceg num_expa 
		      first_inc_idx = insert_symbol($1, INC, NO_TYPE, ref_idx, NO_ATR);
		    else {
					if (idx != NO_INDEX) {	// ako negde u num_expu(od root-a) postoji INC sa datim _ID
						if (get_atr2(idx) == 0)	// i ako nije vec izgenerisan kod za INC datog _ID
							gen_inc(ref_idx);	// generisi INC za dati _ID
						else 
							set_atr2(idx,0);	// ako jeste vec izgenerisan, anuliraj flag atr2, da se, kad dodje do sledece pojave istog _ID, generise kod za inkrement (pravilo exp -> _ID)
					}
					else									// ako od root-a ne postoji INC sa datim _ID ubaci ga u tabelu simbola 
						insert_symbol($1, INC, NO_TYPE, ref_idx, NO_ATR);
		 		}
   		}
   		
   		$$ = take_reg();
   		gen_mov(ref_idx, $$);   
		}
  ;

function_call
  : _ID 
      {
        fcall_idx = lookup_symbol($1, FUN);
        if(fcall_idx == NO_INDEX)
          err("'%s' is not a function", $1);
          
        $<i>$ = push_regs_in_use();
      }
      // akcije za cuvanje informacija o tekucoj funkciji - omogucava poziv funkcija u funkciji
      { 
				$<i>$ = arg_num; 
				arg_num = 0; 
  		}
  		{
				$<i>$ = first_arg_idx;
				first_arg_idx = -1;
  		}
  		{
  			$<i>$ = fcall_idx;
  		}
      
    _LPAREN arguments _RPAREN
      {
      	fcall_idx = $<i>5;
  		
				if(get_atr1(fcall_idx) != $7)	// ako nije dobar broj argumenata, ni ne proverava da li tipovi odgovaraju
		        err("wrong number of args to function '%s'", 
		            get_name(fcall_idx));
		    else {      
					if (!check_arg_types(fcall_idx, first_arg_idx))
				    err("incompatible type for arguments in '%s'",
				        get_name(fcall_idx));
				}
				
				if (first_arg_idx != NO_INDEX) {
					push_args(first_arg_idx);
					//print_symtab();
					clear_symbols(first_arg_idx);
					//print_symtab();  	
				}
				
				first_arg_idx = $<i>4;
  		
  			arg_num = $<i>3;
  			
        code("\n\t\t\tCALL\t%s", get_name(fcall_idx));
        if($7 > 0)
          code("\n\t\t\tADDS\t%%15,$%d,%%15", $7 * 4);
        
        pop_regs_in_use($<i>2);
        set_type(FUN_REG, get_type(fcall_idx));
        $$ = FUN_REG;
        
      }
  ;

arguments
  : /* empty */
    { $$ = 0; }

  | argument_list
  	{ $$ = arg_num;	} 
  ;
  
argument_list
	: argument
	| argument_list _COMMA argument
	;
	
argument
	: root_num_exp
    { 
      int arg_idx = insert_symbol(copy_name(get_name($1)), ARG, get_type($1), $1, ++arg_num);	// upisujem ga svakako jer moram da ga pushujem posebno

      if (first_arg_idx == NO_INDEX)
      	first_arg_idx = arg_idx;
    }
  ;

if_statement
  : if_part %prec ONLY_IF
      { code("\n@exit%d:", $1); }

  | if_part _ELSE statement
      { code("\n@exit%d:", $1); }
  ;

if_part
  : _IF _LPAREN
      {
        $<i>$ = ++lab_num;
        code("\n@if%d:", lab_num);
      }
    rel_exp
      {
        code("\n\t\t%s\t@false%d", opp_jumps[$4], $<i>3);
        code("\n@true%d:", $<i>3);
      }
    _RPAREN statement
      {
        code("\n\t\tJMP \t@exit%d", $<i>3);
        code("\n@false%d:", $<i>3);
        $$ = $<i>3;
      }
  ;
 
conditional_exp
	: condition_part _QMARK 
		
		{ $<i>$ = take_reg(); } 	// zauzimanje registra u kojem ce se nalaziti rezultat uslovnog izraza
		
		cond_operand 
			{
				gen_mov($4, $<i>3);
				code("\n\t\tJMP \t@exit%d", $1);
        code("\n@false%d:", $1);
			} 
		_COLON 
		cond_operand
		{
			if(get_type($4) != get_type($7))
          err("conditional exp: incompatible type for operands");
      
      set_type($<i>3, get_type($7));	
      gen_mov($7, $<i>3);
      code("\n@exit%d:", $1); 
      $$ = $<i>3;
		}
	; 
	
condition_part
	:	_LPAREN
      
    rel_exp
      {
        code("\n\t\t%s\t@false%d", opp_jumps[$2], ++lab_num);
        code("\n@true%d:", lab_num);
      }
    _RPAREN 
    	{ $$ = lab_num; }
 ;
 
cond_operand
	:	literal
	| _ID
		{
			$$ = lookup_symbol_local_global(fun_idx, $1, VAR|PAR);
        if($$ == NO_INDEX)
          err("'%s' undeclared", $1); 
		}
	;

rel_exp
  : root_num_exp _RELOP root_num_exp 
      {
        if(get_type($1) != get_type($3))
          err("invalid operands: relational operator");
        $$ = $2 + ((get_type($1) - 1) * RELOP_NUMBER);
        gen_cmp($1, $3);
      }
  ;

return_statement
  : _RETURN root_num_exp _SEMICOLON
      {
        if(get_type(fun_idx) == VOID)
          err("return num_exp; in void function '%s'", get_name(fun_idx));
        
        if(get_type(fun_idx) != get_type($2))
          err("incompatible types in return in function '%s'", get_name(fun_idx));
         
        return_occurred = TRUE;
        gen_mov($2, FUN_REG);
        code("\n\t\tJMP \t@%s_exit", get_name(fun_idx));
      }
  | _RETURN _SEMICOLON
  	  {
  	  	if(get_type(fun_idx) != VOID)
  	  	  warn("return num_exp; expected in non void function '%s'", get_name(fun_idx));
  	  	  
  	  	return_occurred = TRUE;
        code("\n\t\tJMP \t@%s_exit", get_name(fun_idx));
  	  }
  ;

/*  // otkomentarisati za test blok komentara
comment_block
	: _COMMENT_BLOCK
		{ printf("\nBlock comment #: %d\n", ++cb_num); }
	;
*/
%%

int yyerror(char *s) {
  fprintf(stderr, "\nline %d: ERROR: %s", yylineno, s);
  error_count++;
  return 0;
}

void warning(char *s) {
  fprintf(stderr, "\nline %d: WARNING: %s", yylineno, s);
  warning_count++;
}

int main() {
  int synerr;
  init_symtab();
  output = fopen("output.asm", "w+");

  synerr = yyparse();

  clear_symtab();
  fclose(output);
  
  if(warning_count)
    printf("\n%d warning(s).\n", warning_count);

  if(error_count) {
    remove("output.asm");
    printf("\n%d error(s).\n", error_count);
  }

  if(synerr)
    return -1;  //syntax error
  else if(error_count)
    return error_count & 127; //semantic errors
  else if(warning_count)
    return (warning_count & 127) + 127; //warnings
  else
    return 0; //OK
}

