package client.templates;

import javafx.beans.property.SimpleStringProperty;

public class SixStringClassForTable {
    private final SimpleStringProperty name;
    private final SimpleStringProperty amount;
    private final SimpleStringProperty stdPrice;
    private final SimpleStringProperty salesPrice;
    private final SimpleStringProperty dateFrom;
    private final SimpleStringProperty dateTo;

    public SixStringClassForTable(String name, String amount, String stdPrice, String salesPrice, String dateFrom, String dateTo) {
        this.name = new SimpleStringProperty(name);
        this.amount = new SimpleStringProperty(amount);
        this.stdPrice = new SimpleStringProperty(stdPrice);
        this.salesPrice = new SimpleStringProperty(salesPrice);
        this.dateFrom = new SimpleStringProperty(dateFrom);
        this.dateTo = new SimpleStringProperty(dateTo);
    }

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

    public String getStdPrice() {
        return stdPrice.get();
    }

    public SimpleStringProperty stdPriceProperty() {
        return stdPrice;
    }

    public void setStdPrice(String stdPrice) {
        this.stdPrice.set(stdPrice);
    }

    public String getSalesPrice() {
        return salesPrice.get();
    }

    public SimpleStringProperty salesPriceProperty() {
        return salesPrice;
    }

    public void setSalesPrice(String salesPrice) {
        this.salesPrice.set(salesPrice);
    }

    public String getDateFrom() {
        return dateFrom.get();
    }

    public SimpleStringProperty dateFromProperty() {
        return dateFrom;
    }

    public void setDateFrom(String dateFrom) {
        this.dateFrom.set(dateFrom);
    }

    public String getDateTo() {
        return dateTo.get();
    }

    public SimpleStringProperty dateToProperty() {
        return dateTo;
    }

    public void setDateTo(String dateTo) {
        this.dateTo.set(dateTo);
    }
}
