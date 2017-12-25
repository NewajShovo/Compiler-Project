%{
	#include<stdio.h>
	#include<string.h>
	#include<stdlib.h>
	#include<math.h>
	#include "shuvo.tab.h"
%}

alpha [a-z]+[a-z0-9]*
digit [+|-]?[0-9]+(.[0-9]+)?
header					"@Header"[ ]*+"<<"[^\n]+[.h]">>"[ ]*
keyWord					VOID|INT|FLOAT|CHAR|STRING|SM|CM|START|END

%%

{digit}+	     { yylval = atoi(yytext); return NUM; }
{alpha}	         { yylval = *yytext - 'a'; return	VAR; }
["!"]	         { return(SM); }	
["|"]	         { return(CM); }

 
"Begin" 	     { return START;  }
"Finish"         { return END;	}

{header}  		 {}

PLUS             {return '+';}

MINUS            {return '-';}
MUL              {return '*';}
DIV              {return '/';}
MOD              {return '%';}
EQU              {return '=';}
GT               {return '>';}
LT               {return '<';}
POW              {return '^';}
INTGR  			 {return INT;}
IF               {return IF;}
ELSE             {return ELSE;}
FOR              {return FOR; }
CHAR 		     {return CHAR;}
FLOAT 			 {return FLOAT;}
"VOID  Main[]"   { return MAIN; }

[()]              {yylval = yytext[0];	return *yytext;}
[ ]*	    	 {}
[\n]*			 {}
[\t]*			 {}
.				 {printf("%s --> invalid\n",yytext);}


%%
int yywrap()
{
	return 1;
}

int main()
{
	freopen("text.txt","r",stdin);
	
	yyparse();
    
	return 0;
}