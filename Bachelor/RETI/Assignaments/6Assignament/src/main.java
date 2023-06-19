import java.util.concurrent.Executors;
import java.util.concurrent.ThreadPoolExecutor;
import java.util.concurrent.TimeUnit;

public class main {
    public static ThreadPoolExecutor poolExecutor;
    public static void main(String[] args) {
        Thread lettoreContiCorrente = new Thread(new LettoreContiCorrente());
        lettoreContiCorrente.setName("LettoreContiCorrente");
        poolExecutor = (ThreadPoolExecutor) Executors.newFixedThreadPool(10);
        lettoreContiCorrente.start();
        try {
            lettoreContiCorrente.join();
            poolExecutor.awaitTermination(Long.MAX_VALUE, TimeUnit.MILLISECONDS);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        System.out.println(
                "Bonifico\t\t" + Statistiche.getnBonifico() +
                        "\nAccredito\t\t" + Statistiche.getnAccredito() +
                        "\nBollettino\t\t" + Statistiche.getnBollettino() +
                        "\nF24\t\t\t\t" + Statistiche.getnF24() +
                        "\nPagoBancomat\t" + Statistiche.getnPagoBancomat()                     //Output delle info richieste
        );
    }
}
