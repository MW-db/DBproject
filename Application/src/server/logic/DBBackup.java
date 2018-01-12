package server.logic;

import java.awt.*;
import java.io.File;
import java.io.IOException;
import java.net.URISyntaxException;
import java.security.CodeSource;

public class DBBackup {
    public static void backupDB() {
        try {
            CodeSource codeSource = DBBackup.class.getProtectionDomain().getCodeSource();
            File jarFile = new File(codeSource.getLocation().toURI().getPath());
            String jarDir = jarFile.getParentFile().getPath();

            String dbName = "supershop";
            String dbUser = "root";
            String dbPass = "1234";


            String folderPath = jarDir + "\\backup";

            File f1 = new File(folderPath);
            f1.mkdir();

            String savePath = "\"" + jarDir + "\\backup\\" + "backup.sql\"";

            String executeCmd = "mysqldump -u" + dbUser + " -p" + dbPass + " --database " + dbName + " -r " + savePath;

            Process runtimeProcess = Runtime.getRuntime().exec(executeCmd);
            int processComplete = runtimeProcess.waitFor();

            if (processComplete == 0) {
                System.out.println("Backup Complete");
            } else {
                System.out.println("Backup Failure");
            }

        } catch (URISyntaxException | IOException | InterruptedException ex) {
            ex.printStackTrace();
        }
    }

    public static void restoreDB(String s) {
        try {
            CodeSource codeSource = DBBackup.class.getProtectionDomain().getCodeSource();
            File jarFile = new File(codeSource.getLocation().toURI().getPath());
            String jarDir = jarFile.getParentFile().getPath();

            String dbName = "supershop";
            String dbUser = "root";
            String dbPass = "1234";

            String restorePath = jarDir + "\\backup" + "\\" + s;

            String[] executeCmd = new String[]{"mysql", dbName, "-u" + dbUser, "-p" + dbPass, "-e", " source " + restorePath};

            Process runtimeProcess = Runtime.getRuntime().exec(executeCmd);
            int processComplete = runtimeProcess.waitFor();

            if (processComplete == 0) {
                System.out.println("Restore complete");
            } else {
                System.out.println("Error at restoring");
            }


        } catch (URISyntaxException | IOException | InterruptedException | HeadlessException ex) {
            ex.printStackTrace();
        }

    }
}
