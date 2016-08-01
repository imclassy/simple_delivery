/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package testresults;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.stream.Collectors;
import java.util.stream.Stream;
import javafx.scene.shape.Shape;

/**
 *
 * @author pjaraba
 */
public class Processor {
    
    public static void processResults(final String path, final String fileName){
        final String filePath = path + "\\" + fileName;
        final String outputPath = path + "\\" + "processed_tests_results.txt";
        List<String> results = new ArrayList<>();
        
        try {
            final Stream<String> stream;
            stream = Files.lines(Paths.get(filePath));
            
            /* Take all the lines that start with "FAILURE - " and add them 
               to the "results" list */
            results = stream
                             .filter(line -> line.startsWith("FAILURE - "))
                             .collect(Collectors.toList());
            
            if (results.isEmpty()){
                results.add("SUCCESSFUL TESTS!");
            }
            
            Files.write(Paths.get(outputPath), results);
            
        } catch (IOException ex) {
            Logger.getLogger(Processor.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
}
