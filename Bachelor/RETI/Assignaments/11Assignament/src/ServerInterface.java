import java.rmi.Remote;
import java.rmi.RemoteException;
import java.util.ArrayList;

public interface ServerInterface extends Remote {

    boolean setSpeakerSession(int Day, int Session, String Speaker) throws RemoteException;

    ArrayList<Program> getProgram() throws RemoteException;
}
