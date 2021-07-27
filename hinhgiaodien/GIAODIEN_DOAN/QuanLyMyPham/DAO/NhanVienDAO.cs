using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using QuanLyMyPham.DTO;
using System.Data;

namespace QuanLyMyPham.DAO
{
    public class NhanVienDAO
    {
        private static NhanVienDAO instance;

        public static NhanVienDAO Instance
        {
            get { if (instance == null) instance = new NhanVienDAO(); return instance; }
            private set { instance = value; }
        }

        private NhanVienDAO() { }

        public List<NhanVienDTO> LayDsNhanVien()
        {
            List<NhanVienDTO> danhSach = new List<NhanVienDTO>();

            string query = "SELECT * FROM NhanVien";
            DataTable data = DataProvider.Instance.ExecuteQuery(query);

            foreach (DataRow item in data.Rows)
            {
                danhSach.Add(new NhanVienDTO(item));
            }
            return danhSach;
        }



        public List<NhanVienDTO> LayDsNhanVienvp()
        {
            List<NhanVienDTO> danhSach = new List<NhanVienDTO>();

            string query = "SELECT * FROM NhanVien";
            DataTable data = DataProvider.Instance.ExecuteQuery(query);

            foreach (DataRow item in data.Rows)
            {
                danhSach.Add(new NhanVienDTO(item));
            }
            return danhSach;
        }


        public List<NhanVienDTO> LayDsNhanVienViPham(string maNV)
        {
            List<NhanVienDTO> danhSach = new List<NhanVienDTO>();

            string query = "SELECT MaNV,HoTen,Luong FROM NhanVien where MaNV = '"+maNV+"'";
            DataTable data = DataProvider.Instance.ExecuteQuery(query);

            foreach (DataRow item in data.Rows)
            {
                danhSach.Add(new NhanVienDTO(item));
            }
            return danhSach;
        }



        public bool themNhanVien(string maNV, string hoTen, string sdt, string queQuan, DateTime ngayVaoLam, string luong, string maCN, string phai)
        {
            int result = DataProvider.Instance.ExecuteNonQuery("insert into NhanVien(MaNV, HoTen, SDT, QueQuan, NgayVaoLam, Luong, MaCN, Phai) Values( '" + maNV + "', N'" + hoTen + "', N'" + sdt + "', '" + queQuan + "', N'" + ngayVaoLam + "', N'" + luong + "', N'" + maCN + "', N'" + phai + "')");

            return result > 0;
        }

        public string timNhanVientheoma(string maNV)
        {
            DataTable table = DataProvider.Instance.ExecuteQuery("SELECT * FROM NhanVien WHERE MaNV = '" + maNV + "'");
            foreach (DataRow row in table.Rows)
            {
                NhanVienDTO NhanVienTim = new NhanVienDTO(row);
                return NhanVienTim.MaNV;
            }
            return "";
        }

        public string timNhanVientheomaMC(string maNV)
        {
            DataTable table = DataProvider_MayChu.Instance.ExecuteQuery("SELECT * FROM NhanVien WHERE MaNV = '" + maNV + "'");
            foreach (DataRow row in table.Rows)
            {
                NhanVienDTO NhanVienTim = new NhanVienDTO(row);
                return NhanVienTim.MaNV;
            }
            return "";
        }


        //xóa  Sản Phẩm bằng Mã SP
        public bool xoaNhanVien(string maNV)
        {
            int result = DataProvider.Instance.ExecuteNonQuery("DELETE NhanVien WHERE MaNV = '" + maNV + "'");
            return result > 0;
        }

        //sửa thông tin
        public bool suaThongtinNhanVien(string maNV, string hoTen, string sdt, string queQuan, DateTime ngayVaoLam, string luong, string maCN, string phai)
        {
            int result = DataProvider.Instance.ExecuteNonQuery("UPDATE NhanVien SET HoTen = N'" + hoTen + "', SDT = N'" + sdt + "', QuaQuan = N'" + queQuan + "', NgayVaoLam = N'" + ngayVaoLam + "', Luong = N'" + luong + "', MaCN = N'" + maCN + "', Phai = N'" + phai + "' WHERE MaNV = '" + maNV + "'");
            return result > 0;
        }
    }
}
