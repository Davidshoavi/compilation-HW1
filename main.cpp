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
    }
    return 0;
}