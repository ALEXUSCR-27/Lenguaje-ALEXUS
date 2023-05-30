/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package pry1_ci;

/**
 *
 * @author asmal
 * Clase para realizar analisis y verificaciones de tipos
 */
public class VerificadorTipos {
    public VerificadorTipos(){}
    
    /**
     * @param String tipo
     * @param String valor
     * @param Object valor2
     * @return Valor Booleano
     * Funcion para redirigir a alguna de las verificaciones
     */
    public boolean opciones(String tipo, String valor, Object valor2) {
        switch(tipo){
            case "int":
                if (verificarEntero(valor)) return true;
                break;
            case "bool":
                if (verificarBooleano(valor)) return true;
                break;
            case "float":
                if (verificarFloat(valor2)) return true;
                break;
            case "char":
                if (verificarChar(valor2)) return true;
                break;
            case "string":
                if (verificarString(valor2)) return true;
                break;
            default:
                break;
        }
        return false;
    }
    
    /**
     * @param String valor
     * @return Valor Booleano
     * Funcion para verificar si una cadena de carateres puede ser entero
     */
    public boolean verificarEntero(String valor) {
        try{
            Integer.parseInt(valor);
            return true;
        }
        catch(NumberFormatException e) {
            return false;
        }
        
    }
    
    /**
     * @param String valor
     * @return Valor Booleano
     * Funcion para verificar si una cadena de carateres puede ser booleano
     */
    public boolean verificarBooleano(Object valor) {
        try{
            return valor instanceof Boolean; 
        }
        catch(NumberFormatException e) {
            return false;
        }
        
    }
    
    /**
     * @param Object valor
     * @return Valor Booleano
     * Funcion para verificar si un objeto es flotante
     */
    public boolean verificarFloat(Object valor) {
        return valor instanceof Float;
    }
    
    /**
     * @param Object valor
     * @return Valor Booleano
     * Funcion para verificar si un objeto puede ser char
     */
    public boolean verificarChar(Object valor) {
        return valor instanceof Character;
        
    }
    
    /**
     * @param Object valor
     * @return Valor Booleano
     * Funcion para verificar si un objeto puede ser String
     */
    public boolean verificarString(Object valor) {
        try{
            return valor instanceof String;
        }
        catch(Exception e) {
           return false;
        }
    }
    
}

