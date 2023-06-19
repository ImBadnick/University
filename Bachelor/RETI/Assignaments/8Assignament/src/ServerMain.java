import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.net.InetSocketAddress;
import java.nio.ByteBuffer;
import java.nio.channels.*;
import java.util.*;


public class ServerMain {
    private final int port;
    private final Map<SocketChannel,List<byte[]>> dataMap;
    private final byte[] sbyte = " (Echoed by Server)".getBytes();

    public ServerMain(int port) {
        this.port = port;
        dataMap = new HashMap<>();
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
                        if (key.isAcceptable()) { //"Catturo" le richieste di connessione
                            ServerSocketChannel server = (ServerSocketChannel) key.channel();
                            SocketChannel client = server.accept();
                            System.out.println("Accepted connection from " + client);
                            client.configureBlocking(false);
                            dataMap.put(client, new ArrayList<>());
                            client.register(selector, SelectionKey.OP_READ);
                        }
                        else if (key.isReadable()) { //"Catturo" le richieste di lettura
                            SocketChannel client = (SocketChannel) key.channel();
                            ByteBuffer buffer = ByteBuffer.allocate(8192);
                            int numRead = client.read(buffer);
                            if(new String(buffer.array()).trim().equalsIgnoreCase("exit") || numRead==-1){
                                this.dataMap.remove(client);
                                client.close();
                                key.cancel();
                                System.out.println("Closing connection: " + client.socket().getRemoteSocketAddress());
                            }
                            else {
                                //Copio i dati dentro la struttura associata al client in modo da poter riscrivere successivamente.
                                byte[] data = new byte[numRead];
                                System.arraycopy(buffer.array(), 0, data, 0, numRead);
                                List<byte[]> Data = this.dataMap.get(client);
                                ByteArrayOutputStream baos = new ByteArrayOutputStream( );
                                baos.write(data); baos.write(sbyte);
                                byte[] res = baos.toByteArray( );
                                Data.add(res);
                                key.interestOps(SelectionKey.OP_WRITE); //Voglio ascoltare solo le operazioni di scrittura associate a quel client
                            }
                        }
                        else if (key.isWritable()) { //"Catturo" le richieste di scrittura
                            SocketChannel client = (SocketChannel) key.channel();
                            List<byte[]> Data = this.dataMap.get(client);
                            Iterator<byte[]> items = Data.iterator();
                            while (items.hasNext()) {
                                byte[] item = items.next();
                                items.remove();
                                client.write(ByteBuffer.wrap(item));
                            }
                            key.interestOps(SelectionKey.OP_READ);
                        }
                    } catch (ClosedChannelException e) {
                        e.printStackTrace();
                    } catch (IOException e) {
                        key.cancel();
                        try { key.channel().close(); }
                        catch (IOException ignored) {}
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
