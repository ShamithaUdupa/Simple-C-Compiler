%{
	#include<stdio.h>
	#include<stdlib.h>
	#include<malloc.h>
	#include<string.h>
	void insert(char*,char);
	int countentry=0;
	int comment=0;
	int bracketcount=0;
%}

alpha [a-zA-Z]
digit [0-9]
exp [Ee][+|-]?{digit}+
string {alpha}?\"(\\.|[^\\"])*\"
printf (printf\({string}(\,([^,)])+)*\))
prnterr (printf\(.*\))
scanf (scanf\({string}(\,([^,)])+)*\))
scanerr (scanf\(.*\))
%x mcomment

%%
"//".* ;
"-"|"+"|"*"|"/"|">"|"<"|"="|"&"|"|"|"^"|"<="|">="|"!="|"=="|"&&"|"||"|"%"|"~"|"++"|"--" {insert(yytext,'o');}
"+="|"-="|"*="|"/="|"<<="|">>=" {insert(yytext,'o');}
^#.* {insert(yytext,'d');}
{printf}            {;}
{prnterr}           {printf("ERROR: Printf statement\n");}
{scanf}             {;}
{scanerr}           {printf("ERROR: Scanf statement\n");}
{string} {insert(yytext,'s');}
{alpha}?\"(\\.|[^\\"])* {printf("ERROR: String Literal\n");}
"switch"|"if"|"else"|"break"|"char"|"int"|"while"|"float"|"double"|"return" {insert(yytext,'k');}
"case"|"const"|"continue"|"default"|"do"|"extern"|"for"|"goto"|"long"|"short" {insert(yytext,'k');}
"signed"|"sizeof"|"static"|"struct"|"typedef"|"union"|"void"|"unsigned" {insert(yytext,'k');}
"/*" {BEGIN(mcomment);}
<mcomment>\*\/ {BEGIN(INITIAL);}
<mcomment>. ;
<mcomment>\n ;
{alpha}({alpha}|{digit})* {insert(yytext,'v');}
{digit}+  {insert(yytext,'c');}
{digit}+{exp} {insert(yytext,'c');}
{digit}+{alpha}+ {printf("ERROR : Bad token %s\n",yytext);}
{digit}+"."{digit}*{exp}? {insert(yytext,'c');}
{digit}*"."{digit}+{exp}? {insert(yytext,'c');}
[ \t\n] ;
. {insert(yytext,'p');}
%%

void insert(char* yytext,char type)
{
	switch(type)
	{
		case 'v':
			fprintf(yyout,"\t%s\t\t\tIdentifier\t\t\t%d\n",yytext,countentry);
			countentry++;
			break;
		case 'c':
			fprintf(yyout,"\t%s\t\t\tConstant\t\t\t%d\n",yytext,countentry);
			countentry++;
			break;
		case 'p':
			fprintf(yyout,"\t%s\t\t\tPunctuator\t\t\t%d\n",yytext,countentry);
			countentry++;
			break;
		case 'o':
			fprintf(yyout,"\t%s\t\t\tOperator\t\t\t%d\n",yytext,countentry);
			countentry++;
			break;
		case 'k':
			fprintf(yyout,"\t%s\t\t\tKeyword\t\t\t%d\n",yytext,countentry);
			countentry++;
			break;
		case 's':
			fprintf(yyout,"\t%s\t\t\tString Literal\t\t\t%d\n",yytext,countentry);
			countentry++;
			break;
		case 'd':
			fprintf(yyout,"\t%s\t\t\tPreprocessor Statement\t\t\t%d\n",yytext,countentry);
			countentry++;
			break;
	}
}

int yywrap()
{
	return 1;
}

int main()
{
	yyin=fopen("input.c","r");
	yyout=fopen("output.txt","w");
	fprintf(yyout,"\tLexeme\t\t\tToken\t\t\tValue\n");
	yylex();
	fclose(yyout);
	fclose(yyin);
	return 0;
}
