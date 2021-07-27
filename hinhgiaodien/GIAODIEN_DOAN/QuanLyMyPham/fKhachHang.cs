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
    public partial class fKhachHang : Form
    {
        BindingSource dsKhachHang = new BindingSource();

        public fKhachHang()
        {
            InitializeComponent();
            dgvKhachHang.DataSource = dsKhachHang;
            hienthiDanhSachKhachHang();
            taorangbuoc();
        }

        void hienthiDanhSachKhachHang()
        {
            dsKhachHang.DataSource = KhachHangDAO.Instance.LayDsKhachHang();

            dgvKhachHang.Columns[0].HeaderText = "Mã Khách Hàng";
            dgvKhachHang.Columns[0].Width = 100;

            dgvKhachHang.Columns[1].HeaderText = "Tên Khách Hàng";
            dgvKhachHang.Columns[1].Width = 135;

            dgvKhachHang.Columns[2].HeaderText = "Địa Chỉ";
            dgvKhachHang.Columns[2].Width = 100;

            dgvKhachHang.Columns[3].HeaderText = "Số Điện Thoại";
            dgvKhachHang.Columns[3].Width = 135;

            dgvKhachHang.Columns[4].HeaderText = "Email";
            dgvKhachHang.Columns[4].Width = 100;

            dgvKhachHang.Columns[5].HeaderText = "Công Việc";
            dgvKhachHang.Columns[5].Width = 85;

            dgvKhachHang.Columns[6].HeaderText = "Phái";
            dgvKhachHang.Columns[6].Width = 50;

            dgvKhachHang.Columns[7].HeaderText = "Ngày Sinh";
            dgvKhachHang.Columns[7].Width = 95;

            dgvKhachHang.Columns[8].HeaderText = "Mã Chi Nhánh";
            dgvKhachHang.Columns[8].Width = 95;

        }

        void taorangbuoc()
        {
            txtmakh.DataBindings.Add("text", dgvKhachHang.DataSource, "maKH", true, DataSourceUpdateMode.Never);
            txttenkh.DataBindings.Add("text", dgvKhachHang.DataSource, "tenKH", true, DataSourceUpdateMode.Never);
            txtdiachi.DataBindings.Add("Text", dgvKhachHang.DataSource, "diaChi", true, DataSourceUpdateMode.Never);
            txtsdt.DataBindings.Add("Text", dgvKhachHang.DataSource, "sdt", true, DataSourceUpdateMode.Never);
            txtemail.DataBindings.Add("text", dgvKhachHang.DataSource, "email", true, DataSourceUpdateMode.Never);
            txtcongviec.DataBindings.Add("Text", dgvKhachHang.DataSource, "congViec", true, DataSourceUpdateMode.Never);
            cbphai.DataBindings.Add("text", dgvKhachHang.DataSource, "phai", true, DataSourceUpdateMode.Never);
            dateTimePicker1.DataBindings.Add("text", dgvKhachHang.DataSource, "ngaySinh", true, DataSourceUpdateMode.Never);
            cbCN.DataBindings.Add("text", dgvKhachHang.DataSource, "maCN", true, DataSourceUpdateMode.Never);
        }

        void themDuLieu()
        {
            try
            {
                string maKH = txtmakh.Text;
                string tenKH = txttenkh.Text;
                string diaChi = txtdiachi.Text;
                string sdt = txtsdt.Text;
                string email = txtemail.Text;
                string congViec = txtcongviec.Text;
                string phai = cbphai.Text;
                DateTime ngaySinh = dateTimePicker1.Value;
                string maCN =cbCN.Text;

                if (maKH == "" || tenKH == "" || sdt=="")
                    MessageBox.Show("Bạn phải nhập đủ thông tin khách hàng!", "Thêm Khách Hàng", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                else
                {
                    string KhachHangTim = KhachHangDAO.Instance.timKhachHangtheoma(maKH).ToLower();
                    string KhachHangMC = KhachHangDAO.Instance.timKhachHangMCtheoma(maKH).ToLower();
                    if (KhachHangTim == maKH.ToLower())

                        MessageBox.Show("Lỗi!! Trùng mã khách hàng ở chi nhánh mình hay ở chi nhánh khách rồi bạn ơi!!", "Thêm Khách Hàng", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                   
                    else
                    {
                        bool ketQua = KhachHangDAO.Instance.themKhachHang(maKH,tenKH,diaChi,sdt,email,congViec,phai,ngaySinh,maCN);
                        if (ketQua)
                        {
                            MessageBox.Show("Thêm thành công!", "Thêm Khách Hàng", MessageBoxButtons.OK, MessageBoxIcon.Information);
                            hienthiDanhSachKhachHang();
                        }
                        else
                            MessageBox.Show("Thêm không thành công!", "Thêm Khách Hàng", MessageBoxButtons.OK, MessageBoxIcon.Error);
                    }
                }
            }
            catch (Exception)
            {
                MessageBox.Show("Lỗi nhập!", "Thêm Khách Hàng", MessageBoxButtons.OK, MessageBoxIcon.Warning);
            }

}


        private void btnquaylai_Click(object sender, EventArgs e)
        {
            fGiaoDienChinh f = new fGiaoDienChinh();
            f.Show();
            this.Dispose(false);
        }

        private void btnthem_Click(object sender, EventArgs e)
        {
            txtmakh.Enabled = true;
            txttenkh.Enabled = true;
            txtdiachi.Enabled = true;
            txtsdt.Enabled = true;
            txtemail.Enabled = true;
            txtcongviec.Enabled = true;
            cbphai.Enabled = true;
            dateTimePicker1.Enabled = true;
            btnluu.Enabled = true;
            btnsua.Enabled = true;
            btnxoa.Enabled = true;
            cbCN.Enabled = true;
        }

        private void fKhachHang_Load(object sender, EventArgs e)
        {
            txtmakh.Enabled = false;
            txttenkh.Enabled = false;
            txtdiachi.Enabled = false;
            txtsdt.Enabled = false;
            txtemail.Enabled = false;
            txtcongviec.Enabled = false;
            cbphai.Enabled = false;
            dateTimePicker1.Enabled = false;
            btnluu.Enabled = false;
            btnsua.Enabled = false;
            btnxoa.Enabled = false;
            cbCN.Enabled = false;
        }

        private void btnluu_Click(object sender, EventArgs e)
        {
            themDuLieu();
           
        }

        private void btnxoa_Click(object sender, EventArgs e)
        {
            string maKH = txtmakh.Text;
            if (maKH == "")
                MessageBox.Show("Bạn chưa chọn mã khách hàng", "Xóa Thông Tin Khách Hàng", MessageBoxButtons.OK, MessageBoxIcon.Warning);
            else
            {
                KhachHangDAO.Instance.xoaKH(maKH);
                hienthiDanhSachKhachHang();
            }
         
        }

        private void btnsua_Click(object sender, EventArgs e)
        {
            try
            {
                string maKH = txtmakh.Text;
                string tenKH = txttenkh.Text;
                string diaChi = txtdiachi.Text;
                string sdt = txtsdt.Text;
                string email = txtemail.Text;
                string congViec = txtcongviec.Text;
                string phai = cbphai.Text;
                DateTime ngaySinh = dateTimePicker1.Value;
                string maCN = cbCN.Text;

                bool ketQua = KhachHangDAO.Instance.suaThongtinKH(maKH, tenKH, diaChi, sdt, email, congViec, phai, ngaySinh,maCN);

                if (ketQua)
                {
                    MessageBox.Show("Sửa thành công!", "Sửa thông tin khách hàng", MessageBoxButtons.OK, MessageBoxIcon.Information);
                    hienthiDanhSachKhachHang();
                }
                else
                    MessageBox.Show("Sửa không thành công!", "Sửa thông tin khách hàng", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
            catch (Exception)
            {
                MessageBox.Show("Lỗi định dạng nhập! Vui lòng kiểm tra lại", "Sửa thông tin khách hàng", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }

            //taorangbuoc();
        }
    }
}
