using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;

namespace QuanLyMyPham.DTO
{
   public class QuanLyDTO
    {
        public string MaQL { get; set; }
      //  public string TenNguoiQL { get; set; }
        public string SDT { get; set; }


        public QuanLyDTO(string maQL, string tenNguoiQL, string sdt)
        {
            this.MaQL = maQL;
           // this.TenNguoiQL = tenNguoiQL;
            this.SDT =sdt;
        }

    public QuanLyDTO(DataRow row)
    {
        this.MaQL = row["maQL"].ToString();
       // this.TenNguoiQL = row["tenNguoiQL"].ToString();
        this.SDT = row["sdt"].ToString();
    }
    }
}
