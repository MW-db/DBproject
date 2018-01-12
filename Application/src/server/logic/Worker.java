package server.logic;

import javax.management.NotificationBroadcasterSupport;

public class Worker extends NotificationBroadcasterSupport implements WorkerMBean{
    private int pid;
    private String login;
    private String pass;

    public Worker(int pid, String login, String pass) {
        this.pid = pid;
        this.login = login;
        this.pass = pass;
    }
}
