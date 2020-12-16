import java.io.IOException;
import java.net.*;
import java.nio.ByteBuffer;
import java.nio.channels.DatagramChannel;
import java.nio.channels.SelectionKey;
import java.nio.channels.Selector;
import java.nio.charset.StandardCharsets;
import java.util.Iterator;
import java.util.Random;


public class ServerMain {
    private static final int Buffer_size = 1024;
    private final int port;
    private final Random rnd;
    private final Double prob;

    public static class Connection{ //Object connection
        ByteBuffer request;
        ByteBuffer response;
        SocketAddress socketaddress;
        public Connection() {
            request = ByteBuffer.allocate(Buffer_size);
            response = ByteBuffer.allocate(Buffer_size);
        }
    }

    public ServerMain(int port, long seed) {
        this.port = port;
        if (seed == -1) {
            this.rnd = new Random(System.currentTimeMillis());
            this.prob = 0.25;
        }
        else {
            this.rnd = new Random(seed);
            double randomNumber= rnd.nextDouble();
            this.prob = (double)Math.round(randomNumber*100)/ (double) 100;
        }
        System.out.println("Seed = " + seed + " ----- Probability = " + this.prob);
    }

    public void start() {
        try { //Configuring server
            Selector selector = Selector.open();
            DatagramChannel channel = DatagramChannel.open();
            InetSocketAddress address = new InetSocketAddress(port);
            channel.socket().bind(address);
            channel.configureBlocking(false);
            SelectionKey clientKey = channel.register(selector, SelectionKey.OP_READ);
            clientKey.attach(new Connection());
            System.out.println("Server ready!");

            while (true) { //Selecting
                try {
                    selector.select(); //Selecting a ready key
                    Iterator selectedKeys = selector.selectedKeys().iterator();
                    while (selectedKeys.hasNext()) {
                        try {
                            SelectionKey key = (SelectionKey) selectedKeys.next();
                            selectedKeys.remove();
                            //Type of key
                            if (!key.isValid()) {
                                continue;
                            } else if (key.isReadable()) {
                                read(key);
                                key.interestOps(SelectionKey.OP_WRITE);
                            } else if (key.isWritable()) {
                                write(key);
                                key.interestOps(SelectionKey.OP_READ);
                            }
                        } catch (Exception e) {
                            System.out.println(e);
                        }
                    }
                } catch (IOException e) {
                    System.out.println(e);
                }
            }
        } catch (IOException e) {
            System.out.println(e);
        }
    }


    private void read(SelectionKey key)  throws IOException { //Gets data received from client
        DatagramChannel channel = (DatagramChannel) key.channel();
        Connection connection = (Connection) key.attachment();
        connection.socketaddress = channel.receive(connection.request); //Saving data in receive buffer
        connection.request.flip(); //requestBuffer in reading mode
        connection.response = connection.request;
    }

    private void write(SelectionKey key) throws IOException, InterruptedException { //Send to the client
        //Preparing the write
        DatagramChannel channel = (DatagramChannel)key.channel();
        Connection connection = (Connection) key.attachment();
        String address = (connection.socketaddress).toString(); //Getting ip + port of client
        //Request buffer in writing mode
        if(!packetLoss()) { //checks if the packet is lost or not
            //Delay of packets
            double delay = (rnd.nextInt(200) + 1) + rnd.nextDouble(); //Random double number 1-200
            System.out.println(address + "> " + new String(connection.request.array(), StandardCharsets.UTF_8) + " ACTION: delayed " + delay + " ms");
            Thread.sleep((long) delay); //Simulating connection delay
            //Sending data
            channel.send(connection.response, connection.socketaddress);
            connection.request.clear();
        }
        else { System.out.println(address + "> " + new String(connection.request.array(), StandardCharsets.UTF_8) + " ACTION: not sent"); }
    }

    public Boolean packetLoss(){ //Simulating probability packet loss
        double randomNumber;
        randomNumber = Math.round(rnd.nextDouble()*100); randomNumber = randomNumber / 100;
        return !(randomNumber > this.prob);
    }



    static public void main(String[] args) {

        //CHECKING ARGS
        if(args.length<1 || args.length>2) {
            System.out.println("Server need 1 or 2 args: java PingServer port [seed]");
            System.exit(0);
        }

        boolean FirstArgError = false,SecondArgError = false;
        try{ Integer.parseInt(args[0]); } catch(NumberFormatException e){  FirstArgError = true; }
        if (args.length == 2) try{ Long.parseLong(args[1]); } catch(NumberFormatException e){  SecondArgError = true; }

        //ARGS CONTROL
        if(FirstArgError && SecondArgError) { System.out.println("ERR - arg1 && arg2"); System.exit(0); }
        else if(FirstArgError ) { System.out.println("ERR - arg1"); System.exit(0); }
        else if(SecondArgError ) { System.out.println("ERR - arg2"); System.exit(0); }

        //SERVER START
        ServerMain server;
        if(args.length == 1) server = new ServerMain(Integer.parseInt(args[0]),-1);
        else server = new ServerMain(Integer.parseInt(args[0]),Long.parseLong(args[1]));
        server.start();
    }
}
