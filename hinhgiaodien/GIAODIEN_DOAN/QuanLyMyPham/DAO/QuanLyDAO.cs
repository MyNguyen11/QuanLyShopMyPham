using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using QuanLyMyPham.DTO;
using System.Data;

namespace QuanLyMyPham.DAO
{
    public class QuanLyDAO
    {
        private static QuanLyDAO instance;

        public static QuanLyDAO Instance
        {
            get { if (instance == null) instance = new QuanLyDAO(); return instance; }
            private set { instance = value; }
        }

        private QuanLyDAO() { }

        //lấy tài khoản
        //public QuanLyDTO layTaiKhoan()
        //{
        //    DataTable table = DataProvider_MayChu.Instance.ExecuteQuery("SELECT * FROM QuanLy ");
        //    foreach (DataRow row in table.Rows)
        //    {
        //        return new QuanLyDTO(row);
        //    }
        //    return null;
        //}
    }
}
