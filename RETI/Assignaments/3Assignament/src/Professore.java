import java.util.concurrent.locks.Condition;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

public class Professore implements Runnable {
	private int nAccess; //RANDOM NUMBER OF ACCESS
	private Laboratorio lab; //LABORATORY
	private int access; //CHECKS IF THE PROF CAN ENTER THE LAB
	private Lock lock;
	private Condition PCnotAvilable;
	private String name;
	
	public Professore(Laboratorio lab,String name) {
		this.nAccess = (int) (Math.random() * (9)) + 1;
		this.lab = lab;
		this.access = 0;
		this.lock = new ReentrantLock();
		this.PCnotAvilable = lock.newCondition();
		this.name = name;
	}
	
	public void run() {
		for(int i=0; i<nAccess;i++) {
			lab.println(Thread.currentThread().getName() + ": Entro in coda per la " + (i+1) + " volta");
			try {
				lab.AccessQueue("Professore",Thread.currentThread(),this); //ENTER THE QUEUE
			} catch (InterruptedException e1) {
				e1.printStackTrace();
			}
			
			lock.lock();
			try {
				while(this.access==0) { //CHECK IF THE PROF CAN ENTER
					PCnotAvilable.await();
				}
				this.access = 0;
				
				//SIMULATES COMPUTER USAGE
				int x = (int)(Math.random()*1000);
				try{
					Thread.sleep(x);
				}catch(InterruptedException e) {};
				
				lab.println(Thread.currentThread().getName() + ": ha finito di usare il laboratorio per la " + (i+1) + " volta");
				lab.finished("Professore",this); //PROF HAS FINISHED TO USE THE COMPUTER
				
			} catch (InterruptedException e) {
				e.printStackTrace();
			}finally {lock.unlock();}
			
			//WAIT RANDOM TIME UNTIL JOIN THE QUEUE AGAIN
			int x = (int)(Math.random()*1000);
			try{
				Thread.sleep(x);
			}catch(InterruptedException e) {};
		}
		
		lab.println(Thread.currentThread().getName() + ": Termina");
	}
	
	public int getNumber() {
		return -1;
	}
	
	public void wakeup() { //WAKE UP THE PROF.
		this.access = 1;
		lock.lock();
		PCnotAvilable.signal();
		lock.unlock();
	}
	
	public String getName() {
		return this.name;
	}

}
