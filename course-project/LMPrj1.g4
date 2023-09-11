grammar LMPrj1;

/********* parser grammars **********************************************************************************************/

startparse: unit EOF;



/*  start of import section  *********************************************/

unit: importrule* block;
block: (check  |    functiondeclaration | instantiation | definevaraible | expression | ifblock | callfunction | loop | trycatch | switchrule )*;
//block: functiondeclaration;

check:String_tok SPACE* SEMI;



importrule: IMPORT SPACE  wantedlib SPACE* SEMI | FROM SPACE  fromlibnamelist SPACE IMPORT SPACE wantedlib SPACE* SEMI ;
codeblock: OPENKRO SPACE* code SPACE* CLOSEKRO ;
code: (check  |   instantiation |definevaraible | functiondeclaration | expression | ifblock | callfunction | loop| trycatch | switchrule)* ;
fromlibnamelist: LIBNAME | LIBNAME DOT LIBNAMEMETHOD | LIBNAME DOT LIBNAME;
wantedlib: IMPORTSTAR | LIBNAME | multiplewantedlibs | flashlibs;
multiplewantedlibs: (LIBNAME SPACE* COMMA SPACE* )+ LIBNAME ;
flashlibs: LIBNAME SPACE* FLASH SPACE* LIBNAME ;

/*  end of import section  *********************************************/



/*  start of variables section  *********************************************/
definevaraible: visibility? SPACE* vraiabletype SPACE+ varaiblename SPACE* parttwo addition* SPACE* SEMI SPACE* ;

addition: SPACE* COMMA SPACE* varaiblename SPACE* DONOGHTE  SPACE* newothertypes;
vraiabletype: VAR | CONST ;
varaiblename: LIBNAME ;
number : DECIMAL | NOMADELMI | DOUBLENUM | POSITIVE DECIMAL | NEGETIVE DECIMAL |POSITIVE DOUBLENUM|NEGETIVE DOUBLENUM;

parttwo: assignpart |datatypepart;
assignpart: ASSIGN SPACE* String_tok  | ASSIGN SPACE* arraypart;
arraypart: ARRAY SPACE* OPENPAREN (SPACE* number SPACE* COMMA)* (SPACE* number SPACE*) CLOSEPAREN;

datatypepart: DONOGHTE SPACE* (newarray | newothertypes);
newothertypes:datatype (assignvaltodatatype)?;
newarray: SPACE* 'new' SPACE+ ARRAY SPACE* '[' datatype ']' SPACE* OPENPAREN SPACE* DECIMAL SPACE* CLOSEPAREN SPACE*;
datatype: STRING | DOUBLE | INT | LONG | BOOLEAN | BYTE | CHAR;
assignvaltodatatype: SPACE* ASSIGN SPACE* (arraypart | number | String_tok)SPACE*;
/*  end of variables section  *********************************************/

//// commands
//onelinecomment: LINECOMMENT SPACE* ALPHABET * SPACE* ;
//onelinecomment -> skip;

/*  start of class & instantiation section  *********************************************/

///    instantiation

visibility: PROTECTED | PUBLIC | PRIVATE;

instantiation :preinstantiation   newobject SPACE* SEMI ;
 preinstantiation:visibility? SPACE*(VAR | CONST) SPACE*  newobjectname SPACE* DONOGHTE SPACE* New SPACE+ ;
 newobjectname:LIBNAME;
 newobject: classnameofobj SPACE* OPENPAREN objectarguments? SPACE* CLOSEPAREN;
 classnameofobj:LIBNAME;
 objectarguments:( (SPACE*(number | arraypart | String_tok |callobjattribute|objargumentvar | objname)SPACE* COMMA)* (SPACE*(number | arraypart | String_tok | callobjattribute|objargumentvar| objname)SPACE*)) ;
objargumentvar:LIBNAME;
 //
/*  end of class & instantiation section  *****************************************/



/*  start of FUNCTION section  *********************************************/
functiondeclaration:visibility? SPACE* returntype SPACE* funcname SPACE* parameterlist SPACE* functioncodeblock ;
funcname: LIBNAME;
parameterlist: OPENPAREN SPACE* parameter* SPACE* CLOSEPAREN;
parameter: datatype SPACE* LIBNAME SPACE* COMMA? SPACE* ;
returntype: datatype | VOID ;
functioncodeblock: OPENKRO SPACE* code returnstatement? SPACE* CLOSEKRO ;
returnstatement: RETURN SPACE* returnvalue SPACE* SEMI;
returnvalue: (LIBNAME | String_tok | number);
callfunction: SPACE* precallfunction? SPACE* callmethod SPACE* SEMI | callfuncfromobj;
precallfunction: visibility? SPACE*(VAR | CONST)? SPACE*  newobjectname SPACE* ASSIGN SPACE* ;
callmethod:SPACE* callmethodname SPACE* OPENPAREN calledmethodarguments? SPACE* CLOSEPAREN;
 callmethodname:LIBNAME ;
calledmethodarguments:( (SPACE*(number | arraypart | String_tok|objname)SPACE* COMMA)* (SPACE*(number | arraypart | String_tok | objname)SPACE*)) ;
callfuncfromobj : SPACE* callobjattribute SPACE* OPENPAREN SPACE* objectarguments SPACE* CLOSEPAREN SPACE* SEMI;
callobjattribute: SPACE* objname SPACE* DOT SPACE* objattributename SPACE*;
objname: LIBNAME;
objattributename: LIBNAME;



/*  end of FUNCTION section  *********************************************/

/*  start if section  *********************************************/

ifblock: ifstatement+ elifstatement* elsestatement* ;
ifstatement: SPACE* IF SPACE* OPENPAREN SPACE* condition SPACE* CLOSEPAREN SPACE* codeblock SPACE* ;
elifstatement: SPACE* ELIF SPACE* OPENPAREN SPACE* condition SPACE* CLOSEPAREN SPACE* codeblock SPACE* ;
elsestatement:  SPACE* ELSE  SPACE* codeblock SPACE* ;
/*  end of  if section  *********************************************/


/*  start string interpolation section  *********************************************/
stringinterpolationvariable: variable

/*  start string interpolation section  *********************************************/


/*  start for section  *********************************************/
forstatement: SPACE* forheader SPACE* forblock SPACE*;
forheader: SPACE* FOR SPACE* OPENPAREN SPACE* intializeforcounter SPACE* condition SPACE* SEMI SPACE* forupdate SPACE* CLOSEPAREN SPACE* ;
forblock: SPACE* codeblock SPACE* ;
intializeforcounter: SPACE* forcountername SPACE* ASSIGN SPACE* forcounternamefirstvalue SPACE* SEMI SPACE* ;
forcountername: LIBNAME;
forcounternamefirstvalue: DECIMAL ;
forupdate: SPACE* forcountername SPACE* decreaseop SPACE* ;
forinstatement: SPACE* forinstatementheader SPACE* forblock SPACE* ;
forinstatementheader: SPACE* FOR SPACE* OPENPAREN SPACE* VAR? SPACE* varaiblename SPACE* IN SPACE* iteratorname SPACE* CLOSEPAREN ;
iteratorname: LIBNAME | callobjattribute;
forrule: forinstatement | forstatement ;
loop: forrule | whilerule;
/*  end for section  *********************************************/


/*  start while section  *********************************************/
whileheader: SPACE* WHILE SPACE* OPENPAREN SPACE* condition SPACE* CLOSEPAREN SPACE* ;
whilebody: SPACE* codeblock SPACE* ;
while: SPACE* whileheader SPACE* whilebody SPACE* ;


dowhile: SPACE* doblock SPACE* whileheader SPACE* ;
doblock: DO SPACE* codeblock ;
whilerule: while | dowhile ;

/*  end while section  *********************************************/


/*  start try-catch section  *********************************************/

trycatch: SPACE* tryblock SPACE* catchblock+ SPACE* ;
tryblock: SPACE* TRY SPACE* codeblock SPACE* ;
catchblock:SPACE* (catchblocktype1 | catchblocktype2) SPACE* ;
catchblocktype1: SPACE* ON SPACE* exceptionname SPACE* CATCH SPACE* OPENPAREN SPACE* catchargument SPACE* CLOSEPAREN SPACE* codeblock SPACE* ;
catchblocktype2:SPACE* CATCH SPACE* OPENPAREN SPACE* catchargument SPACE* CLOSEPAREN SPACE* codeblock SPACE* ;
exceptionname: LIBNAME;
catchargument: LIBNAME;

/*  end try-catch section   *********************************************/


/*  start switch case section   *********************************************/

switchheader: SPACE* SWITCH SPACE* OPENPAREN SPACE* switchexperession SPACE* CLOSEPAREN SPACE*;
switchbody: SPACE* OPENKRO SPACE* caseblock+ SPACE* defaultblock? SPACE* CLOSEKRO SPACE* ;
caseblock: SPACE* caseheader SPACE* casebody SPACE* ;
caseheader:SPACE* CASE SPACE* variable SPACE* DONOGHTE SPACE* ;
casebody:   SPACE* code? SPACE* breakins? SPACE* ;
breakins: SPACE* BREAK SPACE* SEMI SPACE* ;
defaultheader:SPACE* DEFAULT  SPACE* DONOGHTE SPACE* ;
defaultbody:  SPACE* code? SPACE* breakins? SPACE* ;
defaultblock: SPACE* defaultheader SPACE* defaultbody SPACE* ;
switchrule: SPACE* switchheader SPACE* switchbody SPACE* ;

switchexperession: buildexpression;

/*  end switch case section   *********************************************/

/*  start of  experession  c section  *********************************************/
//buildexpression :SPACE* OPENPAREN SPACE* buildexpression SPACE* CLOSEPAREN SPACE*
//| buildexpression SPACE* POW SPACE* buildexpression SPACE*
//| SPACE* COMPLEMENT SPACE* buildexpression SPACE*
//|SPACE* NEGETIVE  buildexpression SPACE*| SPACE* POSITIVE buildexpression SPACE*
//| buildexpression  decreaseop SPACE*| SPACE* decreaseop buildexpression SPACE*
//| buildexpression SPACE* arithmaticop SPACE* buildexpression SPACE*
//|buildexpression SPACE* bitop SPACE* buildexpression SPACE*
//|buildexpression SPACE* compareop SPACE* buildexpression SPACE*
//|buildexpression SPACE* logicalop SPACE* buildexpression SPACE*
//|variable;

buildexpression : variable |
buildexpression SPACE* logicalop SPACE* buildexpression SPACE* |
buildexpression SPACE* compareop SPACE* buildexpression SPACE*|
buildexpression SPACE* bitop SPACE* buildexpression SPACE*|
 buildexpression SPACE* arithmaticop SPACE* buildexpression SPACE*|
 buildexpression SPACE* decreaseop SPACE*| SPACE* decreaseop SPACE* buildexpression SPACE*|
 SPACE* NEGETIVE SPACE*  buildexpression SPACE*| SPACE* POSITIVE SPACE* buildexpression SPACE* |
 SPACE* COMPLEMENT SPACE* buildexpression SPACE* |
 buildexpression SPACE* POW SPACE* buildexpression SPACE* |
 SPACE* OPENPAREN SPACE* buildexpression SPACE* CLOSEPAREN SPACE*    ;







decreaseop: PP | MM ;
arithmaticop: '*'
| DIVIDE
|DBDIVIDE
|REM
|SUB
|ADD;

bitop: SL | SR | AND | OR | XOR;

compareop: '==' | '!=' | '<>' | '<' | '>'| '<='|'>=';
logicalop : NOTLOG | ORLOG | ANDLOG | '||' | '&&' ;

variable : LIBNAME | number | callobjattribute | String_tok;
expression: SPACE* buildexpression SPACE* assign SPACE* buildexpression SPACE* SEMI |  SPACE* buildexpression SPACE* SEMI SPACE*;
assign: '-='|'+='|'//='|'/='|'%='|'*='|'=' |'**=';
condition:  comparecondition  | logicalcondition| SPACE* LIBNAME SPACE | TRUE | FALSE;
comparecondition:SPACE* buildexpression SPACE* compareop SPACE* buildexpression SPACE* ;
logicalcondition:  SPACE* comparecondition SPACE* logicalop SPACE* comparecondition SPACE* | SPACE* buildexpression SPACE* logicalop SPACE* buildexpression SPACE*  ;
/*  end of experession  section  *********************************************/





/********* lexer grammars ***************************************************************************************************/






fragment LOWERCASELETTERS:[a-z];
fragment UPPERCASELETTERS:[A-Z];

fragment LETTERS:[a-zA-Z];
fragment ALLPOSSIBLECHARSFORVALNAME: [a-zA-Z0-9_$];
fragment DIGITS:[0-9];
fragment ZERO:[0];
fragment NONZERODIGITS:[1-9];
fragment ALPHABET:[a-zA-Z0-9_$];


VOID :'void';
ASSIGN:'=';
ARRAY:'Array';
IMPORT : 'import';
IMPORTSTAR:'*';
SEMI: ';';
FROM: 'from';
FLASH:'=>';
SPACE: ' ';
COMMA: ',';
DOT: '.';
STRING:'String';
DOUBLE:'Double';
INT:'Int';
BOOLEAN: 'boolean';
FLOAT:'float';
CHAR : 'char';
BYTE : 'byte';
CONST : 'const';
VAR:'var';
LONG : 'long';
PRIVATE : 'private';
PROTECTED : 'protected';
PUBLIC : 'public';
OPENDBQOUTE: '"';
CLOSEDBQOUTE: '"';
OPENPAREN: '(';
CLOSEPAREN:')';
//BOOL : 'true' | 'false';
POSITIVE :'+';
NEGETIVE:'-';
DONOGHTE:':';
New :'new';
CLASS:'class';
IMPLEMENTS:'implements';
WITH:'with';
EXTENDS:'extends';
RETURN:'return';
FOR:'for';
IN:'in';
WHILE:'while';
DO:'do';
ELSE:'else';
ELIF:'elif';
IF:'if';
SWITCH:'switch';
CASE:'case';
DEFAULT:'default';
BREAK:'break';
TRY:'try';
CATCH:'catch';
DOLLORSIGN:'$';
OPENKRO:'{';
CLOSEKRO:'}';
LINECOMMENT:'//';
STARTMULTILINECOMMENT:'/*';
ENDMULTILINECOMMENT:'*/';
FALSE :'false';
TRUE: 'true';
POW:'**';
COMPLEMENT:'~';
PP:'++';
MM:'--';
DIVIDE : '/';
DBDIVIDE:'//';
REM:'%';
SUB:'-';
ADD:'+';
SL:  '<<';
SR :'>>';
AND :'&';
OR :'|';
XOR:'^';
NOTLOG:'not';
ANDLOG:'and';
ORLOG:'or';
ON:'on';








 LIBNAME: ID;
 ID
     : ('a'..'z' | 'A'..'Z'|'_')('a'..'z' | 'A'..'Z'|'0'..'9'|'_' | '$')*
     ;
LIBNAMEMETHOD: LIBNAME UPPERCASELETTERS LIBNAME ;

String_tok : '"' ('\\' ["\\] | ~["\\\r\n])* '"' ;
NOMADELMI: ZERO '.' DIGITS+ 'e' DIGITS*  |  ZERO '.' DIGITS+ 'e' POSITIVE DIGITS* | ZERO '.' DIGITS+ 'e' NEGETIVE DIGITS* ;

DECIMAL : NONZERODIGITS DIGITS* | ZERO;
DOUBLENUM: DIGITS+ DOT DIGITS+ ;



Whitespace
    :   [ \t\n]+
        -> skip
    ;


LINE_COMMENT
    :   '//' ~[\r\n]* -> skip
    ;

COMMENT
    :   '/*' .*? '*/' -> skip
    ;