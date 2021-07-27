using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using QuanLyMyPham.DTO;
using System.Data;

namespace QuanLyMyPham.DAO
{
    public class NSXDAO
    {
        private static NSXDAO instance;

        public static NSXDAO Instance
        {
            get { if (instance == null) instance = new NSXDAO(); return instance; }
            private set { instance = value; }
        }

        private NSXDAO() { }

        public List<NSXDTO> LayDsNSX()
        {
            List<NSXDTO> danhSach = new List<NSXDTO>();

            string query = "SELECT * FROM NhaSanXuat";
            DataTable data = DataProvider.Instance.ExecuteQuery(query);

            foreach (DataRow item in data.Rows)
            {
                danhSach.Add(new NSXDTO(item));
            }
            return danhSach;
        }


        public bool themNSX(string maNSX, string tenNSX, string diaChi)
        {
            int result = DataProvider.Instance.ExecuteNonQuery("insert into NhaSanXuat(MaNSX, TenNSX, DiaChi) Values( '" + maNSX + "', N'" + tenNSX + "', N'" + diaChi + "')");

            return result > 0;
        }

        public string timNSXtheoma(string maNSX)
        {
            DataTable table = DataProvider.Instance.ExecuteQuery("SELECT * FROM NhaSanXuat WHERE MaNSX = '" + maNSX + "'");
            foreach (DataRow row in table.Rows)
            {
                NSXDTO NSXTim = new NSXDTO(row);
                return NSXTim.MaNSX;
            }
            return "";
        }

        public string timNSXtheomaMC(string maNSX)
        {
            DataTable table = DataProvider_MayChu.Instance.ExecuteQuery("SELECT * FROM NhaSanXuat WHERE MaNSX = '" + maNSX + "'");
            foreach (DataRow row in table.Rows)
            {
                NSXDTO NSXTim = new NSXDTO(row);
                return NSXTim.MaNSX;
            }
            return "";
        }


        //xóa  Sản Phẩm bằng Mã SP
        public bool xoaNSX(string maNSX)
        {
            int result = DataProvider.Instance.ExecuteNonQuery("DELETE NhaSanXuat WHERE MaNSX = '" + maNSX + "'");
            return result > 0;
        }

        //sửa thông tin
        public bool suaThongtinNSX(string maNSX, string tenNSX, string diaChi)
        {
            int result = DataProvider.Instance.ExecuteNonQuery("UPDATE NhaSanXuat SET TenNSX= N'" + tenNSX + "', DiaChi = N'"+ diaChi +"' WHERE MaNSX = '" + maNSX + "'");
            return result > 0;
        }
    }
}
