package server.core;

import javax.management.MBeanServer;
import javax.management.MBeanServerFactory;
import javax.management.ObjectName;
import javax.management.remote.JMXConnectorServer;
import javax.management.remote.JMXConnectorServerFactory;
import javax.management.remote.JMXServiceURL;
import java.rmi.registry.LocateRegistry;

public class ConnectionServer {
    public MBeanServer mbs = null;
    private String domain = null;
    private static volatile ConnectionServer instance = null;

    public static ConnectionServer getInstance() {
        if (instance == null) {
            synchronized (ConnectionServer.class) {
                if (instance == null) {
                    instance = new ConnectionServer();
                }
            }
        }
        return instance;
    }

    private ConnectionServer() {
    }

    public void createRegistry(){
        try {
            LocateRegistry.createRegistry(44444);
            System.out.println(">> Create RMI registry on port 44444");
        }
        catch ( Exception e ) {
            e.printStackTrace();
        }
    }

    public void createMBeanServer() {
        mbs = MBeanServerFactory.createMBeanServer();
        System.out.println(">> Create MBean Server");
    }

    public void createDomain() {
        domain = mbs.getDefaultDomain();
    }

    public void createMBeanMainObject(String mBeanClassNameArg, String name, String classID, Object obj) {
        String mbeanClassName = mBeanClassNameArg;
        String mbeanObjectNameStr =
                domain+ classID + ":type=" + mbeanClassName + ",name=" + name;
        try {
            ObjectName mbeanObjectName =
                    ObjectName.getInstance(mbeanObjectNameStr);
            mbs.registerMBean(obj, mbeanObjectName);
            System.out.println(">> Registry main mBean: " + name);
        } catch (Exception e) {
            e.printStackTrace();
            System.exit(1);
        }
    }

    public void createConnectorServer() {
        try {
            JMXServiceURL url = new JMXServiceURL(
                    "service:jmx:rmi://localhost:44445/jndi/rmi://localhost:44444/jmxrmi");
            JMXConnectorServer cs = JMXConnectorServerFactory.newJMXConnectorServer(url, null, mbs);
            cs.start();
            System.out.println(">> Create ConnectorServer");
        }
        catch ( Exception e ) {
            e.printStackTrace();
        }
    }

    public String getDomain() {
        return domain;
    }
}
