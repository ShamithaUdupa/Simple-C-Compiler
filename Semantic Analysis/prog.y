%{
	#include<stdio.h>
	#include<stdlib.h>
	#include<string.h>
	void typecheck(int,int);
	int typeassign(int,int);
	int declarationcheck(char a[20],int);
	int variablecheck(char a[20]);
	int countentries=0;
	struct table
	{
		char name[20];
		int type;
	}arr[100];
	char temp[20];
	int typeno;
	FILE* yyout;
%}

%token IDENTIFIER NUM HEADER REAL CHARVALUE
%token CHAR INT FLOAT DOUBLE VOID RETURN
%token EQ LE GE AND OR XOR ASSIGN L G NEQ
%token IF ELSE SWITCH BREAK WHILE CASE DEFAULT
%token ADD SUB MUL DIV INC DEC
%token SEMICOLON COMMA
%token OP CP OB CB

%start program

%%
program 
	: header programnext {printf("Input accepted\n");exit(0);}
	;
header
	: HEADER
	| HEADER header
	;
programnext
	: declarations
	| function
	| declarations function
	| function function
	;
returnstatement
	: RETURN expressions SEMICOLON
	| {;}
	;
declarations 
	: type assignmentlist SEMICOLON 
	;
assignmentlist
	: variable ASSIGN number
	| variable COMMA assignmentlist
	| variable
	;
number
	: NUM
	| REAL
	| CHARVALUE
	;
type 
	: INT {$$=2;typeno=2;}
	| CHAR {$$=1;typeno=1;}
	| FLOAT {$$=3;typeno=3;}
	| VOID {$$=0;typeno=0;}
	;
function
	: type IDENTIFIER OP argumentlist CP OB statements returnstatement CB
	| function function
	| {;}
	;

variable
	: IDENTIFIER {strcpy(temp,$1);$$=declarationcheck(temp,typeno);}
	;
argument 
	: type variable
	;
argumentlist
	: argument
	| argument COMMA argumentlist
	| {;}
	;
id
	: IDENTIFIER {strcpy(temp,$1);$$=variablecheck(temp);}
	;
statements
	: id ASSIGN expressions SEMICOLON {typecheck($1,$3);}
	| type variable ASSIGN expressions SEMICOLON {typecheck($1,$4);}
	| ifstatements
	| switchstatements
	| whilestatements
	| statements statements
	;
ifstatements
	: IF OP conditionalexpressions CP OB statements CB ELSE OB statements CB
	;
switchstatements
	: SWITCH OP id CP OB casestatements CB
	;
whilestatements
	: WHILE OP conditionalexpressions CP OB statements CB
	;
casestatements
	: CASE NUM ':' statements BREAK SEMICOLON casestatements
	| DEFAULT ':' statements BREAK SEMICOLON
	| {;}
	;
expressions
	: conditionalexpressions {$$=$1;}
	| expressions ADD expressions {$$=typeassign($1,$3);}
	| expressions SUB expressions	{$$=typeassign($1,$3);}
	| expressions MUL expressions {$$=typeassign($1,$3);}
	| expressions DIV expressions {$$=typeassign($1,$3);}
	| IDENTIFIER {strcpy(temp,$1);$$=variablecheck(temp);}
	| NUM {$$=2;}
	| OP expressions CP {$$=$2;}
	| INC IDENTIFIER {strcpy(temp,$2);$$=variablecheck(temp);if($$!=2) fprintf(yyout,"ERROR: Increment Decrement on only Integers\n");}
	| DEC IDENTIFIER {strcpy(temp,$2);$$=variablecheck(temp);if($$!=2) fprintf(yyout,"ERROR: Increment Decrement on only Integers\n");}
	| REAL {$$=3;}
	| CHARVALUE {$$=1;}
	;
conditionalexpressions
	: expressions AND expressions {$$=2;}
	| expressions OR expressions {$$=2;}
	| expressions LE expressions {$$=2;}
	| expressions L expressions {$$=2;}
	| expressions G expressions {$$=2;}
	| expressions NEQ expressions {$$=2;}
	| expressions GE expressions {$$=2;}
	| expressions EQ expressions {$$=2;}
	| OP conditionalexpressions CP {$$=$2;}
	;
%%

void typecheck(int a,int b)
{
	if(a==0 || b==0)
	{
		fprintf(yyout,"ERROR: Void Type Error\n");
		return 0;
	}
	if(a!=b)
	{
		fprintf(yyout,"ERROR: Type Mismatch\n");
		if(a==1 && b==2)
			fprintf(yyout,"Note: Implicit conversion of Int type to Char\n");
		else if(a==2 && b==3)
			fprintf(yyout,"Note: Implicit conversion of Float type expression to Int\n");
		else if(a==3)
			fprintf(yyout,"Note: Implicit conversion to Float Type\n");
	}
}
int typeassign(int a,int b)
{
	if(a==0 || b==0)
		return 0;
	else if(a==b)
		return a;
	else if((a==1 && b==2)||(b==1&&a==2))
		return 2;
	else if((a==2 && b==3)||(a==3 && b==2))
		return 3;
	else return 3;
}
int declarationcheck(char a[20],int type)
{
	int j=0;
	for(j=0;j<countentries;j++)
	{
		if(strcmp(arr[j].name,a)==0)
		{
			fprintf(yyout,"ERROR: Multiple declarations of variable %s\n",a);
			break;
		}
	}
	if(j==countentries)
	{
		strcpy(arr[j].name,a);
		arr[j].type=type;
	}
	countentries++;
	return type;
}
int variablecheck(char a[20])
{
	int j=0,flag=0,t=0;
	for(j=0;j<countentries;j++)
	{
		if(strcmp(arr[j].name,a)==0)
		{
			flag=1;
			t=arr[j].type;
			break;
		}
	}
	if(flag==0)
	{
		fprintf(yyout,"ERROR: Undeclared Variable %s\n",a);	
	}
	return t;
}
#include "lex.yy.c"
int main()
{
	yyout=fopen("out.txt","w");
	yyparse();
	fclose(yyout);
	return 0;
}




