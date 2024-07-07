import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.ResultSetMetaData;

// This code works for Thrift as well as Kyuubi

public class ThriftClient {
    public static void main(String[] args) {
        final String containerName = "demo";

        // Set Hadoop user; this must match the name set in runthriftserver.cmd
        // System.setProperty("HADOOP_USER_NAME", "sparkuser"); // Only needed for Thrift

        // Get the storage account name from the environment variable
        String storageAccountName = System.getenv("AZURE_STORAGE_ACCOUNT_NAME");
        if (storageAccountName == null || storageAccountName.isEmpty()) {
            System.err.println("Environment variable AZURE_STORAGE_ACCOUNT_NAME is not set.");
            return;
        }

        // JDBC URL
        // String jdbcUrl = "jdbc:hive2://localhost:10000/default"; // This is for Thrift
        String jdbcUrl = "jdbc:hive2://localhost:10009/;user=sparkuser"; // This is for Kyuubi

        // JDBC credentials (if needed)
        String user = "";
        String password = "";

        // Load the Hive JDBC driver
        try {
            Class.forName("org.apache.hive.jdbc.HiveDriver");
        }
        catch (ClassNotFoundException e) {
            e.printStackTrace();
            return;
        }

        // Construct the path using the storage account name
        String csvPath = String.format("abfss://%s@%s.dfs.core.windows.net/sales.csv", containerName, storageAccountName);

        // Establish the connection
        try (Connection connection = DriverManager.getConnection(jdbcUrl, user, password);
             Statement statement = connection.createStatement()) {

            // Create the table
            String createTableSql = "CREATE TABLE IF NOT EXISTS sales " +
                    "USING csv OPTIONS (" +
                    "path '" + csvPath + "', " +
                    "header 'true', " +
                    "inferSchema 'true')";
            statement.execute(createTableSql);

            // Execute a query
            String sql = "SELECT * FROM sales";
            ResultSet resultSet = statement.executeQuery(sql);

            // Get metadata to determine column count
            ResultSetMetaData metaData = resultSet.getMetaData();
            int columnCount = metaData.getColumnCount();

            // Process the result set
            while (resultSet.next()) {
                for (int i = 1; i <= columnCount; i++) {
                    System.out.print(resultSet.getString(i) + "\t");
                }
                System.out.println();
            }
        }
        catch (Exception e) {
            e.printStackTrace();
        }
    }
}
