using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data.SqlClient;
using System.Data;

namespace QuanLyMyPham.DAO
{
    class DataProvider_MayChu
    {
        //chuỗi kết nối
        SqlConnection connection;

        //tạo biến singleton
        private static DataProvider_MayChu instance;
        public static DataProvider_MayChu Instance
        {
            get { if (instance == null) instance = new DataProvider_MayChu(); return DataProvider_MayChu.instance; }
            private set { DataProvider_MayChu.instance = value; }
        }
        private DataProvider_MayChu()
        {
            string con = @"Data Source=DESKTOP-1N4F6N4\MAYCHUTPHCM;Initial Catalog=MyPham_CSDLPT;Integrated Security=True";
            connection = new SqlConnection(con);
        }

        //kiểm tra kết nối
        public void Connect()
        {
            if (connection != null && connection.State == ConnectionState.Closed)
                try
                {
                    connection.Open();
                }
                catch (Exception ex)
                {
                    throw ex;
                }
        }
        public void Disconnect()
        {
            if (connection != null && connection.State == ConnectionState.Open)
                try
                {
                    connection.Close();
                }
                catch (Exception ex)
                {
                    throw ex;
                }
        }

        public DataTable ExecuteQuery(string query)
        {
            Connect();
            DataTable tableResult = new DataTable();
            SqlCommand command = new SqlCommand(query, connection);
            SqlDataAdapter adapter = new SqlDataAdapter(command);
            adapter.Fill(tableResult);
            Disconnect();
            return tableResult;
        }

        public int ExecuteNonQuery(string query)
        {
            Connect();
            int result = 0;
            SqlCommand command = new SqlCommand(query, connection);
            result = command.ExecuteNonQuery();
            Disconnect();
            return result;
        }
    }
}
