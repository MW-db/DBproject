package server.logic;

import javax.management.NotificationBroadcasterSupport;

public class Client extends NotificationBroadcasterSupport implements ClientMBean{
    private int pid;
    private String login;
    private String pass;

    public Client(int pid, String login, String pass) {
        this.pid = pid;
        this.login = login;
        this.pass = pass;
    }
}
