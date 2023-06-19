public class Statistiche { //Metodi sincronizzati per il conteggio delle causali
    private static int nBonifico = 0;
    private static int nAccredito = 0;
    private static int nBollettino = 0;
    private static int nF24 = 0;
    private static int nPagoBancomat = 0;

    //INCREMENTO
    public static synchronized void incnBonifico() {
        Statistiche.nBonifico++;
    }
    public static synchronized void incnAccredito() {
        Statistiche.nAccredito++;
    }
    public static synchronized void incnBollettino() {
        Statistiche.nBollettino++;
    }
    public static synchronized void incnF24() {
        Statistiche.nF24++;
    }
    public static synchronized void incnPagoBancomat() {
        Statistiche.nPagoBancomat++;
    }

    //GETTERS
    public static int getnBonifico() {
        return Statistiche.nBonifico;
    }
    public static int getnAccredito() {
        return Statistiche.nAccredito;
    }
    public static int getnBollettino() {
        return Statistiche.nBollettino;
    }
    public static int getnF24() {
        return Statistiche.nF24;
    }
    public static int getnPagoBancomat() {
        return Statistiche.nPagoBancomat;
    }
}
