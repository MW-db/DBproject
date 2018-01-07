package client.core;

import javafx.application.Application;
import javafx.fxml.FXMLLoader;
import javafx.scene.Scene;
import javafx.scene.layout.StackPane;
import javafx.stage.Stage;

public class Client extends Application {
    @Override
    public void start(Stage primaryStage) throws Exception {
        //Load GUI
        FXMLLoader loader = new FXMLLoader();
        loader.setLocation(this.getClass().getResource("/client/ClientDbFXML.fxml"));

        GUIController controller = new GUIController();
        loader.setController(controller);
        StackPane stackPane=loader.load();

        Scene scene = new Scene(stackPane);

        primaryStage.setScene(scene);
        primaryStage.setTitle("Super Shop Manager");
        primaryStage.show();
    }

    public static void main(String[] args) {
        launch(args);
    }
}
