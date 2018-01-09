package client.core;

import javax.management.MBeanServerConnection;
import javax.management.ObjectName;
import javax.management.remote.JMXConnector;
import javax.management.remote.JMXConnectorFactory;
import javax.management.remote.JMXServiceURL;

public class Connection {
    public JMXServiceURL url = null;
    public JMXConnector jmxc = null;
    public String domain = null;
    public MBeanServerConnection mbsc = null;

    public Connection() {
        try {
            url = new JMXServiceURL(
                    "service:jmx:rmi://localhost:44445/jndi/rmi://localhost:44444/jmxrmi");
            jmxc = JMXConnectorFactory.connect(url, null);
            mbsc = jmxc.getMBeanServerConnection();
            domain = mbsc.getDefaultDomain();
        } catch (Exception e){
            e.printStackTrace();
        }
        System.out.println("Open connection...");
    }

    public String getDomain(){
        return domain;
    }

    public void createNewMBean(ObjectName mBeanName) {
        try {
            mbsc.createMBean("server.hellojmxtest.Hello", mBeanName, null, null);
        } catch (Exception  e) {
            e.printStackTrace();
        }
        System.out.println("Create new MBean: " + mBeanName.toString());
    }

    //========================== INVOKE METHOD TEMPLATE ================================

    public void invokeMethod(ObjectName mBeanName, String methodName, Object  opParams[], String  opSig[]) {
        try {
            mbsc.invoke(mBeanName, methodName, opParams, opSig);
        } catch (Exception  e) {
            e.printStackTrace();
        }
    }

    public void closeConnection() {
        try {
            jmxc.close();
        } catch (Exception  e) {
            e.printStackTrace();
        }
        System.out.println("Close connection...");
    }
}
