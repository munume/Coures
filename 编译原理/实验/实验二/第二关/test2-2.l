%{

#include <stdio.h> 


%}


    /* 请在这里补充代码 */
delim		[ \t \n]
ws      	{delim}+
letter  	[A-Za-z_]
digit		[0-9]


%s COMMENT

%%

    /* 请在这里补充代码  */
{ws}          {fprintf(yyout, " ");}
.	          {ECHO;}

	/* ECHO是一个宏，相当于 fprintf(yyout, "%s", yytext) */

%%

int yywrap (){
  return 1;
}


int main (int argc, char ** argv){
	int c,j=0;
	if (argc>=2){
	  if ((yyin = fopen(argv[1], "r")) == NULL){
	    printf("Can't open file %s\n", argv[1]);
	    return 1;
	  }
	  if (argc>=3){
	    yyout=fopen(argv[2], "w");
	  }
	}

	while (yylex());

	if(argc>=2){
	  fclose(yyin);
	  if (argc>=3) fclose(yyout);
	}
	return 0;
}
