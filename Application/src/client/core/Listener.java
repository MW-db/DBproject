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
            case('D')://nextDay
                String date = notification.getMessage().substring(2);
                Object  opParams[] = {};
                String  opSig[] = {};
                if (controller.user.equals("Owner")) {
                    controller.run(() -> {
                        controller.ownerDateLabel.setText(date);
                    });
                    controller.client.connection.invokeMethod(controller.client.ownerObj, "getWorkerList", opParams, opSig);
                    controller.client.connection.invokeMethod(controller.client.ownerObj, "getClientList", opParams, opSig);
                    controller.client.connection.invokeMethod(controller.client.ownerObj, "getBalance", opParams, opSig);
                    controller.client.connection.invokeMethod(controller.client.ownerObj, "getCapacity", opParams, opSig);
                } else if (controller.user.equals("Worker")) {
                    controller.run(() -> {
                        controller.workerDateLabel.setText(date);
                    });
                    controller.client.connection.invokeMethod(controller.client.workerObj, "getOrder", opParams, opSig);
                    controller.client.connection.invokeMethod(controller.client.workerObj, "getBalance", opParams, opSig);
                    controller.client.connection.invokeMethod(controller.client.workerObj, "getCapacity", opParams, opSig);
                } else if (controller.user.equals("Client")) {
                    controller.run(() -> {
                        controller.clientDateLabel.setText(date);
                    });
                }
                break;
            case('C')://clients list
                String[] listC = notification.getMessage().substring(3).split(",");
                controller.run(() -> {
                    controller.clients.setAll(listC);
                    controller.clientsTable.setItems(controller.clients);
                });
                break;
            case('B')://balance list
                String[] listB = notification.getMessage().substring(3).split(",");
                if (controller.user.equals("Owner")) {
                    controller.run(() -> {
                        controller.incomeLabel.setText(listB[0]);
                        controller.expenseLabel.setText(listB[1]);
                        controller.balanceLabel.setText(listB[2]);
                    });
                } else if (controller.user.equals("Worker")) {
                    controller.run(() -> {
                        controller.workerIncomeLabel.setText(listB[0]);
                        controller.workerExpensesLabel.setText(listB[1]);
                        controller.workerBalanceLabel.setText(listB[2]);
                    });
                }
                break;
            case('S')://storage list
                String[] listS = notification.getMessage().substring(3).split(",");
                if (controller.user.equals("Owner")) {
                    controller.run(() -> {
                        controller.foodStatusLabel.setText(listS[0]);
                        controller.drinkStatusLabel.setText(listS[1]);
                        controller.otherStatusLabel.setText(listS[2]);
                    });
                } else if (controller.user.equals("Worker")) {
                    controller.run(() -> {
                        controller.workerFoodStatusLabel.setText(listS[0]);
                        controller.workerDrinkStatusLabel.setText(listS[1]);
                        controller.workerOtherStatusLabel.setText(listS[2]);
                    });
                }
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
            controller.client.connection.invokeMethod(controller.client.ownerObj, "getBalance", opParams, opSig);
            controller.client.connection.invokeMethod(controller.client.ownerObj, "getCapacity", opParams, opSig);
        } else if (controller.user.equals("Worker")) {
            Object  opParams[] = {};
            String  opSig[] = {};
            controller.client.connection.invokeMethod(controller.client.workerObj, "getOrder", opParams, opSig);
            controller.client.connection.invokeMethod(controller.client.workerObj, "getBalance", opParams, opSig);
            controller.client.connection.invokeMethod(controller.client.workerObj, "getCapacity", opParams, opSig);
        }
    }
}
