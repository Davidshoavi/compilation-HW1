%{
#define yyleng __disabled_yyleng
#include "tokens.hpp"
#undef yyleng
#include "output.hpp"
#include <stdio.h>
#include <string.h>
void printIllegalEscapeChar(const char* yytext, int yyleng);
%}

%option yylineno
%option noyywrap

digit      ([0-9])
letter     ([a-zA-Z])
digit_and_letter ([a-zA-Z0-9])
whitespace ([ \t\n\r])
string (([^\\\"\n\r]|\\[\\\"nrt0]|\\x[2-6][0-9a-fA-F]|\\x7[0-9a-eA-E])*)

%%

void                                   return VOID;
int                                    return INT;
byte                                   return BYTE;
bool                                   return BOOL;
and                                    return AND;
or                                     return OR;
not                                    return NOT;
true                                   return TRUE;
false                                  return FALSE;
return                                 return RETURN;
if                                     return IF;
else                                   return ELSE;
while                                  return WHILE;
break                                  return BREAK;
continue                               return CONTINUE;
";"                                    return SC;
","                                    return COMMA;
"("                                    return LPAREN;
")"                                    return RPAREN;
"{"                                    return LBRACE;
"}"                                    return RBRACE;
"["                                    return LBRACK;
"]"                                    return RBRACK;
"="                                    return ASSIGN;
"=="                                   return RELOP;
"!="                                   return RELOP;
"<"                                    return RELOP;
">"                                    return RELOP;
"<="                                   return RELOP;
">="                                   return RELOP;
"+"                                    return BINOP;
"-"                                    return BINOP;
"*"                                    return BINOP;
"/"                                    return BINOP;
"//"[^\n\r]*                           return COMMENT;
{letter}{digit_and_letter}*            return ID;
0                                      return NUM;
[1-9]{digit}*                          return NUM;
0b                                     return NUM_B;
[1-9]{digit}*b                         return NUM_B;
\"{string}\"                           return STRING;
\"{string}[\n\r]?                      output::errorUnclosedString();
\"{string}\\([nrt\\]|x[^2-7]|x7[^0-9a-eA-E]){string}\" {printIllegalEscapeChar(yytext, yyleng);}
{whitespace} {;}
. {output::errorUnknownChar(yytext[0]);}

%%

void printIllegalEscapeChar(const char* yytext, int yyleng) {
    for (int i = 0; i < yyleng - 1; ++i) {
        if (yytext[i] == '\\') {
            char esc = yytext[i + 1];

            int valid_simple = (esc == 'n' || esc == 'r' || esc == 't' ||
                                esc == '\\' || esc == '"');

            int valid_hex = 0;
            if (esc == 'x' && i + 3 < yyleng) {
                char hi = yytext[i + 2];
                char lo = yytext[i + 3];
                if ((hi >= '2' && hi <= '6') ||
                    (hi == '7' && (
                        (lo >= '0' && lo <= '9') ||
                        (lo >= 'a' && lo <= 'e') ||
                        (lo >= 'A' && lo <= 'E')))) {
                    valid_hex = 1;
                }
            }

            if (!valid_simple && !valid_hex) {
                if (esc == 'x') {
                    char seq[4] = "x";
                    if (i + 2 < yyleng) seq[1] = yytext[i + 2]; else seq[1] = '\0';
                    if (i + 3 < yyleng) seq[2] = yytext[i + 3]; else seq[2] = '\0';
                    seq[3] = '\0';
                    output::errorUndefinedEscape(seq);
                } else {
                    char single[2] = { esc, '\0' };
                    output::errorUndefinedEscape(single);
                }
            }
        }
    }
}