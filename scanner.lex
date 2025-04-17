%{
#include "tokens.hpp"
#include "output.hpp"
void printIllegalEscapeChar(const char* yytext, size_t yyleng);
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
. {output::errorIllegalChar(yytext[0]);}

%%

void printIllegalEscapeChar(const char* yytext, size_t yyleng) {
    for (int i = 0; i < yyleng - 1; ++i) {
        if (yytext[i] == '\\') {
            char esc = yytext[i + 1];

            // escape חוקיים רגילים
            bool valid_simple = (esc == 'n' || esc == 'r' || esc == 't' ||
                                 esc == '0' || esc == '\\' || esc == '"');

            // escape חוקי מסוג \xDD לפי טווח חוקי
            bool valid_hex = false;
            if (esc == 'x' && i + 3 < yyleng) {
                char hi = yytext[i + 2];
                char lo = yytext[i + 3];
                if ((hi >= '2' && hi <= '6') ||
                    (hi == '7' && (
                        (lo >= '0' && lo <= '9') ||
                        (lo >= 'a' && lo <= 'e') ||
                        (lo >= 'A' && lo <= 'E')))) {
                    valid_hex = true;
                }
            }

            // טיפול בשגיאה
            if (!valid_simple && !valid_hex) {
                if (esc == 'x') {
                    std::string seq = "x";
                    if (i + 2 < yyleng) seq += yytext[i + 2];
                    if (i + 3 < yyleng) seq += yytext[i + 3];
                    output::errorUndefEscape(seq);
                } else {
                    output::errorUndefEscape(esc);
                }
            }
        }
    }
}