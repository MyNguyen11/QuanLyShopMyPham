using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using QuanLyMyPham.DTO;
using System.Data;

namespace QuanLyMyPham.DAO
{
    public class LoaiSPDAO
    {
        private static LoaiSPDAO instance;

        public static LoaiSPDAO Instance
        {
            get { if (instance == null) instance = new LoaiSPDAO(); return instance; }
            private set { instance = value; }
        }

        private LoaiSPDAO() { }

        public List<LoaiSPDTO> LayDsLoaiSP()
        {
            List<LoaiSPDTO> danhSach = new List<LoaiSPDTO>();

            string query = "SELECT * FROM LoaiSP";
            DataTable data = DataProvider.Instance.ExecuteQuery(query);

            foreach (DataRow item in data.Rows)
            {
                danhSach.Add(new LoaiSPDTO(item));
            }
            return danhSach;
        }




        //Thêm Khách Hàng

        public bool themLoaiSP(string maLoai, string tenLoai)
        {
            int result = DataProvider.Instance.ExecuteNonQuery("insert into LoaiSP(MaLoai, TenLoai) Values( '" + maLoai + "', N'" + tenLoai + "')");

            return result > 0;
        }

        public string timLoaiSPtheoma(string maLoai)
        {
            DataTable table = DataProvider.Instance.ExecuteQuery("SELECT * FROM LoaiSP WHERE MaLoai = '" + maLoai + "'");
            foreach (DataRow row in table.Rows)
            {
                LoaiSPDTO LoaiSPTim = new LoaiSPDTO(row);
                return LoaiSPTim.MaLoai;
            }
            return "";
        }

        public string timLoaiSPtheomaMC(string maLoai)
        {
            DataTable table = DataProvider_MayChu.Instance.ExecuteQuery("SELECT * FROM LoaiSP WHERE MaLoai = '" + maLoai + "'");
            foreach (DataRow row in table.Rows)
            {
                LoaiSPDTO LoaiSPTim = new LoaiSPDTO(row);
                return LoaiSPTim.MaLoai;
            }
            return "";
        }


        //xóa  Sản Phẩm bằng Mã SP
        public bool xoaLoaiSP(string maLoai)
        {
            int result = DataProvider.Instance.ExecuteNonQuery("DELETE LoaiSP WHERE MaLoai = '" + maLoai + "'");
            return result > 0;
        }

        //sửa thông tin
        public bool suaThongtinLoaiSP(string maLoai, string tenLoai)
        {
            int result = DataProvider.Instance.ExecuteNonQuery("UPDATE LoaiSP SET TenLoai= N'" + tenLoai + "' WHERE MaLoai = '" + maLoai + "'");
            return result > 0;
        }

    }
}
