import java.io.Serializable;
import java.util.*;

public class Program implements Serializable { //Class that rappresent congress's program of the day
    private final TreeMap<String, ArrayList<String>> program; //Pair (i-session, List[ speaker1, speaker2 ... speaker5])

    class compare implements Comparator<String>, Serializable{ //Key ordering TreeMap
        public int compare(String s, String s1) {
            int value = Integer.parseInt(s.substring(1));
            int value1 = Integer.parseInt(s1.substring(1));
            if(value == value1) return 0;
            else if(value>value1) return 1;
            else return -1;
        }
    }


    public Program(int nSession){
        this.program = new TreeMap<String, ArrayList<String>>(new compare()); //Initialize TreeMap
        for(int i=1; i <= nSession;i++){ //Initialize Keys(sessions) and list of speakers
            program.put("S" + i, new ArrayList<String>());
        }
    }


    public TreeMap<String, ArrayList<String>> getProgram(){ //Get program of the day
        return (TreeMap<String, ArrayList<String>>) this.program.clone();
    }

    public ArrayList<String> getSession(String Session){ //Get speaker of that session
        return this.program.get(Session);
    }

}


