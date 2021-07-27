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

namespace QuanLyMyPham
{
    public partial class fGiaoDienChinh : Form
    {
        public fGiaoDienChinh()
        {
            InitializeComponent();
        }

        private void btnBanSanPham_Click(object sender, EventArgs e)
        {
            fBanSanPham f = new fBanSanPham();
            f.Show();
            this.Dispose(false);
        }

        private void btnQLHD_Click(object sender, EventArgs e)
        {
            fHoaDon f = new fHoaDon();
            f.Show();
            this.Dispose(false);
        }

        ListViewItem lstviewItem;
        ImageList lstviewItemImageList = new ImageList();

        private void lst_items()
        {
            try
            {

                string[] file;
                file = new string[] { "C:\\Users\\HP\\Desktop\\CSDLNC_ST6\\Nhom9_QuanLyKinhDoanhShopMyPham\\hinhgiaodien\\quanly1.jpg", "C:\\Users\\HP\\Desktop\\CSDLNC_ST6\\Nhom9_QuanLyKinhDoanhShopMyPham\\hinhgiaodien\\quanly2.jpg", "C:\\Users\\HP\\Desktop\\CSDLNC_ST6\\Nhom9_QuanLyKinhDoanhShopMyPham\\hinhgiaodien\\quanly3.jpg", "C:\\Users\\HP\\Desktop\\CSDLNC_ST6\\Nhom9_QuanLyKinhDoanhShopMyPham\\hinhgiaodien\\quanly4.jpg", "C:\\Users\\HP\\Desktop\\CSDLNC_ST6\\Nhom9_QuanLyKinhDoanhShopMyPham\\hinhgiaodien\\quanly6.jpg" };
                foreach (string files in file)
                {

                    lstviewItem = new ListViewItem(files);
                    lstviewItemImageList.ImageSize = new Size(200, 256);
                    listView1.SmallImageList = lstviewItemImageList;
                    lstviewItem.ImageIndex = lstviewItemImageList.Images.Add(Image.FromFile(lstviewItem.Text), Color.Transparent);
                    listView1.Items.Add(lstviewItem);
                }

            }
            catch (Exception ex)
            {
                MessageBox.Show("Xem lại thư mục chứa hình : " + ex.Message);
            }
        }

        private void fGiaoDienChinh_Load(object sender, EventArgs e)
        {
            listView1.View = View.Details;
            listView1.Columns.Add("SẢN PHẨM CỦA SHOP");
            listView1.Columns[0].Width = 500;

            lst_items();

        }

        private void btnKH_Click(object sender, EventArgs e)
        {
            fKhachHang f = new fKhachHang();
            f.Show();
            this.Dispose(false);
        }

        private void btnQLSP_Click(object sender, EventArgs e)
        {
            fQLSanPham f = new fQLSanPham();
            f.Show();
            this.Dispose(false);
        }

        private void btnQuaylai_Click(object sender, EventArgs e)
        {

            //if (MessageBox.Show("Bạn muốn rời khỏi phần mềm?", "Thông báo", MessageBoxButtons.YesNo, MessageBoxIcon.Question) == DialogResult.Yes)
            //{
            //    frmLogin f = new frmLogin();
            //    f.Show();
            //    this.Dispose(false);
            //    this.Close();
                
            //}
        }

        private void btnQLNV_Click(object sender, EventArgs e)
        {

            fQLNhanVien f = new fQLNhanVien();
            f.Show();
            this.Dispose(false);
            this.Close();
        }

        private void btnQLNhaKho_Click(object sender, EventArgs e)
        {
            fNhaKho f = new fNhaKho();
            f.Show();
            this.Dispose(false);
        }

        private void button2_Click(object sender, EventArgs e)
        {
            fThongKe f = new fThongKe();
            f.Show();
            this.Dispose(false);
        }
    }
}
