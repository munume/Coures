%{
#include "test5-2.tab.h"

int yywrap(void){
  return 1;
}
%}

ws			[ \t]
digit	 	[0-9]
inum		{digit}+
fnum 		{digit}*\.{digit}+

%%

true    { return (TRUE);}
false   { return (FALSE);}

or			{ return (OR);}
and			{ return (AND);}
not			{ return (NOT);}
{inum} 	{sscanf(yytext, "%lf", &yylval); return NUM;}
{fnum}	{sscanf(yytext, "%lf", &yylval); return NUM;}
"+"			{return PLUS;}
"*"			{return TIMES;}
"-"			{return MINUS;}
"/"			{return DIVIDE;}
"("			{return LPAREN;}
")"			{return RPAREN;}
{ws}		{;}
"\n"		{return ENTER;}
.				{printf("\nLEX:ERROR! c=%s\n", yytext);}
