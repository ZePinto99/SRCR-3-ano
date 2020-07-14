import java.io.*;

public class CSVReaderADJ {

    public static void main(String[] args) {
      try {
          File myObj = new File("Adj1.pl");
          if (myObj.createNewFile()) {
              System.out.println("File created: " + myObj.getName());
          } else {
              System.out.println("File already exists.");
          }
      } catch (IOException e) {
          System.out.println("An error occurred.");
          e.printStackTrace();
      }

      try {
          FileOutputStream fos = new FileOutputStream("Adj1.pl");
          BufferedWriter writer = new BufferedWriter(new FileWriter("Adj1.pl"));
          int[] ficheirocsv = new int[] {1,2,6,7,10,11,12,13,15,23,101,102,106,108,111,112,114,115,116,117,119,122,125,129,158,162,171,184,201,467,468,470,471,479,714,748,750,751,776};
          int[] tam = new int[] {76,76,37,18,62,35,68,102,95,8,22,53,64,49,42,42,46,55,10,60,53,61,45,36,75,17,45,44,21,10,7,18,22,11,12,11,11,22,20};

          int[] listaIds = new int[809]; int incIds = 0;
          String[] listaArestas;
          int nrArestas = 0;
          for(int csvs=0;csvs<39;csvs++){

              System.out.println(ficheirocsv[csvs]);
        String csvFile = "adjacencias_csv"+ficheirocsv[csvs]+".csv";
        BufferedReader br = null;
        String line = "";
        String cvsSplitBy = ";";
        Paragem[] paragens = new Paragem[809];
        int adj[] = new int[tam[csvs]];
        int carreira=0;
        int i = 0;
        int j;
        try {

            br = new BufferedReader(new FileReader(csvFile));
            br.readLine();
            int in=0;
            while ((line = br.readLine()) != null) {

                j = 0;
                String[] componentes = line.split(cvsSplitBy);
                adj[in]= Integer.parseInt(componentes[j]);

                boolean test = false;
                for (int element : listaIds) {
                    if (element == adj[in]) {
                        test = true;
                        break;
                    }
                }

                if(!test){
                    listaIds[incIds] = adj[in];
                    incIds++;
                }

                j++;in++;
                String lat = componentes[j];
                j++;
                String longi = componentes[j];
                j++;
                String estado = componentes[j];
                j++;
                String abrigo = componentes[j];
                j++;
                String pubAbrigo = componentes[j];
                j++;
                String operadora = componentes[j];
                j++;


                carreira = Integer.parseInt(componentes[j]);

                j++;
                int codRua = Integer.parseInt(componentes[j]);
                j++;
                String nomeRua = componentes[j];
                j++;
                String freguesia = null;
                if (j < componentes.length) {
                    freguesia = componentes[j];
                }

                //Paragem atual = new Paragem(grid, lat, longi, estado, abrigo, pubAbrigo, operadora, carreira, codRua, nomeRua, freguesia);
                //paragens[i] = atual;
                i++;
            }

        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (br != null) {
                try {
                    br.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }


            StringBuilder ids = new StringBuilder();
            StringBuilder arestas = new StringBuilder();


                ids.append("[");
                int d = 1;
                for (int c : adj) {
                    if (d < adj.length) ids.append(c + ",");
                    else ids.append(c);
                    d++;
                }
                ids.append("]");



                    ids.append(",[");
                     d = 1;int aux=0;
                    for (int c : adj) {
                      if(d==1);
                     //   if (d < adj.length && k==0) arestas.append("aresta("+adj[k]+","+adj[k+1]+")");
                     //   if (d < adj.length && k!=0) arestas.append(",aresta("+adj[k]+","+adj[k+1]+")");
                      else{
                      if(d==2) {
                      ids.append("aresta("+aux+","+c+")"); nrArestas ++;}
                      if(d!=2){
                      ids.append(",aresta("+aux+","+c+")"); nrArestas++;}
                    }
                        d++;
                        aux=c;
                    }
                    ids.append("]");


                      String readyids = ids.toString();
                writer.write("g("+carreira+",grafo("+readyids+")).\n");

            System.out.println("Successfully wrote to the file.");
        }
          writer.close();
      }
        catch (IOException e) {
            System.out.println("An error occurred.");
            e.printStackTrace();
        }

    }


}
