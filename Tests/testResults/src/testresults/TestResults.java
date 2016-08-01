/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package testresults;

/**
 *
 * @author pjaraba
 */
public class TestResults {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        
        final String path = System.getProperty("user.dir");
        final String fileName = "tests_results.txt";
        Processor.processResults(path, fileName);
        
    }
    
}
