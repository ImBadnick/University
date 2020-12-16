import java.util.Arrays;
import java.util.concurrent.LinkedBlockingQueue;
import java.util.concurrent.locks.Condition;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

public class Laboratorio implements Runnable{
    private final int[] computers;
    private final LinkedBlockingQueue<Object> ProfessoriQueue;
    private final LinkedBlockingQueue<Object> StudentiQueue;
    private final LinkedBlockingQueue<Object> TesistiQueue;
    private final int labSize;
    boolean writingQueues = false;
    int readers = 0;

    final Object syncroQueue = new Object();
    Object syncroComputers = new Object();

    public Laboratorio(int size) {
        computers = new int[size];

        ProfessoriQueue = new LinkedBlockingQueue<>();
        StudentiQueue = new LinkedBlockingQueue<>();
        TesistiQueue = new LinkedBlockingQueue<>();

        this.labSize = size; //Computers in the laboratory

        for (int i=0;i<size;i++) computers[i]=0;

    }

    public void AccessQueue(String type, Object currentOBJ) { //Adding in the Queue prof, gs and students
        synchronized (syncroQueue) {
            while(writingQueues || (readers != 0))
                try{
                    syncroQueue.wait();
                } catch (InterruptedException ignored){}
            writingQueues = true;
            if(type.equals("Professore")) {
                ProfessoriQueue.add(currentOBJ);
            }
            if(type.equals("Studente")) {
                StudentiQueue.add(currentOBJ);
            }
            if(type.equals("Tesista")) {
                TesistiQueue.add(currentOBJ);
            }
            writingQueues = false;
            syncroQueue.notifyAll();
        }

    }

    public Object getFirst(LinkedBlockingQueue<Object> queue) {
        synchronized (syncroQueue) {
            while (writingQueues)
                try {
                    syncroQueue.wait();
                } catch (InterruptedException ignored) {
                }
            readers += 1;
            Object tmp = queue.remove();
            readers -= 1;
            syncroQueue.notifyAll();
            if (readers == 0) syncroQueue.notifyAll();
            return tmp;
        }
    }

    public Object getInstanceofFirst(LinkedBlockingQueue<Object> queue) {
        synchronized (syncroQueue){
            while (writingQueues)
                try {
                    syncroQueue.wait();
                } catch (InterruptedException ignored) {
                }
            readers += 1;
            Object tmp = queue.element();
            readers -= 1;
            if (readers == 0) syncroQueue.notifyAll();
            return tmp;
        }
    }

    public void run() {
        while(!Thread.currentThread().isInterrupted()) {

            //------------------ CHECKING IF THE QUEUES ARE EMPTY AND LET LABORATORY WAIT ---------------- //
            synchronized (syncroQueue){
                while(ProfessoriQueue.isEmpty() && StudentiQueue.isEmpty() && TesistiQueue.isEmpty()){
                    try{
                        syncroQueue.wait();
                    }catch (InterruptedException e){return;}
                }
            }
            //------------------ IF QUEUES ARE NOT EMPTY, TAKE ONE FROM PROF -> GS -> STUDENT
            if(!ProfessoriQueue.isEmpty()) {
                synchronized (syncroComputers){
                    while(!checkAllComputerFree()){
                        try{
                            syncroComputers.wait();
                        }catch (InterruptedException ignored){}
                    }
                Professore tmp = (Professore) getFirst(ProfessoriQueue);
                println(Thread.currentThread().getName() + ": Entra nel laboratorio il thread: " + tmp.getName());
                setComputersProf(); //SETS ALL THE COMPUTERS AT 1 (USED)
                tmp.wakeup(); //WAKE UP PROF THREAD
                }
            }
            else {
                if(!TesistiQueue.isEmpty()) {
                    Tesista tmp = (Tesista) getInstanceofFirst(TesistiQueue);
                    if(computers[tmp.getNumber()] == 0) { //CHECK IF THE GS COMPUTER IS FREE
                        tmp = (Tesista) getFirst(TesistiQueue);
                        println(Thread.currentThread().getName() + ": Entra nel laboratorio il thread: " + tmp.getName());
                        computers[tmp.getNumber()] = 1; //SET THE GS COMPUTER AT 1 (USED)
                        tmp.wakeup(); //WAKE UP GS THREAD
                    }
                }
                else if (!StudentiQueue.isEmpty()) {
                    Studente tmp = (Studente) getInstanceofFirst(StudentiQueue);
                    if(computers[tmp.getNumber()] == 0) { //CHECK IF THE STUDENT COMPUTER IS FREE
                        tmp = (Studente) getFirst(StudentiQueue);
                        println(Thread.currentThread().getName() + ": Entra nel laboratorio il thread: " + tmp.getName());
                        computers[tmp.getNumber()] = 1; //SET THE STUDENT COMPUTER AT 1 (USED)
                        tmp.wakeup(); //WAKE UP STUDENT THREAD
                    }

                }
            }
        }
    }

    public boolean checkAllComputerFree() { //FUNCTION TO CHECK IF ALL THE COMPUTERS ARE FREE
        for(int cmp : this.computers)
            if (cmp==1) { return false; }
        return true;
    }

    public void setComputersProf() { //FUNCTION TO SET ALL THE COMPUTERS TO 1
        for (int i=0; i<this.labSize; i++) computers[i]=1;
    }


    public void finished(String type, Object obj) { //WHEN ONE OF PROF, STUDENTS, GS HAVE FINISHED -> RESET COMPUTER/COMPUTERS TO 0
        synchronized (syncroComputers){
            PrintPC("before"); //PRINT PC ARRAY
            if (type.equals("Professore")) {
                for (int i=0; i<this.labSize; i++) resetPC(i);
                syncroComputers.notify(); //WAKE UP THE LABORATORY
            }
            if (type.equals("Tesista")) {
                Tesista tmp = (Tesista) obj;
                resetPC(tmp.getNumber());
                syncroComputers.notify(); //WAKE UP THE LABORATORY
            }
            if (type.equals("Studente")) {
                Studente tmp = (Studente) obj;
                resetPC(tmp.getNumber());
                syncroComputers.notify(); //WAKE UP THE LABORATORY
            }
            PrintPC("after"); //PRINT PC ARRAY
        }

    }

    public void resetPC(int i) { //RESET COMPUTER[I] TO 0
        computers[i]=0;
    }

    public void PrintPC(String type) {
        if (type.equals("before")) println("COMPUTERS ARRAY BEFORE: " + Arrays.toString(computers));
        else println("COMPUTERS ARRAY AFTER:  " + Arrays.toString(computers));
    }

    public void println(String x) {
        synchronized (this) {
            System.out.println(x);
        }
    }


}