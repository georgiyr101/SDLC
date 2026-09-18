import javax.swing.*;

public class Main {
    public static void main(String[] args) {
        SwingUtilities.invokeLater(() -> {
            CigaretteModel model = new CigaretteModel();
            MainView view = new MainView();
            CakeController cakeController = new CakeController(model);

            model.addPropertyChangeListener(view);
            view.setController(cakeController);

            view.setVisible(true);
        });
    }
}