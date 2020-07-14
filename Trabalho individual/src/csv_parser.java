import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.PrintWriter;
import java.util.ArrayList;



public class csv_parser {
    public static void main(String[] args) throws Exception{
        int[] ficheirocsv = new int[] {1,2,6,7,10,11,12,13,15,23,101,102,106,108,111,112,114,115,116,117,119,122,125,129,158,162,171,184,201,467,468,470,471,479,714,748,750,751,776};

        for( int carreira : ficheirocsv) {

            BufferedReader fis = new BufferedReader(new FileReader(new File("adjacencias_csv" + carreira + ".csv")));
            PrintWriter out = new PrintWriter(new BufferedWriter(new FileWriter("baseConhecimento.pl", true)));
            //PrintWriter out2 = new PrintWriter(new BufferedWriter(new FileWriter("paragens_incompletas.txt",true)));
            fis.readLine();

            ArrayList<String> lista = new ArrayList<>();


            String linha;
            while ((linha = fis.readLine()) != null) {
                String[] partes = linha.split(";");
                if (partes.length != 11) {
                    System.out.println(linha);
                    //out2.println(linha);
                    //out.flush();
                } else {
                    StringBuilder sb = new StringBuilder();

                    sb.append(partes[0]).append(";").append(partes[7]);

                    lista.add(sb.toString());
                    //out.println(retttt.toString());
                    //out.flush();
                }
            }


            for (int i = 1; i < lista.size(); i++) {
                String[] a = lista.get(i - 1).split(";");
                String[] b = lista.get(i).split(";");

                out.println("aresta(" + a[0] + "," + b[0] + ").");
                out.flush();

            }
        }
    }
}