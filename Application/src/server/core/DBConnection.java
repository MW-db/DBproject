package server.core;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    private Connection connection;
    private String url = "jdbc:mysql://localhost:3306/supershopmanager";
    private String username = "root";
    private String password = "1234";

    public void getConnection() {
        System.out.println(">> Connecting database...");

        try {
            connection = DriverManager.getConnection(url, username, password
            System.out.println(">> Database connected!");
        } catch (SQLException e) {
            throw new IllegalStateException("Cannot connect the database!", e);
        }
    }

    public void getRecord() {
        String sql = "SELECT * FROM `stackoverflow`";
        try {
            PreparedStatement statement = mysqlConnect.connect().prepareStatement(sql);

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void disconnect() {
        if (connection != null) {
            try {
                connection.close();
                connection = null;
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
