import java.util.concurrent.locks.Condition;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

public class Professore implements Runnable {
    private final int nAccess; //RANDOM NUMBER OF ACCESS
    private final Laboratorio lab; //LABORATORY
    private int access; //CHECKS IF THE PROF CAN ENTER THE LAB
    private final Object lock = new Object();
    private final String name;

    public Professore(Laboratorio lab,String name) {
        this.nAccess = (int) (Math.random() * (9)) + 1;
        this.lab = lab;
        this.access = 0;
        this.name = name;
    }

    public void run() {
        for(int i=0; i<nAccess;i++) {
            lab.println(Thread.currentThread().getName() + ": Entro in coda per la " + (i+1) + " volta");
            lab.AccessQueue("Professore",this); //ENTER THE QUEUE
            synchronized (lock){
                while(this.access==0) { //CHECK IF THE PROF CAN ENTER
                    try {
                        lock.wait();
                    } catch (InterruptedException ignored) {}
                }
                this.access = 0;
            }

            //SIMULATES COMPUTER USAGE
            int x = (int)(Math.random()*1000);
            try{
                Thread.sleep(x);
            }catch(InterruptedException ignored) {}

            lab.println(Thread.currentThread().getName() + ": ha finito di usare il laboratorio per la " + (i+1) + " volta");
            lab.finished("Professore",this); //PROF HAS FINISHED TO USE THE COMPUTER

            //WAIT RANDOM TIME UNTIL JOIN THE QUEUE AGAIN
            x = (int)(Math.random()*1000);
            try{
                Thread.sleep(x);
            }catch(InterruptedException ignored) {}
        }

        lab.println(Thread.currentThread().getName() + ": Termina");
    }

    public void wakeup() { //WAKE UP THE PROF.
        synchronized (lock){
            this.access = 1;
            lock.notify();
        }
    }

    public String getName() {
        return this.name;
    }

    public String toString() {
        return "Professore";
    }

}