package server.logic;

import server.core.Server;

import javax.management.Notification;
import javax.management.NotificationBroadcasterSupport;
import java.util.ArrayList;

public class Worker extends NotificationBroadcasterSupport implements WorkerMBean{
    private Server server;
    private int pid;
    private String login;
    private String pass;

    public Worker(int pid, String login, String pass, Server server) {
        this.pid = pid;
        this.login = login;
        this.pass = pass;
        this.server = server;
    }

    public void getOrder() {
        /*String query = "SELECT Name, Surname FROM clients";
        String query = "SELECT Name, Surname FROM Clients";
        origin/front/worker
        ArrayList<String> data = server.dbConnection.getRecords(query);
        String dataStr = "";
        for (String s:data) {
            dataStr = dataStr.concat(s);
        }
        sendNotification(new Notification(String.valueOf(pid), this, 001100110011,
                "C#" + dataStr));*/
    }

    public void getBalance() {
        String data = server.dbConnection.getMoney();
        sendNotification(new Notification(String.valueOf(pid), this, 001100110011,
                "B#" + data));
    }

    public void getCapacity() {
        String data = server.dbConnection.getStorage();
        sendNotification(new Notification(String.valueOf(pid), this, 001100110011,
                "S#" + data));
    }
}
