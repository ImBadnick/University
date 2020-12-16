import java.io.File;
import java.io.IOException;
import java.util.ArrayList;

public class Produttore implements Runnable{
    private File dir;
    private Monitor monitor;

    public Produttore(File dir,Monitor monitor){
        this.dir = dir;
        this.monitor = monitor;
    }

    public void run(){
        try {
            AddDirectoriesRecursivelly(dir);
        } catch (InterruptedException | IOException e) {
            e.printStackTrace();
        }
        try {
            monitor.add(dir.getCanonicalPath());
        } catch (IOException e) {
            e.printStackTrace();
        }
        System.out.println("IL PRODUTTORE E' TERMINATO");
    }

    public void AddDirectoriesRecursivelly(File dir) throws InterruptedException, IOException {
        File[] files = dir.listFiles();
        for (File file : files) {
            if(file.isDirectory())
            {
                AddDirectoriesRecursivelly(file); //Chiamata ricorsiva
                monitor.add(file.getCanonicalPath()); //Aggiungo directoryName alla queue
            }
        }
    }

}
