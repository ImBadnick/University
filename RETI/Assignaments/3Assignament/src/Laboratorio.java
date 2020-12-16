import java.util.Arrays;
import java.util.concurrent.LinkedBlockingQueue;
import java.util.concurrent.locks.Condition;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

class CustomRow {
	private Thread thread;
	private Object currentObj;
	
	public void setThread(Thread thread) {
		this.thread = thread;
	}
	
	public void setObject(Object currentObj) {
		this.currentObj = currentObj;
	}
	
	public Thread getThread() {
		return this.thread;
	}
	
	public Object getObject() {
		return this.currentObj;
	}
}


public class Laboratorio implements Runnable{
	private int[] computers;
	private Lock computersLock,QueueLock; //Computer array and Queues Lock
	private LinkedBlockingQueue<CustomRow> ProfessoriQueue,StudentiQueue,TesistiQueue;
	private Condition computersLockCondition,queueLockCondition; //Computer array and Queues Lock condition variable
	private int labSize;
	
	public Laboratorio(int size) {
		computers = new int[size];
		computersLock = new ReentrantLock();
		QueueLock = new ReentrantLock();
		
		ProfessoriQueue = new LinkedBlockingQueue<CustomRow>();
		StudentiQueue = new LinkedBlockingQueue<CustomRow>();
		TesistiQueue = new LinkedBlockingQueue<CustomRow>();
		
		this.labSize = size; //Computers in the laboratory
		
		computersLockCondition = computersLock.newCondition();
		queueLockCondition = QueueLock.newCondition();
		for (int i=0;i<size;i++) computers[i]=0;
		
	}
	
	public void AccessQueue(String type, Thread current, Object currentOBJ) throws InterruptedException { //Adding in the Queue prof, gs and students
		CustomRow cr = new CustomRow();
		cr.setThread(current);
		cr.setObject(currentOBJ);
		
		QueueLock.lock();
		if(type.equals("Professore")) {
			ProfessoriQueue.add(cr);
			queueLockCondition.signal();
		}
		if(type.equals("Studente")) {
			StudentiQueue.add(cr);
			queueLockCondition.signal();
		}
		if(type.equals("Tesista")) {
			TesistiQueue.add(cr);
			queueLockCondition.signal();
		}	
		QueueLock.unlock();
	}

	public void run() {
		while(!Thread.currentThread().isInterrupted()) {
			
			//------------------ CHECKING IF THE QUEUES ARE EMPTY AND LET LABORATORY WAIT ---------------- //
			QueueLock.lock();
			try {
				while(ProfessoriQueue.isEmpty() && StudentiQueue.isEmpty() && TesistiQueue.isEmpty()) {
					queueLockCondition.await();
					}
				} catch (InterruptedException e) {
					return;
				}finally {
					QueueLock.unlock();
				}
			
			//------------------ IF QUEUES ARE NOT EMPTY, TAKE ONE FROM PROF -> GS -> STUDENT
			if(!ProfessoriQueue.isEmpty()) {
				computersLock.lock();
				try {
					while(!checkAllComputerFree()) { //WAIT UNTIL ALL THE COMPUTERS ARE NOT FREE
						computersLockCondition.await();
					}
					Professore tmp = (Professore) ProfessoriQueue.remove().getObject();
					println(Thread.currentThread().getName() + ": Entra nel laboratorio il thread: " + tmp.getName());
					setComputersProf(); //SETS ALL THE COMPUTERS AT 1 (USED)
					tmp.wakeup(); //WAKE UP PROF THREAD
				} catch (InterruptedException e) {
					e.printStackTrace();
				}finally {
					computersLock.unlock();
				}				
			}
			else {
				if(!TesistiQueue.isEmpty()) {
					computersLock.lock();
					Tesista tmp = (Tesista) TesistiQueue.element().getObject();
					if(computers[tmp.getNumber()] == 0) { //CHECK IF THE GS COMPUTER IS FREE
						tmp = (Tesista) TesistiQueue.remove().getObject();
						println(Thread.currentThread().getName() + ": Entra nel laboratorio il thread: " + tmp.getName());
						computers[tmp.getNumber()] = 1; //SET THE GS COMPUTER AT 1 (USED)
						tmp.wakeup(); //WAKE UP GS THREAD
					}
					computersLock.unlock();
				}
				else if (!StudentiQueue.isEmpty()) {
					computersLock.lock();
					Studente tmp = (Studente) StudentiQueue.element().getObject();
					if(computers[tmp.getNumber()] == 0) { //CHECK IF THE STUDENT COMPUTER IS FREE
						tmp = (Studente) StudentiQueue.remove().getObject();
						println(Thread.currentThread().getName() + ": Entra nel laboratorio il thread: " + tmp.getName());
						computers[tmp.getNumber()] = 1; //SET THE STUDENT COMPUTER AT 1 (USED)
						tmp.wakeup(); //WAKE UP STUDENT THREAD
					}
					computersLock.unlock();
				}
			}
		}
	}
	
	public boolean checkAllComputerFree() { //FUNCTION TO CHECK IF ALL THE COMPUTERS ARE FREE
		computersLock.lock();
		for(int cmp : this.computers)
			if (cmp==1) { computersLock.unlock(); return false; }
		computersLock.unlock();
		return true;
	}
	
	public void setComputersProf() { //FUNCTION TO SET ALL THE COMPUTERS TO 1
		for (int i=0; i<this.labSize; i++) computers[i]=1;
	}
	

	public void finished(String type, Object obj) { //WHEN ONE OF PROF, STUDENTS, GS HAVE FINISHED -> RESET COMPUTER/COMPUTERS TO 0
		computersLock.lock();
		PrintPC("before"); //PRINT PC ARRAY
		if (type.equals("Professore")) {
			for (int i=0; i<this.labSize; i++) resetPC(i);
			computersLockCondition.signal(); //WAKE UP THE LABORATORY
		}
		if (type.equals("Tesista")) {
			Tesista tmp = (Tesista) obj;
			resetPC(tmp.getNumber());
			computersLockCondition.signal(); //WAKE UP THE LABORATORY
		}
		if (type.equals("Studente")) {
			Studente tmp = (Studente) obj;
			resetPC(tmp.getNumber());
			computersLockCondition.signal(); //WAKE UP THE LABORATORY
		}
		PrintPC("after"); //PRINT PC ARRAY
		computersLock.unlock();
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
