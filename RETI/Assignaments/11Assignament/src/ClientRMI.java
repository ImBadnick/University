import java.awt.datatransfer.SystemFlavorMap;
import java.rmi.RemoteException;
import java.rmi.registry.LocateRegistry;
import java.rmi.registry.Registry;
import java.util.*;

public class ClientRMI {
    public static void main(String[] args) {
        //CHECK ARGS
        if(args.length != 1){
            System.out.println("Args error, correct: java ServerRMI port");
            System.exit(0);
        }
        try {
            //Setup RMI
            Registry registry = LocateRegistry.getRegistry(Integer.parseInt(args[0]));
            ServerInterface stub = (ServerInterface) registry.lookup("ServerRMI");
            Scanner in = new Scanner(System.in);
            while(true){ //Menù
                System.out.println("Which operation?:");
                System.out.println("1. Add speaker to a session\n2. Get congress program\n0. EXIT");
                try{ //Get operation
                    switch(Integer.parseInt(in.nextLine())) {
                        case 0:
                            System.out.println("CLIENT EXIT");
                            System.exit(0);
                        case 1:
                            insertSpeaker(in,stub);
                            break;
                        case 2:
                            getProgram(stub);
                            break;
                        default:
                            System.out.println("Unrecognized option");
                            break;
                    }
                }catch(NumberFormatException ex) { System.out.println("Not a number!");}
            }
        } catch (Exception e) {
            System.err.println("Client exception: " + e.toString());
            e.printStackTrace();
        }
    }

    public static void insertSpeaker(Scanner in, ServerInterface stub) throws RemoteException {
        int day, sessionNumber;
        System.out.println("Insert day: ");
        try{ day = Integer.parseInt(in.nextLine()); }catch(NumberFormatException ex){ System.out.println("Not a number!"); return;}
        System.out.println("Insert session number: ");
        try{ sessionNumber = Integer.parseInt(in.nextLine()); }catch(NumberFormatException ex){ System.out.println("Not a number!"); return;}
        System.out.println("Insert speaker: ");
        String speaker = in.nextLine();
        boolean result = stub.setSpeakerSession(day,sessionNumber, speaker); //Use RMI to insert the Speaker to the i-session of the j-day
        if(!result) System.out.println("Operation error!"); else System.out.println("Operation done with success!");
    }

    public static void getProgram(ServerInterface stub) throws RemoteException {
        int counter = 1;
        ArrayList<Program> congressProgram = stub.getProgram(); //Use RMI to get all programs of the congression's days
        for(Program day : congressProgram){ //Print programs
            if(day != null){
                System.out.println("Day: " + counter);
                if(day.getProgram()!=null) System.out.println(Arrays.toString(day.getProgram().entrySet().toArray()));
            }
            counter ++;
        }

    }


}
