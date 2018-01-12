package server.logic;

public interface OwnerMBean {
    void getWorkerList();

    void getClientList();

    void getBalance();

    void getCapacity();

    void addWorker(String a, String b, String c, String d, String e, String f, String g, String h);

    void removeWorker(String worker);

    void removeClient(String client);

    void nextDay();

    void backupDB();

    void restoreDB();
}
