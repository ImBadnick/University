import java.io.IOException;
import java.net.InetSocketAddress;
import java.nio.ByteBuffer;
import java.nio.channels.SocketChannel;
import java.nio.charset.StandardCharsets;
import java.util.Scanner;

public class ClientMain {
    public static void main(String[] args) {
        SocketChannel socketChannel;
        try {
            socketChannel= SocketChannel.open(); //Apertura socket
            socketChannel.connect(new InetSocketAddress("127.0.0.1", 10000)); //Connessione al server
            while(true){
                Scanner scanner = new Scanner(System.in);
                String str = scanner.nextLine();
                socketChannel.write(ByteBuffer.wrap(str.getBytes(StandardCharsets.UTF_8)));

                if(str.equalsIgnoreCase("exit")) break;

                ByteBuffer buffer = ByteBuffer.allocate(str.getBytes(StandardCharsets.UTF_8).length + (" (echoed by server).".getBytes(StandardCharsets.UTF_8)).length); //Creo il buffer per contenere la risposta
                socketChannel.read(buffer);
                buffer.flip();
                String response = new String(buffer.array()).trim();
                System.out.println(response);
                buffer.clear();
            }
            socketChannel.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
