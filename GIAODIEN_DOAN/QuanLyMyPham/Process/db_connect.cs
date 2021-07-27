using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace QuanLyMyPham.Process
{
    class db_connect
    {
        public static int KTDangNhap(String loginName, String password)
        {
            string userID = ConfigurationManager.AppSettings["USERID"];
            string pass = ConfigurationManager.AppSettings["PASSWORD"];
            Program.connectionstring = "Server=" + Program.TenServer + ";initial catalog=" + Program.TenDataBase
                                               + ";User id=" + userID + "; Password=" + pass;
            try {
                using (SqlConnection conn = new SqlConnection(Program.connectionstring))
                {

                    using (SqlCommand cmd = new SqlCommand("SP_KIEMTRA_NV", conn))
                    {

                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("MANV", loginName);

                        var returnParameter = cmd.Parameters.Add("@result", SqlDbType.Int);
                        returnParameter.Direction = ParameterDirection.ReturnValue;

                        conn.Open();
                        cmd.ExecuteNonQuery();
                        conn.Close();
                        int tmpResult = (int)returnParameter.Value;
                        return tmpResult;

                    }
                }  
            } catch(Exception ex)
            {
                return -1;
            }

        }

        public static SanPham ThongTinSanPham(String maSP)
        {
            SqlConnection conn = new SqlConnection(Program.connectionstring);
            string strLenh = "EXEC SP_ThongTinSanPham '" + maSP + "'";

            SqlDataReader myReader;
            SqlCommand sqlcmd = new SqlCommand(strLenh, conn);
            sqlcmd.CommandType = CommandType.Text;
            if (conn.State == ConnectionState.Closed) conn.Open();
            SanPham sanPham = new SanPham();
            try
            {
                myReader = sqlcmd.ExecuteReader();

            }
            catch (SqlException ex)
            {
                conn.Close();                
                return null;
            }

                // Program.myReader = Program.ExecSqlDataReader(strLenh);


                if (!myReader.Read()) return null;

            
            try
            {
                sanPham.MaSP = myReader.GetString(0);
                sanPham.TenSP = myReader.GetString(1);
                sanPham.GiaSP = (decimal) myReader.GetSqlMoney(2);
                sanPham.HinhSanPham = myReader.GetString(3);
                return sanPham;
            }
            catch (System.Data.SqlTypes.SqlNullValueException)
            {
                sanPham.MaSP ="";
                sanPham.TenSP = "";
                sanPham.GiaSP = 0;
                sanPham.HinhSanPham = "";
                return null;
            }
        

        }

        //public static KhachHang ThongTinKhachHang(String maKH)
        //{
        //    SqlConnection conn = new SqlConnection(Program.connectionstring);
        //    string strLenh = "EXEC SP_ThongTinKhachHang '" + maKH + "'";

        //    SqlDataReader myReader;
        //    SqlCommand sqlcmd = new SqlCommand(strLenh, conn);
        //    sqlcmd.CommandType = CommandType.Text;
        //    if (conn.State == ConnectionState.Closed) conn.Open();
        //    KhachHang khachHang = new KhachHang();
        //    try
        //    {
        //        myReader = sqlcmd.ExecuteReader();

        //    }
        //    catch (SqlException ex)
        //    {
        //        conn.Close();
        //        return null;
        //    }

        //}


        }
    }
