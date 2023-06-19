import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;
import java.text.SimpleDateFormat;
import java.util.Date;

public class TimeServer {
    //Sends to a multicast group, date and time
    //Waits some time to send another message to the Multicast group
    //IP address from args


    public static void main(String[] args){
        if(args.length != 2) {
            System.out.println("Program need 1 args: java TimeServer IP Port");
            System.exit(0);
        }

        try{
            InetAddress dategroup=InetAddress.getByName(args[0]);
            SimpleDateFormat formatter= new SimpleDateFormat("yyyy-MM-dd 'at' HH:mm:ss z");
            DatagramSocket ms = new DatagramSocket();
            int port= Integer.parseInt(args[1]);
            while(true){
                Date date = new Date(System.currentTimeMillis());
                byte[] data = (formatter.format(date)).getBytes();
                DatagramPacket dp = new DatagramPacket(data,data.length,dategroup,port); //Preparing datagram
                System.out.println("Sending date and time: " + new String(data));
                ms.send(dp); //Sending date and time
                Thread.sleep(1000);
            }
        }catch(Exception e){System.out.println(e);}
    }
}
