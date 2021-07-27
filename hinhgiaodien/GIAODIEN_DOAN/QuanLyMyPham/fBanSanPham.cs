using QuanLyMyPham.Process;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using QuanLyMyPham.DAO;
using QuanLyMyPham.DTO;

namespace QuanLyMyPham
{
    public partial class fBanSanPham : Form
    {
        public fBanSanPham()
        {
            InitializeComponent();
            LoadSanPham();
            //hienThiMaKH();
            loadComboKH();
        }

        private void textBox2_TextChanged(object sender, EventArgs e)
        {

        }

        void LoadSanPham()
        {
            flowLayoutPanel1.Controls.Clear();

            List<SanPhamDTO> SPlist = SanPhamDAO.Instance.LayDsSanPham();

            foreach (SanPhamDTO item in SPlist)
            {
                Button btn = new Button() { Width = SanPhamDAO.TableWidth, Height = SanPhamDAO.TableHeight };
                btn.Text = item.MaSP + Environment.NewLine + item.TenSP;
                btn.BackColor = Color.Pink;

                btn.Click += btn_Click;
                btn.Tag = item;

                flowLayoutPanel1.Controls.Add(btn);
            }
        }

        private void btn_Click(object sender, EventArgs e)
        {
           // string MaSP = ((sender as Button).Tag as SanPham).MaSP;

        }

        //void hienThiMaKH()
        //{
        //    List<KhachHangDTO> dsmakh = KhachHangDAO.Instance.LayDsKhachHang();
        //    for (int i = 0; i < dsmakh.Count - 1; i++)
        //    {
        //        for (int j = i + 1; j < dsmakh.Count; j++)
        //        {
        //            if (dsmakh.ElementAt(i).MaKH.Contains(dsmakh.ElementAt(j).MaKH))
        //                dsmakh.RemoveAt(j);
        //        }
        //    }

        //    cbMaKH.DataSource = dsmakh;
        //    cbMaKH.DisplayMember = "tenKH";

        //}


        private void txtMaSanPham_TextChanged(object sender, EventArgs e)
        {

        }

        private void groupBox1_Enter(object sender, EventArgs e)
        {

        }

        private void txtTenSanPham_TextChanged(object sender, EventArgs e)
        {

        }

        private void txtMaHoaDon_TextChanged(object sender, EventArgs e)
        {

        }

        private void txtGiaBan_TextChanged(object sender, EventArgs e)
        {
            if (txtGiaBan.Text != "" && txtSoLuong.Text != "")
            {
                try
                {
                    double giaBan = Convert.ToDouble(txtGiaBan.Text);
                    int soLuong;
                    soLuong = Convert.ToInt32(txtSoLuong.Text);
                    txtTongTien.Text= String.Format("{0:0.00}", giaBan*soLuong);
                }
                catch (Exception ex)
                { return; }
                            
            }
            else
                return;


        }

        public void loadComboKH()
        {
            SqlConnection conn = new SqlConnection(Program.connectionstring);
            conn.Open();
            SqlCommand cm = new SqlCommand("select maKH, tenKH from KhachHang", conn);
            SqlDataAdapter ap = new SqlDataAdapter(cm);
            DataSet ds = new DataSet();
            ap.Fill(ds, "KhachHang");
            cbKH.DataSource = ds.Tables[0];
            cbKH.DisplayMember = "tenKH";
            cbKH.ValueMember = "maKH";
        }


        private void btnThanhToan_Click(object sender, EventArgs e)
        {
            ThanhToan();
        }
        private void ClearForm()
        {
            txtMaHoaDon.Text = "";
            txtMaKhachHang.Text = "";
            txtMaSanPham.Text = "";
            txtMaNhaPhanPhoi.Text = "";
            txtTenSanPham.Text = "";
            txtSoLuong.Text = "";
            txtGiaBan.Text = "";
            txtNgayLap.Text = "";
            txtTongTien.Text = "";

        }
        private void ThanhToan()
        {
            SqlConnection conn = new SqlConnection(Program.connectionstring);
            string strLenh = "insert into HOADON(MAHD, MaKH, MaSP, MaCN, MaNV, TenSP, SoLuong, GiaBan, TongTien,NgayLap) " +
                "values ('{0}','{1}','{2}','{3}','{4}',N'{5}','{6}','{7}','{8}','{9}')";
            String tmp = txtTenSanPham.Text;
            byte[] tmpBytes = System.Text.Encoding.UTF8.GetBytes(tmp);
            String tenSP = System.Text.Encoding.UTF8.GetString(tmpBytes);
            double giaBan = Convert.ToDouble(txtGiaBan.Text);
            int soLuong;
            soLuong = Convert.ToInt32(txtSoLuong.Text);
            txtTongTien.Text = String.Format("{0:0.00}", giaBan * soLuong);
            // string tongtien = txtTongTien.Text;
            strLenh = string.Format(strLenh, txtMaHoaDon.Text, txtMaKhachHang.Text,txtMaSanPham.Text,txtMaNhaPhanPhoi.Text ,Program.loginUser, txtTenSanPham.Text, txtSoLuong.Text, txtGiaBan.Text,txtTongTien.Text, DateTime.Now.ToString());

            SqlDataReader myReader;
            SqlCommand sqlcmd = new SqlCommand(strLenh, conn);
            sqlcmd.CommandType = CommandType.Text;
            if (conn.State == ConnectionState.Closed) conn.Open();
            SanPham sanPham = new SanPham();
            try
            {
                myReader = sqlcmd.ExecuteReader();
                MessageBox.Show(" Đơn hàng đã được thanh toán! \n Cảm ơn quý khách đã đến");
               // ClearForm();

            }
            catch (SqlException ex)
            {
                conn.Close();
                MessageBox.Show("Có lỗi khi kết nối đến database!\n Kiểm tra lại thông tin trong chi nhánh nhá");
                return;
            }
        }



        private void NewMethod(SqlConnection conn, ref SqlDataReader myReader, SqlCommand sqlcmd)
        {
           
        }

        private void pictureProduct_Click(object sender, EventArgs e)
        {

        }

        private void btnDangKyThongTin_Click(object sender, EventArgs e)
        {
            fKhachHang f = new fKhachHang();
            f.Show();
            this.Dispose(false);
        }

        private void button1_Click(object sender, EventArgs e)
        {

        }

        private void button1_Click_1(object sender, EventArgs e)
        {
            fGiaoDienChinh f = new fGiaoDienChinh();
            f.Show();
            this.Dispose(false);
        }

        private void txtMaSanPham_Leave_1(object sender, EventArgs e)
        {
            SanPham sp = (SanPham)db_connect.ThongTinSanPham(txtMaSanPham.Text.Trim());
            txtNgayLap.Text = DateTime.Now.ToString("dd/MM/yyyy");
            if (sp == null)
            {
                MessageBox.Show("Mã sản phẩm không tồn tại");
            }
            else
            {
                try
                {
                    txtTenSanPham.Text = sp.TenSP;
                    txtGiaBan.Text = String.Format("{0:0.00}", sp.GiaSP);
                    pictureProduct.Load("Images/" + sp.HinhSanPham);
                }
                catch (Exception)
                {
                    MessageBox.Show("Sản Phẩm chưa có hình minh họa\n Nhập hình vào nhé shop", "Lỗi nhập!", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                }

            }
        }

        private void cbKH_SelectedIndexChanged(object sender, EventArgs e)
        {
            //SqlConnection conn = new SqlConnection(Program.connectionstring);
            //conn.Open();
            //SqlCommand cmd = new SqlCommand("Select*from KhachHang where maKH '" + cbKH.SelectedValue.ToString() + "'",conn);
         
            //SqlDataReader reader = cmd.ExecuteReader();
            //if (reader.HasRows)
            //{
            //    reader.Read();
            //    txtMaKhachHang.Text = reader.GetString(0).ToString();

            //}
            

        }

        private void button2_Click(object sender, EventArgs e)
        {
            ClearForm();
        }

        //private void cbMaSP_Leave(object sender, EventArgs e)
        //{
        //    SanPham sp = (SanPham)db_connect.ThongTinSanPham(cbMaSP.SelectedValue.ToString());
        //    txtNgayLap.Text = DateTime.Now.ToString("dd/MM/yyyy");
        //    if (sp == null)
        //    {
        //        MessageBox.Show("Mã sản phẩm không tồn tại");
        //    }
        //    else
        //    {
        //        try
        //        {
        //            txtTenSanPham.Text = sp.TenSP;
        //            txtGiaBan.Text = String.Format("{0:0.00}", sp.GiaSP);
        //            pictureProduct.Load("Images/" + sp.HinhSanPham);
        //        }
        //        catch (Exception)
        //        {
        //            MessageBox.Show("Sản Phẩm chưa có hình minh họa\n Nhập hình vào nhé shop", "Lỗi nhập!", MessageBoxButtons.OK, MessageBoxIcon.Warning);
        //        }

        //    }
        //}
    }
}
