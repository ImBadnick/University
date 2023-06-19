import java.io.File;
import java.util.ArrayList;
import java.util.Collections;

public class main {
    public static void main(String[] args) throws InterruptedException {
        File dir;
        if(args.length != 0)  dir = new File(args[0]); else dir = null;
        
        if ((dir != null && dir.isDirectory()) && args.length==1){
            int k = 4;
            Monitor monitor = new Monitor(5);

            Thread produttore = new Thread(new Produttore(dir,monitor));
            Thread[] consumatore = new Thread[k];

            produttore.start();
            for (int i=0; i<k; i++) { consumatore[i] = new Thread(new Consumatore(i+1,monitor,dir)); consumatore[i].start();}

            produttore.join();

            System.out.println("FERMO I CONSUMATORI");
            for (int i=0; i<k; i++) consumatore[i].interrupt();
            for (int i=0; i<k; i++) consumatore[i].join();
            System.out.println("CONSUMATORI TERMINATI CON SUCCESSO");
            System.out.println("TERMINO PROGRAMMA");
        }
        else {
            System.out.println("Not 1 argument or argument is not a directory, ERROR!");
            System.exit(0);
        }

    }
}
