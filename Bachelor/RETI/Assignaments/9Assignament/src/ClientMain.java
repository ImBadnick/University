import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;
import java.net.SocketTimeoutException;
import java.nio.charset.StandardCharsets;

public class ClientMain {
    private final String serverName;
    private final int serverPort;
    private int PacketsRecived;
    private int PacketsLost;
    private double minRTT, maxRTT, sumRTT, avgRTT;



    public ClientMain(String serverName,int serverPort) {
        this.serverName = serverName;
        this.serverPort = serverPort;
        this.minRTT = Double.POSITIVE_INFINITY;
    }


    public void start() {
        int PacketsNumber = 10; //Number of datagrams
        try{
            DatagramSocket clientSocket = new DatagramSocket();
            clientSocket.setSoTimeout(2000);
            InetAddress address = InetAddress.getByName(this.serverName);
            byte[] sendData;
            byte[] receiveData;
            for(int i=0; i<PacketsNumber; i++) {
                String sendString = ("PING " + i + " " + System.currentTimeMillis());
                receiveData = sendData = sendString.getBytes(StandardCharsets.US_ASCII);
                DatagramPacket SendPacket = new DatagramPacket(sendData,sendData.length,address,this.serverPort);  //Preparing the datagram
                clientSocket.send(SendPacket); //Sending String
                long time = System.currentTimeMillis();
                try{
                    DatagramPacket receivePacket = new DatagramPacket(receiveData,receiveData.length); //Receiving the RTT
                    clientSocket.receive(receivePacket);
                    time = System.currentTimeMillis() - time;
                    //Updating stats
                    this.PacketsRecived++;
                    if(time>this.maxRTT) maxRTT = time;
                    if(time<this.minRTT) minRTT = time;
                    this.sumRTT += time;
                    System.out.println(new String(receivePacket.getData()) + " RTT: " + time);
                }catch(SocketTimeoutException ex) {
                    this.PacketsLost++;
                    System.out.println(sendString + " RTT: *");
                }
            }
            Statistics(PacketsNumber); //Print stats
            System.exit(0);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    public void Statistics(int PacketsNumber) { //Print stats
        this.avgRTT = sumRTT / this.PacketsRecived;
        double percentRTT = (PacketsLost/(PacketsNumber*1.0))*100;
        System.out.println("---- PING Statistics ----");
        System.out.printf(PacketsNumber + " packets transmitted, " + PacketsRecived + " packets received, %1.0f%% packet loss\n",percentRTT);
        System.out.printf("round-trip (ms) min/avg/max = " + this.minRTT + "/%1.2f/" + this.maxRTT+ "\n",avgRTT);
    }


    static public void main(String[] args) {
        //CHECKING ARGSs
        if(args.length!=2) {
            System.out.println("Server need 2 args: java PingServer hostname port");
            System.exit(0);
        }
        try{ Long.parseLong(args[1]); } catch(NumberFormatException e){
            System.out.println("ERR - arg2"); System.exit(0);
        }

        //CLIENT STARTs
        ClientMain client = new ClientMain(args[0],Integer.parseInt(args[1]));
        client.start();
    }

}

