%option yylineno

%{

//definitions
#include <stdio.h>
#include <stdlib.h>
#include "urlscanner.h"


    
%}

DIGIT	[0-9]
INTEGER	{DIGIT}+
FLOAT	{INTEGER}"."{INTEGER}|"."{INTEGER}
LETTER	[a-zA-Z]
BOOL "true"|"false"
STRING "\""[^\n\"]*"\""
ID ({LETTER})+({DIGIT}|{LETTER})*
WORD {LETTER}+
CONST_FLOAT {FLOAT}([eE]([-+])?{INTEGER})?|{INTEGER}([eE]([-+])?{INTEGER})

URL "href="\"[^\"]*/\"
%s TEXT

%%
"href="\"[^\"]*/\"   {BEGIN(TEXT);printf("Line:   %d	URL: %s \n",yylineno,yytext+6);}
<TEXT>">"[^<]*  {printf("Line:   %d	TEXT: %s \n",yylineno,yytext+1);BEGIN(INITIAL);}
\n {}
. {}



%%
yywrap() {}
int main(int argc,char** argv)
{
  //printf("%d",argc);
  //printf("%s",argv[2]);
  if (argc != 2) {
        yyin = stdin;
    } else {
        yyin = fopen(argv[1], "r");
        if (yyin == 0) {
            fprintf(
                    stderr,
                    "Fehler: Konnte Datei %s nicht zum lesen oeffnen.\n",
                    argv[1]
            );
            exit(-1);
        }
    }
  yylex();
  return 0;
    
    

}