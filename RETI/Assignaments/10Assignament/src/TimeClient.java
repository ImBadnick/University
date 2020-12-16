import java.io.IOException;
import java.net.DatagramPacket;
import java.net.InetAddress;
import java.net.MulticastSocket;


public class TimeClient {
    //Gets data and time for 10 times and print them
    //IP and Port from args


    public static void main(String[] args) {
        if(args.length != 2) {
            System.out.println("Program need 2 args: java TimeClient IP Port");
            System.exit(0);
        }

        MulticastSocket ms = null;
        InetAddress dategroup = null;
        try {
            dategroup=InetAddress.getByName(args[0]);
            ms = new MulticastSocket(Integer.parseInt(args[1]));
            ms.joinGroup(dategroup); //joining the group
            byte[] buffer = new byte[8192];
            DatagramPacket dp=new DatagramPacket(buffer,buffer.length);
            for(int i=0;i<10;i++) { //receiving data and time from server
                ms.receive(dp);
                String s = new String(dp.getData());
                System.out.println(s);
            }
        } catch (IOException e) { System.out.println(e); }

        if (ms!= null){
            try {
                ms.leaveGroup(dategroup);
                ms.close();
            } catch (IOException ignored){}
        }

    }
}
