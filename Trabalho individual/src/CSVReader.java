import java.io.*;

public class CSVReader {

    public static void main(String[] args) {
        String csvFile = "paragem_autocarros_oeiras_processado_4.csv";
        BufferedReader br = null;
        String line = "";
        String cvsSplitBy = ";";
        Paragem[] paragens = new Paragem[809];
        int[] listaIds = new int[809];
        int i = 0;
        int j;
        try {

            br = new BufferedReader(new FileReader(csvFile));
            br.readLine();
            while ((line = br.readLine()) != null) {
                j = 0;
                String[] componentes = line.split(cvsSplitBy);
                int grid = Integer.parseInt(componentes[j]);
                j++;
                System.out.println(grid);
                String lat = componentes[j];
                System.out.println(lat);
                j++;
                String longi = componentes[j];
                System.out.println(componentes[j]);
                j++;
                String estado = componentes[j];
                System.out.println(componentes[j]);
                j++;
                String abrigo = componentes[j];
                System.out.println(componentes[j]);
                j++;
                String pubAbrigo = componentes[j];
                System.out.println(componentes[j]);
                j++;
                String operadora = componentes[j];
                System.out.println(componentes[j]);
                j++;


                String[] carreiras = componentes[j].split(",");
                String[] carreira = new String[carreiras.length];
                for (int w = 0; w<carreiras.length; w++) {
                    String aux = carreiras[w];
                    carreira[w] = null;
                    carreira[w] = aux;
                    System.out.println(carreira[w]);
                }
                j++;
                System.out.println(componentes[j]);
                int codRua = Integer.parseInt(componentes[j]);
                j++;
                System.out.println(componentes[j]);
                String nomeRua = componentes[j];
                j++;
                String freguesia = null;
                if (j < componentes.length) {
                    System.out.println(componentes[j]);
                    freguesia = componentes[j];
                    System.out.println(freguesia);
                }

                Paragem atual = new Paragem(grid, lat, longi, estado, abrigo, pubAbrigo, operadora, carreira, codRua, nomeRua, freguesia);
                paragens[i] = atual;
                listaIds[i] = atual.getGrid();
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

        try {
            File myObj = new File("baseConhecimento.pl");
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
            FileOutputStream fos = new FileOutputStream("baseConhecimento.pl");
            BufferedWriter writer = new BufferedWriter(new FileWriter("baseConhecimento.pl"));
            for(int k=0; k <paragens.length; k++){
               // paragem(ID,LT,LG,E,A,PUB,OP,C,R,NR,F)
                StringBuilder carreirasAux = new StringBuilder();
                carreirasAux.append("[");
                int d = 1;
                for (String c : paragens[k].getCarreira()) {
                    if (d < paragens[k].getCarreira().length) carreirasAux.append(c + ",");
                    else carreirasAux.append(c);
                    d++;
                }
                carreirasAux.append("]");
                String readyCarreiras = carreirasAux.toString();
                String s = "paragem(" + paragens[k].getGrid()+ "," +  paragens[k].getLat()+ "," +  paragens[k].getLongi()+ "," + "\'" + paragens[k].getEstado()+ "\'" + "," + "\'" + paragens[k].getAbrigo() + "\'" + ","
                        + "\'" + paragens[k].getPubAbrigo() + "\'" + "," + "\'" + paragens[k].getOperadora() + "\'" + "," + readyCarreiras + "," + paragens[k].getCodRua()+ "," + "\'" + paragens[k].getNomeRua() + "\'" + ","
                        + "\'" + paragens[k].getFreguesia() + "\'" + ").\n";
                s = s.replaceAll("á", "a");
                s = s.replaceAll("à", "a");
                s = s.replaceAll("ã", "a");
                s = s.replaceAll("â", "a");
                s = s.replaceAll("é", "e");
                s = s.replaceAll("ê", "e");
                s = s.replaceAll("í", "i");
                s = s.replaceAll("ì", "i");
                s = s.replaceAll("ó", "o");
                s = s.replaceAll("Á", "A");
                s = s.replaceAll("À", "A");
                s = s.replaceAll("Ã", "A");
                s = s.replaceAll("Â", "A");
                s = s.replaceAll("É", "E");
                s = s.replaceAll("Ê", "E");
                s = s.replaceAll("Í", "I");
                s = s.replaceAll("Ì", "I");
                s = s.replaceAll("Ó", "O");
                s = s.replaceAll("ç", "c");
                writer.write(s);
        }
            StringBuilder listaI = new StringBuilder();
            listaI.append("grafo([");
            for(int id : listaIds)
                listaI.append(id + ",");
            listaI.append("],[");

            //##################################################################################

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
                FileOutputStream fosA = new FileOutputStream("Adj1.pl");
                BufferedWriter writerA = new BufferedWriter(new FileWriter("Adj1.pl"));
                int[] ficheirocsv = new int[] {1,2,6,7,10,11,12,13,15,23,101,102,106,108,111,112,114,115,116,117,119,122,125,129,158,162,171,184,201,467,468,470,471,479,714,748,750,751,776};
                int[] tam = new int[] {76,76,37,18,62,35,68,102,95,8,22,53,64,49,42,42,46,55,10,60,53,61,45,36,75,17,45,44,21,10,7,18,22,11,12,11,11,22,20};

                StringBuilder listaArestas= new StringBuilder(); //= new String[75+75+36+17+61+34+67+101+94+7+21+52+63+48+41+41+45+54+9+59+52+60+44+35+74+16+44+43+20+9+6+17+21+10+11+10+10+21+20];
                int lAdjInc = 0;
                int nrArestas = 0;
                for(int csvs=0;csvs<39;csvs++){

                    System.out.println(ficheirocsv[csvs]);
                    String csvFileA = "adjacencias_csv"+ficheirocsv[csvs]+".csv";
                    br = null;
                    cvsSplitBy = ";";
                    Paragem[] paragensA = new Paragem[809];
                    String adj[] = new String[tam[csvs]+1];
                    int carreira=0;
                    i = 0;
                    try {

                        br = new BufferedReader(new FileReader(csvFileA));
                        br.readLine();
                        int in=0;
                        System.out.println("\n");
                        while ((line = br.readLine()) != null) {

                            String[] componentes = line.split(cvsSplitBy);
                            adj[in]= componentes[0];

                            in++;

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

                    System.out.println("check\n");
                    StringBuilder ids = new StringBuilder();
                    StringBuilder arestas = new StringBuilder();


                    int d = 1;
                    String aux="";
                    for (String c : adj) {
                        if(d==1);
                            //   if (d < adj.length && k==0) arestas.append("aresta("+adj[k]+","+adj[k+1]+")");
                            //   if (d < adj.length && k!=0) arestas.append(",aresta("+adj[k]+","+adj[k+1]+")");
                        else{
                            if(d==2) {
                                ids.append("aresta("+aux+","+c+")"); nrArestas ++;}
                                listaI.append("aresta("+aux+","+c+")");
                            if(d!=2){
                                ids.append(",aresta("+aux+","+c+")"+ ","); nrArestas++;}
                                listaI.append(",aresta("+aux+","+c+")"+ ",");
                        }
                        d++;
                        aux=c;
                    }


                    System.out.println("Successfully wrote to the file.");
                }
            }
            catch (IOException e) {
                System.out.println("An error occurred.");
                e.printStackTrace();
            }


            //##################################################################################
            System.out.println("Chehuei cheguei chegando");
            listaI.append("]).");
            writer.write(listaI.toString());
            writer.close();
            System.out.println("Successfully wrote to the file.");
        } catch (IOException e) {
            System.out.println("An error occurred.");
            e.printStackTrace();
        }
    }

}
