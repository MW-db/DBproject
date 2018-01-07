package client.core;

import javafx.application.Platform;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.scene.control.*;
import javafx.scene.layout.StackPane;

public class GUIController {

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
    private ListView clientsTable;
    @FXML
    private ListView workersTable;
    @FXML
    private ListView infoTable;
    @FXML
    private ListView deliveryWaitingTable;
    @FXML
    private ListView deliveryIncomingTable;

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
    private ListView clientsOrderListTable;
    @FXML
    private ListView waitingDeliveryTable;
    @FXML
    private ListView goingDeliveryTable;



    //---------EXIT BUTTON-------------

    public void exitOnClick(ActionEvent event) {
        Platform.exit();
    }



    //========= LOGIN ACTIONS =============

    public void loginOnClick(ActionEvent event) {
        this.loginPage.setVisible(false);
        this.loginPage.setDisable(true);

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

    }

    public void removeWorkerOnClick(ActionEvent event) {

    }

    public void addClientOnClick(ActionEvent event) {

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
}
