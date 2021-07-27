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
    public partial class fHoaDon : Form
    {
        BindingSource dsHoaDon = new BindingSource();
        BindingSource dsNhanvienViPham = new BindingSource();


        public fHoaDon()
        {
            InitializeComponent();
            dgvHoaDon.DataSource = dsHoaDon;

            hienthidanhsachHD();
            taorangbuoc();
        }

        void hienthidanhsachnhanvien()
        {
            dsNhanvienViPham.DataSource = NhanVienDAO.Instance.LayDsNhanVienvp();

            dgvnhanvien.Columns[0].HeaderText = "Mã Nhân Viên";
            dgvnhanvien.Columns[0].Width = 100;

            dgvnhanvien.Columns[1].HeaderText = "Tên Nhân Viên";
            dgvnhanvien.Columns[1].Width = 135;

            dgvnhanvien.Columns[2].HeaderText = "Số Điện Thoại";
            dgvnhanvien.Columns[2].Width = 100;

            dgvnhanvien.Columns[3].HeaderText = "Quê Quán";
            dgvnhanvien.Columns[3].Width = 135;

            dgvnhanvien.Columns[4].HeaderText = "Ngày vào làm";
            dgvnhanvien.Columns[4].Width = 100;

            dgvnhanvien.Columns[5].HeaderText = "Lương";
            dgvnhanvien.Columns[5].Width = 85;

            dgvnhanvien.Columns[6].HeaderText = "Phái";
            dgvnhanvien.Columns[6].Width = 50;

            dgvnhanvien.Columns[7].HeaderText = "Mã chi nhánh";
            dgvnhanvien.Columns[7].Width = 95;

        }


        void hienthidanhsachHD()
        {
            dsHoaDon.DataSource = HoaDonDAO.Instance.LayDsHoaDon();

            dgvHoaDon.Columns[0].HeaderText = "Mã Hóa Đơn";
            dgvHoaDon.Columns[0].Width = 200;

            dgvHoaDon.Columns[1].HeaderText = "Mã Khách Hàng";
            dgvHoaDon.Columns[1].Width = 205;

            dgvHoaDon.Columns[2].HeaderText = "Mã Sản Phẩm";
            dgvHoaDon.Columns[2].Width = 205;

            dgvHoaDon.Columns[3].HeaderText = "Mã Chi Nhánh";
            dgvHoaDon.Columns[3].Width = 205;

            dgvHoaDon.Columns[4].HeaderText = "Mã Nhân Viên";
            dgvHoaDon.Columns[4].Width = 205;

            dgvHoaDon.Columns[5].HeaderText = "Tên Sản Phẩm";
            dgvHoaDon.Columns[5].Width = 205;

            dgvHoaDon.Columns[6].HeaderText = "Số Lượng";
            dgvHoaDon.Columns[6].Width = 205;

            dgvHoaDon.Columns[7].HeaderText = "Giá Bán";
            dgvHoaDon.Columns[7].Width = 205;

            dgvHoaDon.Columns[8].HeaderText = "Tổng Tiền";
            dgvHoaDon.Columns[8].Width = 205;

            dgvHoaDon.Columns[9].HeaderText = "Ngày Lập";
            dgvHoaDon.Columns[9].Width = 205;

        }

        void taorangbuoc()
        {
            txtMaHD.DataBindings.Add("text", dgvHoaDon.DataSource, "maHD", true, DataSourceUpdateMode.Never);
            cbMaKH.DataBindings.Add("text", dgvHoaDon.DataSource, "maKH", true, DataSourceUpdateMode.Never);
            cbMaSP.DataBindings.Add("text", dgvHoaDon.DataSource, "maSP", true, DataSourceUpdateMode.Never);
            txtCN.DataBindings.Add("text", dgvHoaDon.DataSource, "maCN", true, DataSourceUpdateMode.Never);
            txtMaNV.DataBindings.Add("text", dgvHoaDon.DataSource, "maNV", true, DataSourceUpdateMode.Never);
            txtTenSP.DataBindings.Add("text", dgvHoaDon.DataSource, "tenSP", true, DataSourceUpdateMode.Never);
            txtSoLuong.DataBindings.Add("text", dgvHoaDon.DataSource, "soLuong", true, DataSourceUpdateMode.Never);
            txtGiaBan.DataBindings.Add("text", dgvHoaDon.DataSource, "giaBan", true, DataSourceUpdateMode.Never);
            txtTongTien.DataBindings.Add("text", dgvHoaDon.DataSource, "TongTien", true, DataSourceUpdateMode.Never);
            txtNgayLap.DataBindings.Add("text", dgvHoaDon.DataSource, "ngayLap", true, DataSourceUpdateMode.Never);
        }

        private void btnQuayLai_Click(object sender, EventArgs e)
        {
            fGiaoDienChinh f = new fGiaoDienChinh();
            f.Show();
            this.Dispose(false);
        }

        private void btnthem_Click(object sender, EventArgs e)
        {
            txtMaHD.Enabled = true;
            cbMaKH.Enabled = true;
            cbMaSP.Enabled = true;
            txtCN.Enabled = true;
            txtMaNV.Enabled = true;
            txtTenSP.Enabled = true;
            txtTenSP.Enabled = true;
            txtSoLuong.Enabled = true;
            txtGiaBan.Enabled = true;
            txtTongTien.Enabled = true;
            txtNgayLap.Enabled = true;
            btnsua.Enabled = true;
            btnxoa.Enabled = true;
        }

        void hienThiMaKH()
        {
            List<KhachHangDTO> dskh = KhachHangDAO.Instance.LayDsKhachHang();
            for (int i = 0; i < dskh.Count - 1; i++)
            {
                for (int j = i + 1; j < dskh.Count; j++)
                {
                    if (dskh.ElementAt(i).MaKH.Contains(dskh.ElementAt(j).MaKH))
                        dskh.RemoveAt(j);
                }
            }
            cbMaKH.DataSource = dskh;
            cbMaKH.DisplayMember = "maKH";
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

        void suahoadon()
        {
            try
            {
                string maHD = txtMaHD.Text;
                string maKH = cbMaKH.Text;
                string maSP = cbMaSP.Text;
                string maCN = txtCN.Text;
                string maNV = txtMaNV.Text;
                string tenSP = txtTenSP.Text;
                string soLuong = txtSoLuong.Text;
                string giaBan = txtGiaBan.Text;

            
                double giaban = Convert.ToDouble(txtGiaBan.Text);
                int soluong;
                soluong = Convert.ToInt32(txtSoLuong.Text);
                txtTongTien.Text = String.Format("{0:0.00}", giaban * soluong);
                string tongTien = txtTongTien.Text;
                string ngayLap = txtNgayLap.Text;
                bool ketQua = HoaDonDAO.Instance.suaThongTinHoaDon(maHD, maKH, maSP, maCN, maNV, tenSP, soLuong, giaBan, tongTien.ToString(), ngayLap);
                if (ketQua)
                {
                    MessageBox.Show("Sửa thành công!", "Sửa Hóa Đơn", MessageBoxButtons.OK, MessageBoxIcon.Information);
                    hienthidanhsachHD();
                }
                else
                    MessageBox.Show("Sửa không thành công!", "Sửa Hóa Đơn", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
            catch (Exception)
            {
                MessageBox.Show("Lỗi định dạng nhập! Vui lòng kiểm tra lại", "Sửa Hóa Đơn", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }


        }


        private void btnsua_Click(object sender, EventArgs e)
        {
            suahoadon();
        }

        private void fHoaDon_Load(object sender, EventArgs e)
        {
            txtMaHD.Enabled = false;
            cbMaKH.Enabled = false;
            cbMaSP.Enabled = false;
            txtCN.Enabled = false;
            txtMaNV.Enabled = false;
            txtTenSP.Enabled = false;
            txtTenSP.Enabled = false;
            txtSoLuong.Enabled = false;
            txtGiaBan.Enabled = false;
            txtTongTien.Enabled = false;
            txtNgayLap.Enabled = false;
            groupBox5.Enabled = false;
            btnsua.Enabled = false;
            btnxoa.Enabled = false;
            hienThiMaKH();
            hienThiMaSP();
        }

        private void btntimhd_Click(object sender, EventArgs e)
        {
            try
            {
                string maHD = txtHDTim.Text;
                List<HoaDonDTO> ds = HoaDonDAO.Instance.TimHD(maHD);
                dgvHoaDon.DataSource = ds;
                hienthidanhsachHD();
            }
            catch (Exception)
            {
                MessageBox.Show("Lỗi định dạng nhập! Vui lòng kiểm tra lại", "Tìm hóa đơn khách hàng", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
            
        }

        private void bttatca_Click(object sender, EventArgs e)
        {
            dgvHoaDon.DataSource = dsHoaDon;
            hienthidanhsachHD();
            //taorangbuoc();
        }

        private void btntimnv_Click(object sender, EventArgs e)
        {
            string maNV = txtNVvipham.Text;
            List<NhanVienDTO> ds = HoaDonDAO.Instance.TimNV(maNV);
            groupBox5.Enabled = true;
            dgvnhanvien.DataSource = ds;
            hienthidanhsachnhanvien();


        }

        private void button1_Click(object sender, EventArgs e)
        {
            fGiaoDienChinh f = new fGiaoDienChinh();
            f.Show();
            this.Dispose(false);

        }

        private void btnxoa_Click(object sender, EventArgs e)
        {
            string maHD = txtMaHD.Text;
            string maSP = cbMaSP.ValueMember;
            if (maHD == "" ||maSP=="" )
                MessageBox.Show("Bạn chưa chọn mã Hóa Đơn", "Xóa Hóa Đơn", MessageBoxButtons.OK, MessageBoxIcon.Warning);
            else
            {
                HoaDonDAO.Instance.xoaHoaDontheomaSP(maHD,maSP);
                hienthidanhsachHD();
            }
        }

        private void button2_Click(object sender, EventArgs e)
        {
            string maHD = txtMaHD.Text;
            if (maHD == "")
                MessageBox.Show("Bạn chưa chọn mã Hóa Đơn", "Xóa Hóa Đơn", MessageBoxButtons.OK, MessageBoxIcon.Warning);
            else
            {
                HoaDonDAO.Instance.xoaHoaDontheomaHd(maHD);
                hienthidanhsachHD();
            }
        }
    }
}
