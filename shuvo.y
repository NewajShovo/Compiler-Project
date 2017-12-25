%{
	#include<stdio.h>
	#include<stdlib.h>
	#include<math.h>
	int data[60];
	int check[60];

%}

/* bison declarations */

%token NUM VAR IF ELSE MAIN INT FLOAT CHAR START END CM SM FOR
%nonassoc IFX
%nonassoc ELSE

%left '<' '>'
%left '+' '-'
%left '*' '/' '%'

/* Grammar rules and actions follow.  */

%%

program: MAIN  START cstatement END
	 ;

cstatement: /* NULL */

	| cstatement statement
	;

statement: SM			
	| declaration SM		{ printf("Declaration\n"); }

	| expression SM 			{   printf("value of expression: %d\n", $1); $$=$1;}
	
	| VAR '=' expression SM { 
	                       if(check[$1]==1){
							data[$1] = $3; 
							printf("Value of the variable: %d\t\n",$3);
							$$=$3;
							}
							else{
							printf("ERROR:Variable is not declared!\n");
							}
						} 
	| IF '(' expression ')' START expression SM END  %prec IFX {
								if($3){
									printf("\nvalue of expression in IF: %d\n",$6);
								}
								else{
									printf("condition value zero in IF block\n");
								}
							}

	| IF '(' expression ')' START expression SM END ELSE START expression SM END {
								if($3){
									printf("value of expression in IF: %d\n",$6);
								}
								else{
									printf("value of expression in ELSE: %d\n",$11);
								}
							}
    | FOR '(' NUM CM NUM ')' START statement END {
	                                int i;
	                                for(i=$3 ; i<$5 ; i++) {printf("value of the loop: %d expression value: %d\n", i,$8);}									
				               }
   
	
	
declaration : TYPE ID1   
             ;


TYPE : INT   
     | FLOAT  
     | CHAR   
     ;



ID1 : ID1 CM VAR  {
                    if(check[$3]==0) check[$3]=1;
                    else printf("ERROR: Variable is re declared!\n");}
    |VAR          {if(check[$1]==0) check[$1]=1;
                   else printf("ERROR: Variable is re declared!\n"); }
    ;

expression: NUM					{ $$ = $1; 	}

	| VAR						{ 
                                if(check[$1]==1){
                                $$ = data[$1];
                                }
	                            else{
	                            printf("ERROR: Variable not declared!\n");
	                            }    
	                               }
	
	| expression '+' expression	{ $$ = $1 + $3; }

	| expression '-' expression	{ $$ = $1 - $3; }

	| expression '*' expression	{ $$ = $1 * $3; }

	| expression '/' expression	{ if($3){
				     					$$ = $1 / $3;
				  					}
				  					else{
										$$ = 0;
										printf("\ndivision by zero\t");
				  					} 	
				    			}
	| expression '%' expression	{ if($3){
				     					$$ = $1 % $3;
				  					}
				  					else{
										$$ = 0;
										printf("\nMOD by zero\t");
				  					} 	
				    			}
	| expression '^' expression	{ $$ = pow($1 , $3);}
	| expression '<' expression	{ $$ = $1 < $3; }
	
	| expression '>' expression	{ $$ = $1 > $3; }

	| '(' expression ')'		{ $$ = $2;	}

	
	;
%%


yyerror(char *s){
	printf( "%s\n", s);
}

