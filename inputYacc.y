%{
#include <stdio.h>
#include <stdlib.h>
#define YYDEBUG 1

#define TIP_INT 1
#define TIP_REAL 2
#define TIP_CAR 3

double stack[20];
int sp;

void push (double x)
{ stack[sp++] = x; }

double pop()
{ return stack[--sp]; }

%}

%union {
	int l_val;
	char *p_val;
}


%token INT
%token bool
%token CHAR
%token string
%token list
%token CONST
%token IF
%token ELSE
%token WHILE
%token DO
%token FOR
%token all
%token READ
%token WRITE
%token of
%token TRUE
%token FALSE
%token BEGIN_STMT
%token END_STMT
%token BREAK
%token print
%token RETURN
%token between
%token and
%token VOID
%token PROGRAM

%token identifier
%token <p_val> noconst
%token <p_val> stringconst

%left not
%left assignment
%left equal
%left notequal
%left lessorequal
%left greaterorequal
%left less
%left greater
%left addition
%left subtraction
%left multiplication
%left DIV 
%left underscore
%left and
%left pow
%left or
%left mod
%left leftsquarebracket
%left rightsquarebracket
%left leftcurlybracket
%left rightcurlybracket
%left leftbracket
%left rightbracket
%left column
%left semicolumn
%left comma
%left dot

%%
program: '*' decllist cmpdstmt '*'
	 ;
decllist: declaration 
	  | declaration ',' decllist
	  ;
declaration: type identifier ';'
	     ;
type: specifictype
      | listingdecl
      ;
specifictype: INT
	      | bool
	      | CHAR
	      | string
	      ;
listingdecl: list '[' identifier ']' of specifictype
	     ;
cmpdstmt: stmtlist
	  ;
stmtlist: stmt 
	  | stmt ';' stmtlist
	  ;
stmt: simplestmt
      | structstmt
      ;
simplestmt: iostmt
	    | assignstmt
	    ;
assignstmt: identifier '=' expression ';'
	    ;
expression: term
	    | term '+' expression
	    | term '-' expression
	    ;
term: factor
      | factor '*' term
      | factor '/' term
      ;
factor: '[' expression ']'
	| identifier
	| noconst
	| CHAR
	| string
	| bool
	;
iostmt: READ
	| WRITE
	| '[' identifier ']'
	;
structstmt: cmpdstmt
	    | ifstmt
	    | whilestmt
	    | forallstmt
	    ;
ifstmt: IF '(' condition ')' '{' stmtlist '}' 
	| IF '(' condition ')' '{' stmtlist '}' ELSE '{' stmtlist '}'
	;
whilestmt: WHILE '(' condition ')' '{' stmtlist '}'
	   ;
forallstmt: FOR all identifier between noconst and noconst '{' stmtlist '}'
	    | FOR all identifier between CHAR and CHAR '{' stmtlist '}'
	    | FOR all identifier between string and string '{' stmtlist '}'
	    | FOR all identifier between bool and bool '{' stmtlist '}'
	    ;
condition: expression relation expression
	   | '(' expression ')'
	   | '!' expression
	   ; 
relation: '<'
	  | '<''='
	  | '=''='
	  | '!''='
	  | '>''='
	  | '>'
	  ;
	  
%%

yyerror(char *s)
{
	printf("%s\n", s);
}

extern FILE *yyin;

main(int argc, char **argv)
{
	if (argc > 1) yyin = fopen(argv[1], "r");
	if ((argc > 2) && (!strcmp(argv[2], "-d"))) yydebug = 1;
	if (!yyparse()) fprintf(stderr, "passed \n");
}
