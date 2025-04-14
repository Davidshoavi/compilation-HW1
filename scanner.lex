%{
#include "tokens.hpp"
#include "output.hpp"
using namespace std;
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

void  {output::printToken(yylineno, VOID, yytext); return VOID;}
int {output::printToken(yylineno, INT, yytext); return INT;}
byte {output::printToken(yylineno, BYTE, yytext); return BYTE;}
bool {output::printToken(yylineno, BOOL, yytext); return BOOL;}
and {output::printToken(yylineno, AND, yytext); return AND;}
or {output::printToken(yylineno, OR, yytext); return OR;}
not {output::printToken(yylineno, NOT, yytext); return NOT;}
true {output::printToken(yylineno, TRUE, yytext); return TRUE;}
false {output::printToken(yylineno, FALSE, yytext); return FALSE;}
return {output::printToken(yylineno, RETURN, yytext); return RETURN;}
if {output::printToken(yylineno, IF, yytext); return IF;}
else {output::printToken(yylineno, ELSE, yytext); return ELSE;}
while {output::printToken(yylineno, WHILE, yytext); return WHILE;}
break {output::printToken(yylineno, BREAK, yytext); return BREAK;}
continue {output::printToken(yylineno, CONTINUE, yytext); return CONTINUE;}
";" {output::printToken(yylineno, SC, yytext); return SC;}
"," {output::printToken(yylineno, COMMA, yytext); return COMMA;}
"(" {output::printToken(yylineno, LPAREN, yytext); return LPAREN;}
")" {output::printToken(yylineno, RPAREN, yytext); return RPAREN;}
"{" {output::printToken(yylineno, LBRACE, yytext); return LBRACE;}
"}" {output::printToken(yylineno, RBRACE, yytext); return RBRACE;}
"[" {output::printToken(yylineno, LBRACK, yytext); return LBRACK;}
"]" {output::printToken(yylineno, RBRACK, yytext); return RBRACK;}
"=" {output::printToken(yylineno, ASSIGN, yytext); return ASSIGN;}
"==" {output::printToken(yylineno, RELOP, yytext); return RELOP;}
"!=" {output::printToken(yylineno, RELOP, yytext); return RELOP;}
"<" {output::printToken(yylineno, RELOP, yytext); return RELOP;}
">" {output::printToken(yylineno, RELOP, yytext); return RELOP;}
"<=" {output::printToken(yylineno, RELOP, yytext); return RELOP;}
">=" {output::printToken(yylineno, RELOP, yytext); return RELOP;}
"+" {output::printToken(yylineno, BINOP, yytext); return BINOP;}
"-" {output::printToken(yylineno, BINOP, yytext); return BINOP;}
"*" {output::printToken(yylineno, BINOP, yytext); return BINOP;}
"/" {output::printToken(yylineno, BINOP, yytext); return BINOP;}
"//"[^\n\r]* {output::printToken(yylineno, COMMENT, "David Shoavi is the king of the world!"); return COMMENT;}
{letter}{digit_and_letter}* {output::printToken(yylineno, ID, yytext); return ID;}
0 {output::printToken(yylineno, NUM, yytext); return NUM;}
[1-9]{digit}* {output::printToken(yylineno, NUM, yytext); return NUM;}
0b {output::printToken(yylineno, NUM_B, yytext); return NUM_B;}
[1-9]{digit}*b {output::printToken(yylineno, NUM_B, yytext); return NUM_B;}
\"{string}\" {return STRING;}
\"{string}[\n\r]? {output::errorUnclosedString();}
\"{string}\\([nrt\\]|x[^2-7]|x7[^0-9a-eA-E]){string}\" {printIllegalEscapeChar(yytext, yyleng);}
{whitespace} {;}
. {output::errorIllegalChar(yytext[0]);}

%%

void printIllegalEscapeChar(const char* yytext, int yyleng) {
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