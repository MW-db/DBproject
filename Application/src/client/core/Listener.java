package client.core;

import javax.management.MalformedObjectNameException;
import javax.management.Notification;
import javax.management.NotificationListener;
import javax.management.ObjectName;

public class Listener implements NotificationListener {
    private GUIController controller;

    public Listener(GUIController controller) {
        this.controller = controller;
        controller.setListener(this);
    }

    public void handleNotification(Notification notification, Object handback)
    {
        switch (notification.getMessage().charAt(0)) {
            case('N')://New user
                System.out.println("Received notification: " + notification.getMessage().substring(2));
                if (notification.getMessage().substring(2).equals(Integer.toString(controller.client.pid))) {
                    createUser();
                    controller.changeViewAfterLogin();
                }
                break;
            default:
        }
    }

    private void createUser() {
        if (controller.user.equals("Owner")) {
            try {
                controller.client.ownerObj = new ObjectName(controller.client.connection.domain+String.valueOf(controller.client.pid)
                        +":type=server.logic.Owner,name=Owner");
            } catch (MalformedObjectNameException e) {
                e.printStackTrace();
            }
        } else if (controller.user.equals("Worker")) {
            try {
                String pid = String.valueOf(controller.client.pid);
                controller.client.workerObj = new ObjectName(controller.client.connection.domain+pid
                        +":type=server.logic.Worker,name=Worker"+pid);
            } catch (MalformedObjectNameException e) {
                e.printStackTrace();
            }
        } else if (controller.user.equals("Client")) {
            try {
                String pid = String.valueOf(controller.client.pid);
                controller.client.clientObj = new ObjectName(controller.client.connection.domain+pid
                        +":type=server.logic.Client,name=Client"+pid);
            } catch (MalformedObjectNameException e) {
                e.printStackTrace();
            }
        }
    }
}
