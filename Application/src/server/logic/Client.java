package server.logic;

import server.core.Server;

import javax.management.Notification;
import javax.management.NotificationBroadcasterSupport;
import java.util.ArrayList;

public class Client extends NotificationBroadcasterSupport implements ClientMBean{
    private Server server;
    private int pid;
    private String login;
    private String pass;

    public Client(int pid, String login, String pass, Server server) {
        this.pid = pid;
        this.login = login;
        this.pass = pass;
        this.server = server;
    }

    @Override
    public void getProductsList() {
        String query = "SELECT Name FROM Products";
        ArrayList<String> data = server.dbConnection.getRecords(query);

        String dataStr = "";

        for(String s : data){
            dataStr = dataStr.concat(s);
        }

        sendNotification(new Notification(String.valueOf(pid), this, 1010111001,
                "P#" + dataStr));
    }

    @Override
    public void getItemsInCart() {
        //TODO
        String query = "SELECT Name FROM Products";
        ArrayList<String> data = server.dbConnection.getRecords(query);

        String dataStr = "";

        for(String s : data){
            dataStr = dataStr.concat(s);
        }

        sendNotification(new Notification(String.valueOf(pid), this, 1010111001,
                "P#" + dataStr));
    }

    @Override
    public void getPreviousTransactions() {

    }
}
