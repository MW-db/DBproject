package server.core;

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
    public void testConnection(int pid) {
        System.out.println("Client with pid: " + pid + " invoking method");
        sendNotification(new Notification(String.valueOf(pid), this, 110011110,
                "T, connection and notification test" ));
    }
}
