package client.templates;

import javafx.beans.property.SimpleStringProperty;

public class ThreeStringClassForTable {
    private final SimpleStringProperty name;
    private final SimpleStringProperty amount;
    private final SimpleStringProperty capacity;

    public String getName() {
        return name.get();
    }

    public SimpleStringProperty nameProperty() {
        return name;
    }

    public void setName(String name) {
        this.name.set(name);
    }

    public String getAmount() {
        return amount.get();
    }

    public SimpleStringProperty amountProperty() {
        return amount;
    }

    public void setAmount(String amount) {
        this.amount.set(amount);
    }

    public String getCapacity() {
        return capacity.get();
    }

    public SimpleStringProperty capacityProperty() {
        return capacity;
    }

    public void setCapacity(String capacity) {
        this.capacity.set(capacity);
    }

    public ThreeStringClassForTable(String name, String amount, String capacity) {

        this.name = new SimpleStringProperty(name);
        this.amount = new SimpleStringProperty(amount);
        this.capacity = new SimpleStringProperty(capacity);
    }
}
