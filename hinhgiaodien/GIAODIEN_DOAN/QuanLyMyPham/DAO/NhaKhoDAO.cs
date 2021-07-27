using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using QuanLyMyPham.DTO;
using System.Data;
namespace QuanLyMyPham.DAO
{
    public class NhaKhoDAO
    {

        private static NhaKhoDAO instance;

        public static NhaKhoDAO Instance
        {
            get { if (instance == null) instance = new NhaKhoDAO(); return instance; }
            private set { instance = value; }
        }

        private NhaKhoDAO() { }

        public List<NhaKhoDTO> LayDsNhaKho()
        {
            List<NhaKhoDTO> danhSach = new List<NhaKhoDTO>();

            string query = "SELECT * FROM NhaKho";
            DataTable data = DataProvider.Instance.ExecuteQuery(query);

            foreach (DataRow item in data.Rows)
            {
                danhSach.Add(new NhaKhoDTO(item));
            }
            return danhSach;
        }



        public bool themNhaKho(string maKho, string maLoai, string maSP, string slNhap, string slTon, string maCN)
        {
            int result = DataProvider.Instance.ExecuteNonQuery("insert into NhaKho(MaKho,MaLoai,MaSP,SLNhap,SLTon,MaCN) Values( '" + maKho + "', N'" + maLoai + "', N'" + maSP + "', '" + slNhap + "', '" + slTon + "', '" + maCN + "')");

            return result > 0;
        }

        //public string timtheomakho(string maLoai,string maSP)
        //{
        //    DataTable table = DataProvider.Instance.ExecuteQuery("SELECT * FROM NhaKho WHERE MaLoai='"+maLoai+"',MaSP='"+maSP+"'");
        //    foreach (DataRow row in table.Rows)
        //    {
        //        NhaKhoDTO NhaKhoTim = new NhaKhoDTO(row);
        //        return NhaKhoTim.MaKho;
        //    }
        //    return "";
        //}



      

        public bool suaThongtinKho(string maKho, string maLoai, string maSP, string slNhap, string slTon, string maCN)
        {
            int result = DataProvider.Instance.ExecuteNonQuery("UPDATE NhaKho SET MaLoai = N'" + maLoai + "', MaSP = N'" + maSP + "', SLNhap = N'" +slNhap+ "', SLTon = N'" +slTon+ "'  WHERE MaKho = '" + maKho + "' and MaSP='"+maSP+"' AND MaLoai='"+maLoai+"'");
            return result > 0;
        }

    }
}
