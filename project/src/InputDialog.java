import javax.swing.*;
import java.awt.*;

public class InputDialog extends JDialog {
    private JTextField txtCigarettes = new JTextField(10);
    private JTextField txtPackPrice = new JTextField(10);
    private JTextField txtTar = new JTextField(10);
    private JTextField txtNicotine = new JTextField(10);
    private JTextField txtYears = new JTextField(10);
    private JTextField txtCakePrice = new JTextField(10);
    private JTextField txtOrangePrice = new JTextField(10);

    private boolean confirmed = false;

    public InputDialog(Frame owner, CigaretteModel model) {
        super(owner, "Ввод данных", true);
        setLayout(new BorderLayout(10, 10));

        JPanel formPanel = new JPanel(new GridLayout(7, 2, 5, 5));
        formPanel.setBorder(BorderFactory.createEmptyBorder(10, 10, 10, 10));

        formPanel.add(new JLabel("Сигарет в день:"));
        formPanel.add(txtCigarettes);
        formPanel.add(new JLabel("Цена пачки (руб):"));
        formPanel.add(txtPackPrice);
        formPanel.add(new JLabel("Смола в сигарете (мг):"));
        formPanel.add(txtTar);
        formPanel.add(new JLabel("Никотин в сигарете (мг):"));
        formPanel.add(txtNicotine);
        formPanel.add(new JLabel("Стаж курения (лет):"));
        formPanel.add(txtYears);
        formPanel.add(new JLabel("Цена одного тортика (руб):"));
        formPanel.add(txtCakePrice);
        formPanel.add(new JLabel("Цена одного апельсина (руб):"));
        formPanel.add(txtOrangePrice);

        if (model.getCigarettesPerDay() > 0) {
            txtCigarettes.setText(String.valueOf(model.getCigarettesPerDay()));
            txtPackPrice.setText(String.valueOf(model.getPackPrice()));
            txtTar.setText(String.valueOf(model.getTarMg()));
            txtNicotine.setText(String.valueOf(model.getNicotineMg()));
            txtYears.setText(String.valueOf(model.getYearsSmoking()));
            txtCakePrice.setText(String.valueOf(model.getCakePrice()));
            txtOrangePrice.setText(String.valueOf(model.getOrangePrice()));
        }

        JButton btnSave = new JButton("Рассчитать");
        btnSave.addActionListener(e -> onSave());

        JButton btnCancel = new JButton("Отмена");
        btnCancel.addActionListener(e -> dispose());

        JPanel buttonPanel = new JPanel();
        buttonPanel.add(btnSave);
        buttonPanel.add(btnCancel);

        add(formPanel, BorderLayout.CENTER);
        add(buttonPanel, BorderLayout.SOUTH);
        pack();
        setLocationRelativeTo(owner);
    }

    private void onSave() {
        try {
            int cigarettes = Integer.parseInt(txtCigarettes.getText().trim());
            double packPrice = Double.parseDouble(txtPackPrice.getText().trim());
            double tar = Double.parseDouble(txtTar.getText().trim());
            double nicotine = Double.parseDouble(txtNicotine.getText().trim());
            double years = Double.parseDouble(txtYears.getText().trim());
            double cakePrice = Double.parseDouble(txtCakePrice.getText().trim());
            double orangePrice = Double.parseDouble(txtOrangePrice.getText().trim());

            if (cigarettes < 0 || packPrice < 0 || tar < 0 || nicotine < 0 || years < 0 || cakePrice <= 0 || orangePrice <= 0) {
                throw new IllegalArgumentException("Значения должны быть положительными!");
            }

            confirmed = true;
            dispose();
        } catch (Exception ex) {
            JOptionPane.showMessageDialog(this,
                    "Некорректные данные! Пожалуйста, проверьте правильность введенных чисел.",
                    "Ошибка ввода",
                    JOptionPane.ERROR_MESSAGE);
        }
    }

    public boolean isConfirmed() { return confirmed; }
    public int getCigarettes() { return Integer.parseInt(txtCigarettes.getText().trim()); }
    public double getPackPrice() { return Double.parseDouble(txtPackPrice.getText().trim()); }
    public double getTar() { return Double.parseDouble(txtTar.getText().trim()); }
    public double getNicotine() { return Double.parseDouble(txtNicotine.getText().trim()); }
    public double getYears() { return Double.parseDouble(txtYears.getText().trim()); }
    public double getCakePrice() { return Double.parseDouble(txtCakePrice.getText().trim()); }
    public double getOrangePrice() { return Double.parseDouble(txtOrangePrice.getText().trim()); }
}