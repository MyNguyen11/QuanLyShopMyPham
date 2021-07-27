using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;

namespace QuanLyMyPham.DTO
{
   public class LoaiSPDTO
    {
        public string MaLoai { get; set; }
        public string TenLoai { get; set; }

        public LoaiSPDTO(string maLoai, string tenLoai)
        {
            this.MaLoai = maLoai;
            this.TenLoai = tenLoai;
        }

        public LoaiSPDTO(DataRow row)
        {
            this.MaLoai = row["maLoai"].ToString();
            this.TenLoai = row["tenLoai"].ToString();

        }
    }
}
