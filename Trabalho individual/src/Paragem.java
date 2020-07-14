public class Paragem {
    int grid;
    String lat;
    String longi;
    String estado;
    String abrigo;
    String pubAbrigo;
    String operadora;
    String[] carreira;
    int codRua;
    String nomeRua;
    String freguesia;

    public  Paragem(int grid,String lat,String longi,String estado,String abrigo,String pubAbrigo,String operadora,String[] carreira,int codRua,String nomeRua,String freguesia){
        this.grid = grid;
        this.lat = lat;
        this.longi = longi;
        this.estado = estado;
        this.abrigo = abrigo;
        this.pubAbrigo = pubAbrigo;
        this.operadora = operadora;
        this.carreira = carreira;
        this.codRua = codRua;
        this.nomeRua = nomeRua;
        this.freguesia = freguesia;
    }

    public int getGrid() {
        return grid;
    }

    public String getLat() {
        return lat;
    }

    public int getCodRua() {
        return codRua;
    }

    public String getAbrigo() {
        return abrigo;
    }

    public String getEstado() {
        return estado;
    }

    public String getLongi() {
        return longi;
    }

    public String getOperadora() {
        return operadora;
    }

    public String getFreguesia() {
        return freguesia;
    }

    public String getPubAbrigo() {
        return pubAbrigo;
    }
    public String getNomeRua() {
        return nomeRua;
    }

    public String[] getCarreira() {
        return carreira;
    }
}
