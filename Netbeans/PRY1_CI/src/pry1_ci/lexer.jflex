package pry1_ci;
import java_cup.runtime.*;

%%

%class LexerAS
%public
%unicode
%cup
%line
%column

%{

    int line = 1;
    int column = 1;
    String msgErr = "";
    StringBuffer string = new StringBuffer();

    public Symbol symbol(int type) {
        return new Symbol(type, yyline, yycolumn);
    }

    public Symbol symbol(int type, Object value) {
        return new Symbol(type, yyline, yycolumn, value);
    }

    public int getYYLine() {
        return yyline+1;
    }

    public int getYYColumn() {
        return yycolumn+1;
    }

    public String getMsgErr() {
        return msgErr;
    }

    public void SetMsgErr() {
        msgErr = "";
    }
%}


FinLinea = \r|\n|\r\n

CaracterChar = [^\r\n]
EspacioB = {FinLinea} | [ \t\f]

/* Comentarios */
Comentario  = {ComentarioM} | {ComentarioL}

ComentarioM = "/_" [^*] ~"_/" | "/*" "*"+ "/" 
ComentarioL = "@" {CaracterChar}* {FinLinea}

// Identificador
Identificador = [a-zA-Z_][a-zA-Z_0-9]*

//Enteros
Entero = 0 | {EnteroP} | {EnteroN}
EnteroP = [1-9][0-9]*
EnteroN = -{EnteroP}

Flotante = {FlotanteC} | {FlotanteP} | {FlotanteN}
FlotanteC = 0 \. [0-9]+
FlotanteP = {EnteroP} \. [0-9]+
FlotanteN = - ({FlotanteC}|{FlotanteP})

Boolean = T | F

%state CADENA, CHAR

%%




/* keywords */

/*Tipos*/
<YYINITIAL> "bool" {return symbol(sym.BOOL);}
<YYINITIAL> "int" {return symbol(sym.INT);}
<YYINITIAL> "float" {return symbol(sym.FLOAT);}
<YYINITIAL> "string" {return symbol(sym.STRING);}
<YYINITIAL> "char" {return symbol(sym.CHAR);}


<YYINITIAL> "@" {return symbol(sym.COMENTARIO);}


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

<YYINITIAL> "sysPrint" {return symbol(sym.SYS_PRINT);}
<YYINITIAL> "sysRead" {return symbol(sym.SYS_READ);}
//<YYINITIAL> "main" {return symbol(sym.MAIN);}

	
<YYINITIAL> {

    /* Identificadores */
    {Identificador} { return symbol(sym.Identificador, yytext()); }
    
    //{main} {return symbol(sym.MAIN, yytext());}
    // Operadores
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
    "["     {return symbol(sym.LLAVESCUADABRE);}
    "]"     {return symbol(sym.LLAVESCUADCIERRA);}
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

    // Literales
	// Numeros
	{Entero}	{return symbol(sym.L_ENTERO, Integer.valueOf(yytext()));}
	{Flotante}	{return symbol(sym.L_FLOTANTE, Float.valueOf(yytext()));}
	
	// Booleanos
	{Boolean} {return symbol(sym.L_BOOLEANO);}
    

    \'			{yybegin(CHAR);}
    // Strings 
    \"			{yybegin(CADENA); string.setLength(0);}
    
    /*comments*/
    {Comentario} {return symbol(sym.COMENTARIO);}

    /*whitespace*/
    {EspacioB} {/*ignore*/}


    
}

<CADENA> {
    \"      {yybegin(YYINITIAL); return symbol(sym.STRING_LITERAL, string.toString());}
    [^\n\r\"\\]+    {string.append(yytext());}
    \\t     {string.append('\t');}
    \\n     {string.append('\n');}
    \\r     {string.append('\r');}
    \\\"    {string.append('\"');}
    \\      {string.append('\\');}

    // Error 
	\\.	{ msgErr = "[Error lexico] Secuencia de escape ilegal:" + yytext() + "\" en la linea "+(yyline+1)+", columna "+(yycolumn+1);
    System.err.println(msgErr);}
	{FinLinea}	{msgErr = "[Error lexico] String incompleto:" + yytext() + "\" en la linea "+(yyline+1)+", columna "+(yycolumn+1);
    System.err.println(msgErr);}
}

<CHAR> {
	{CaracterChar}\'	{yybegin(YYINITIAL);
						 return symbol(sym.L_CHAR, yytext().charAt(0));}
	
	//Secuencias de escape de caracteres
	"\\b"\'				{yybegin(YYINITIAL);
						 return symbol(sym.L_CHAR, '\b');}
	"\\t"\'				{yybegin(YYINITIAL);
						 return symbol(sym.L_CHAR, '\t');}
	"\\n"\'				{yybegin(YYINITIAL);
						 return symbol(sym.L_CHAR, '\n');}
	"\\f"\'				{yybegin(YYINITIAL);
						 return symbol(sym.L_CHAR, '\f');}
	"\\r"\'				{yybegin(YYINITIAL);
						 return symbol(sym.L_CHAR, '\r');}
	"\\\""\'			{yybegin(YYINITIAL);
						 return symbol(sym.L_CHAR, '\"');}
	"\\'"\'				{yybegin(YYINITIAL);
						 return symbol(sym.L_CHAR, '\'');}	
	"\\\\"\'			{yybegin(YYINITIAL);
						 return symbol(sym.L_CHAR, '\\');}

	//Errores
	\\.	{ msgErr = "[Error lexico] Secuencia de escape ilegal:" + yytext() + "\" en la linea "+(yyline+1)+", columna "+(yycolumn+1);
    System.err.println(msgErr);}
	{FinLinea}	{msgErr = "[Error lexico] Literal caracter incompleto:" + yytext() + "\" en la linea "+(yyline+1)+", columna "+(yycolumn+1);
    System.err.println(msgErr);}
}


/* error fallback */
[^]    { msgErr = "[Error lexico] Caracter Ilegal: "+yytext()+"\" en la linea "+(yyline+1)+", columna "+(yycolumn+1);
        System.err.println(msgErr);
}