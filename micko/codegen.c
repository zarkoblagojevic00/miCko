#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "codegen.h"
#include "symtab.h"


extern FILE *output;
int free_reg_num = 0;
char invalid_value[] = "???";

// REGISTERS

int take_reg(void) {
  if(free_reg_num > LAST_WORKING_REG) {
    err("Compiler error! No free registers!");
    exit(EXIT_FAILURE);
  }
  return free_reg_num++;
}

void free_reg(void) {
   if(free_reg_num < 1) {
      //err("Compiler error! No more registers to free!");
      //exit(EXIT_FAILURE);
   }
   else
      set_type(--free_reg_num, NO_TYPE);
}

// Ako je u pitanju indeks registra, oslobodi registar
void free_if_reg(int reg_index) {
  if(reg_index >= 0 && reg_index <= LAST_WORKING_REG)
    free_reg();
}

// SYMBOL
void gen_sym_name(int index) {
  if(index > -1) {
    if(get_kind(index) == VAR) // -n*4(%14)
      code("-%d(%%14)", get_atr1(index) * 4);
    else 
      if(get_kind(index) == PAR) // m*4(%14)
        code("%d(%%14)", 4 + get_atr1(index) *4);
      else
        if(get_kind(index) == LIT)
          code("$%s", get_name(index));
        else //function, reg
          code("%s", get_name(index));
  }
}

// OTHER

void gen_cmp(int op1_index, int op2_index) {
  if(get_type(op1_index) == INT)
    code("\n\t\tCMPS \t");
  else
    code("\n\t\tCMPU \t");
  gen_sym_name(op1_index);
  code(",");
  gen_sym_name(op2_index);
  free_if_reg(op2_index);
  free_if_reg(op1_index);
}

void gen_mov(int input_index, int output_index) {
  code("\n\t\tMOV \t");
  gen_sym_name(input_index);
  code(",");
  gen_sym_name(output_index);

  //ako se smešta u registar, treba preneti tip 
  if(output_index >= 0 && output_index <= LAST_WORKING_REG)
    set_type(output_index, get_type(input_index));
  free_if_reg(input_index);
}

void gen_inc(int index) {
	int type = get_type(index);    
  code("\n\t\t%s\t", ar_instructions[ADD + (type - 1) * AROP_NUMBER]);
  gen_sym_name(index);
  code(",$1,");
  gen_sym_name(index);
}

void gen_yielded_inc(int begin_index) {
	int i;
	int first_empty = get_last_element() + 1;
	
  if(begin_index == first_empty) //nema sta da se generise 
    return;
  if(begin_index > first_empty) {
    err("Compiler error! Wrong clear symbols argument");
    exit(EXIT_FAILURE);
  }
  for(i = begin_index; i < first_empty; i++)
  	if (get_kind(i) == INC && get_atr2(i) == 0) 
  		gen_inc(get_atr1(i)); // atr1 inc promenljive je indeks originalne promenljive koja se inkrementira
}

int gen_arop(int op1_index, int arop, int op2_index) {
	int type = get_type(op1_index);    
  code("\n\t\t%s\t", ar_instructions[arop + (type - 1) * AROP_NUMBER]);
  gen_sym_name(op1_index);
  code(",");
  gen_sym_name(op2_index);
  code(",");
  free_if_reg(op2_index);
  free_if_reg(op1_index);
  int reg = take_reg();
  gen_sym_name(reg);
  set_type(reg, type);
  return reg;
}

void gen_push(int index) {
	code("\n\t\tPUSH\t");
  gen_sym_name(index);
}

void gen_pop(int index) {
	code("\n\t\tPOP \t");
	gen_sym_name(index);
}

int push_regs_in_use() {
	int reg_idx = 0;
	
	while (get_type(reg_idx) != NO_TYPE) {
		gen_push(reg_idx++);
	}
	return --reg_idx;
}

void pop_regs_in_use(int reg_idx) {
	while (reg_idx >= 0)
		gen_pop(reg_idx--);
}

void push_args(int first_arg_idx) {
	int real_arg;
	int first_empty = get_last_element() + 1;
	
  if(first_arg_idx == first_empty) //nema sta da se generise 
    return;
  if(first_arg_idx > first_empty) {
    err("Compiler error! Wrong push args argument");
    exit(EXIT_FAILURE);
  }
  while (--first_empty >= first_arg_idx) {
  	if (get_kind(first_empty) == ARG) {	// ignorisi literale
  		real_arg = get_atr1(first_empty);
  		free_if_reg(real_arg);
  		gen_push(real_arg);
  	}
  }
}
