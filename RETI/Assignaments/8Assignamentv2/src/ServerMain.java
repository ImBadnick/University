import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.net.InetSocketAddress;
import java.nio.ByteBuffer;
import java.nio.channels.*;
import java.nio.charset.StandardCharsets;
import java.util.*;


public class ServerMain {
    private int port;

    public ServerMain(int port) {
        this.port = port;
    }

    public void startServer(){
        try {
            ServerSocketChannel srvSkt = ServerSocketChannel.open();  //Apertura del socket di ascolto
            srvSkt.socket().bind(new InetSocketAddress(port)); //Configurazione del socket
            srvSkt.configureBlocking(false);

            //Setup selector
            Selector selector = Selector.open();
            srvSkt.register(selector, SelectionKey.OP_ACCEPT);
            System.out.println(Thread.currentThread().getName() + ": server online");
            ByteBuffer buffer = ByteBuffer.allocate(1024);
            while (true) {
                try {
                    selector.select(); //Selecting
                } catch (IOException ex) {
                    ex.printStackTrace();
                    break;
                }

                Set<SelectionKey> readyKeys = selector.selectedKeys();
                Iterator<SelectionKey> iterator = readyKeys.iterator();

                while (iterator.hasNext()) {
                    SelectionKey key = iterator.next();
                    iterator.remove();
                    try {
                        if (!key.isValid()) {
                            continue;
                        }
                        else if (key.isAcceptable()) { //"Catturo" le richieste di connessione
                            ServerSocketChannel server = (ServerSocketChannel) key.channel();
                            SocketChannel client = server.accept();
                            System.out.println("Accepted connection from " + client);
                            client.configureBlocking(false);
                            SelectionKey clientKey =  client.register(selector, SelectionKey.OP_READ);
                        }
                        else if (key.isReadable()) { //"Catturo" le richieste di lettura
                            SocketChannel client = (SocketChannel) key.channel();
                            int numRead = client.read(buffer);
                            buffer.flip(); // read from the buffer
                            String stringRecived = new String(buffer.array(),StandardCharsets.UTF_8).trim(); //Reading
                            if(stringRecived.equalsIgnoreCase("exit") || numRead==-1){
                                client.close();
                                key.cancel();
                                System.out.println("Closing connection: " + client.socket().getRemoteSocketAddress());
                            }
                            else {
                                key.interestOps(SelectionKey.OP_WRITE); //Voglio ascoltare solo le operazioni di scrittura associate a quel client
                            }
                        }
                        else if (key.isWritable()) { //"Catturo" le richieste di scrittura
                            SocketChannel client = (SocketChannel) key.channel();;
                            client.write(buffer);
                            buffer.clear();
                            key.interestOps(SelectionKey.OP_READ);
                        }
                    } catch (ClosedChannelException e) {
                        e.printStackTrace();
                    } catch (IOException e) {
                        key.cancel();
                        try { key.channel().close(); }
                        catch (IOException cex) {}
                    }
                }

            }
        }catch(IOException e){
            e.printStackTrace();
        }
    }


    public static void main(String[] args) {

        ServerMain server = new ServerMain(10000);
        server.startServer();
    }
}
