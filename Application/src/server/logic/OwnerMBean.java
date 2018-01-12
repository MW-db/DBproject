package server.logic;

public interface OwnerMBean {
    void getWorkerList();

    void backupDB();

    void restoreDB();
}
