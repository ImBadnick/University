import java.util.concurrent.ArrayBlockingQueue;
import java.util.concurrent.ThreadPoolExecutor;
import java.util.concurrent.TimeUnit;

public class Sportelli {
	private ThreadPoolExecutor executor;
	
	public Sportelli(int sizeQueue,int nSportelli) {
		executor = new ThreadPoolExecutor(nSportelli,nSportelli,0L,TimeUnit.MILLISECONDS,new ArrayBlockingQueue<Runnable>(sizeQueue));
	}
	
	public void executeTasks(Persona persona) {
		executor.execute(persona);
		System.out.println("PERSON-"+persona.getNumber() + ": ENTERING THE 2° ROOM");
	}
	
	public void CloseSportelli() {
		executor.shutdown();
		try {
		    executor.awaitTermination(Long.MAX_VALUE, TimeUnit.MILLISECONDS);
		} catch (InterruptedException e) {
		    e.printStackTrace();
		}
	}
	
	public int getTaskCount() {
		return (int) this.executor.getQueue().size()+ this.executor.getActiveCount();
	}
	


}
