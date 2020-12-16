
public class Persona implements Runnable {
	private int number;
	
	public Persona(int number) {
		this.number = number;
	}
	
	public void run() {
		int max = 10;
		int min = 1;
		int random = (int)(max*Math.random()+min);
		System.out.println("PERSON-"+this.number+" :GETTING SERVED BY "+ Thread.currentThread().getName() +"-TIME NECESSARY:"+random);
		try {
			Thread.sleep((long)(random* 1000));
		} catch (InterruptedException e) {
			e.printStackTrace();
		}
		System.out.println("PERSON- " +this.number+" :HAS FINISHED.");
	}


	public int getNumber() {
		return this.number;
	}

}
