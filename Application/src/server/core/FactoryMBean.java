package server.core;

public interface FactoryMBean {
    ConnectionServer createConnection();

    void testConnection(int pid);
}
