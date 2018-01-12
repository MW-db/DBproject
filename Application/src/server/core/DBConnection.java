package server.core;

import java.sql.*;
import java.util.ArrayList;

public class DBConnection {
    private Connection connection;
    private String url = "jdbc:mysql://localhost:3306/supershop";
    private String username = "root";
    private String password = "1234";

    public void getConnection() {
        System.out.println(">> Connecting database...");

        try {
            connection = DriverManager.getConnection(url, username, password);
            System.out.println(">> Database connected");
        } catch (SQLException e) {
            throw new IllegalStateException("Cannot connect the database!", e);
        }
    }

    /*public void getRecord(String query) {
        Statement stmt;
        try {
            stmt = connection.createStatement();
            ResultSet rs = stmt.executeQuery(query);
            while (rs.next()) {
                int balance = rs.getInt("Balance");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }*/

    public void executeSQLStatement() {
            /* execute procedure with parameters
            CallableStatement cs = connection.prepareCall("{call registerClient(?,?,?,?,?,?,?)}");
            cs.setString(1, "qwerty");
            cs.setString(2, "123456");
            cs.setString(3, "abc");
            cs.setString(4, "zxc");
            cs.setString(5, "2018-01-07");
            cs.setString(6, "123456789");
            cs.setString(7, "abc 3/4");
            cs.execute();*/

            /* execute function with parameters and get return value
            CallableStatement cs = connection.prepareCall("{? = call createDelivery(?, ?)}");
            cs.setString(2, "2018-01-07");
            cs.setString(3, "2018-01-09");
            cs.registerOutParameter(1, java.sql.Types.INTEGER);
            cs.execute();

            int res = cs.getInt(1);
            System.out.println(">> Function result = " + res);
            */
    }

    public ArrayList<String> getRecords(String query) {
        ArrayList<String> data = new ArrayList<>();
        Statement stmt;
        try {
            stmt = connection.createStatement();
            ResultSet rs = stmt.executeQuery(query);
            while (rs.next()) {
                String s = "";
                s = s.concat("," + rs.getString("Name") + " " + rs.getString("Surname"));
                data.add(s);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return data;
    }

    public int executeStmInt(String query, String column) {
        Statement stmt = null;
        int id = 0;
        try {
            stmt = connection.createStatement();
            ResultSet rs = stmt.executeQuery(query);
            while (rs.next()) {
                id = rs.getInt(column);
            }

        } catch (SQLException e ) {
            e.printStackTrace();
        } finally {
            if (stmt != null) {
                try {
                    stmt.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
        return id;
    }

    public void executeStm(String query) {
        PreparedStatement  stmt = null;
        try {
            System.out.println("Executing statement...");
            stmt = connection.prepareStatement(query);
            stmt.executeUpdate(query);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void disconnect() {
        if (connection != null) {
            try {
                connection.close();
                connection = null;
                System.out.println(">> Database disconnected");
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
