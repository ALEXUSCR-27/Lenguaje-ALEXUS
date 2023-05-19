/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Main.java to edit this template
 */
package pry1_ci;
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.Reader;
import java.nio.file.Files;
import java.nio.file.Paths;
import java_cup.runtime.Symbol;

/**
 *
 * @author asmal
 */
public class PRY1_CI {

    /**
     * @param args the command line arguments
     * @throws java.io.IOException
     */
    public static void main(String[] args) throws IOException, Exception {
        Limpiar();
    }
        
    /**
    * Metodo para eliminar los archivos existentes de analisis pasados
    * @throws java.io.IOException
    */
    private static void Limpiar() throws IOException, Exception {
        
        String raiz, rutaLexer, rutaParser;

        raiz = System.getProperty("user.dir");
        System.out.println(raiz);
       
        rutaLexer = raiz+"\\src\\pry1_ci\\lexer.jflex";
        rutaParser = raiz+"\\src\\pry1_ci\\Parser.cup";
        
        Files.deleteIfExists(Paths.get(raiz+"\\src/pry1_ci\\sym.java"));
        Files.deleteIfExists(Paths.get(raiz+"\\src/pry1_ci\\Parser.java"));
        Files.deleteIfExists(Paths.get(raiz+"\\src/pry1_ci\\LexerAS.java"));
        Files.deleteIfExists(Paths.get(raiz+"\\src/pry1_ci\\analisis.txt"));
        Generar(rutaLexer, rutaParser);
        
        Files.move(Paths.get(raiz+"\\sym.java"), Paths.get(raiz+"\\src\\pry1_ci\\sym.java"));
        Files.move(Paths.get(raiz+"\\parser.java"), Paths.get(raiz+"\\src\\pry1_ci\\parser.java"));
        //probarLexer();
        probarParser();
       
    }
    
    /**
    * Metodo para generar el Lexer y Parser
    * @throws java.io.IOException
    */
    private static void Generar(String r1, String r2) throws IOException {
        File archivo;
        archivo = new File(r1);
        JFlex.Main.generate(archivo);
        String[] opciones = {r2};
         try 
        {
            java_cup.Main.main(opciones);
        } 
        catch (Exception ex)
        {
            System.out.print(ex);
        }
         
    }
    
    /**
     * Metodo para realizar el analisis lexico y sintactico del codigo del archivo ej.txt
     * @throws java.io.IOException
    */
    private static void probarLexer() throws FileNotFoundException, IOException {
        String rutaEJ1 = "src/pry1_ci/ej2.txt";
        Reader reader = new BufferedReader(new FileReader (rutaEJ1));
        reader.read();
        LexerAS lexer = new LexerAS(reader);
        int i = 0;
        
        Symbol token;
        String rutaAnalisis = "src/pry1_ci/analisis.txt";
        
        File analisis = new File(rutaAnalisis);
        
        analisis.createNewFile();
        FileWriter escribir = new FileWriter(analisis);
        BufferedWriter buffer = new BufferedWriter(escribir);
       
        while(true) {
            token = lexer.next_token();
            if(token.sym !=0) {
                String msg = "[Tabla de lexer] Linea: "+lexer.getYYLine()+" Columna: "+lexer.getYYColumn()+" Tokem: "+token.sym+ ", Valor: "+lexer.yytext()+ " ("+sym.terminalNames[token.sym]+")\n";
                
                buffer.write(msg);
                System.out.print(msg);
                
                if(!"".equals(lexer.getMsgErr())) {
                    buffer.write(lexer.getMsgErr()+"\n");
                }
                lexer.SetMsgErr();
            }
          
            else {
                String msg = "Cantidad de lexemas encontrados: "+i;
                buffer.write(msg);
                buffer.close();
                System.out.println(msg);
                return;
            }
            i++;
        }
        
    }
    
    private static void probarParser() throws FileNotFoundException, IOException, Exception {
        String rutaEJ1 = "src/pry1_ci/ej.txt";
        Reader reader = new BufferedReader(new FileReader (rutaEJ1));
        reader.read();
        LexerAS lexer = new LexerAS(new FileReader (rutaEJ1));
        parser p = new parser(lexer);
        Object result = p.parse();
      
                //Object result = p.parse().value;
                //System.out.println("El archivo se puede compilar.");
           
    }
    
}
