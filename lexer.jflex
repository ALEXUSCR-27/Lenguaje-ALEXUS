package ParserLexer;
import java_cup.runtime.*;

%%

%class LexerAC
%public
%unicode
%cup
%line
%column
%implements sym


%{
    StringBuffer string = new StringBuffer();

    private Symbol symbol(int type) {
        return new Symbol(type, yyline, yycolumn);
    }

    private Symbol symbol(int type, Object value) {
        return new Symbol(type, yyline, yycolumn, value);
    }
%}

LineTerminator = \r|\n|\r\n
InputCharacter = [^\r\n]
WhiteSpace = {LineTerminator} | [ \t\f]

/* comments */
Comment  = {TraditionalComment} | {EndOfLineComment} | {DocumentationComment}

TraditionalComment = "/*" [^*] ~"*/" | "/*" "*"+ "/" //esto cambia
// Comment can be last line of the file, without line terminator.
EndOfLineComment = "//" {InputCharacter}* {LineTerminator}?
DocumentationComment = "/**" {CommentContent} "*"+ "/"
CommentContent = ([^*] | \*+ [^/*])*

Identifier = [:jletter:] [:jletterdigit:]*

DecIntegerLiteral = 0 | [1-9][0-9]*

%state CADENA

%%

/* keywords */

/*Tipos*/
<YYINITIAL> "bool" {return symbol(sym.BOOL);}
<YYINITIAL> "int" {return symbol(sym.INT);}
<YYINITIAL> "float" {return symbol(sym.FLOAT);}
<YYINITIAL> "string" {return symbol(sym.STRING);}
<YYINITIAL> "char" {return symbol(sym.CHAR);}
<YYINITIAL> "arreglo" {return symbol(sym.ARREGLO);}
<YYINITIAL> "true" {return symbol(sym.TRUE);}
<YYINITIAL> "false" {return symbol(sym.FALSE);}
<YYINITIAL> "@" {return symbol(sym.COMENTARIO_SIMPLE);}
<YYINITIAL> "def" {return symbol(sym.DEFINICION);}


/*Control*/
<YYINITIAL> "if" {return symbol(sym.IF);}
<YYINITIAL> "elif" {return symbol(sym.ELIF);}
<YYINITIAL> "else" {return symbol(sym.ELSE);}
<YYINITIAL> "while" {return symbol(sym.WHILE);}
<YYINITIAL> "do" {return symbol(sym.DO);}
<YYINITIAL> "for" {return symbol(sym.FOR);}
<YYINITIAL> "break" {return symbol(sym.BREAK);}
<YYINITIAL> "return" {return symbol(sym.RETURN);}
<YYINITIAL> "$" {return symbol(sym.FIN_EXPRESION);}
<YYINITIAL> "null" {return symbol(sym.NULL);}
<YYINITIAL> "sysPrint" {return symbol(sym.SYS_PRINT);}
<YYINITIAL> "sysRead" {return symbol(sym.SYS_READ);}


<YYINITIAL> {
    /*identifiers*/
    {Identificador} {return symbol(sym.IDENTIFICADOR, yytext();)}

    /*literals*/
    {DecIntegerLiteral} {return symbol(sym.INTEGER_LITERAL, Integer.parserInt(yytext()));}
    \"                  {string.setLength(0); yybegin(CADENA);}
    
    //Operators
    "=="    {return symbol(sym.EQEQ);}
    "="     {return symbol(sym.EQ);}
    "+"     {return symbol(sym.PLUS);}
    "*"     {return symbol(sym.TIMES);}
    "-"     {return symbol(sym.MINUS);}
    "/"     {return symbol(sym.DIVI);}
    "("     {return symbol(sym.PARENTESISABRE);}
    ")"     {return symbol(sym.PARENTESISCIERRA);}
    "{"     {return symbol(sym.LLAVESCORCHETEABRE);}
    "}"     {return symbol(sym.LLAVESCORCHETECIERRA);}
    ";"     {return symbol(sym.SEMI);}
    ","     {return symbol(sym.COMA);}
    "!"     {return symbol(sym.NEGACION);}
    "^"     {return symbol(sym.CONJUNCION);}
    "#"     {return symbol(sym.DISYUNCION);}
    "--"    {return symbol(sym.MINUSMINUS);}
    "++"    {return symbol(sym.PLUSPLUS);}
    ">"     {return symbol(sym.GREATER_THAN);}
    "<"     {return symbol(sym.LESS_THAN);}
    ">="    {return symbol(sym.GREATER_THAN_OR_EQ);}
    "<="    {return symbol(sym.LESS_THAN_OR_EQ);}
    "!="    {return symbol(sym.NOT_EQ);}
    "**"    {return symbol(sym.POWER);}
    "~"     {return symbol(sym.MODULO);}


    

    /*comments*/
    {Comment} {/*ignore*/}

    /*whitespace*/
    {WhiteSpace} {/*ignore*/}
    
}

<CADENA> {
    \"      {yybegin(YYINITIAL);
            return symbol(sym.STRING_LITERAL,
            string.toString());}
    [^\n\r\"\\]+    {string.append(yytext());}
    \\t     {string.append('\t');}
    \\n     {string.append('\n');}
    \\r     {string.append('\r');}
    \\\"    {string.append('\"');}
    \\      {string.append('\\');}
}

/*error fallback*/
[^]     {throw new Error("Illegal character <"+ yytext()+">");}