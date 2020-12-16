import java.util.LinkedList;


public class UfficioPostaleMain {
	
	public static void main(String[] args) {
		if (args.length!=2) {
			System.out.println("Please specify the <nPerson> and <K> parameters");
		}
		else {
			int nPerson = Integer.parseInt(args[0]);
			int K = Integer.parseInt(args[1]);
			int nSportelli = 4;
			Sportelli sportelli;
			
			if (K<nSportelli) { System.out.println("Please the parameter <K> needs to be >= "+ nSportelli); System.exit(0);}
			
			LinkedList<Persona> queue1= new LinkedList<Persona>();
			for (int i=0;i<nPerson;i++) {
				queue1.add(new Persona(i+1));
			}
			
			if (K==nSportelli) sportelli = new Sportelli(1, nSportelli);
			else sportelli = new Sportelli(K-nSportelli+1, nSportelli);
			
			while(!queue1.isEmpty()) {	
				if(sportelli.getTaskCount()<K) {
					Persona tmp = queue1.removeFirst();
					sportelli.executeTasks(tmp);
				}
			}
			sportelli.CloseSportelli();
			System.out.println("\nAll the customers have been served");
		}
	}
	
	
}
