package server.logic;

import javax.management.NotificationBroadcasterSupport;

public class Owner extends NotificationBroadcasterSupport implements OwnerMBean{
    private int pid;
    private String login;
    private String pass;

    public Owner(int pid, String login, String pass) {
        this.pid = pid;
    }
}
