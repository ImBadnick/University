import com.sun.org.apache.xerces.internal.parsers.CachingParserPool;

import java.util.ArrayList;

public class Monitor {
    private int readers = 0;
    private boolean writing = false;
    private int capacity;
    private ArrayList<String> queue = new ArrayList<String>();

    public Monitor(int capacity){
        this.capacity = capacity;
    }

    synchronized void add (String name){
        while(queue.size() == capacity) {
            try {
                wait();
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
        queue.add(name);
        notifyAll();

    }

    synchronized String remove() {
        while(queue.isEmpty()) {
            try {
                wait();
            } catch (InterruptedException e) {
                return null; //Se la coda è vuota e il produttore è terminato -> Devono terminare anche i consumatori.
            }
        }
        String tmp = queue.remove(0);
        notifyAll();
        return tmp;
    }


}
