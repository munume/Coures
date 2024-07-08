/* 这是注释的形式，与C中的/*...* /注释相同。 */
/* 第一部分是定义、声明部分。这部分内容可以为空。*/

%{

/* 写在 %{...%}这对特殊括号内的内容会被直接拷贝到C文件中。
 *
 * 这部分通常进行一些头文件声明，变量（全局，外部）、常量
 * 的定义，用C语法。
 *
 * %{和%}两个符号都必须位于行首 
 */

/* 下面定义了需要识别的记号名，如果和yacc联合使用，这些记号名都应该在yacc中定义 */
#include <stdio.h> 
#define RELOP       1
#define OTHER       2
#define BRACKETS    3

%}

 /* 这里进行正规定义和状态定义。如果没有，可以不写。 */ 

 /* 注意|前后不能有空格，否则分析器会认为你要识别空格 */
relop       \<|\<=|=|\<\>|\>|\>=
 /* 注意查一下lex手册中，^代表什么含义*/
other       [^<=>()]+
brackets    \(|\)
   

/* %%作为lex文件三个部分的分割符，必须位于行首 */
/* 下面这个%%不能省略 */
%%

  /* 第二部分是翻译规则部分。 */
  /* 写在这一部分的注释要有前导空格，否则lex编译出错。*/
  /* 翻译规则的形式是：正规式  {动作}
   * 其中，正规式要顶行首写，动作要以C语法写（动作会被拷贝到yylex()函数中，），\
   * 正规式和动作之间要用空白分割。
   * 若有2条或以上的匹配规则，越靠前的匹配越先执行。（注：根据最长匹配原则，如果后面的规则能够匹配上更长的串，则不受此条影响。）
   */

{relop}     {return RELOP;}
{brackets}  {return BRACKETS;}
{other}     {return OTHER;}

  /*.匹配除换行之外的任何字符，一般可作为最后一条翻译规则。*/
.								        {}
 
%%
/* yywrap这个辅助函数是词法分析器遇到输入文件结尾时会调用的，用来决定下一步怎么做：
 * 若yywrap返回0，则继续扫描；返回1，则词法分析器返回报告文件已结束的0。
 * lex库中的标准yywrap程序就是返回1，你也可以定义自己的yywrap。
 */
int yywrap (){
  return 1;
}

void writeout(int c){
  switch(c){
  	case OTHER: fprintf(yyout, "(OTHER,%d)", yyleng);break;
  	case RELOP: fprintf(yyout, "(RELOP,\"%s\")", yytext);break;
    case BRACKETS: fprintf(yyout, "(BRACKETS,\"%s\")", yytext);break;
    default:break;
  }
  return;
}

/* 辅助函数里可以使用yytext和yyleng这些外部定义的变量。
 * yytext指向输入缓冲区当前词法单元(lexeme)的第一个字符，
 * yyleng给出该词法单元的长度		*/

/* 如果你的词法分析器并不是作为语法分析器的子程序，
 * 而是有自己的输入输出，你可以在这里定义你的词法
 * 分析器的main函数，main函数里可以调用yylex()
 */

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
	/* yyin和yyout是lex中定义的输入输出文件指针，它们指明了
	 * lex生成的词法分析器从哪里获得输入和输出到哪里。
	 * 默认：键盘输入，屏幕输出。 
	 */
	while (c = yylex()){
		writeout(c);
	}
	if(argc>=2){
	  fclose(yyin);
	  if (argc>=3) fclose(yyout);
	}
	return 0;
}
