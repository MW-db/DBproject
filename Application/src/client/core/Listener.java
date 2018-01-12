package client.core;

import javax.management.MalformedObjectNameException;
import javax.management.Notification;
import javax.management.NotificationListener;
import javax.management.ObjectName;

public class Listener implements NotificationListener {
    private GUIController controller;
    private String[] list;

    public Listener(GUIController controller) {
        this.controller = controller;
        controller.setListener(this);
    }

    public void handleNotification(Notification notification, Object handback)
    {
        switch (notification.getMessage().charAt(0)) {
            case('N')://New user
                if (notification.getMessage().substring(2).equals(Integer.toString(controller.client.pid))) {
                    createUser();
                    controller.changeViewAfterLogin();
                }
                break;
            case('W')://workers list
                String[] listW = notification.getMessage().substring(3).split(",");
                controller.run(() -> {
                    controller.workers.setAll(listW);
                    controller.workersTable.setItems(controller.workers);
                });
                break;
            case('C')://clients list
                String[] listC = notification.getMessage().substring(3).split(",");
                controller.run(() -> {
                    controller.clients.setAll(listC);
                    controller.clientsTable.setItems(controller.clients);
                });
                break;
            default:
        }
    }

    private void createUser() {
        if (controller.user.equals("Owner")) {
            try {
                String pid = String.valueOf(controller.client.pid);
                controller.client.ownerObj = new ObjectName(controller.client.connection.domain+pid
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
        controller.client.setNewNotificationFilter();

        if (controller.user.equals("Owner")) {
            Object  opParams[] = {};
            String  opSig[] = {};
            controller.client.connection.invokeMethod(controller.client.ownerObj, "getWorkerList", opParams, opSig);
            controller.client.connection.invokeMethod(controller.client.ownerObj, "getClientList", opParams, opSig);
        } else if (controller.user.equals("Worker")) {
            Object  opParams[] = {};
            String  opSig[] = {};
            controller.client.connection.invokeMethod(controller.client.workerObj, "getOrder", opParams, opSig);
        }
    }
}
