package server.core;

import java.io.IOException;

public class Server {
    public ConnectionServer connection = null;
    public Factory factory = null;

    public Server() {
        factory = Factory.getInstance(this);
        connection = factory.createConnection();

        connection.createConnectorServer();

        connection.createMBeanMainObject("server.core.Factory", "Factory", "F", factory);

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
