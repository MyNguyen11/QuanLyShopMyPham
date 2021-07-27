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
    public partial class fQLNhanVien : Form
    {
        BindingSource dsNhanvien = new BindingSource();

        public fQLNhanVien()
        {
            InitializeComponent();
            dgvNhanVien.DataSource = dsNhanvien;
            hienThiNhanVien();
            taoRangBuoc();
          
        }


        void hienThiNhanVien()
        {
            dsNhanvien.DataSource =NhanVienDAO.Instance.LayDsNhanVien();

            dgvNhanVien.Columns[0].HeaderText = "Mã Nhân Viên";
            dgvNhanVien.Columns[0].Width = 100;

            dgvNhanVien.Columns[1].HeaderText = "Tên Nhân Viên";
            dgvNhanVien.Columns[1].Width = 135;

            dgvNhanVien.Columns[2].HeaderText = "Số Điện Thoại";
            dgvNhanVien.Columns[2].Width = 100;

            dgvNhanVien.Columns[3].HeaderText = "Quê Quán";
            dgvNhanVien.Columns[3].Width = 135;

            dgvNhanVien.Columns[4].HeaderText = "Ngày vào làm";
            dgvNhanVien.Columns[4].Width = 100;

            dgvNhanVien.Columns[5].HeaderText = "Lương";
            dgvNhanVien.Columns[5].Width = 85;

            dgvNhanVien.Columns[6].HeaderText = "Phái";
            dgvNhanVien.Columns[6].Width = 50;

            dgvNhanVien.Columns[7].HeaderText = "Mã chi nhánh";
            dgvNhanVien.Columns[7].Width = 95;

        }

        void taoRangBuoc()
        {
            txtmanv.DataBindings.Add("text", dgvNhanVien.DataSource, "maNV", true, DataSourceUpdateMode.Never);
            txttennv.DataBindings.Add("text", dgvNhanVien.DataSource, "hoTen", true, DataSourceUpdateMode.Never);
            txtsdt.DataBindings.Add("text", dgvNhanVien.DataSource, "sdt", true, DataSourceUpdateMode.Never);
            txtquequan.DataBindings.Add("text", dgvNhanVien.DataSource, "queQuan", true, DataSourceUpdateMode.Never);
            datengayvaolam.DataBindings.Add("text", dgvNhanVien.DataSource, "ngayVaoLam", true, DataSourceUpdateMode.Never);
            txtluong.DataBindings.Add("text", dgvNhanVien.DataSource, "luong", true, DataSourceUpdateMode.Never);
            cbphai.DataBindings.Add("text", dgvNhanVien.DataSource, "phai", true, DataSourceUpdateMode.Never);
            cbMaCN.DataBindings.Add("text", dgvNhanVien.DataSource, "maCN", true, DataSourceUpdateMode.Never);

        }

        private void btnquaylai_Click(object sender, EventArgs e)
        {
            fGiaoDienChinh f = new fGiaoDienChinh();
            f.Show();
            this.Dispose(false);
        }

        private void btnthem_Click(object sender, EventArgs e)
        {
            txtmanv.Enabled = true;
            txttennv.Enabled = true;
            txtsdt.Enabled = true;
            txtquequan.Enabled = true;
            txtluong.Enabled = true;
            datengayvaolam.Enabled = true;
            cbphai.Enabled = true;
            cbMaCN.Enabled = true;
            btnluu.Enabled = true;
            btnsua.Enabled = true;
            btnxoa.Enabled = true;
        }

        private void fQLNhanVien_Load(object sender, EventArgs e)
        {
            txtmanv.Enabled = false;
            txttennv.Enabled = false;
            txtsdt.Enabled = false;
            txtquequan.Enabled = false;
            txtluong.Enabled = false;
            datengayvaolam.Enabled = false;
            cbphai.Enabled = false;
            cbMaCN.Enabled = false;
            btnluu.Enabled = false;
            btnsua.Enabled = false;
            btnxoa.Enabled = false;
        }


        void themDuLieu()
        {
            try
            {
                string maNV = txtmanv.Text;
                string hoTen = txttennv.Text;
                string sdt = txtsdt.Text;
                string queQuan = txtquequan.Text;
                string luong = txtluong.Text;
                DateTime ngayVaoLam = datengayvaolam.Value;
                string phai = cbphai.Text;
                string maCN = cbMaCN.Text;

                if (maNV == "" || hoTen == "" || sdt == "" || queQuan == "" || luong == "")
                    MessageBox.Show("Bạn phải nhập đủ thông tin nhân viên!", "Thêm nhân viên", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                else
                {
                    string NhanvienTim = NhanVienDAO.Instance.timNhanVientheoma(maNV).ToLower();
                    string NhanvienTimMC = NhanVienDAO.Instance.timNhanVientheomaMC(maNV).ToLower();
                    if (NhanvienTim == maNV.ToLower() || NhanvienTimMC == maNV.ToLower())

                        MessageBox.Show("Lỗi!! Trùng mã nhân viên ở chi nhánh mình hay ở chi nhánh khách rồi bạn ơi!!", "Thêm nhân viên", MessageBoxButtons.OK, MessageBoxIcon.Warning);

                    else
                    {
                        bool ketQua = NhanVienDAO.Instance.themNhanVien(maNV, hoTen, sdt, queQuan, ngayVaoLam, luong, maCN, phai);
                        if (ketQua)
                        {
                            MessageBox.Show("Thêm thành công!", "Thêm nhân viên", MessageBoxButtons.OK, MessageBoxIcon.Information);
                            hienThiNhanVien();
                        }
                        else
                            MessageBox.Show("Thêm không thành công!", "Thêm nhân viên", MessageBoxButtons.OK, MessageBoxIcon.Error);
                    }
                }
            }
            catch (Exception)
            {
                MessageBox.Show("Lỗi nhập!", "Thêm nhân viên", MessageBoxButtons.OK, MessageBoxIcon.Warning);
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
                string maNV = txtmanv.Text;
                string hoTen = txttennv.Text;
                string sdt = txtsdt.Text;
                string queQuan = txtquequan.Text;
                string luong = txtluong.Text;
                DateTime ngayVaoLam = datengayvaolam.Value;
                string phai = cbphai.Text;
                string maCN = cbMaCN.Text;

                bool ketQua = NhanVienDAO.Instance.suaThongtinNhanVien(maNV, hoTen, sdt, queQuan, ngayVaoLam, luong,maCN,phai);

                if (ketQua)
                {
                    MessageBox.Show("Sửa thành công!", "Sửa thông tin nhân viên", MessageBoxButtons.OK, MessageBoxIcon.Information);
                    hienThiNhanVien();
                }
                else
                    MessageBox.Show("Sửa không thành công!", "Sửa thông tin nhân viên", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
            catch (Exception)
            {
                MessageBox.Show("Lỗi định dạng nhập! Vui lòng kiểm tra lại", "Sửa thông tin nhân viên", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private void btnxoa_Click(object sender, EventArgs e)
        {
            string maNV = txtmanv.Text;
            if (maNV == "")
                MessageBox.Show("Bạn chưa chọn mã Nhân Viên", "Xóa Thông Tin Nhân Viên", MessageBoxButtons.OK, MessageBoxIcon.Warning);
            else
            {
                NhanVienDAO.Instance.xoaNhanVien(maNV);
                hienThiNhanVien();
            }
        }
    }
}
