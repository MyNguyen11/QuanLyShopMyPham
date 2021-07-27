using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;



namespace QuanLyMyPham.DTO
{
    public class SanPhamDTO
    {
        public string MaSP { get; set; }
        public string TenSP { get; set; }
        public string Hinh { get; set; }
        public string Size { get; set; }
        public string GiaNhap { get; set; }
        public string GiaBan { get; set; }
        public string MaNSX { get; set; }
        public string MaLoai { get; set; }

        public SanPhamDTO(string maSP, string tenSP, string hinh, string size, string giaNhap, string giaBan, string maNSX, string maLoai)
        {
            this.MaSP = maSP;
            this.TenSP = tenSP;
            this.Hinh = hinh;
            this.Size = size;
            this.GiaNhap = giaNhap;
            this.GiaBan = giaBan;
            this.MaNSX = maNSX;
            this.MaLoai = maLoai;
        }

        public SanPhamDTO(DataRow row)
        {
            this.MaSP = row["maSP"].ToString();
            this.TenSP = row["tenSP"].ToString();
            this.Hinh = row["hinh"].ToString(); 
            this.Size = row["size"].ToString(); 
            this.GiaNhap = row["giaNhap"].ToString(); 
            this.GiaBan = row["giaBan"].ToString(); 
            this.MaNSX = row["maNSX"].ToString();
            this.MaLoai = row["maLoai"].ToString();

        }

    }
}
