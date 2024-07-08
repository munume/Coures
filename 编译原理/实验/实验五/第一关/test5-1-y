%{
	#include <stdio.h>
	int yylex();
  #define YYSTYPE int /* 将Yacc栈定义为double类型 */
  int yyerror(char *s);   /* 不声明该函数将出现warning */
%}

%token NUM LPAREN RPAREN ENTER PLUS TRUE FALSE
%left  MINUS
%left  TIMES DIVIDE
%right UMINUS
%left OR
%left AND
%right NOT

%%

 /* 这样写prog可以让分析器每次读入一行进行分析，下一行重新分析expr */
prog : prog exprp
		 | exprp
		 ;

exprp 	: s ENTER {$1 == 0 ? printf("false") : printf("true");}
			 	;
s  : s OR s  {$$ = $1 || $3;}
     |s AND s  {$$ = $1 && $3;}
     |NOT s  {$$ = ! $2;}
     |LPAREN s RPAREN  {$$ = $2;}
     |TRUE  {$$ = 1;}
     |FALSE  {$$ = 0;}
			;


%%

int main(){
	yyparse();
	return 0;
}
