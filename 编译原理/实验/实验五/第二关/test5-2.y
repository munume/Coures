%{
	#include <stdio.h>
	int yylex();
  #define YYSTYPE double /* 将Yacc栈定义为double类型 */
  int yyerror(char *);   /* 不声明该函数将出现warning */
%}

%token NUM LPAREN RPAREN ENTER PLUS FALSE TRUE OR AND NOT
%left  MINUS
%left  TIMES DIVIDE
%right UMINUS

%%

 /* 这样写prog可以让分析器每次读入一行进行分析，下一行重新分析expr */
prog : prog exprp
		 | exprp
		 ;

exprp 	: s ENTER {if($1) printf("true\n"); else printf("false\n");}
			 	;
s  : s OR a  {$$ = $1 || $3;}
        | a  {$$ = $1;}
        ;

a  : a AND b  {$$ = $1 && $3;}
        | b   {$$ = $1;}
        ;
        
b  : NOT b  {$$ = ! $2;}
     |LPAREN s RPAREN  {$$ = $2;}
     |TRUE  {$$ = 1;}
     |FALSE  {$$ = 0;}
			;


%%

int main(){
	yyparse();
	return 0;
}
