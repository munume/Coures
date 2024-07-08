#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>

#define TODO()                                  \
  do{                                                           \
    printf ("\nAdd your code here: file \"%s\", line %d\n",     \
            __FILE__, __LINE__);                                \
  }while(0)

///////////////////////////////////////////////
// Data structures for the Sum language.
enum Exp_Kind_t {EXP_INT, EXP_SUM};
struct Exp_t
{
  enum Exp_Kind_t kind;
};

struct Exp_Int
{
  enum Exp_Kind_t kind;
  int i;
};

struct Exp_Sum
{
  enum Exp_Kind_t kind;
  struct Exp_t *left;
  struct Exp_t *right;
};

// "constructors"
struct Exp_t *Exp_Int_new (int i)
{
  struct Exp_Int *p = malloc (sizeof(*p));
  p->kind = EXP_INT;
  p->i = i;
  return (struct Exp_t *)p;
}

struct Exp_t *Exp_Sum_new (struct Exp_t *left, struct Exp_t *right)
{
  struct Exp_Sum *p = malloc (sizeof(*p));
  p->kind = EXP_SUM;
  p->left = left;
  p->right = right;
  return (struct Exp_t *)p;
}

// "printer"
void Exp_print(struct Exp_t* exp)
{
    switch (exp->kind) {
    case EXP_INT: {
        struct Exp_Int* p = (struct Exp_Int*)exp;
        printf("%d", p->i);
        break;
    }
    case EXP_SUM: {
        struct Exp_Sum* p = (struct Exp_Sum*)exp;
        printf("(");
        Exp_print(p->left);
        printf("+");
        Exp_print(p->right);
        printf(")");
        break;
    }
    default:
        break;
    }
}

//////////////////////////////////////////////
// Data structures for the Stack language.
enum Stack_Kind_t {STACK_ADD, STACK_PUSH};
struct Stack_t
{
  enum Stack_Kind_t kind;
};

struct Stack_Add
{
  enum Stack_Kind_t kind;
};

struct Stack_Push
{
  enum Stack_Kind_t kind;
  int i;
};

// "constructors"
struct Stack_t *Stack_Add_new ()
{
  struct Stack_Add *p = malloc (sizeof(*p));
  p->kind = STACK_ADD;
  return (struct Stack_t *)p;
}

struct Stack_t *Stack_Push_new (int i)
{
  struct Stack_Push *p = malloc (sizeof(*p));
  p->kind = STACK_PUSH;
  p->i = i;
  return (struct Stack_t *)p;
}

/// instruction list
struct List_t
{
  struct Stack_t *instr;
  struct List_t *next;
};

struct List_t *List_new (struct Stack_t *instr, struct List_t *next)
{
  struct List_t *p = malloc (sizeof (*p));
  p->instr = instr;
  p->next = next;
  return p;
}

// "printer"
void List_reverse_print (struct List_t *list)
{
  if(list==NULL) return;
  List_reverse_print(list->next);
  switch (list->instr->kind){
    case STACK_PUSH:{
      struct Stack_Push *p = (struct Stack_Push *)list->instr;
      printf("PUSH %d\n", p->i);
      break;
    }
    case STACK_ADD:{
      printf("ADD\n");
      break;
    }
    default:
      break;
  }
}

//////////////////////////////////////////////////
// a compiler from Sum to Stack
struct List_t *all = 0;

void emit (struct Stack_t *instr)
{
  all = List_new (instr, all);
}

void compile (struct Exp_t *exp)
{
  //TODO:
  switch (exp->kind){
  case EXP_INT:{
    struct Exp_Int *p = (struct Exp_Int *)exp;
    emit (Stack_Push_new (p->i));
    break;
  }
  case EXP_SUM:{
    struct Exp_Sum *p = (struct Exp_Sum *)exp;
    compile(p->left);
    compile(p->right);
    emit (Stack_Add_new ());
    break;
  }
  default:
    break;
  }
}

/* 用c模拟的简单词法分析器，利用yylex()函数来体现，该函数的返回值为词法记号的类别（用enum表示），参数value是额外用来返回整数的属性值的。
 * 关于yylex()函数的定义，可查阅实验附带的Lex说明手册。
 * 忽略空格和制表符。
 * 能够识别加号、整数、括号和逗号。
 */
enum type { PLUS, ENTER, NUM, LPAREN, RPAREN, COMMA };

int yylex(int* value) {
    int c;
    do {
        c = getchar();
    } while (c == ' ' || c == '\t');
    switch (c) {
    case '+': return PLUS;
    case '\n': case EOF: return ENTER;
    // 本实验中不需要识别这三个符号，故注释掉
    // case '(': return LPAREN;
    // case ')': return RPAREN;
    // case ',': return COMMA;
    default:
        // 本实验中不需要识别'.''，故注释掉
        if (/*(c == '.') || */(isdigit(c))) {
            ungetc(c, stdin);
            scanf("%d", value);
            return NUM;
        }
        else {
            printf("\nLEX:ERROR! c=%c\n", c);
            return -1;
        }
    }
}

/* 简易的抽象语法树的读取器。
 * 能够诸如：++2 3 4 这样的抽象语法树输入。
 */
struct Exp_t* Read_ast()
{
  TODO();
  return NULL;
}

//////////////////////////////////////////////////
// program entry
int main()
{
  printf("Compile starting\n");
  // build an expression tree:
  //            +
  //           / \
  //          +   4
  //         / \
  //        2   3
  struct Exp_t *exp = Exp_Sum_new (Exp_Sum_new(Exp_Int_new (2)
                                               , Exp_Int_new (3))
                                   , Exp_Int_new (4));

  /* 你可以用的Read_ast()函数从外部获取抽象语法树，用于代替上面固定的抽象语法树。 
   * Read_ast()调用了yylex()函数，yylex()模拟了词法分析器过程，每次会返回一个单词。
   * 为了便于输入，本例中的抽象语法树使用前缀表示法来输入，数字间以空格隔开，如上述语法树可输入为：++2 3 4。
   */
  // struct Exp_t* exp = Read_ast ();

  if (exp)
  {
    // print out this tree:
    printf ("\nThe expression is:\n");
    Exp_print (exp);

    // compile this tree to Stack machine instructions
    compile (exp);

    // print out the generated Stack instructons:
    printf("\nThe stack instruction list is:\n");
    List_reverse_print (all);
  }
  
  printf("\nCompile finished\n");
  return 0;
}
