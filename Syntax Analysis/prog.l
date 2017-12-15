%{
	#include<stdio.h>
	#include<stdlib.h>
	#include<malloc.h>
	#include<string.h>
%}

alpha [a-zA-Z]
digit [0-9]

%%
"-" return SUB;
"+" return ADD;
"*" return MUL;
"/" return DIV;
">=" return GE;
"<=" return LE;
"==" return EQ;
"=" return ASSIGN;
"&&" return AND;
"||" return OR;
"^" return XOR;
"switch" return SWITCH;
"if" return IF;
"else" return ELSE;
"break" return BREAK;
"char" return CHAR;
"int" return INT;
"while" return WHILE;
"float" return FLOAT;
"case" return CASE;
"double" return DOUBLE; 
{alpha}({alpha}|{digit})* return IDENTIFIER;
{digit}+  return NUM;
";" return SEMICOLON;
"," return COMMA;
"(" return OP;
")" return CP;
"{" return OB;
"}" return CB;
. ;
[ \n] ;
%%

