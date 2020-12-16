public class AnalizzaCC implements Runnable {
    public Correntista c;

    public AnalizzaCC(Correntista c){
        this.c = c;
    }

    @Override
    public void run() {
        //System.out.println(Thread.currentThread().getName() + ": analizzo i " + this.c.movimenti.size() + " movimenti di " + this.c.nome);
        for (MovimentiCorrentista movement : this.c.movimenti) { //Per ogni movimento del correntista, analizzo la causale
            switch (movement.causale) {
                case "Bonifico" -> Statistiche.incnBonifico();
                case "Accredito" -> Statistiche.incnAccredito();
                case "Bollettino" -> Statistiche.incnBollettino();
                case "F24" -> Statistiche.incnF24();
                case "PagoBancomat" -> Statistiche.incnPagoBancomat();
            }
        }
        //System.out.println("\t\t\t\t" + Thread.currentThread().getName() + ": concluso per " + this.c.nome);
    }
}
