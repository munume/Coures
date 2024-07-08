%{

#include <stdio.h> 
char* PRINT_DOUBLE();  /* 本项目给你提供了一个打印double关键字的函数，该函数可以替换yytext中的float字样，同时保留其他字符不变。你可以不用该函数。*/
%}

    /* 请在这里补充代码 */

string   \"([^\"'\n\\]|\\[^\n])*\"
	/* 状态（或条件）定义可以定义在这里，例如本题你可以用状态来区分注释（两种）和非注释
	* INITIAL是一个默认的状态，不需要定义
	*/
%s COMMENT
%s LINECOMMENT


%%
    
<INITIAL>"/*"						{BEGIN COMMENT;ECHO;}
<COMMENT>"*/"						{BEGIN INITIAL;ECHO;}
<COMMENT>.|\n						{ECHO;}
<INITIAL>"//"                       {BEGIN LINECOMMENT;ECHO;}
<LINECOMMENT>\n		                {BEGIN INITIAL;ECHO;}
<LINECOMMENT>.                      {ECHO;}


	/* ECHO是一个宏，相当于 fprintf(yyout, "%s", yytext) */



	/* 请在这里补充代码  */
<INITIAL>[^a-zA-Z_0-9]float[^a-zA-Z_0-9]    {PRINT_DOUBLE();}
<INITIAL>{string}                           {ECHO;}
%%

int yywrap (){
  return 1;
}

/* 本项目给你提供了一个打印double关键字的函数，该函数可以替换yytext中的float字样，同时保留其他字符不变。你可以不用该函数。*/
char* PRINT_DOUBLE(){
    int i = 0;
    while (i < yyleng && yytext[i] != 'f')  /* yyleng为yytext的长度 */
    {
        fprintf(yyout, "%c", yytext[i]);
        i ++;
    }

    fprintf(yyout, "double");
    i += 5; // "float" length = 5

    while (i < yyleng)
    {
        fprintf(yyout, "%c", yytext[i]);
        i ++;
    }
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
