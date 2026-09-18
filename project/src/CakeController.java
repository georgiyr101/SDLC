class CakeController {
    private CigaretteModel model;

    public CakeController(CigaretteModel model) {
        this.model = model;
    }

    public void openInputDialog(MainView view) {
        InputDialog dialog = new InputDialog(view, model);
        dialog.setVisible(true);

        if (dialog.isConfirmed()) {
            model.setData(
                    dialog.getCigarettes(),
                    dialog.getPackPrice(),
                    dialog.getTar(),
                    dialog.getNicotine(),
                    dialog.getYears(),
                    dialog.getCakePrice(),
                    dialog.getOrangePrice()
            );
        }
    }
}