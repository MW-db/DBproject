package client.core;

import javafx.application.Platform;
import javafx.beans.property.ReadOnlyStringWrapper;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.scene.control.*;
import javafx.scene.layout.StackPane;

public class GUIController {

    private Listener clientListener;
    private Client client;

    //---------LOGIN PAGE-------------
    @FXML
    private StackPane loginPage;
    @FXML
    private Button loginButton;
    @FXML
    private Button exitButton;
    @FXML
    private TextField loginTextField;
    @FXML
    private PasswordField passwordTextField;


    //---------OWNER PAGE-------------
    @FXML
    private StackPane ownerPage;
    @FXML
    private Label ownerDateLabel;
    @FXML
    private Label incomeLabel;
    @FXML
    private Label expenseLabel;
    @FXML
    private Label balanceLabel;
    @FXML
    private Label otherStatusLabel;
    @FXML
    private Label drinkStatusLabel;
    @FXML
    private Label foodStatusLabel;
    @FXML
    private Button removeClientButton;
    @FXML
    private Button addClientButton;
    @FXML
    private Button removeWorkerButton;
    @FXML
    private Button addWorkerButton;
    @FXML
    private Button nextDayButton;
    @FXML
    private Button manageFinanceButton;
    @FXML
    private Button clearButton;
    @FXML
    private Button refreshButton;
    @FXML
    private Button createDeliveryButton;
    @FXML
    private Button cancelDeliveryButton;
    @FXML
    private Button receiveDeliveryButton;
    @FXML
    private Button ownerExitButton;
    @FXML
    private TableView<String> clientsTable;
    @FXML
    private TableView<String> workersTable;
    @FXML
    private TableView<String> infoTable;
    @FXML
    private TableView<String> deliveryWaitingTable;
    @FXML
    private TableView<String> deliveryIncomingTable;
    @FXML
    private TableColumn<String, String> workersColumn;
    @FXML
    private TableColumn<String, String> deliveryWaitingColumn;
    @FXML
    private TableColumn<String, String> clientsColumn;
    @FXML
    private TableColumn<String, String> deliveryIncomingColumn;
    @FXML
    private TableColumn<String, String> infoColumn;

    //---------WORKER PAGE-------------

    @FXML
    private StackPane workerPage;
    @FXML
    private Label workerDateLabel;
    @FXML
    private Label workerIncomeLabel;
    @FXML
    private Label workerExpensesLabel;
    @FXML
    private Label workerBalanceLabel;
    @FXML
    private Label workerFoodStatusLabel;
    @FXML
    private Label workerDrinkStatusLabel;
    @FXML
    private Label workerOtherStatusLabel;
    @FXML
    private Button workerExitButton;
    @FXML
    private Button workerAcceptOrderButton;
    @FXML
    private Button workerDeclineOrderButton;
    @FXML
    private Button workerReceiveDeliveryButton;
    @FXML
    private Button workerCreateDeliveryButton;
    @FXML
    private TableView<String> clientsOrderListTable;
    @FXML
    private TableView<String> waitingDeliveryTable;
    @FXML
    private TableView<String> goingDeliveryTable;
    @FXML
    private TableColumn<String, String> clientsOrderListColumn;
    @FXML
    private TableColumn<String, String> waitingDeliveryColumn;
    @FXML
    private TableColumn<String, String> goingDeliveryColumn;



    //---------CLIENT PAGE-------------

    @FXML
    private StackPane clientPage;
    @FXML
    private Label clientDateLabel;
    @FXML
    private Label summaryLabel;
    @FXML
    private Label walletLabel;
    @FXML
    private Button filtrButton;
    @FXML
    private Button clientRefreshButton;
    @FXML
    private Button payButton;
    @FXML
    private Button addBalanceButton;
    @FXML
    private Button addProductButton;
    @FXML
    private Button removeProductButton;
    @FXML
    private Button cancelOrderButton;
    @FXML
    private Button checkPreviousTransactionButton;
    @FXML
    private Button clientExitButton;
    @FXML
    private TableView<String> productsListTable;
    @FXML
    private TableView<String> cartTable;
    @FXML
    private TableView<String> previousTransactionTable;
    @FXML
    private TableColumn<String, String> productsListColumn;
    @FXML
    private TableColumn<String, String> cartColumn;
    @FXML
    private TableColumn<String, String> previousTransactionColumn;
    @FXML
    private CheckBox foodCheckBox;
    @FXML
    private CheckBox drinksCheckBox;
    @FXML
    private CheckBox otherCheckBox;


    //====== OWNER OBSERVABLE =======
    private ObservableList<String> workers;
    private ObservableList<String> clients;
    private ObservableList<String> deliveryInc;
    private ObservableList<String> deliveryWait;
    private ObservableList<String> info;

    //====== WORKER OBSERVABLE =======
    private ObservableList<String> workerClOrder;
    private ObservableList<String> workerDeliveryInc;
    private ObservableList<String> workerDeliveryWait;

    //====== CLIENT OBSERVABLE =======
    private ObservableList<String> prevTrans;
    private ObservableList<String> productList;
    private ObservableList<String> cart;


    @FXML
    void initialize() {
        //OWNER TABLE
        clients = FXCollections.observableArrayList();
        clientsColumn.setCellValueFactory(param -> new ReadOnlyStringWrapper(param.getValue()));
        clientsTable.setItems(clients);

        workers = FXCollections.observableArrayList();
        workersColumn.setCellValueFactory(param -> new ReadOnlyStringWrapper(param.getValue()));
        workersTable.setItems(workers);

        deliveryWait = FXCollections.observableArrayList();
        deliveryWaitingColumn.setCellValueFactory(param -> new ReadOnlyStringWrapper(param.getValue()));
        deliveryWaitingTable.setItems(deliveryWait);

        deliveryInc = FXCollections.observableArrayList();
        deliveryIncomingColumn.setCellValueFactory(param -> new ReadOnlyStringWrapper(param.getValue()));
        deliveryIncomingTable.setItems(deliveryInc);

        info = FXCollections.observableArrayList();
        infoColumn.setCellValueFactory(param -> new ReadOnlyStringWrapper(param.getValue()));
        infoTable.setItems(info);


        //WORKER TABLE
        workerClOrder = FXCollections.observableArrayList();
        clientsOrderListColumn.setCellValueFactory(param -> new ReadOnlyStringWrapper(param.getValue()));
        clientsOrderListTable.setItems(workerClOrder);

        workerDeliveryInc = FXCollections.observableArrayList();
        goingDeliveryColumn.setCellValueFactory(param -> new ReadOnlyStringWrapper(param.getValue()));
        goingDeliveryTable.setItems(workerDeliveryInc);

        workerDeliveryWait = FXCollections.observableArrayList();
        waitingDeliveryColumn.setCellValueFactory(param -> new ReadOnlyStringWrapper(param.getValue()));
        waitingDeliveryTable.setItems(workerDeliveryWait);


        //CLIENT TABLE
        prevTrans = FXCollections.observableArrayList();
        previousTransactionColumn.setCellValueFactory(param -> new ReadOnlyStringWrapper(param.getValue()));
        previousTransactionTable.setItems(prevTrans);

        productList = FXCollections.observableArrayList();
        productsListColumn.setCellValueFactory(param -> new ReadOnlyStringWrapper(param.getValue()));
        productsListTable.setItems(productList);

        cart = FXCollections.observableArrayList();
        cartColumn.setCellValueFactory(param -> new ReadOnlyStringWrapper(param.getValue()));
        cartTable.setItems(cart);
    }



    //---------EXIT BUTTON-------------

    public void exitOnClick(ActionEvent event) {
        Platform.exit();
    }



    //========= LOGIN ACTIONS =============

    public void loginOnClick(ActionEvent event) {
        this.loginPage.setVisible(false);
        this.loginPage.setDisable(true);

        //test method invoking
            Object  opParams[] = {client.pid};
            String  opSig[] = {int.class.getName()};
            client.connection.invokeMethod(client.factory, "testConnection", opParams, opSig);
        //end test

        if(!loginTextField.getText().equals("")) {
            this.ownerPage.setVisible(true);
            this.ownerPage.setDisable(false);
        } else {
            this.workerPage.setVisible(true);
            this.workerPage.setDisable(false);
        }
    }



    //========= OWNER ACTIONS =============

    public void addWorkerOnClick(ActionEvent event) {
        String[] list = {"worker1", "worker2", "worker3", "worker4", "worker5"};
        run(() -> {
            workers.setAll(list);
            workersTable.setItems(workers);
        });
    }

    public void removeWorkerOnClick(ActionEvent event) {

    }

    public void addClientOnClick(ActionEvent event) {
        String[] list = {"client1", "client2", "client13"};
        run(() -> {
            clients.setAll(list);
            clientsTable.setItems(clients);
        });
    }

    public void removeClientOnClick(ActionEvent event) {

    }

    public void manageFinanceOnClick(ActionEvent event) {

    }

    public void createDeliveryOnClick(ActionEvent event) {

    }

    public void cancelDeliveryOnClick(ActionEvent event) {

    }

    public void receiveDeliveryOnClick(ActionEvent event) {

    }

    public void refreshOnClick(ActionEvent event) {

    }

    public void clearOnClick(ActionEvent event) {

    }

    public void nextDayOnClick(ActionEvent event) {

    }





    //========= WORKER ACTIONS =============

    public void workerAcceptOrderOnClick(ActionEvent event) {

    }

    public void workerDeclineOrderOnClick(ActionEvent event) {

    }

    public void workerReceiveDeliveryOnClick(ActionEvent event) {

    }

    public void workerCreateDeliveryOnClick(ActionEvent event) {

    }




    //========= CLIENT ACTIONS =============

    public void filtrOnClick(ActionEvent event) {

    }

    public void clientRefreshOnClick(ActionEvent event) {

    }

    public void payOnClick(ActionEvent event) {

    }

    public void addBalanceOnClick(ActionEvent event) {

    }

    public void addProductOnClick(ActionEvent event) {

    }

    public void removeProductOnClick(ActionEvent event) {

    }

    public void cancelOrderOnClick(ActionEvent event) {

    }

    public void checkPreviousTransactionOnClick(ActionEvent event) {

    }

    public void clientExitButton(ActionEvent event) {

    }

    public void changeFoodFiltrOnAction(ActionEvent event) {

    }

    public void changeDrinkFiltrOnAction(ActionEvent event) {

    }

    public void changeOtherFiltrOnAction(ActionEvent event) {

    }



    //OTHERS------------------------------------------------

    public static void run(Runnable treatment) {
        if(treatment == null) throw new IllegalArgumentException("The treatment to perform can not be null");
        if(Platform.isFxApplicationThread()) treatment.run();
        else Platform.runLater(treatment);
    }

    public GUIController(Client client) {
        this.client = client;
    }

    public void setListener(Listener clientListener) {
        this.clientListener = clientListener;
    }
}
