#ifndef CODEGEN_H
#define CODEGEN_H

#include "defs.h"

// funkcije za zauzimanje, oslobadjanje registra
int  take_reg(void);
void free_reg(void);
// oslobadja ako jeste indeks registra
void free_if_reg(int reg_index); 

// ispisuje simbol (u odgovarajucem obliku) 
// koji se nalazi na datom indeksu u tabeli simbola
void gen_sym_name(int index);

// generise CMP naredbu, parametri su indeksi operanada u TS-a 
void gen_cmp(int operand1_index, int operand2_index);

// generise MOV naredbu, parametri su indeksi operanada u TS-a 
void gen_mov(int input_index, int output_index);

// generise INCREMENT instrukciju za simbol
// koji se nalazi na datom indeksu u tabeli simbola
void gen_inc(int index);

// generise INCREMENT instrukcije za sve
// INC promenljive u tabeli simbola koje su u registrovane tekucem num_exp-u
// (poziva se nakon num_expa) 
void gen_yielded_inc(int begin_index);

// generise kod za aritmeticke operacije
// vraca indeks registra u koji se smesta rezultat arop
int gen_arop(int operand1_index, int arop, int operand2_index);

void gen_push(int index);

void gen_pop(int index);

// vrsi push na stek registre koji su u upotrebi u tekucem num_expu
// vraca indeks poslednjeg push-ovanog registra
int push_regs_in_use();

// vrsi pop sa steka registre koji su bili u upotrebi pre poziva funkcije
void pop_regs_in_use(int reg_index);

// vrsi push argumenata na stek u odgovarajucem redosledu
void push_args(int first_arg_idx);
#endif
