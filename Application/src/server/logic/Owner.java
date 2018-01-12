package server.logic;

import server.core.Server;

import javax.management.Notification;
import javax.management.NotificationBroadcasterSupport;
import java.util.ArrayList;

public class Owner extends NotificationBroadcasterSupport implements OwnerMBean{
    private Server server;
    private int pid;
    private String login;
    private String pass;

    public Owner(int pid, String login, String pass, Server server) {
        this.pid = pid;
        this.login = login;
        this.pass = pass;
        this.server = server;
    }

    public void getWorkerList() {
        String query = "SELECT Name, Surname FROM Workers";
        ArrayList<String> data = server.dbConnection.getRecords(query);
        String dataStr = "";
        for (String s:data) {
            dataStr = dataStr.concat(s);
        }
        sendNotification(new Notification(String.valueOf(pid), this, 001100110011,
                "W#" + dataStr));
    }

    public void getClientList() {
        String query = "SELECT Name, Surname FROM Clients";
        ArrayList<String> data = server.dbConnection.getRecords(query);
        String dataStr = "";
        for (String s:data) {
            dataStr = dataStr.concat(s);
        }
        sendNotification(new Notification(String.valueOf(pid), this, 001100110011,
                "C#" + dataStr));
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

    public void removeWorker(String worker) {
        String[] workerName = worker.split(" ");
        String query = "UPDATE Workers SET Salary = 0, Name = \"\", Surname = \"\", Password = \"@@@@@\"" +
                " WHERE Name = \"" + workerName[0] + "\" AND Surname = \"" + workerName[1] + "\"";
        System.out.println(query);
        server.dbConnection.executeStm(query);
        getWorkerList();
    }

    public void removeClient(String client) {
        String[] clientName = client.split(" ");
        String query = "UPDATE Clients SET Name = \"\", Surname = \"\", Password = \"@@@@@\"" +
                " WHERE Name = \"" + clientName[0] + "\" AND Surname = \"" + clientName[1] + "\"";
        server.dbConnection.executeStm(query);
        getClientList();
    }

    public void nextDay() {
        String date = server.dbConnection.executeStmStr("SELECT * FROM tempdate");
        server.factory.sendNextDayNotif(date);
    }

    public void addWorker(String a, String b, String c, String d, String e, String f, String g, String h) {
        server.dbConnection.registerWorker(a, b, c, d, e, f, g, h);
        getClientList();
    }

    public void backupDB() {
        DBBackup.backupDB();
    }

    public void restoreDB() {
        DBBackup.restoreDB("backup.sql");
    }
}
