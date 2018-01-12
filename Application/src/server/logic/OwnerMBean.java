package server.logic;

public interface OwnerMBean {
    void getWorkerList();

    void getClientList();

    void removeWorker(String worker);

    void removeClient(String client);

    void backupDB();

    void restoreDB();
}
