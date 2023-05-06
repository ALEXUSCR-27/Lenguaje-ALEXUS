/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 */

package com.mycompany.projecto01.compiladores;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.Reader;

/**
 *
 * @author danie
 */
public class Projecto01Compiladores {

    public static void main(String[] args) {
        System.out.println("Hello World!");
    }
    
    
    private void probar() {
        Reader reader = new BufferedReader(new FileReader (ruta));
        reader.read();
        LexerAC lexer = new LexerAC(reader);
        int i = 0;
        
        Symbol token;
        while(true) {
            token = lexer.next_token();
            if(token.sym !=0) {
                System.out.println("Tokem: "+token.sym+ ", Valor: "+lexer.yytext());
            }
            else {
                System.out.println("Cantidad de lexemas encontrados: "+i);
                return;
            }
            i++;
        }
        
    }
    
    
    
}
