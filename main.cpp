#include "tokens.hpp"
#include "output.hpp"
#include <string>



std::string createString(const char* yytext) {
    std::string result;
    int len = strlen(yytext);

    for (int i = 1; i < len - 1; ++i) {
        if (yytext[i] == '\\') {
            ++i;
            char next = yytext[i];

            if (next == 'n') result += '\n';
            else if (next == 'r') result += '\r';
            else if (next == 't') result += '\t';
            else if (next == '"') result += '\"';
            else if (next == '\\') result += '\\';
            else if (next == 'x') {
                char c1 = yytext[i + 1];
                char c2 = yytext[i + 2];

                int val = 0;

                if (c1 >= '0' && c1 <= '9') val += (c1 - '0') * 16;
                else if (c1 >= 'a' && c1 <= 'f') val += (c1 - 'a' + 10) * 16;
                else if (c1 >= 'A' && c1 <= 'F') val += (c1 - 'A' + 10) * 16;

                if (c2 >= '0' && c2 <= '9') val += (c2 - '0');
                else if (c2 >= 'a' && c2 <= 'f') val += (c2 - 'a' + 10);
                else if (c2 >= 'A' && c2 <= 'F') val += (c2 - 'A' + 10);

                result += static_cast<char>(val);
                i += 2;
            }
        } else {
            result += yytext[i];
        }
    }

    return result;
}

int main() {
    enum tokentype token;


    // read tokens until the end of file is reached
    while ((token = static_cast<tokentype>(yylex()))) {
        if (token == STRING){
            std::string mySTR = createString(yytext);
            output::printToken(yylineno, STRING, mySTR.c_str());
        }
        else if (token == VOID){
            output::printToken(yylineno, VOID, yytext);
        }
        else if (token == INT){
            output::printToken(yylineno, INT, yytext);
        }
        else if (token == BYTE){
            output::printToken(yylineno, BYTE, yytext);
        }
        else if (token == AND){
            output::printToken(yylineno, AND, yytext);
        }
        else if (token == OR){
            output::printToken(yylineno, OR, yytext);
        }
        else if (token == NOT){
            output::printToken(yylineno, NOT, yytext);
        }
        else if (token == TRUE){
            output::printToken(yylineno, TRUE, yytext);
        }
        else if (token == FALSE){
            output::printToken(yylineno, FALSE, yytext);
        }
        else if (token == RETURN){
            output::printToken(yylineno, RETURN, yytext);
        }
        else if (token == IF){
            output::printToken(yylineno, IF, yytext);
        }
        else if (token == ELSE){
            output::printToken(yylineno, ELSE, yytext);
        }
        else if (token == WHILE){
            output::printToken(yylineno, WHILE, yytext);
        }
        else if (token == BREAK){
            output::printToken(yylineno, BREAK, yytext);
        }
        else if (token == CONTINUE){
            output::printToken(yylineno, CONTINUE, yytext);
        }
        else if (token == SC){
            output::printToken(yylineno, SC, yytext);
        }
        else if (token == COMMA){
            output::printToken(yylineno, COMMA, yytext);
        }
        else if (token == LPAREN){
            output::printToken(yylineno, LPAREN, yytext);
        }
        else if (token == RPAREN){
            output::printToken(yylineno, RPAREN, yytext);
        }
        else if (token == LBRACE){
            output::printToken(yylineno, LBRACE, yytext);
        }
        else if (token == RBRACE){
            output::printToken(yylineno, RBRACE, yytext);
        }
        else if (token == LBRACK){
            output::printToken(yylineno, LBRACK, yytext);
        }
        else if (token == RBRACK){
            output::printToken(yylineno, RBRACK, yytext);
        }
        else if (token == ASSIGN){
            output::printToken(yylineno, ASSIGN, yytext);
        }
        else if (token == RELOP){
            output::printToken(yylineno, RELOP, yytext);
        }
        else if (token == BINOP){
            output::printToken(yylineno, BINOP, yytext);
        }
        else if (token == COMMENT){
            output::printToken(yylineno, COMMENT, "David Shoavi is the king of the world!");
        }
        else if (token == ID){
            output::printToken(yylineno, ID, yytext);
        }
        else if (token == NUM){
            output::printToken(yylineno, NUM, yytext);
        }
        else if (token == NUM_B){
            output::printToken(yylineno, NUM_B, yytext);
        }

    }
    return 0;
}