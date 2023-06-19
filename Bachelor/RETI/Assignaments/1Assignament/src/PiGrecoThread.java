/**
 * @author Lorenzo Massagli
 * @matricola 579418
 */

public class PiGrecoThread implements Runnable{
	private float Accuracy;
	private boolean isRunning;
	
	public PiGrecoThread(float Accuracy) {
		this.Accuracy=Accuracy;
		this.isRunning = true;
	}
	public void run() {
		double PiGreco = 0,denom=1;
		int i=0;
		boolean sign = true;
		
		while(!Thread.interrupted() && this.isRunning == true)
		{
			if(sign==true) PiGreco += 4/denom;
			else PiGreco -= 4/denom;
			denom+=2; sign=!sign; i++;
						
			if(Math.abs(PiGreco - Math.PI) < this.Accuracy) this.isRunning = false;			
		}
		
		System.out.println("PiGreco = " + PiGreco + "\nIterations=" + i +"\nError="+Math.abs(PiGreco - Math.PI)+"\nAccouracy inserted = "+ this.Accuracy + "\n");
	}

}
