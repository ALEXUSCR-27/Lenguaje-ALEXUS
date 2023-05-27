/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package pry1_ci;

/**
 *
 * @author asmal
 */
public class VerificadorTipos {
    public VerificadorTipos(){}
    
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
    
    public boolean verificarEntero(String valor) {
        try{
            Integer.parseInt(valor);
            return true;
        }
        catch(NumberFormatException e) {
            return false;
        }
        
    }
    
    public boolean verificarBooleano(String valor) {
        try{
            Boolean.parseBoolean(valor);
            return true;
        }
        catch(NumberFormatException e) {
            return false;
        }
        
    }
    
    public boolean verificarFloat(Object valor) {
        return valor instanceof Float;
    }
    
    public boolean verificarChar(Object valor) {
        return valor instanceof Character;
        
    }
    
    public boolean verificarString(Object valor) {
            return valor instanceof String;
    }
    
}

