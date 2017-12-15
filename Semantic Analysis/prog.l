%{
	#include<stdio.h>
	#include<stdlib.h>
	#include<malloc.h>
	#include<string.h>
%}

alpha [a-zA-Z]
digit [0-9]
exp (E|e){digit}+

%%
"-" return SUB;
"+" return ADD;
"*" return MUL;
"/" return DIV;
">=" return GE;
"<=" return LE;
"==" return EQ;
"<" return L;
">" return G;
"!=" return NEQ;
"=" {return ASSIGN;}
"&&" return AND;
"||" return OR;
"++" return INC;
"--" return DEC;
"^" return XOR;
"switch" return SWITCH;
"if" return IF;
"else" return ELSE;
"break" return BREAK;
"char" return CHAR;
"int" return INT;
"while" return WHILE;
"float" return FLOAT;
"default" return DEFAULT;
"case" return CASE;
"void" return VOID;
"return" return RETURN;
"double" return DOUBLE; 
'.' {yylval=(char*)yytext;return CHARVALUE;}
{alpha}({alpha}|{digit})* {yylval=(char*)yytext;return IDENTIFIER;}
{digit}+  {yylval=(char*)yytext;return NUM;}
{digit}*\.{digit}+{exp}? {yylval=(char*)yytext;return REAL;}
{digit}+\.{digit}*{exp}? {yylval=(char*)yytext;return REAL;}
";" return SEMICOLON;
"," return COMMA;
"(" return OP;
")" return CP;
"{" return OB;
"}" return CB;
^#.* {yylval=(char*)yytext;return HEADER;}
[ \t\n] ;
. return yytext;
%%

