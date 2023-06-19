import com.fasterxml.jackson.databind.ObjectMapper;

import java.io.FileInputStream;
import java.io.IOException;
import java.nio.ByteBuffer;
import java.nio.channels.Channels;
import java.nio.channels.ReadableByteChannel;
import java.nio.charset.StandardCharsets;

public class LettoreContiCorrente implements Runnable {

    public void run() {
        ObjectMapper mapper = new ObjectMapper();
        try {
            ReadableByteChannel source = Channels.newChannel(new FileInputStream("ContoCorrenti.json")); //Apro un canale in lettura
            ByteBuffer buffer = ByteBuffer.allocate(1024);
            StringBuilder sJson = new StringBuilder();                            //Buffer di costruzione stringa JSON
            while (source.read(buffer) != -1) {
                buffer.flip();                                                     //Imposto per lettura
                while (buffer.hasRemaining()) sJson.append(StandardCharsets.UTF_8.decode(buffer).toString());
                buffer.clear();                                                    //Riparto dall'inizio e in scrittura
            }

            Correntista[] ListaCorrentisti = mapper.readValue(sJson.toString(), Correntista[].class); //Deserializzazione
            for (Correntista c : ListaCorrentisti) {
                main.poolExecutor.submit(new AnalizzaCC(c)); //Sottopongo i task alla thread-pool
            }
            main.poolExecutor.shutdown();
        } catch (IOException e) {
            e.printStackTrace();
        }


    }
}
