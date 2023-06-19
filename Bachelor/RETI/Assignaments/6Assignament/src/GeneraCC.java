import com.fasterxml.jackson.databind.ObjectMapper;

import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.ByteBuffer;
import java.nio.channels.Channels;
import java.nio.channels.WritableByteChannel;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;
import java.util.concurrent.ThreadLocalRandom;

public class GeneraCC {
    public static void main(String[] args) {
        String[] causali = {"Bonifico","Accredito","Bollettino","F24","PagoBancomat"};
        Random rnd = new Random(System.currentTimeMillis());
        int n = rnd.nextInt(20) + 50; //Numero random da 50 a 69
        int k;

        List<Correntista> ListaCorrentisti = new ArrayList<>(); //Lista di correntisti
        //CREO I DATI
        for(int i=0;i<n;i++) {
            Correntista correntista = new Correntista("Correntista - " + i); //Creo un nuovo oggetto Correntista
            k = rnd.nextInt(20)+1; //Numero random da 1 a 20
            List<MovimentiCorrentista> mList = new ArrayList<>(); //Lista di movimenti
            for (int j=0; j<k; j++) { //CREAZIONE k MOVIMENTI DEL CORRENTISTA i
                LocalDate start = LocalDate.now().minusYears(2);
                LocalDate end = LocalDate.now();
                LocalDate randomDay = between(start, end);
                mList.add(new MovimentiCorrentista(randomDay.toString(), causali[rnd.nextInt(causali.length)]));
            }
            correntista.movimenti = mList;
            ListaCorrentisti.add(correntista);
        }


        //APRO IL CANALE E SCRIVO SUL FILE JSON
        ObjectMapper mapper = new ObjectMapper();
        try {
            WritableByteChannel dest = Channels.newChannel (new FileOutputStream("ContoCorrenti.json")); //CREO UN CANALE
            String jsonString = mapper.writerWithDefaultPrettyPrinter().writeValueAsString(ListaCorrentisti); //SERIALIZZAZIONE OGGETTO JAVA -> JSON
            ByteBuffer buffer = ByteBuffer.wrap(jsonString.getBytes(StandardCharsets.UTF_8)); //CREO UN OGGETTO BUFFER MA NON ALLOCO MEM. PER GLI ELEMENTI

            while(buffer.hasRemaining()) { //SCRIVO NEL FILE "ContoCorrenti.json"
                dest.write(buffer);
            }
            buffer.clear();
            dest.close();
        } catch (IOException e) {
            e.printStackTrace();
        }

    }

    //CREA UNA DATA RANDOM TRA LA DATA INIZIALE E FINALE
    public static LocalDate between(LocalDate startInclusive, LocalDate endExclusive) {
        long startEpochDay = startInclusive.toEpochDay();
        long endEpochDay = endExclusive.toEpochDay();
        long randomDay = ThreadLocalRandom.current().nextLong(startEpochDay, endEpochDay);
        return LocalDate.ofEpochDay(randomDay);
    }
}
