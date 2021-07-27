using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data.SqlClient;
using System.Data;

namespace QuanLyMyPham.DTO
{
   public class NhaKhoDTO
    {
        public string MaKho { get; set; }
        public string MaLoai { get; set; }
        public string MaSP { get; set; }
        public string SLNhap { get; set; }
        public string SLTon { get; set; }
        public string MaCN { get; set; }

        public NhaKhoDTO(string maKho, string maLoai, string maSP, string slNhap,string slTon, string maCN)
        {
            this.MaKho = maKho;
            this.MaLoai = maLoai;
            this.MaSP= maSP;
            this.SLNhap = slNhap;
            this.SLTon = slTon;
            this.MaCN = maCN;

        }

        public NhaKhoDTO(DataRow row)
        {
            this.MaKho = row["maKho"].ToString();
            this.MaLoai = row["maLoai"].ToString();
            this.MaSP = row["maSP"].ToString();
            this.SLNhap = row["slNhap"].ToString();
            this.SLTon = row["slTon"].ToString();
            this.MaCN = row["maCN"].ToString();
        }
    }
}
