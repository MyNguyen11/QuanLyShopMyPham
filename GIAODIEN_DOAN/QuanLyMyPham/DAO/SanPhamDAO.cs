using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using QuanLyMyPham.DTO;
using System.Data;


namespace QuanLyMyPham.DAO
{
    public class SanPhamDAO
    {
        private static SanPhamDAO instance;

        public static SanPhamDAO Instance
        {
            get { if (instance == null) instance = new SanPhamDAO(); return instance; }
            private set { instance = value; }
        }

        private SanPhamDAO() { }

        public static int TableWidth = 130;
        public static int TableHeight = 130;

        public List<SanPhamDTO> LayDsSanPham()
        {
            List<SanPhamDTO> danhSach = new List<SanPhamDTO>();

            string query = "SELECT * FROM SanPham";
            DataTable data = DataProvider.Instance.ExecuteQuery(query);

            foreach (DataRow item in data.Rows)
            {
                danhSach.Add(new SanPhamDTO(item));
            }
            return danhSach;
        }


        //Thêm Khách Hàng

        public bool themsanpham(string maSP, string tenSP, string hinh, string size, string giaNhap, string giaBan, string maNSX, string maLoai)
        {
            int result = DataProvider.Instance.ExecuteNonQuery("insert into SanPham(MaSP,TenSP,Hinh,Size,GiaNhap,GiaBan,MaNSX,MaLoai) Values( '" + maSP + "', N'" + tenSP + "',N'" + hinh + "','" + size + "','" + giaNhap + "',N'" + giaBan + "',N'" + maNSX + "','" + maLoai + "')");

            return result > 0;
        }

        public string timSanPhamtheoma(string maSP)
        {
            DataTable table = DataProvider.Instance.ExecuteQuery("SELECT * FROM SanPham WHERE MaSP = '" + maSP + "'");
            foreach (DataRow row in table.Rows)
            {
                SanPhamDTO SPTim= new SanPhamDTO(row);
                return SPTim.MaSP;
            }
            return "";
        }

        public string timSanPhamtheomaMC(string maSP)
        {
            DataTable table = DataProvider_MayChu.Instance.ExecuteQuery("SELECT * FROM SanPham WHERE MaSP = '" + maSP + "'");
            foreach (DataRow row in table.Rows)
            {
                SanPhamDTO SPTim = new SanPhamDTO(row);
                return SPTim.MaSP;
            }
            return "";
        }


        //xóa  Sản Phẩm bằng Mã SP
        public bool xoaSP(string maSP)
        {
            int result = DataProvider.Instance.ExecuteNonQuery("DELETE SanPham WHERE MaSP = '" + maSP + "'");
            return result > 0;
        }

        //sửa thông tin
        public bool suaThongtinSP(string maSP, string tenSP, string hinh, string size, string giaNhap, string giaBan, string maNSX, string maLoai)
        {
            int result = DataProvider.Instance.ExecuteNonQuery("UPDATE SanPham SET TenSP= N'" + tenSP + "', Hinh='" + hinh + "',Size='" + size + "',GiaNhap='" +giaNhap+ "', GiaBan='" + giaBan + "', MaNSX=N'" + maNSX + "', MaLoai='" + maLoai + "' WHERE MaSP = '" + maSP + "'");
            return result > 0;
        }




    }
}
