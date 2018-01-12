package server.logic;

import server.core.Server;

import javax.management.NotificationBroadcasterSupport;

public class Client extends NotificationBroadcasterSupport implements ClientMBean{
    private Server server;
    private int pid;
    private String login;
    private String pass;

    public Client(int pid, String login, String pass, Server server) {
        this.pid = pid;
        this.login = login;
        this.pass = pass;
        this.server = server;
    }
}
