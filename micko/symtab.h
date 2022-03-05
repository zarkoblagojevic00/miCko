
#ifndef SYMTAB_H
#define SYMTAB_H

// Element tabele simbola
typedef struct sym_entry {
   char *   name;          // ime simbola
   unsigned kind;          // vrsta simbola
   unsigned type;          // tip vrednosti simbola
   unsigned atr1;          // dodatni attribut simbola
   unsigned atr2;          // dodatni attribut simbola
} SYMBOL_ENTRY;

// Vraca indeks prvog sledeceg praznog elementa.
int get_next_empty_element(void);

// Vraca indeks poslednjeg zauzetog elementa.
int get_last_element(void);

// Ubacuje novi simbol (jedan red u tabeli) 
// i vraca indeks ubacenog elementa u tabeli simbola 
// ili -1 u slucaju da nema slobodnog elementa u tabeli.
int insert_symbol(char *name, unsigned kind, unsigned type, 
                  unsigned atr1, unsigned atr2);

// Ubacuje konstantu u tabelu simbola (ako vec ne postoji).
int insert_literal(char *str, unsigned type);

// Vraca indeks pronadjenog simbola ili vraca -1 na nivou celog programa.
int lookup_symbol(char *name, unsigned kind);

// Vraca indeks pronadjenog simbola ili vraca -1,
// opseg pretrage od pocetnog indeksa do kraja tabele 
int lookup_symbol_from(int begin_index, char *name, unsigned kind);

// Vraca indeks pronadjenog simbola na nivou tekuce funkcije, 
// ako simbol ne postoji u funkciji, vraca indeks globalnog simbola, ako postoji takav 
// ili -1 ako dati simbol uopste ne postoji
int lookup_symbol_local_global(int fun_idx, char *name, unsigned local_kind);

// set i get metode za polja tabele simbola
void     set_name(int index, char *name);
char*    get_name(int index);
void     set_kind(int index, unsigned kind);
unsigned get_kind(int index);
void     set_type(int index, unsigned type);
unsigned get_type(int index);
void     set_atr1(int index, unsigned atr1);
unsigned get_atr1(int index);
void     set_atr2(int index, unsigned atr2);
unsigned get_atr2(int index);

// Kopira ime prosledjene promenljive
char* copy_name(char* str_to_copy);

// Proverava tipove argumenata
bool check_arg_types(int fcall_idx, int first_arg_idx);

// Brise elemente tabele od zadatog indeksa
void clear_symbols(unsigned begin_index);

// Brise elemente tabele od poslednjeg elementa do prvog for iteratora FIT (ukljucujuci i njega)
//void clear_for(unsigned fit_num);

// Brise sve elemente tabele simbola.
void clear_symtab(void);

// Ispisuje sve elemente tabele simbola.
void print_symtab(void);
unsigned logarithm2(unsigned value);

// Inicijalizacija tabele simbola.
void init_symtab(void);

#endif
