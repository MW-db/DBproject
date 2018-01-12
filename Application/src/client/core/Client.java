package client.core;

import javafx.application.Application;
import javafx.fxml.FXMLLoader;
import javafx.scene.Scene;
import javafx.scene.layout.StackPane;
import javafx.stage.Stage;
import javax.management.NotificationFilterSupport;
import javax.management.ObjectName;
import java.lang.management.ManagementFactory;

public class Client extends Application {
    public int pid = 0;
    public String domain = null;
    public ObjectName factory = null;
    public Connection connection;
    public ObjectName ownerObj;
    public ObjectName workerObj;
    public ObjectName clientObj;
    private Listener clientListener;
    private NotificationFilterSupport myFilter;
    private GUIController controller;


    @Override
    public void start(Stage primaryStage) throws Exception {
        pid = Integer.parseInt(ManagementFactory.getRuntimeMXBean().getName().split("@")[0]);
        connection = new Connection();
        domain = connection.getDomain();

        factory = new ObjectName(domain+"F" +":type=server.core.Factory,name=Factory");

        //Load GUI
        FXMLLoader loader = new FXMLLoader();
        loader.setLocation(this.getClass().getResource("/client/ClientDbFXML.fxml"));

        controller = new GUIController(this);
        loader.setController(controller);
        StackPane stackPane=loader.load();

        Scene scene = new Scene(stackPane);

        //Add notification listener
        clientListener = new Listener(controller);
        myFilter = new NotificationFilterSupport();
        myFilter.disableAllTypes();
        myFilter.enableType(String.valueOf(pid));
        connection.mbsc.addNotificationListener(factory, clientListener, myFilter, null);

        primaryStage.setScene(scene);
        primaryStage.setTitle("Super Shop Manager");
        primaryStage.show();
    }

    public void setNewNotificationFilter() {
        try {
            connection.mbsc.removeNotificationListener(factory, clientListener, myFilter, null);
        } catch (Exception e) {
            e.printStackTrace();
        }

        if (ownerObj != null) {
            try {
                myFilter.enableType(String.valueOf(ownerObj));
                connection.mbsc.addNotificationListener(ownerObj, clientListener, myFilter, null);
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else if (workerObj != null) {
            try {
                myFilter.enableType(String.valueOf(workerObj));
                connection.mbsc.addNotificationListener(workerObj, clientListener, myFilter, null);
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else if (clientObj != null) {
            try {
                myFilter.enableType(String.valueOf(clientObj));
                connection.mbsc.addNotificationListener(clientObj, clientListener, myFilter, null);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        try {
            connection.mbsc.addNotificationListener(factory, clientListener, myFilter, null);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void stop() {
        connection.closeConnection();
    }

    public static void main(String[] args) {
        launch(args);
    }
}

