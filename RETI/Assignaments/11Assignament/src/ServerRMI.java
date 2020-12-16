import java.rmi.RemoteException;
import java.rmi.registry.LocateRegistry;
import java.rmi.registry.Registry;
import java.rmi.server.UnicastRemoteObject;
import java.util.ArrayList;

public class ServerRMI implements ServerInterface{
    private static final int nSessions = 12;
    private final ArrayList<Program> days;


    public ServerRMI(int nDays){
        this.days = new ArrayList<Program>(); //List of programs (1 x day)
        for(int i=0;i<nDays;i++){
            days.add(new Program(nSessions)); //Creating new program for the day and adding to the list
        }
    }

    public boolean setSpeakerSession(int Day, int Session, String Speaker) throws RemoteException {
        if( (Day<=days.size() && Day>0) && (Session > 0 && Session <=12)){ //Checking if the params are correct
            ArrayList<String> speakers = days.get(Day-1).getSession("S" + Session);
            if(speakers.size()<=4) {
                System.out.printf("SetSpeakerSession operation done with SUCCESS: day = %d , session = %d, speaker = %s\n",Day,Session,Speaker);
                speakers.add(Speaker); //Adding speaker to the i-session of the j-day!
                return true;
            }
        }
        System.out.printf("SetSpeakerSession operation FAILED: day = %d , session = %d, speaker = %s\n",Day,Session,Speaker);
        return false;

    }


    public ArrayList<Program> getProgram() throws RemoteException { //Get all programs of the congression's days
        System.out.println("getProgram operation done with SUCCESS");
        return (ArrayList<Program>) this.days.clone();
    }


    public static void main(String[] args) {
        //CHECK ARGS
        if(args.length != 1){
            System.out.println("Args error, correct: java ServerRMI port");
            System.exit(0);
        }
        int nDays = 3, port=0;
        try { port = Integer.parseInt(args[0]);} catch (NumberFormatException ex) { System.out.println("Args not a number"); System.exit(0);}

        //SETUP RMI
        ServerRMI server = new ServerRMI(nDays);
        try{
            ServerInterface stub = (ServerInterface) UnicastRemoteObject.exportObject(server, 0);
            LocateRegistry.createRegistry(port);
            Registry registry = LocateRegistry.getRegistry(port);
            registry.rebind("ServerRMI",stub);
        } catch (RemoteException e) {
            System.out.println("Communication error " + e.toString());
        }

    }


}
