%{
#include <stdio.h>

unsigned int groupLevel = 0;
unsigned int score = 0;
unsigned int garbageChars = 0;
%}

%x GARBAGE

%%
\{ { groupLevel++; }
\} {
  score += groupLevel;
  groupLevel--;
}
\< { BEGIN(GARBAGE); }
. {}
<GARBAGE>\> { BEGIN(INITIAL); }
<GARBAGE>!. {}
<GARBAGE>. { garbageChars++; }
%%
int main() {
  yylex();

  printf("score: %d\n", score);
  printf("garbage chars: %d\n", garbageChars);
  return 0;
}
