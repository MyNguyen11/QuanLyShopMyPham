using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;

namespace QuanLyMyPham.DTO
{
    public class NhanVienDTO
    {
        public string MaNV { get; set; }
        public string HoTen { get; set; }
        public string SDT { get; set; }
        public string QueQuan { get; set; }
        public DateTime NgayVaoLam { get; set; }
        public string Luong { get; set; }
        public string MaCN { get; set; }
        public string Phai { get; set; }

        public NhanVienDTO(string maNV, string hoTen, string sdt,string queQuan, DateTime ngayVaoLam,string luong,string maCN,string phai)
        {
            this.MaNV = maNV;
            this.HoTen = hoTen;
            this.SDT = sdt;
            this.QueQuan = queQuan;
            this.NgayVaoLam = ngayVaoLam;
            this.Luong = luong;
            this.MaCN = maCN;
            this.Phai = phai;

        }

        public NhanVienDTO(DataRow row)
        {
            this.MaNV = row["maNV"].ToString();
            this.HoTen = row["hoTen"].ToString();
            this.SDT = row["sdt"].ToString();
            this.QueQuan = row["queQuan"].ToString();
            this.NgayVaoLam = (DateTime)row["ngayVaoLam"];
            this.Luong = row["luong"].ToString();
            this.MaCN = row["maCN"].ToString();
            this.Phai = row["phai"].ToString();
        }
    }
}
