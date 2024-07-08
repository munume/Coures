%{
#include <stdio.h>
#include "ast.h" //该文件定义了抽象语法树（分析树）的数据结构
#include "errormsg.h"
#define YYDEBUG 1 
/* 允许跟踪错误，与%debug功能相同 */

int yylex(void); /* function prototype */

/* 该函数显示错误信息s，显示时包含了错误发生的位置。*/
void yyerror(char *s)
{
 EM_error(EM_tokPos, "%s", s);
}

/* 存放抽象语法树中 "程序" 数据结构的变量 */
a_prog program = NULL;

%}


 /* 定义属性值栈的类型，最后一个实验可能需要修改此处  */
%union {
	int ival;
	double fval;
	string sval;
  a_exp exp;
  a_stm_list stms;
  a_stm stm;
  a_prog prog;
  a_dec_list decl;

  a_var_list varl;
  a_dec dec;
  a_bexp bexpp;
  a_op opp;
  a_bop bopp;
  ttype typee;
}

 /* 定义各个终结符，以及他们的属性值的类型，最后一个实验可能需要修改此处 */
%token <sval> ID /* id */
%token <ival> INT  /*整型数*/
%token <fval> FLOAT /*浮点数*/
%token INTEGER REAL  /*两种类型名：整型、实型*/
%token 
  COMMA COLON SEMICOLON LPAREN RPAREN PERIOD /* 符号 , : ; ( ) . */
  PROGRAM BEGINN END VAR IF WHILE DO   /* 关键字：PROGRAM BEGIN END VAR IF WHILE Do */
  /* 想想为什么不声明为BEGIN？ */
  THEN ELSE /* 关键字：THEN ELSE */
  ASSIGN EQ NEQ LT LE GT GE /* 符号 :=	 =  <>  <  <=  >  >= */
  PLUS MINUS TIMES DIVIDE /* 符号 + = * / */

%start program

  /* 定义各个非终结符的属性值类型，最后一个实验可能需要修改此处  */
%type <prog> program
%type <decl> declist vardec
%type <stms> stmts
%type <stm> stmt
%type <exp> exp
%type <varl> idlist
%type <typee> type
%type <bexpp> judge
%type <bopp> relop
%type <opp> op




%%
 /* 文法：program--> PROGRAM ID; vardec BEGIN stmts END. 
  *       vardec-->   VAR declist 
  *       declist-->  ID:INTEGER;
  *       stmts--> ID := exp
  *       exp--> INT
  *
  * 最后一个实验需要修改这个文法
  */
program	:	PROGRAM ID SEMICOLON vardec BEGINN stmts END PERIOD	
					{program = A_Prog(EM_tokPos, $2, $4, $6);}
				;

vardec 	: VAR declist 	{$$ = $2;}
				;


declist : idlist COLON type SEMICOLON declist  {$$ = A_DecList(A_VarDec(EM_tokPos, $1, $3), $5);}
         | idlist COLON type SEMICOLON  {$$ = A_DecList(A_VarDec(EM_tokPos,$1, $3), NULL);}
				;

idlist : ID {$$ = A_VarList(A_Id(EM_tokPos, $1), NULL);}
       | ID COMMA idlist {$$ = A_VarList(A_Id(EM_tokPos, $1), $3);}
       ;

type : INTEGER  {$$ = T_int;}
     | REAL  {$$ = T_real;}
     ;

stmts : stmt SEMICOLON stmts {$$ = A_StmList($1, $3);}
      | stmt {$$ = A_StmList($1, NULL);}
      ;



stmt : ID ASSIGN exp	{$$ = A_Assign(EM_tokPos, A_Id(EM_tokPos, $1), $3);}
      | WHILE judge DO BEGINN stmts END  {$$ = A_While(EM_tokPos, $2, A_Seq(EM_tokPos, $5));}
      | IF judge THEN BEGINN stmts END ELSE BEGINN stmts END   {$$ = A_If(EM_tokPos, $2, A_Seq(EM_tokPos, $5), A_Seq(EM_tokPos, $9));}            
			;
			
judge : exp relop exp {$$ = A_BExp(EM_tokPos, $2, $1, $3);}
      ;

relop : EQ {$$ = A_eqOp;}
      | NEQ {$$ = A_neqOp;}
      | LT {$$ = A_ltOp;}
      | LE {$$ = A_leOp;}
      | GT {$$ = A_gtOp;}
      | GE {$$ = A_geOp;}
      ;

exp : INT	{$$ = A_IntExp(EM_tokPos, $1);}
    | FLOAT {$$ = A_RealExp(EM_tokPos, $1);}
    | ID {$$ = A_VarExp(EM_tokPos, A_Id(EM_tokPos, $1));}
    | exp op exp {$$ = A_OpExp(EM_tokPos, $2, $1, $3);}
		;

op : PLUS {$$ = A_plusOp;}
   | MINUS {$$ = A_minusOp;}
   | TIMES {$$ = A_timesOp;}
   | DIVIDE {$$ = A_divideOp;}
   ;
 
