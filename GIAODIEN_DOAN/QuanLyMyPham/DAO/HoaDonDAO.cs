using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using QuanLyMyPham.DTO;

namespace QuanLyMyPham.DAO
{
    public class HoaDonDAO
    {
        private static HoaDonDAO instance;

        public static HoaDonDAO Instance
        {
            get { if (instance == null) instance = new HoaDonDAO(); return instance; }
            private set { instance = value; }
        }

        private HoaDonDAO() { }

        public List<HoaDonDTO> LayDsHoaDon()
        {
            List<HoaDonDTO> danhSach = new List<HoaDonDTO>();

            string query = "SELECT * FROM HoaDon";
            DataTable data = DataProvider.Instance.ExecuteQuery(query);

            foreach (DataRow item in data.Rows)
            {
                danhSach.Add(new HoaDonDTO(item));
            }
            return danhSach;
        }

        

        public List<HoaDonDTO> TimHD(string maHD)
        {
            List<HoaDonDTO> danhSach = new List<HoaDonDTO>();

            string query = "SELECT * FROM HoaDon where MaHD = '"+maHD+"' ";
            DataTable data = DataProvider.Instance.ExecuteQuery(query);

            foreach (DataRow item in data.Rows)
            {
                danhSach.Add(new HoaDonDTO(item));
            }
            return danhSach;
            
        }


        public string timHDtheoma(string maHD)
        {
            DataTable table = DataProvider.Instance.ExecuteQuery("SELECT * FROM HoaDon WHERE MaHD = '" + maHD + "'");
            foreach (DataRow row in table.Rows)
            {
                HoaDonDTO HoaDonTim = new HoaDonDTO(row);
                return HoaDonTim.MaHD;
            }
            return "";
        }
   


        public List<NhanVienDTO> TimNV(string maNV)
        {
            List<NhanVienDTO> danhSach = new List<NhanVienDTO>();

            string query = "SELECT * FROM NhanVien where MaNV = '" + maNV + "' ";
            DataTable data = DataProvider.Instance.ExecuteQuery(query);

            foreach (DataRow item in data.Rows)
            {
                danhSach.Add(new NhanVienDTO(item));
            }
            return danhSach;

        }


        public bool xoaHoaDontheomaSP(string maHD,string maSP)
        {
            int result = DataProvider.Instance.ExecuteNonQuery("DELETE HoaDon WHERE MaHD = '" + maHD + "' And MaSP ='"+maSP+"'");
            return result > 0;
        }

        public bool xoaHoaDontheomaHd(string maHD)
        {
            int result = DataProvider.Instance.ExecuteNonQuery("DELETE HoaDon WHERE MaHD = '" + maHD + "'");
            return result > 0;
        }


        //sửa thông tin
        public bool suaThongTinHoaDon(string maHD, string maKH, string maSP, string maCN, string maNV, string tenSP, string soLuong, string giaBan, string tongTien, string ngayLap)
        {
            int result = DataProvider.Instance.ExecuteNonQuery("UPDATE HoaDon SET TenSP= N'" + tenSP + "', MaKH='"+maKH+"',MaSP='"+maSP+"', SoLuong='"+soLuong+"' ,TongTien='"+tongTien+"'  WHERE MaHD = '" + maHD + "'");
            return result > 0;
        }


       



    }
}
