
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <limits.h>
#include "defs.h"
#include "symtab.h"


SYMBOL_ENTRY symbol_table[SYMBOL_TABLE_LENGTH];
int first_empty = 0;


// Vraca indeks prvog sledeceg praznog elementa.
int get_next_empty_element(void) {
  if(first_empty < SYMBOL_TABLE_LENGTH)
    return first_empty++;
  else {
    err("Compiler error! Symbol table overflow!");
    exit(EXIT_FAILURE);
  }
}

// Vraca indeks poslednjeg zauzetog elementa.
int get_last_element(void) {
  return first_empty-1;
}

// Ubacuje simbol sa datom vrstom simbola i tipom simbola 
// i vraca indeks ubacenog elementa u tabeli simbola 
// ili -1 u slucaju da nema slobodnog elementa u tabeli.
int insert_symbol(char *name, unsigned kind, unsigned type, 
                  unsigned atr1, unsigned atr2){
  int index = get_next_empty_element();
  symbol_table[index].name = name;
  symbol_table[index].kind = kind;
  symbol_table[index].type = type;
  symbol_table[index].atr1 = atr1;
  symbol_table[index].atr2 = atr2;
  return index;
}

// Ubacuje konstantu u tabelu simbola (ako vec ne postoji).
int insert_literal(char *str, unsigned type) {
  int idx;
  for(idx = first_empty - 1; idx > FUN_REG; idx--) {
    if(strcmp(symbol_table[idx].name, str) == 0 
       && symbol_table[idx].kind == LIT
       && symbol_table[idx].type == type)
       return idx;
  }

  // provera opsega za konstante
  long int num = atol(str);
  if(((type==INT) && (num<INT_MIN || num>INT_MAX) )
    || ((type==UINT) && (num<0 || num>UINT_MAX)) )  
      err("literal out of range");
  idx = insert_symbol(str, LIT, type, NO_ATR, NO_ATR);
  return idx;
}

// Vraca indeks pronadjenog simbola ili vraca -1.
int lookup_symbol(char *name, unsigned kind) {
  int i;
  for(i = first_empty - 1; i > FUN_REG; i--) {
    if(strcmp(symbol_table[i].name, name) == 0 
       && symbol_table[i].kind & kind)
       return i;
  }
  return -1;
}

// Vraca indeks pronadjenog simbola ili vraca -1,
// opseg pretrage od pocetnog indeksa do kraja tabele 
int lookup_symbol_from(int begin_index, char *name, unsigned kind) {
	int i;
  for(i = first_empty - 1; i > begin_index; i--) {
    if(strcmp(symbol_table[i].name, name) == 0 
       && symbol_table[i].kind & kind)
       return i;
  }
  return -1;
}

// Vraca indeks pronadjenog simbola na nivou tekuce funkcije, 
// ako simbol ne postoji u funkciji, vraca indeks globalnog simbola, ako postoji takav 
// ili -1 ako dati simbol uopste ne postoji
int lookup_symbol_local_global(int fun_idx, char *name, unsigned local_kind) {
	
	int idx = lookup_symbol_from(fun_idx, name, local_kind); 
  if(idx != NO_INDEX)
  	return idx;
  
	return lookup_symbol(name, GVAR);
}

void set_name(int index, char *name) {
  if(index > -1 && index < SYMBOL_TABLE_LENGTH)
    symbol_table[index].name = name;
}

char *get_name(int index) {
  if(index > -1 && index < SYMBOL_TABLE_LENGTH)
    return symbol_table[index].name;
  return "?";
}

void set_kind(int index, unsigned kind) {
  if(index > -1 && index < SYMBOL_TABLE_LENGTH)
    symbol_table[index].kind = kind;
}

unsigned get_kind(int index) {
  if(index > -1 && index < SYMBOL_TABLE_LENGTH)
    return symbol_table[index].kind;
  return NO_KIND;
}

void set_type(int index, unsigned type) {
  if(index > -1 && index < SYMBOL_TABLE_LENGTH)
    symbol_table[index].type = type;
}

unsigned get_type(int index) {
  if(index > -1 && index < SYMBOL_TABLE_LENGTH)
    return symbol_table[index].type;
  return NO_TYPE;
}

void set_atr1(int index, unsigned atr1) {
  if(index > -1 && index < SYMBOL_TABLE_LENGTH)
    symbol_table[index].atr1 = atr1;
}

unsigned get_atr1(int index) {
  if(index > -1 && index < SYMBOL_TABLE_LENGTH)
    return symbol_table[index].atr1;
  return NO_ATR;
}

void set_atr2(int index, unsigned atr2) {
  if(index > -1 && index < SYMBOL_TABLE_LENGTH)
    symbol_table[index].atr2 = atr2;
}

unsigned get_atr2(int index) {
  if(index > -1 && index < SYMBOL_TABLE_LENGTH)
    return symbol_table[index].atr2;
  return NO_ATR;
}

char* copy_name(char* str_to_copy) {
	char* copy_name = (char*)malloc(strlen(str_to_copy) * sizeof(char));
	strcpy(copy_name, str_to_copy);
	return copy_name;
}

bool check_arg_types(int fcall_idx, int first_arg_idx) {
	int i;
	int par_num = get_atr1(fcall_idx);
	++fcall_idx;	// namestam da pokazuje na prvi parametar, zbog sinhronizacije brojaca i
	
	for(i = 0; i < par_num; ++i) {
		if(get_kind(first_arg_idx) != ARG) { // nadji sledeci arg, moram uvesti zbog problema koji u tabeli simbola stvaraju literali
			++first_arg_idx;
		}
		if (get_type(fcall_idx++) != get_type(first_arg_idx++))
			return FALSE;
	}
	return TRUE;
}
// Uklanja element tabele na zadatom indeksu
void remove_symbol(unsigned index) {
	if(symbol_table[index].name)
      free(symbol_table[index].name);
    symbol_table[index].name = 0;
    symbol_table[index].kind = NO_KIND;
    symbol_table[index].type = NO_TYPE;
    symbol_table[index].atr1 = NO_ATR;
    symbol_table[index].atr2 = NO_TYPE;
}

// Brise elemente tabele od zadatog indeksa do kraja tabele
void clear_symbols(unsigned begin_index) {
  int i;
  if(begin_index == first_empty) //nema sta da se brise 
    return;
  if(begin_index > first_empty) {
    err("Compiler error! Wrong clear symbols argument");
    exit(EXIT_FAILURE);
  }
  for(i = begin_index; i < first_empty; i++) 
  	remove_symbol(i);
  
  first_empty = begin_index;
}

// Brise elemente tabele od poslednjeg elementa do prvog for iteratora FIT (ukljucujuci i njega)
/*
void clear_for(unsigned fit_num) {
	if (fit_num < 1) // nema sta da brise
		return;
		
	// brisanje svih elemenata do FIT elementa
	while(symbol_table[--first_empty].kind != FIT) 
		remove_symbol(first_empty);
	
	// brisanje FIT elementa 
	remove_symbol(first_empty);
}
*/

// Brise sve elemente tabele simbola.
void clear_symtab(void) {
  first_empty = SYMBOL_TABLE_LENGTH - 1;
  clear_symbols(0);
}
   
// Ispisuje sve elemente tabele simbola.
void print_symtab(void) {
  static const char *symbol_kinds[] = { 
    "NONE", "REG", "LIT", "FUN", "VAR", "PAR", "GVAR", "INC", "ARG" };
  int i,j;
  printf("\n\nSYMBOL TABLE\n");
  printf("\n       name           kind   type  atr1   atr2");
  printf("\n-- ---------------- -------- ----  -----  -----");
  for(i = 0; i < first_empty; i++) {
    printf("\n%2d %-19s %-4s %4d  %4d  %4d ", i, 
    symbol_table[i].name, 
    symbol_kinds[(int)(logarithm2(symbol_table[i].kind))], 
    symbol_table[i].type, 
    symbol_table[i].atr1, 
    symbol_table[i].atr2);
  }
  printf("\n\n");
}

unsigned logarithm2(unsigned value) {
  unsigned mask = 1;
  int i = 0;
  for(i = 0; i < 32; i++) {
    if(value & mask)
      return i;
    mask <<= 1;
  }
  return 0; // ovo ne bi smelo; indeksiraj string "NONE"
}

// Inicijalizacija tabele simbola.
void init_symtab(void) {
  clear_symtab();

  int i = 0;
  char s[4];
  for(i = 0; i < 14; i++) {
    sprintf(s, "%%%d", i);
    insert_symbol(strdup(s), REG, NO_TYPE, NO_ATR, NO_ATR);
  }
}

