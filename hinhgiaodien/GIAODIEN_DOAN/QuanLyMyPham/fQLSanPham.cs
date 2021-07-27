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
    public partial class fQLSanPham : Form
    {
        BindingSource dsSanPham = new BindingSource();

        public fQLSanPham()
        {
            InitializeComponent();
            dgvSanPham.DataSource = dsSanPham;
            hienThiSanPham();
            taoRangBuoc();
            hienThiMaLoai();
            hienThiMaNSX();
        }


        void hienThiSanPham()
        {
            dsSanPham.DataSource = SanPhamDAO.Instance.LayDsSanPham();

            dgvSanPham.Columns[0].HeaderText = "Mã Sản Phẩm";
            dgvSanPham.Columns[0].Width = 120;

            dgvSanPham.Columns[1].HeaderText = "Tên Sản Phẩm";
            dgvSanPham.Columns[1].Width = 180;

            dgvSanPham.Columns[2].HeaderText = "Hình";
            dgvSanPham.Columns[2].Width = 100;

            dgvSanPham.Columns[3].HeaderText = "Size";
            dgvSanPham.Columns[3].Width = 155;

            dgvSanPham.Columns[4].HeaderText = "Giá Nhập";
            dgvSanPham.Columns[4].Width = 160;

            dgvSanPham.Columns[5].HeaderText = "Giá Bán";
            dgvSanPham.Columns[5].Width = 160;

            dgvSanPham.Columns[6].HeaderText = "Mã Nhà Sản Xuát";
            dgvSanPham.Columns[6].Width = 160;

            dgvSanPham.Columns[7].HeaderText = "Mã Loại";
            dgvSanPham.Columns[7].Width = 160;

        }

        void taoRangBuoc()
        {
            txtMaSP.DataBindings.Add("text", dgvSanPham.DataSource, "maSP", true, DataSourceUpdateMode.Never);
            txtTenSP.DataBindings.Add("text", dgvSanPham.DataSource, "tenSP", true, DataSourceUpdateMode.Never);
            txtHinh.DataBindings.Add("text", dgvSanPham.DataSource, "hinh", true, DataSourceUpdateMode.Never);
            txtTheTich.DataBindings.Add("text", dgvSanPham.DataSource, "size", true, DataSourceUpdateMode.Never);
            txtGiaNhap.DataBindings.Add("text", dgvSanPham.DataSource, "giaNhap", true, DataSourceUpdateMode.Never);
            txtGiaBan.DataBindings.Add("text", dgvSanPham.DataSource, "giaBan", true, DataSourceUpdateMode.Never);
            cbMaNSX.DataBindings.Add("text", dgvSanPham.DataSource, "maNSX", true, DataSourceUpdateMode.Never);
            cbMaLoai.DataBindings.Add("text", dgvSanPham.DataSource, "maLoai", true, DataSourceUpdateMode.Never);

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

        void hienThiMaNSX()
        {
            List<NSXDTO> dsmansx = NSXDAO.Instance.LayDsNSX();
            for (int i = 0; i < dsmansx.Count - 1; i++)
            {
                for (int j = i + 1; j < dsmansx.Count; j++)
                {
                    if (dsmansx.ElementAt(i).MaNSX.Contains(dsmansx.ElementAt(j).MaNSX))
                        dsmansx.RemoveAt(j);
                }
            }

            cbMaNSX.DataSource = dsmansx;
            cbMaNSX.DisplayMember = "maNSX";

        }

        private void button1_Click(object sender, EventArgs e)
        {
            fGiaoDienChinh f = new fGiaoDienChinh();
            f.Show();
            this.Dispose(false);
        }

        private void btnthem_Click(object sender, EventArgs e)
        {
            txtMaSP.Enabled = true;
            txtTenSP.Enabled = true;
            txtHinh.Enabled = true;
            txtTheTich.Enabled = true;
            txtGiaNhap.Enabled = true;
            txtGiaBan.Enabled = true;
            cbMaLoai.Enabled = true;
            cbMaNSX.Enabled = true;
            btnluu.Enabled = true;
            btnsua.Enabled = true;
            btnxoa.Enabled = true;
        }

        private void btnluu_Click(object sender, EventArgs e)
        {
            themDuLieu();
        }

        private void fQLSanPham_Load(object sender, EventArgs e)
        {
            txtMaSP.Enabled = false;
            txtTenSP.Enabled = false;
            txtHinh.Enabled = false;
            txtTheTich.Enabled = false;
            txtGiaNhap.Enabled = false;
            txtGiaBan.Enabled = false;
            cbMaLoai.Enabled = false;
            cbMaNSX.Enabled = false;
            btnluu.Enabled = false;
            btnsua.Enabled = false;
            btnxoa.Enabled = false;
        }

        void themDuLieu()
        {
            try
            {
                string maSP = txtMaSP.Text;
                string tenSP = txtTenSP.Text;
                string hinh = txtHinh.Text;
                string size = txtTheTich.Text;
                string giaNhap = txtGiaNhap.Text;
                string giaBan = txtGiaBan.Text;
                string maNSX = cbMaNSX.Text;
                string maLoai = cbMaLoai.Text;

                if (maSP == ""|| tenSP == "" || hinh == ""||giaBan==""||giaNhap=="")
                    MessageBox.Show("Bạn phải nhập đủ thông tin sản phẩm!", "Thêm sản phẩm", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                else
                {
                    string SanPhamTim = SanPhamDAO.Instance.timSanPhamtheoma(maSP).ToLower();
                    string SanPhamTimMC = SanPhamDAO.Instance.timSanPhamtheomaMC(maSP).ToLower();
                    if (SanPhamTim == maSP.ToLower() || SanPhamTimMC == maSP.ToLower())

                        MessageBox.Show("Lỗi!! Trùng mã Sản Phẩm ở chi nhánh mình hay ở chi nhánh khách rồi bạn ơi!!", "Thêm sản phẩm", MessageBoxButtons.OK, MessageBoxIcon.Warning);

                    else
                    {
                        bool ketQua = SanPhamDAO.Instance.themsanpham(maSP, tenSP, hinh, size, giaNhap, giaBan, maNSX, maLoai);
                        if (ketQua)
                        {
                            MessageBox.Show("Thêm thành công!", "Thêm sản phẩm", MessageBoxButtons.OK, MessageBoxIcon.Information);
                            hienThiSanPham();
                        }
                        else
                            MessageBox.Show("Thêm không thành công!", "Thêm sản phẩm", MessageBoxButtons.OK, MessageBoxIcon.Error);
                    }
                }
            }
            catch (Exception)
            {
                MessageBox.Show("Lỗi nhập!", "Thêm sản phẩm", MessageBoxButtons.OK, MessageBoxIcon.Warning);
            }
        }

        private void btnsua_Click(object sender, EventArgs e)
        {
            try
            {
                string maSP = txtMaSP.Text;
                string tenSP = txtTenSP.Text;
                string hinh = txtHinh.Text;
                string size = txtTheTich.Text;
                string giaNhap = txtGiaNhap.Text;
                string giaBan = txtGiaBan.Text;
                string maNSX = cbMaNSX.Text;
                string maLoai = cbMaLoai.Text;

                bool ketQua = SanPhamDAO.Instance.suaThongtinSP(maSP, tenSP, hinh, size, giaNhap, giaBan, maNSX, maLoai);

                if (ketQua)
                {
                    MessageBox.Show("Sửa thành công!", "Sửa thông tin sản phẩm", MessageBoxButtons.OK, MessageBoxIcon.Information);
                    hienThiSanPham();
                }
                else
                    MessageBox.Show("Sửa không thành công!", "Sửa thông tin sản phẩm", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
            catch (Exception)
            {
                MessageBox.Show("Lỗi định dạng nhập! Vui lòng kiểm tra lại", "Sửa thông tin sản phẩm", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private void btnxoa_Click(object sender, EventArgs e)
        {
            string maSP = txtMaSP.Text;
            if (maSP== "")
                MessageBox.Show("Bạn chưa chọn mã khách hàng", "Xóa Thông Tin sản phẩm", MessageBoxButtons.OK, MessageBoxIcon.Warning);
            else
            {
                SanPhamDAO.Instance.xoaSP(maSP);
                hienThiSanPham();
            }
        }
    }
}
