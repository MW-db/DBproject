package server.core;

import server.logic.Client;
import server.logic.Owner;
import server.logic.Worker;

import javax.management.Notification;
import javax.management.NotificationBroadcasterSupport;

public class Factory extends NotificationBroadcasterSupport implements FactoryMBean{
    public Server server;
    private static volatile Factory instance = null;

    public static Factory getInstance(Server server) {
        if (instance == null) {
            synchronized (Factory.class) {
                if (instance == null) {
                    instance = new Factory(server);
                }
            }
        }
        return instance;
    }

    private Factory(Server server) {
        this.server = server;
    }

    @Override
    public ConnectionServer createConnection() {
        ConnectionServer connection = ConnectionServer.getInstance();
        connection.createRegistry();
        connection.createMBeanServer();
        connection.createDomain();
        return connection;
    }

    @Override
    public void createUser(int pid, String type, String login, String pass) {
        if (type.equals("Owner")) {

            if (server.owner == null) {
                if (login.equals("admin") && pass.equals("11Admin12")) {
                    server.owner = new Owner(pid, login, pass, server);
                    server.connection.createMBeanMainObject("server.logic.Owner", "Owner",
                            String.valueOf(pid), server.owner);
                    sendNotification(new Notification(String.valueOf(pid), this, 001100110011,
                            "N#" + pid));
                }
            }

        } else if (type.equals("Worker")) {
            String query = "SELECT WorkerID FROM workers WHERE Login = \"" + login + "\" AND Password = \"" + pass + "\"";
            if (server.dbConnection.executeStmInt(query, "WorkerID") != 0) {
                Worker worker = new Worker(pid, login, pass, server);
                server.workerList.add(worker);
                server.connection.createMBeanMainObject("server.logic.Worker", "Worker" +
                        pid, String.valueOf(pid), worker);
                sendNotification(new Notification(String.valueOf(pid), this, 001100110011,
                        "N#" + pid));
            }

        }  else if (type.equals("Client")) {
            String query = "SELECT ClientID FROM clients WHERE Login = \"" + login + "\" AND Password = \"" + pass + "\"";
            if (server.dbConnection.executeStmInt(query, "ClientID") != 0) {
                Client client = new Client(pid, login, pass, server);
                server.clientList.add(client);
                server.connection.createMBeanMainObject("server.logic.Client", "Client" +
                        pid, String.valueOf(pid), client);
                sendNotification(new Notification(String.valueOf(pid), this, 001100110011,
                        "N#" + pid));
            }
        }
    }

    @Override
    public void testConnection(int pid) {
        System.out.println("Client with pid: " + pid + " invoking method");
        sendNotification(new Notification(String.valueOf(pid), this, 110011110,
                "T, connection and notification test" ));
    }
}
