/**
 * @author Lorenzo Massagli
 * @matricola 579418
 */

class Main {
	public static void main(String[] args){
		 if (args.length != 2) {
	            System.out.println("Please specify <accuracy> and <time limit> from the command line.");
	     } 
		 else {
		    PiGrecoThread pigreco = new PiGrecoThread(Float.parseFloat(args[0]));
		    Thread thread1 = new Thread(pigreco);
		    thread1.start();
		    
		    try { //Sleeping
		    	Thread.sleep(Integer.parseInt(args[1]));
		    }catch(InterruptedException x) {};
		    
		    System.out.println("Throwing an interrupt to the Thread \n");
		    thread1.interrupt( );
		    
		    try {
                thread1.join();
            } catch (InterruptedException ignored) {}
		    
		    System.out.println ("I'm terminating...");  
		 }	
	}
}
