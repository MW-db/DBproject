package server.core;

public interface FactoryMBean {
    ConnectionServer createConnection();

    void createUser(int pid, String type, String login, String pass);

    void testConnection(int pid);
}
