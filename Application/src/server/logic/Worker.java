package server.logic;

import server.core.Server;

import javax.management.NotificationBroadcasterSupport;

public class Worker extends NotificationBroadcasterSupport implements WorkerMBean{
    private Server server;
    private int pid;
    private String login;
    private String pass;

    public Worker(int pid, String login, String pass, Server server) {
        this.pid = pid;
        this.login = login;
        this.pass = pass;
        this.server = server;
    }
}
