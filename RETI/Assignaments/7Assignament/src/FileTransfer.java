import java.io.File;
import java.io.OutputStream;
import java.net.Socket;
import java.nio.charset.Charset;
import java.nio.file.Files;
import java.nio.file.NoSuchFileException;
import java.nio.file.Paths;
import java.util.Date;
import java.util.Scanner;

public class FileTransfer implements Runnable {
    private Socket socket;
    public FileTransfer(Socket socket){
        this.socket = socket;
    }

    public void run() {
        System.out.println("Connected: " + socket);
        try (Scanner in = new Scanner(socket.getInputStream());
             OutputStream outStream = socket.getOutputStream();)
        {
            String Path = in.nextLine().split(" ")[1].substring(1);
            System.out.println(Thread.currentThread().getName() + "\tRequested: " + Path); //Estraggo il path dalla richiesta
            try{
                File FileRequested = new File(Path);
                byte[] fileByte = null;
                fileByte = Files.readAllBytes(Paths.get(Path)); //Prendo i byte del file per poterli inviare
                //Preparo messaggio GET RESPONSE
                outStream.write(("HTTP/1.1 200 OK\n").getBytes(Charset.defaultCharset()));
                outStream.write(("Server: HTTPFileTransferServer\n").getBytes(Charset.defaultCharset()));
                outStream.write(("Date: " + new Date().toString() + "\n").getBytes(Charset.defaultCharset()));
                outStream.write(("Content-Length: " + FileRequested.length() + "\n").getBytes(Charset.defaultCharset()));
                outStream.write(("\n").getBytes(Charset.defaultCharset()));
                outStream.write(fileByte);
                outStream.flush();
            }catch (NoSuchFileException ex) { //FILE NOT FOUND
                outStream.write(("HTTP/1.1 500 No Such File Exception\n").getBytes(Charset.defaultCharset()));
                outStream.write(("Server: HTTPFileTransferServer\n").getBytes(Charset.defaultCharset()));
                outStream.write(("Date: " + new Date().toString() + "\n").getBytes(Charset.defaultCharset()));
                outStream.flush();
            }
            System.out.println(Thread.currentThread().getName() + "\tClosing connection");
            socket.close();
        } catch (Exception e) { System.out.println("Error:" + socket); }


    }
}
