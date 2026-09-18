import javax.swing.*;
import java.awt.*;
import java.beans.PropertyChangeEvent;
import java.beans.PropertyChangeListener;

public class MainView extends JFrame implements PropertyChangeListener {
    private CakeController cakeController;
    private JTextArea resultArea;
    private JButton btnInputData;

    public MainView() {
        setTitle("Калькулятор Тортиков");
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setSize(480, 380);
        setLayout(new BorderLayout(15, 15));

        resultArea = new JTextArea();
        resultArea.setEditable(false);
        resultArea.setFont(new Font("Segoe UI", Font.PLAIN, 14));
        resultArea.setMargin(new Insets(15, 15, 15, 15));
        resultArea.setText("Нажмите кнопку \"Ввести данные\" для расчета результатов.");

        btnInputData = new JButton("Ввести данные");
        btnInputData.setFont(new Font("Segoe UI", Font.BOLD, 14));
        btnInputData.setPreferredSize(new Dimension(180, 40));
        btnInputData.addActionListener(e -> {
            if (cakeController != null) {
                cakeController.openInputDialog(this);
            }
        });

        JPanel buttonPanel = new JPanel();
        buttonPanel.setBorder(BorderFactory.createEmptyBorder(0, 0, 15, 0));
        buttonPanel.add(btnInputData);

        add(new JScrollPane(resultArea), BorderLayout.CENTER);
        add(buttonPanel, BorderLayout.SOUTH);

        setLocationRelativeTo(null);
    }

    public void setController(CakeController cakeController) {
        this.cakeController = cakeController;
    }

    @Override
    public void propertyChange(PropertyChangeEvent evt) {
        if ("dataUpdated".equals(evt.getPropertyName())) {
            CigaretteModel model = (CigaretteModel) evt.getNewValue();

            String report = String.format(
                    "РЕЗУЛЬТАТЫ РАСЧЕТА:\n\n" +
                            "Смолы прошло через легкие: %.2f г.\n" +
                            "Никотина прошло через тело:  %.2f г.\n" +
                            "Всего потрачено денег:       %.2f руб.\n\n" +
                            "Вместо сигарет можно было купить:\n" +
                            " • Тортиков:  %.1f шт.\n" +
                            " • Апельсинов: %.1f шт.\n",
                    model.getTotalTarGrams(),
                    model.getTotalNicotineGrams(),
                    model.getTotalMoneySpent(),
                    model.getCakesCount(),
                    model.getOrangesCount()
            );

            resultArea.setText(report);
        }
    }
}