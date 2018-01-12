package client.core;

import client.templates.SixStringClassForTable;
import client.templates.ThreeStringClassForTable;
import javafx.application.Platform;
import javafx.beans.property.ReadOnlyStringWrapper;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.scene.control.*;
import javafx.scene.control.cell.PropertyValueFactory;
import javafx.scene.layout.StackPane;

public class GUIController {

    private Listener clientListener;
    public Client client;
    public String user = "Worker";
    private String productType = "Food";

    //---------LOGIN PAGE-------------
    @FXML
    private StackPane loginPage;
    @FXML
    private ComboBox<String> userComboBox;
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
    private Button dumpDBButton;
    @FXML
    private Button restoreDBButton;
    @FXML
    private Button createSalesButton;
    @FXML
    private Button createProductButton;
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
    public TableView<String> clientsTable;
    @FXML
    public TableView<String> workersTable;
    @FXML
    public TableView<String> infoTable;
    @FXML
    public TableView<String> deliveryWaitingTable;
    @FXML
    public TableView<String> deliveryIncomingTable;
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
    private TableView<ThreeStringClassForTable> clientsOrderListTable;
    @FXML
    private TableView<String> waitingDeliveryTable;
    @FXML
    private TableView<String> goingDeliveryTable;
    @FXML
    private TableColumn clientsOrderListColumn;
    @FXML
    private TableColumn clientsOrderPriceColumn;
    @FXML
    private TableColumn clientsOrderDateColumn;
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

    //---------ADD BALANCE PAGE-------------
    @FXML
    private StackPane addBalancePage;
    @FXML
    private DialogPane addBalanceDialogPane;
    @FXML
    private Button addBalanceAcceptButton;
    @FXML
    private Button addBalanceCancelButton;
    @FXML
    private TextField clientAddBalanceTextField;



    //---------CREATE DELIVERY PAGE-------------

    @FXML
    private StackPane createDeliveryPage;
    @FXML
    private Label createDeliverySumLabel;
    @FXML
    private Button createDeliveryAddProductButton;
    @FXML
    private Button createDeliveryRemoveProductButton;
    @FXML
    private Button createDeliveryOrderButton;
    @FXML
    private Button createDeliveryCancelButton;
    @FXML
    private TableView<ThreeStringClassForTable> createDeliveryProductList;
    @FXML
    private TableView<ThreeStringClassForTable> createDeliveryCartList;
    @FXML
    private TableColumn createDeliveryProductListName;
    @FXML
    private TableColumn createDeliveryProductListAmount;
    @FXML
    private TableColumn createDeliveryProductListCapacity;
    @FXML
    private TableColumn createDeliveryCartListName;
    @FXML
    private TableColumn createDeliveryCartListAmount;
    @FXML
    private TableColumn createDeliveryCartListPrice;



    //---------CREATE SALES PAGE-------------

    @FXML
    private StackPane manageSalesPage;
    @FXML
    private Button createSalesAddSalesButton;
    @FXML
    private Button createSalesRemoveSalesButton;
    @FXML
    private Button createSalesCancelButton;
    @FXML
    private TextField createSalesNewPriceTextField;
    @FXML
    private DatePicker createSalesDateFromPicker;
    @FXML
    private DatePicker createSalesDateToPicker;
    @FXML
    private TableView<SixStringClassForTable> createSalesTable;
    @FXML
    private TableColumn createSalesNameColumn;
    @FXML
    private TableColumn createSalesAmountColumn;
    @FXML
    private TableColumn createSalesStdPriceColumn;
    @FXML
    private TableColumn createSalesSalesPriceColumn;
    @FXML
    private TableColumn createSalesDateFromColumn;
    @FXML
    private TableColumn createSalesDateToColumn;



    //---------CREATE PRODUCT PAGE-------------

    @FXML
    private StackPane createProductPage;
    @FXML
    private Button createProductAddButton;
    @FXML
    private Button createProductCancelButton;
    @FXML
    private TextField createProductNameTextField;
    @FXML
    private TextField createProductPriceTextField;
    @FXML
    private ComboBox<String> productTypeComboBox;



    //---------REGISTRY WORKER PAGE-------------

    @FXML
    private StackPane registryWorkerPage;
    @FXML
    private Button registryWorkerRegistryButton;
    @FXML
    private Button registryWorkerCancelButton;
    @FXML
    private TextField registryWorkerPassTextField;
    @FXML
    private TextField registryWorkerNameTextField;
    @FXML
    private TextField registryWorkerSurnameTextField;
    @FXML
    private TextField registryWorkerPeselTextField;
    @FXML
    private TextField registryWorkerPhoneTextField;
    @FXML
    private TextField registryWorkerSalaryTextField;
    @FXML
    private DatePicker registryWorkerDateFromPicker;
    @FXML
    private DatePicker registryWorkerDateToPicker;




    //---------REGISTRY CLIENT PAGE-------------

    @FXML
    private StackPane registryClientPage;
    @FXML
    private Button registryClientRegistryButton;
    @FXML
    private Button registryClientcancelButton;
    @FXML
    private TextField registryClientLoginTextField;
    @FXML
    private TextField registryClientPassTextField;
    @FXML
    private TextField registryClientNameTextField;
    @FXML
    private TextField registryClientSurnameTextField;
    @FXML
    private TextField registryClientCompanyTextField;
    @FXML
    private TextField registryClientphoneTextField;
    @FXML
    private TextField registryClientAdressTextField;




    //====== OWNER OBSERVABLE =======
    public ObservableList<String> workers;
    public ObservableList<String> clients;
    public ObservableList<String> deliveryInc;
    public ObservableList<String> deliveryWait;
    public ObservableList<String> info;

    //====== WORKER OBSERVABLE =======
    public ObservableList<ThreeStringClassForTable> workerClOrder;
    public ObservableList<String> workerDeliveryInc;
    public ObservableList<String> workerDeliveryWait;

    //====== CLIENT OBSERVABLE =======
    public ObservableList<String> prevTrans;
    public ObservableList<String> productList;
    public ObservableList<String> cart;

    //====== CREATE DELIVERY OBSERVABLE =======
    public ObservableList<ThreeStringClassForTable> createDeliveryProduct;
    public ObservableList<ThreeStringClassForTable> createDeliveryCart;

    //====== CREATE SALES OBSERVABLE =======
    public ObservableList<SixStringClassForTable> createSalesProduct;



    @FXML
    void initialize() {
        run(() -> {
            userComboBox.getItems().setAll("Owner", "Worker", "Client");
            userComboBox.setValue("Worker");
            userComboBox.setOnAction((ActionEvent ev) -> {
                user = userComboBox.getSelectionModel().getSelectedItem().toString();
            });
        });

        run(() -> {
            productTypeComboBox.getItems().setAll("Food", "Drink", "Other");
            productTypeComboBox.setValue("Food");
            productTypeComboBox.setOnAction((ActionEvent ev) -> {
                productType = productTypeComboBox.getSelectionModel().getSelectedItem().toString();
            });
        });


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
        clientsOrderListColumn.setCellValueFactory(new PropertyValueFactory<>("Order"));
        clientsOrderPriceColumn.setCellValueFactory(new PropertyValueFactory<>("Price"));
        clientsOrderDateColumn.setCellValueFactory(new PropertyValueFactory<>("Date"));
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


        //CREATE DELIVERY TABLE
        createDeliveryProduct = FXCollections.observableArrayList();
        createDeliveryProductListName.setCellValueFactory(new PropertyValueFactory<>("Name"));
        createDeliveryProductListAmount.setCellValueFactory(new PropertyValueFactory<>("Amount"));
        createDeliveryProductListCapacity.setCellValueFactory(new PropertyValueFactory<>("Capacity"));
        createDeliveryProductList.setItems(createDeliveryProduct);

        createDeliveryCart = FXCollections.observableArrayList();
        createDeliveryCartListName.setCellValueFactory(new PropertyValueFactory<>("Name"));
        createDeliveryCartListAmount.setCellValueFactory(new PropertyValueFactory<>("Amount"));
        createDeliveryCartListPrice.setCellValueFactory(new PropertyValueFactory<>("Price"));
        createDeliveryCartList.setItems(createDeliveryCart);

        //CREATE SALES TABLE
        createSalesProduct = FXCollections.observableArrayList();
        createSalesNameColumn.setCellValueFactory(new PropertyValueFactory<>("Name"));
        createSalesAmountColumn.setCellValueFactory(new PropertyValueFactory<>("Amount"));
        createSalesStdPriceColumn.setCellValueFactory(new PropertyValueFactory<>("Standard price"));
        createSalesSalesPriceColumn.setCellValueFactory(new PropertyValueFactory<>("Sales price"));
        createSalesDateFromColumn.setCellValueFactory(new PropertyValueFactory<>("Date from"));
        createSalesDateToColumn.setCellValueFactory(new PropertyValueFactory<>("Date to"));
        createSalesTable.setItems(createSalesProduct);

    }



    //---------EXIT BUTTON-------------

    public void exitOnClick(ActionEvent event) {
        Platform.exit();
    }



    //========= LOGIN ACTIONS =============

    public void loginOnClick(ActionEvent event) {
        Object  opParams[] = {client.pid, user, loginTextField.getText(), passwordTextField.getText()};
        String  opSig[] = {int.class.getName(), String.class.getName(), String.class.getName(), String.class.getName()};
        client.connection.invokeMethod(client.factory, "createUser", opParams, opSig);
    }

    public void changeViewAfterLogin() {
        this.loginPage.setVisible(false);
        this.loginPage.setDisable(true);
        if (user.equals("Owner")) {
            this.ownerPage.setVisible(true);
            this.ownerPage.setDisable(false);
        } else if (user.equals("Worker")) {
            this.workerPage.setVisible(true);
            this.workerPage.setDisable(false);
        }  else if (user.equals("Client")) {
            this.clientPage.setVisible(true);
            this.clientPage.setDisable(false);
        }
    }



    //========= OWNER ACTIONS =============

    public void addWorkerOnClick(ActionEvent event) {
        this.ownerPage.setVisible(false);
        this.ownerPage.setDisable(true);

        this.registryWorkerPage.setVisible(true);
        this.registryWorkerPage.setDisable(false);
    }

    public void removeWorkerOnClick(ActionEvent event) {
        String str = workersTable.getSelectionModel().getSelectedItem();
        Object  opParams[] = {str};
        String  opSig[] = {String.class.getName()};
        client.connection.invokeMethod(client.ownerObj, "removeWorker", opParams, opSig);
    }

    public void addClientOnClick(ActionEvent event) {
        this.ownerPage.setVisible(false);
        this.ownerPage.setDisable(true);

        this.registryClientPage.setVisible(true);
        this.registryClientPage.setDisable(false);
    }

    public void removeClientOnClick(ActionEvent event) {
        String str = clientsTable.getSelectionModel().getSelectedItem();
        Object  opParams[] = {str};
        String  opSig[] = {String.class.getName()};
        client.connection.invokeMethod(client.ownerObj, "removeClient", opParams, opSig);
    }

    public void dumpDbOnClick(ActionEvent event) {
        Object  opParams[] = {};
        String  opSig[] = {};
        client.connection.invokeMethod(client.ownerObj, "backupDB", opParams, opSig);
    }

    public void restoreDBOnClick(ActionEvent event) {
        Object  opParams[] = {};
        String  opSig[] = {};
        client.connection.invokeMethod(client.ownerObj, "restoreDB", opParams, opSig);
    }

    public void createSalesOnClick(ActionEvent event) {
        this.ownerPage.setVisible(false);
        this.ownerPage.setDisable(true);

        this.manageSalesPage.setVisible(true);
        this.manageSalesPage.setDisable(false);
    }

    public void createProductonClick(ActionEvent event) {
        this.ownerPage.setVisible(false);
        this.ownerPage.setDisable(true);

        this.createProductPage.setVisible(true);
        this.createProductPage.setDisable(false);
    }

    public void createDeliveryOnClick(ActionEvent event) {
        this.ownerPage.setVisible(false);
        this.ownerPage.setDisable(true);

        this.createDeliveryPage.setVisible(true);
        this.createDeliveryPage.setDisable(false);
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

    public void fillWorkerTable() {

    }





    //========= WORKER ACTIONS =============

    public void workerAcceptOrderOnClick(ActionEvent event) {

    }

    public void workerDeclineOrderOnClick(ActionEvent event) {

    }

    public void workerReceiveDeliveryOnClick(ActionEvent event) {

    }

    public void workerCreateDeliveryOnClick(ActionEvent event) {
        this.workerPage.setVisible(false);
        this.workerPage.setDisable(true);

        this.createDeliveryPage.setVisible(true);
        this.createDeliveryPage.setDisable(false);
    }




    //========= CLIENT ACTIONS =============

    public void filtrOnClick(ActionEvent event) {

    }

    public void clientRefreshOnClick(ActionEvent event) {

    }

    public void payOnClick(ActionEvent event) {

    }

    public void addBalanceOnClick(ActionEvent event) {
        this.clientPage.setDisable(true);
        this.addBalancePage.setVisible(true);
        this.addBalancePage.setDisable(false);
    }

    public void addProductOnClick(ActionEvent event) {

    }

    public void removeProductOnClick(ActionEvent event) {

    }

    public void cancelOrderOnClick(ActionEvent event) {

    }

    public void checkPreviousTransactionOnClick(ActionEvent event) {

    }

    public void changeFoodFiltrOnAction(ActionEvent event) {

    }

    public void changeDrinkFiltrOnAction(ActionEvent event) {

    }

    public void changeOtherFiltrOnAction(ActionEvent event) {

    }



    //========= ADD BALANCE ACTIONS =============

    public void addBalanceAcceptOnClick(ActionEvent event) {
        this.addBalancePage.setVisible(false);
        this.addBalancePage.setDisable(true);
        this.clientPage.setVisible(true);
        this.clientPage.setDisable(false);
    }

    public void addBalanceCancelOnClick(ActionEvent event) {
        this.addBalancePage.setVisible(false);
        this.addBalancePage.setDisable(true);
        this.clientPage.setVisible(true);
        this.clientPage.setDisable(false);
    }





    //========= CREATE DELIVERY ACTIONS =============

    public void createDeliveryAddProductOnClick(ActionEvent event) {

    }

    public void createDeliveryOrderOnClick(ActionEvent event) {
        this.createDeliveryPage.setVisible(false);
        this.createDeliveryPage.setDisable(true);

        backFromDeliveryPage();
    }

    public void createDeliveryRemoveProductOnClick(ActionEvent event) {

    }

    public void createDeliveryCancelOnClick(ActionEvent event) {
        this.createDeliveryPage.setVisible(false);
        this.createDeliveryPage.setDisable(true);

        backFromDeliveryPage();
    }

    private void backFromDeliveryPage() {
        if (user.equals("Worker")) {
            this.workerPage.setVisible(true);
            this.workerPage.setDisable(false);
        } else if (user.equals("Owner")) {
            this.ownerPage.setVisible(true);
            this.ownerPage.setDisable(false);
        }
    }




    //========= MANAGE SALES ACTIONS =============

    public void createSalesAddSalesonClick(ActionEvent event) {

    }

    public void createSalesRemoveSalesOnClick(ActionEvent event) {

    }

    public void createSalesCancelOnClick(ActionEvent event) {
        this.manageSalesPage.setVisible(false);
        this.manageSalesPage.setDisable(true);

        this.ownerPage.setVisible(true);
        this.ownerPage.setDisable(false);
    }





    //========= CREATE PRODUCT ACTIONS =============

    public void createProductAddOnClick(ActionEvent event) {

    }

    public void createProductCancelOnClick(ActionEvent event) {
        this.createProductPage.setVisible(false);
        this.createProductPage.setDisable(true);

        this.ownerPage.setVisible(true);
        this.ownerPage.setDisable(false);
    }





    //========= REGISTRY WORKER ACTIONS =============

    public void registryWorkerRegistryOnClick(ActionEvent event) {
        regWorkerBackToOwnerPage();
    }

    public void registryWorkerCancelOnClick(ActionEvent event) {
        regWorkerBackToOwnerPage();
    }

    private void regWorkerBackToOwnerPage() {
        this.registryWorkerPage.setVisible(false);
        this.registryWorkerPage.setDisable(true);

        this.ownerPage.setVisible(true);
        this.ownerPage.setDisable(false);
    }





    //========= REGISTRY CLIENT ACTIONS =============

    public void registryClientRegistryOnClick(ActionEvent event) {
        regClientBackToOwnerPage();
    }

    public void registryClientCancelOnClick(ActionEvent event) {
        regClientBackToOwnerPage();
    }

    private void regClientBackToOwnerPage() {
        this.registryClientPage.setVisible(false);
        this.registryClientPage.setDisable(true);

        this.ownerPage.setVisible(true);
        this.ownerPage.setDisable(false);
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


    //=================== EXAMPLES ======================================
    /*
        Get clicked element from table

        ThreeStringClassForTable tStr = createDeliveryProductList.getSelectionModel().getSelectedItem();
        System.out.println(tStr.getName() + " " + tStr.getAmount() + " " + tStr.getCapacity());
    */

    /*
        Add element into multi-column table

        run(() -> {
            createDeliveryProduct.add(new ThreeStringClassForTable("soap", "5", "100"));
        });
    */

    /*
        Add element into single-column table

        String[] list = {"client1", "client2", "client13"};
        run(() -> {
            clients.setAll(list);
            clientsTable.setItems(clients);
        });
    */

    /*
        Invoking method on server

        Object  opParams[] = {client.pid};
        String  opSig[] = {int.class.getName()};
        client.connection.invokeMethod(
                        client.factory,
                        "testConnection",
                        opParams,
                        opSig);
        client.connection.invokeMethod(
                        element on which we invoke method,
                        invoked method name
                        methods' parameters
                        parameters signature
        );
    */

}
