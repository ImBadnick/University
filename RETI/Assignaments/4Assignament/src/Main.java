public class Main {
    public static void main(String[] args) throws InterruptedException {

        if (args.length!=3) {
            System.out.println("Please specify the <nStudenti>, <nTesisti> e <nProfessori> parameters");
        }
        else {
            int nStudenti = Integer.parseInt(args[0]);
            int nTesisti = Integer.parseInt(args[1]);
            int nProfessori = Integer.parseInt(args[2]);
            int LabSize = 20;

            Laboratorio lab = new Laboratorio(LabSize); //CREATE THE LAB OBJECT
            Thread labThread = new Thread(lab); //CREATE THE LAB THREAD
            labThread.setName("LABORATORIO");
            labThread.start();

            //CREATE STUDENT/PROF/GS TASK AND THREADS ARRAYS
            Studente[] studenti = new Studente[nStudenti];
            Thread[] ThreadStudenti = new Thread[nStudenti];
            Professore[] professori = new Professore[nProfessori];
            Thread[] ThreadProfessori = new Thread[nProfessori];
            Tesista[] tesisti = new Tesista[nTesisti];
            Thread[] ThreadTesisti = new Thread[nTesisti];

            //CREATE STUDENTS/PROF/GS, THE THREADS AND START THE THREADS
            for (int i=0;i<nStudenti;i++) { studenti[i] = new Studente(lab,"Studente-"+i); ThreadStudenti[i] = new Thread(studenti[i]); ThreadStudenti[i].setName("Studente-"+i); ThreadStudenti[i].start();}
            for (int i=0;i<nTesisti;i++) { tesisti[i] = new Tesista(lab,"Tesista-"+i); ThreadTesisti[i] = new Thread(tesisti[i]); ThreadTesisti[i].setName("Tesista-"+i); ThreadTesisti[i].start();}
            for (int i=0;i<nProfessori;i++) { professori[i] = new Professore(lab,"Professore-"+i); ThreadProfessori[i] = new Thread(professori[i]); ThreadProfessori[i].setName("Professore-"+i);  ThreadProfessori[i].start();}

            //WAIT UNTIL ALL THE STUDENTS/PROF/GS THREADS HAVE FINISHED
            for (int i=0;i<nStudenti;i++) {ThreadStudenti[i].join();}
            for (int i=0;i<nTesisti;i++) {ThreadTesisti[i].join();}
            for (int i=0;i<nProfessori;i++) {ThreadProfessori[i].join();}

            //CLOSE THE LABORATORY
            lab.println("Chiudo il laboratorio");
            labThread.interrupt();
            labThread.join();

            lab.println("Programma terminato");
        }
    }
}