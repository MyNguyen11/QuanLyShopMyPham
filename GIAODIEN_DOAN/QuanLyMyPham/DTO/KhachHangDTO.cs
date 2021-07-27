using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;

namespace QuanLyMyPham.DTO
{
    public class KhachHangDTO
    {
        public string MaKH { get; set; }
        public string TenKH { get; set; }
        public string DiaChi { get; set; }
        public string SDT { get; set; }
        public string Email { get; set; }
        public string CongViec { get; set; }
        public string Phai { get; set; }
        public DateTime NgaySinh { get; set; }
        public string MaCN { get; set; }

        public KhachHangDTO(string maKH, string tenKH, string diaChi, string sdt, string email, string congViec, string phai, DateTime ngaySinh,string maCN)
        {
            this.MaKH = maKH;
            this.TenKH = tenKH;
            this.DiaChi = diaChi;
            this.SDT = sdt;
            this.Email=email;
            this.CongViec=congViec;
            this.Phai = phai;
            this.NgaySinh = ngaySinh;
            this.MaCN = maCN;
        }

        public KhachHangDTO(DataRow row)
        {
            this.MaKH = row["maKH"].ToString();
            this.TenKH = row["tenKH"].ToString();
            this.DiaChi = row["diaChi"].ToString();
            this.SDT = row["sdt"].ToString();
            this.Email = row["email"].ToString();
            this.CongViec = row["congViec"].ToString();
            this.Phai = row["phai"].ToString();
            this.NgaySinh = (DateTime)row["ngaySinh"];
            this.MaCN= row["maCN"].ToString();
        }
    }
}
