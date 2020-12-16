import java.io.File;
import java.io.IOException;
import java.util.ArrayList;

public class Consumatore implements Runnable{
    private int id;
    private Monitor monitor;
    private File dir;

    public Consumatore(int id, Monitor monitor, File dir){
        this.id = id;
        this.monitor = monitor;
        this.dir = dir;
    }


    public void run() {
        while (true) {
            String path = monitor.remove();
            if (path == null) return;
            else {
                File tmp = new File(path); //Leggo dalla coda
                System.out.println(Thread.currentThread().getName() + ": LEGGO FILES IN DIRECTORY: " + tmp.getName());
                printDirectoryContents(tmp);
            }
        }
    }

    public void printDirectoryContents(File directory){ //Stampo tutti i file della directory
        File[] files = directory.listFiles();
        if(files!=null)
            for (File file : files) {
                try {
                    System.out.println(Thread.currentThread().getName() + ": FILE - " + file.getName() + " - DIRECTORY: " + directory.getCanonicalPath());
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
    }
}

