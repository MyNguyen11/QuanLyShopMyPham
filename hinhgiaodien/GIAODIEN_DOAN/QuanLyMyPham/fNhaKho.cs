using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using QuanLyMyPham.DAO;
using QuanLyMyPham.DTO;

namespace QuanLyMyPham
{
    public partial class fNhaKho : Form
    {
        BindingSource dsNhaKho = new BindingSource();

        public fNhaKho()
        {
            InitializeComponent();
            dgvNhaKho.DataSource = dsNhaKho;
            hienthiDanhSachNhaKho();
            taorangbuoc();
            hienThiMaLoai();
            hienThiMaSP();

        }

        private void button1_Click(object sender, EventArgs e)
        {
            fGiaoDienChinh f = new fGiaoDienChinh();
            f.Show();
            this.Dispose(false);
        }

        //void LoadListBillByDate(DateTime ThangDauVao, DateTime ThangCuoi)
        //{
        //    dgvNhaKho.DataSource = HoaDonDAO.Instance.GetBillListByDate(ThangDauVao, ThangCuoi);
        //}

        void hienthiDanhSachNhaKho()
        {
            dsNhaKho.DataSource = NhaKhoDAO.Instance.LayDsNhaKho();

            dgvNhaKho.Columns[0].HeaderText = "Mã Nhà Kho";
            dgvNhaKho.Columns[0].Width = 100;

            dgvNhaKho.Columns[1].HeaderText = "Mã Loại";
            dgvNhaKho.Columns[1].Width = 135;

            dgvNhaKho.Columns[2].HeaderText = "Mã Sản Phẩm";
            dgvNhaKho.Columns[2].Width = 100;

            dgvNhaKho.Columns[3].HeaderText = "Số Lượng Nhập";
            dgvNhaKho.Columns[3].Width = 135;

            dgvNhaKho.Columns[4].HeaderText = "Số Lượng Tồn";
            dgvNhaKho.Columns[4].Width = 100;

            dgvNhaKho.Columns[5].HeaderText = "Mã Chi Nhánh";
            dgvNhaKho.Columns[5].Width = 85;


        }

        void taorangbuoc()
        {
            txtMaNK.DataBindings.Add("text", dgvNhaKho.DataSource, "maKho", true, DataSourceUpdateMode.Never);
            cbMaLoai.DataBindings.Add("text", dgvNhaKho.DataSource, "maLoai", true, DataSourceUpdateMode.Never);
            cbMaSP.DataBindings.Add("Text", dgvNhaKho.DataSource, "maSP", true, DataSourceUpdateMode.Never);
            txtSLNhap.DataBindings.Add("Text", dgvNhaKho.DataSource, "slNhap", true, DataSourceUpdateMode.Never);
            txtSLTon.DataBindings.Add("text", dgvNhaKho.DataSource, "slTon", true, DataSourceUpdateMode.Never);
            txtMaCN.DataBindings.Add("Text", dgvNhaKho.DataSource, "maCN", true, DataSourceUpdateMode.Never);
        }

        private void btnthem_Click(object sender, EventArgs e)
        {
            txtMaNK.Enabled = true;
            cbMaLoai.Enabled = true;
            cbMaSP.Enabled = true;
            txtSLNhap.Enabled = true;
            txtSLTon.Enabled = true;
            txtMaCN.Enabled = true;
            btnluu.Enabled = true;
            btnsua.Enabled = true;
        }

        private void fNhaKho_Load(object sender, EventArgs e)
        {
            txtMaNK.Enabled = false;
            cbMaLoai.Enabled = false;
            cbMaSP.Enabled = false;
            txtSLNhap.Enabled = false;
            txtSLTon.Enabled = false;
            txtMaCN.Enabled = false;
            btnluu.Enabled = false;
            btnsua.Enabled = false;
        }

        void hienThiMaSP()
        {
            List<SanPhamDTO> dsmasp = SanPhamDAO.Instance.LayDsSanPham();
            for (int i = 0; i < dsmasp.Count - 1; i++)
            {
                for (int j = i + 1; j < dsmasp.Count; j++)
                {
                    if (dsmasp.ElementAt(i).MaSP.Contains(dsmasp.ElementAt(j).MaSP))
                        dsmasp.RemoveAt(j);
                }
            }

            cbMaSP.DataSource = dsmasp;
            cbMaSP.DisplayMember = "maSP";

        }


        void hienThiMaLoai()
        {
            List<LoaiSPDTO> dsmaloai = LoaiSPDAO.Instance.LayDsLoaiSP();
            for (int i = 0; i < dsmaloai.Count - 1; i++)
            {
                for (int j = i + 1; j < dsmaloai.Count; j++)
                {
                    if (dsmaloai.ElementAt(i).MaLoai.Contains(dsmaloai.ElementAt(j).MaLoai))
                        dsmaloai.RemoveAt(j);
                }
            }

            cbMaLoai.DataSource = dsmaloai;
            cbMaLoai.DisplayMember = "maLoai";

        }


        void themDuLieu()
        {
            try
            {
                string maKho = txtMaNK.Text;
                string maLoai = cbMaLoai.Text;
                string maSP = cbMaSP.Text;
                string slTon = txtSLNhap.Text;
                string slNhap = txtSLNhap.Text;
                string maCN = txtMaCN.Text;


                if (maKho == "" || maLoai == "" || maSP == "")
                    MessageBox.Show("Bạn phải nhập đủ thông tin vào kho!", "Nhập Nhà Kho", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                else
                { 
                        bool ketQua = NhaKhoDAO.Instance.themNhaKho(maKho, maLoai, maSP, slNhap, slTon, maCN);
                        if (ketQua)
                        {
                            MessageBox.Show("Thêm thành công!", "Nhập Kho", MessageBoxButtons.OK, MessageBoxIcon.Information);
                            hienthiDanhSachNhaKho();
                        }
                        else
                            MessageBox.Show("Thêm không thành công!", "Nhập Kho", MessageBoxButtons.OK, MessageBoxIcon.Error);
                    //}
                }
        }
            catch (Exception)
            {
                MessageBox.Show("Lỗi nhập!", "Nhập Kho", MessageBoxButtons.OK, MessageBoxIcon.Warning);
            }

}

        private void btnluu_Click(object sender, EventArgs e)
        {
            themDuLieu();
        }

        private void btnsua_Click(object sender, EventArgs e)
        {
            try
            {
                string maKho = txtMaNK.Text;
                string maLoai = cbMaLoai.Text;
                string maSP = cbMaSP.Text;
                string slNhap = txtSLNhap.Text;
                string slTon = txtSLNhap.Text;
                string maCN = txtMaCN.Text;

                bool ketQua = NhaKhoDAO.Instance.suaThongtinKho(maKho, maLoai, maSP, slNhap, slTon, maCN);

                if (ketQua)
                {
                    MessageBox.Show("Sửa thành công!", "Sửa thông tin sản phẩm trong kho", MessageBoxButtons.OK, MessageBoxIcon.Information);
                    hienthiDanhSachNhaKho();
                }
                else
                    MessageBox.Show("Sửa không thành công!", "Sửa thông tin sản phẩm trong kho", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
            catch (Exception)
            {
                MessageBox.Show("Lỗi định dạng nhập! Vui lòng kiểm tra lại", "Sửa thông tin sản phẩm trong kho", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }
    }
}
