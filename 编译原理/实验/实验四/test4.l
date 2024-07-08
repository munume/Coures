%{

#include <stdio.h> 

union
{
char c_val;
int i_val;
double f_val;
char *t_val;
}yylval;

#define LT					1
#define	LE					2
#define GT					3
#define	GE					4
#define	EQ					5
#define NE					6
#define	NEQ					7

#define WHILE				18
#define	DO					19
#define ID          20
#define NUMBER      21
#define RELOP       22

#define NEWLINE     23
#define ERRORCHAR   24


#define INT         30
#define FLOAT       31
#define INTEGER     32
#define REAL        33


#define COMMA       34
#define COLON       35 
#define SEMICOLON   36
#define LPAREN      37
#define RPAREN      38
#define PERIOD      39

#define PROGRAM     40
#define BEGINN      41
#define END         42
#define VAR         43
#define IF          44

#define THEN        45
#define ELSE        46

#define ASSIGN      47

#define PLUS        48
#define MINUS       49
#define TIMES        50
#define DIVIDE      51


%}

 
delim		[ \t \n]
ws			{delim}+
letter	    [A-Za-z]
digit		[0-9]
id			{letter}({letter}|{digit})*
int         {digit}+
float       ({digit}+)?\.{digit}+
number   	{digit}+(\.{digit}+)?(E[+-]?{digit}+)?

/* 状态（或条件）定义可以定义在这里 
 * INITIAL是一个默认的状态，不需要定义
 */
%s COMMENT

%%

<INITIAL>"/*"						{BEGIN COMMENT;}
<COMMENT>"*/"						{BEGIN INITIAL;}
<COMMENT>.|\n						{;}

 /* ECHO是一个宏，相当于 fprintf(yyout, "%s", yytext)*/

<INITIAL>{ws}	          {;}
<INITIAL>"WHILE"		   	  {return (WHILE);}
<INITIAL>"DO"		            {return (DO);}
<INITIAL>"IF"               {return (IF);}
<INITIAL>{int}            {yylval.i_val = atoi(yytext);return (INT);}
<INITIAL>{float}          {yylval.f_val = atof(yytext);return (FLOAT);}
<INITIAL>"INTEGER"        {return (INTEGER);}
<INITIAL>"REAL"           {return (REAL);}
<INITIAL>"PROGRAM"        {return (PROGRAM);}
<INITIAL>"BEGIN"          {return (BEGINN);}
<INITIAL>"END"            {return (END);}
<INITIAL>"VAR"            {return (VAR);}

<INITIAL>"THEN"           {return (THEN);}
<INITIAL>"ELSE"           {return (ELSE);}

<INITIAL>{id}	          {yylval.t_val = yytext;return (ID);}

<INITIAL>{number}	      {return (NUMBER);}
<INITIAL>"<"	          {return (LT);}
<INITIAL>"<="	          {return (LE);}
<INITIAL>"="	          {return (EQ);}
<INITIAL>"<>"          {return (NEQ);}
<INITIAL>">"	          {return (GT);}
<INITIAL>">="	          {return (GE);}
<INITIAL>":="             {return (ASSIGN);}

<INITIAL>","	          {return (COMMA);}
<INITIAL>":"	          {return (COLON);}
<INITIAL>";"	          {return (SEMICOLON);}
<INITIAL>"("	          {return (LPAREN);}
<INITIAL>")"	          {return (RPAREN);}
<INITIAL>"."	          {return (PERIOD);}

<INITIAL>"+"              {return (PLUS);}
<INITIAL>"-"              {return (MINUS);}
<INITIAL>"*"              {return (TIMES);}
<INITIAL>"/"              {return (DIVIDE);}

<INITIAL>.				  {return ERRORCHAR;}

 
%%

int yywrap (){
  return 1;
}

void writeout(int c){
  switch(c){
  	case ERRORCHAR: fprintf(yyout, "(ERRORCHAR, \"%s\") ", yytext);break;
  	case RELOP: fprintf(yyout, "(RELOP, \"%s\") ", yytext);break;  	  
    case WHILE: fprintf(yyout, "(WHILE, \"%s\") ", yytext);break;
    case DO: fprintf(yyout, "(DO, \"%s\") ", yytext);break;
    case NUMBER: fprintf(yyout, "(NUM, \"%s\") ", yytext);break;
    case ID: fprintf(yyout, "(ID, \"%s\") ", yylval.t_val);break;
    case NEWLINE: fprintf(yyout, "\n");break;
    
    case PROGRAM: fprintf(yyout, "(PROGRAM, \"%s\") ", yytext);break;
    case SEMICOLON: fprintf(yyout, "(SEMICOLON, \"%s\") ", yytext);break;
    case ASSIGN: fprintf(yyout, "(ASSIGN, \"%s\") ", yytext);break;
    
    case INT: fprintf(yyout, "(INT, \"%d\") ", yylval.i_val);break;
    case FLOAT: fprintf(yyout, "(FLOAT, \"%f\") ", yylval.f_val);break;
    case INTEGER: fprintf(yyout, "(INTEGER, \"%s\") ", yytext);break;
    case REAL: fprintf(yyout, "(REAL, \"%s\") ", yytext);break;

    case COMMA: fprintf(yyout, "(COMMA, \"%s\") ", yytext);break;
    case COLON: fprintf(yyout, "(COLON, \"%s\") ", yytext);break;
    case LPAREN : fprintf(yyout, "(LPAREN, \"%s\") ", yytext);break;
    case RPAREN: fprintf(yyout, "(RPAREN, \"%s\") ", yytext);break;
    case PERIOD: fprintf(yyout, "(PERIOD, \"%s\") ", yytext);break;
    case BEGINN: fprintf(yyout, "(BEGIN, \"%s\") ", yytext);break;
    case END: fprintf(yyout, "(END, \"%s\") ", yytext);break;
    case VAR: fprintf(yyout, "(VAR, \"%s\") ", yytext);break;
    case IF: fprintf(yyout, "(IF, \"%s\") ", yytext);break;
    case THEN: fprintf(yyout, "(THEN, \"%s\") ", yytext);break;
    case ELSE: fprintf(yyout, "(ELSE, \"%s\") ", yytext);break;
    case PLUS: fprintf(yyout, "(PLUS, \"%s\") ", yytext);break;
    case MINUS: fprintf(yyout, "(MINUS, \"%s\") ", yytext);break;
    case TIMES: fprintf(yyout, "(TIMES, \"%s\") ", yytext);break;
    case DIVIDE: fprintf(yyout, "(DIVIDE, \"%s\") ", yytext);break;

    case EQ: fprintf(yyout, "(EQ, \"%s\") ", yytext);break;
    case NEQ: fprintf(yyout, "(NEQ, \"%s\") ", yytext);break;
    case LT: fprintf(yyout, "(LT, \"%s\") ", yytext);break;
    case LE: fprintf(yyout, "(LE, \"%s\") ", yytext);break;
    case GT: fprintf(yyout, "(GT, \"%s\") ", yytext);break;
    case GE: fprintf(yyout, "(GE, \"%s\") ", yytext);break;

    default:break;
  }
  return;
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

	while (c = yylex()){
		writeout(c);
		j++;
		if (j%5 == 0) writeout(NEWLINE);
	}
	if(argc>=2){
	  fclose(yyin);
	  if (argc>=3) fclose(yyout);
	}
	return 0;
}
