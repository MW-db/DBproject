package server.logic;

public interface OwnerMBean {
    void getWorkerList();

    void getClientList();

    void backupDB();

    void restoreDB();
}
