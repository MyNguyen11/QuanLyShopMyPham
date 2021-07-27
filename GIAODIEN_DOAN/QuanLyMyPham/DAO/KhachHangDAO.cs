using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using QuanLyMyPham.DTO;

namespace QuanLyMyPham.DAO
{
    public class KhachHangDAO
    {
        private static KhachHangDAO instance;

        public static KhachHangDAO Instance
        {
            get { if (instance == null) instance = new KhachHangDAO(); return instance; }
            private set { instance = value; }
        }

        private KhachHangDAO() { }


        public List<KhachHangDTO> LayDsKhachHang()
        {
            List<KhachHangDTO> danhSach = new List<KhachHangDTO>();

            string query = "SELECT * FROM KhachHang";
            DataTable data = DataProvider.Instance.ExecuteQuery(query);

            foreach (DataRow item in data.Rows)
            {
                danhSach.Add(new KhachHangDTO(item));
            }
            return danhSach;
        }

        //Thêm Khách Hàng

        public bool themKhachHang(string maKH, string tenKH, string diaChi, string sdt, string email, string congViec, string phai, DateTime ngaySinh,string maCN)
        {
            int result = DataProvider.Instance.ExecuteNonQuery("insert into KhachHang(MaKH,TenKH,DiaChi,SDT,Email,CongViec,Phai,NgaySinh,MaCN) Values( '" + maKH + "', N'" + tenKH + "',N'"+diaChi+"','"+sdt+"','"+email+"',N'"+congViec+"',N'"+phai+"','"+ngaySinh+"','"+maCN+"')");

            return result > 0;
        }

        public string timKhachHangtheoma(string maKH)
        {
            DataTable table = DataProvider.Instance.ExecuteQuery("SELECT * FROM KhachHang WHERE MaKH = '" + maKH + "'");
            foreach (DataRow row in table.Rows)
            {
                KhachHangDTO KHTim = new KhachHangDTO(row);
                return KHTim.MaKH;
            }
            return "";
        }

        public string timKhachHangMCtheoma(string maKH)
        {
            DataTable table = DataProvider_MayChu.Instance.ExecuteQuery("SELECT * FROM KhachHang WHERE MaKH = '" + maKH + "'");
            foreach (DataRow row in table.Rows)
            {
                KhachHangDTO KHTim = new KhachHangDTO(row);
                return KHTim.MaKH;
            }
            return "";
        }



        //xóa Loại Sản Phẩm bằng Mã Loại
        public bool xoaKH(string maKH)
        {
            int result = DataProvider.Instance.ExecuteNonQuery("DELETE KhachHang WHERE MaKH = '" + maKH + "'");
            return result > 0;
        }

        //sửa thông tin
        public bool suaThongtinKH(string maKH, string tenKH, string diaChi, string sdt, string email, string congViec, string phai, DateTime ngaySinh,string maCN)
        {
            int result = DataProvider.Instance.ExecuteNonQuery("UPDATE KhachHang SET TenKH= N'" + tenKH + "', DiaChi=N'"+diaChi+"',SDT='"+sdt+"',Email='"+email+"', CongViec=N'"+congViec+"', Phai=N'"+phai+"', NgaySinh='"+ngaySinh+"', MaCN='"+maCN+"' WHERE MaKH = '" + maKH + "'");
            return result > 0;
        }



    }
}
