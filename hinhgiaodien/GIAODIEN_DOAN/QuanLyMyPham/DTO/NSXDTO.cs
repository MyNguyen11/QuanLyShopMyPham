using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;

namespace QuanLyMyPham.DTO
{
   public class NSXDTO
    {
        public string MaNSX { get; set; }
        public string TenNSX{ get; set; }
        public string DiaChi { get; set; }

        public NSXDTO(string maNSX, string tenNSX, string diaChi)
        {
            this.MaNSX = maNSX;
            this.TenNSX = tenNSX;
            this.DiaChi = DiaChi;       
        }

        public NSXDTO(DataRow row)
        {
            this.MaNSX = row["maNSX"].ToString();
            this.TenNSX= row["tenNSX"].ToString();
            this.DiaChi = row["diaChi"].ToString();         
        }

    }
}
