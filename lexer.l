%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

typedef struct _token{
    int clase;
    char valor[32];
    int line;
} token;
token TOKEN;
enum clase {ID=1, CONDICIONA, ARITMETICO, RELACIONAL, ASIGNACION, BOOLEANO, ESPECIAL, ENT, FLOTANTE, CADENA,BASE};

void error(char *s);
%}

%option yylineno
%option noyywrap
%s COMENTARIO
%x COMENTARIO2

caracter [a-zA-Z]
caracter_ {caracter}|_
num [0-9]
negativo 	"-"({num})+

id #{caracter}({caracter_}|{num})*
number {num} | {negativo}
real {num}*"."{num}+|{num}+"."{num}*
exp [eE][+-]?{entero}


aritmetic      [*+-/]
relacional     "<"|">"|"<="|">="|"!="
asignacion     "="
booleano       "||"|"&&"|"!"|"True"|"False"
especial       [(){};,]
entero         ({num})+
base 		   "ent"|"real"|"dreal"|"car"|"sin"
condiciona	   "si"|"entonces"|"fin"|"sino"|"mientras"|"mientras que"|"hacer"|"escribir"|"leer"|"devolver"|"registro"|"terminar"|"car"
condicionaC	   "caso"{num}:
predetermina	 "pred"{condiciona}
cadena         ({caracter})+
arreglo        id"["{expresion}"]" | arreglo"["{expresion}"]"


 
operador 	(aritmetic)|(relacional)|(asignacion)|(booleano)


%%
<INITIAL>{id}    { 
            TOKEN.clase = ID;
            strcpy(TOKEN.valor, yytext);
            TOKEN.line = yylineno;
            return ID;
        		}
        
<INITIAL>{condiciona}  { 
                TOKEN.clase = CONDICIONA;
                strcpy(TOKEN.valor, yytext);
                TOKEN.line = yylineno;
                return CONDICIONA;
						}
  
<INITIAL>{aritmetic}  { 
                TOKEN.clase = ARITMETICO;
                strcpy(TOKEN.valor, yytext);
                TOKEN.line = yylineno;
                return ARITMETICO;
						}
<INITIAL>{relacional}  { 
                TOKEN.clase = RELACIONAL;
                strcpy(TOKEN.valor, yytext);
                TOKEN.line = yylineno;
                return RELACIONAL;
						}
<INITIAL>{asignacion}  { 
                TOKEN.clase = ASIGNACION;
                strcpy(TOKEN.valor, yytext);
                TOKEN.line = yylineno;
                return ASIGNACION;
						}
<INITIAL>{booleano}  { 
                TOKEN.clase = BOOLEANO;
                strcpy(TOKEN.valor, yytext);
                TOKEN.line = yylineno;
                return BOOLEANO;
						}
<INITIAL>{especial}  { 
                TOKEN.clase = ESPECIAL;
                strcpy(TOKEN.valor, yytext);
                TOKEN.line = yylineno;
                return ESPECIAL;
						}
  
<INITIAL>{entero}    { 
                TOKEN.clase = ENT;
                strcpy(TOKEN.valor, yytext);
                TOKEN.line = yylineno;
                return ENT;
            }

<INITIAL>{base}  { 
                TOKEN.clase = BASE;
                strcpy(TOKEN.valor, yytext);
                TOKEN.line = yylineno;
                return BASE;
                        }


<INITIAL>{cadena}  { 
                TOKEN.clase = CADENA;
                strcpy(TOKEN.valor, yytext);
                TOKEN.line = yylineno;
                return CADENA;
  									}
  

        
<INITIAL>[ \t\n\r] {/* Ignora los espacios en blanco*/}
<INITIAL>"/*" {BEGIN(COMENTARIO);}
<INITIAL>.   {error(yytext);}

<COMENTARIO>[^*/]  {}
<COMENTARIO>[*/]   {}    
<COMENTARIO>"*/"   {BEGIN(INITIAL);}

<INITIAL>"//" {BEGIN(COMENTARIO2);}
<COMENTARIO2>"\n"   {BEGIN(INITIAL);}
%%
void error(char *s){
    printf("Error léxico: %s, en la línea %d\n",s,yylineno);
}

int main(int argc, char **argv){
    FILE *f;
    if(argc<2){
        printf("Falta archivo\n");
        exit(-1);
    }
    f = fopen(argv[1],"r");
    if(!f){
        printf("No se puede abrir el archivo\n");
        exit(-1);
    }
    yyin = f;
    int tok = yylex();
    while(tok != 0){
        printf("%d\n",tok);
        tok = yylex();
    }    
    return 0;
}
