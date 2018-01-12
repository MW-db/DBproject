package server.core;

import server.logic.Client;
import server.logic.Owner;
import server.logic.Worker;

import java.io.IOException;
import java.util.ArrayList;

public class Server {
    public ConnectionServer connection = null;
    public Factory factory = null;
    public DBConnection dbConnection = null;
    public Owner owner;
    public ArrayList<Worker> workerList;
    public ArrayList<Client> clientList;

    public Server() {
        workerList = new ArrayList<>();
        clientList = new ArrayList<>();

        factory = Factory.getInstance(this);
        connection = factory.createConnection();

        connection.createConnectorServer();

        connection.createMBeanMainObject("server.core.Factory", "Factory", "F", factory);

        dbConnection = new DBConnection();
        dbConnection.getConnection();
        dbConnection.executeSQLStatement();

        System.out.println(">> server is running...");
    }

    public static void main(String argv[]) {
        new Server();
        try {
            System.in.read();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
