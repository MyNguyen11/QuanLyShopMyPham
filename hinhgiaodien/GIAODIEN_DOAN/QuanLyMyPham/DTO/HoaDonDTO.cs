using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace QuanLyMyPham.DTO
{
    public class HoaDonDTO
    {
        public string MaHD { get; set; }
        public string MaKH { get; set; }
        public string MaSP { get; set; }
        public string MaCN { get; set; }
        public string MaNV { get; set; }
        public string TenSP { get; set; }
        public string SoLuong { get; set; }
        public string GiaBan { get; set; }
        public string TongTien { get; set; }
        public string NgayLap { get; set; }

        public HoaDonDTO(string maHD, string maKH, string maSP, string maCN, string maNV, string tenSP, string soLuong, string giaBan, string tongTien, string ngayLap)
        {
            this.MaHD = maHD;
            this.MaKH = maKH;
            this.MaSP = maSP;
            this.MaCN = maCN;
            this.MaNV = maNV;
            this.TenSP = tenSP;
            this.SoLuong = soLuong;
            this.GiaBan = giaBan;
            this.TongTien = tongTien;
            this.NgayLap = ngayLap;
        }

        public HoaDonDTO(DataRow row)
        {
            this.MaHD = row["maHD"].ToString();
            this.MaKH = row["maKH"].ToString();
            this.MaSP = row["maSP"].ToString();
            this.MaCN = row["maCN"].ToString();
            this.MaNV = row["maNV"].ToString();
            this.TenSP = row["tenSP"].ToString();
            this.SoLuong = row["soLuong"].ToString();
            this.GiaBan = row["giaBan"].ToString();
            this.TongTien = row["tongTien"].ToString();
            this.NgayLap =row["ngayLap"].ToString();
        }
    }
}
