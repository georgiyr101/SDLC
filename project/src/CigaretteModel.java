import java.beans.PropertyChangeListener;
import java.beans.PropertyChangeSupport;

public class CigaretteModel {
    private final PropertyChangeSupport pcs = new PropertyChangeSupport(this);

    private int cigarettesPerDay;
    private double packPrice;
    private double tarMg;
    private double nicotineMg;
    private double yearsSmoking;
    private double cakePrice;
    private double orangePrice;
    private double totalTarGrams;
    private double totalNicotineGrams;
    private double totalMoneySpent;
    private double cakesCount;
    private double orangesCount;

    public void addPropertyChangeListener(PropertyChangeListener listener) {
        pcs.addPropertyChangeListener(listener);
    }

    public void removePropertyChangeListener(PropertyChangeListener listener) {
        pcs.removePropertyChangeListener(listener);
    }

    public void setData(int cigarettesPerDay, double packPrice, double tarMg,
                        double nicotineMg, double yearsSmoking, double cakePrice, double orangePrice) {
        this.cigarettesPerDay = cigarettesPerDay;
        this.packPrice = packPrice;
        this.tarMg = tarMg;
        this.nicotineMg = nicotineMg;
        this.yearsSmoking = yearsSmoking;
        this.cakePrice = cakePrice;
        this.orangePrice = orangePrice;

        calculate();

        pcs.firePropertyChange("dataUpdated", null, this);
    }

    private void calculate() {
        double totalDays = yearsSmoking * 365.25;
        double totalCigarettes = cigarettesPerDay * totalDays;

        double totalPacks = totalCigarettes / 20.0;
        this.totalMoneySpent = totalPacks * packPrice;

        this.totalTarGrams = (totalCigarettes * tarMg) / 1000.0;
        this.totalNicotineGrams = (totalCigarettes * nicotineMg) / 1000.0;

        this.cakesCount = cakePrice > 0 ? totalMoneySpent / cakePrice : 0;
        this.orangesCount = orangePrice > 0 ? totalMoneySpent / orangePrice : 0;
    }

    public int getCigarettesPerDay() { return cigarettesPerDay; }
    public double getPackPrice() { return packPrice; }
    public double getTarMg() { return tarMg; }
    public double getNicotineMg() { return nicotineMg; }
    public double getYearsSmoking() { return yearsSmoking; }
    public double getCakePrice() { return cakePrice; }
    public double getOrangePrice() { return orangePrice; }

    public double getTotalTarGrams() { return totalTarGrams; }
    public double getTotalNicotineGrams() { return totalNicotineGrams; }
    public double getTotalMoneySpent() { return totalMoneySpent; }
    public double getCakesCount() { return cakesCount; }
    public double getOrangesCount() { return orangesCount; }
}