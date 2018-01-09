package client.core;

import javax.management.Notification;
import javax.management.NotificationListener;

public class Listener implements NotificationListener {
    private GUIController controller;

    public Listener(GUIController controller) {
        this.controller = controller;
        controller.setListener(this);
    }

    public void handleNotification(Notification notification, Object handback)
    {
        //System.out.println("Receive notification: " + notification.getMessage());

        switch (notification.getMessage().charAt(0)) {
            case('T')://Test notification
                System.out.println("Received notification: " + notification.getMessage().substring(2));
                break;
            default:
        }
    }
}
