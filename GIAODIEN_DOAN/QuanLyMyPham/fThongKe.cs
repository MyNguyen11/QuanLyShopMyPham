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
    public partial class fThongKe : Form
    {
        public fThongKe()
        {
            InitializeComponent();
            hienthi();
        }

        private void button1_Click(object sender, EventArgs e)
        {

        }
        void hienthi()
        {
            dataGridView1.DataSource = HoaDonDAO.Instance.LayDsHoaDon();

            dataGridView1.Columns[0].HeaderText = "Mã Hóa Đơn";
            dataGridView1.Columns[0].Width = 200;

            dataGridView1.Columns[1].HeaderText = "Mã Khách Hàng";
            dataGridView1.Columns[1].Width = 205;

            dataGridView1.Columns[2].HeaderText = "Mã Sản Phẩm";
            dataGridView1.Columns[2].Width = 205;

            dataGridView1.Columns[3].HeaderText = "Mã Chi Nhánh";
            dataGridView1.Columns[3].Width = 205;

            dataGridView1.Columns[4].HeaderText = "Mã Nhân Viên";
            dataGridView1.Columns[4].Width = 205;

            dataGridView1.Columns[5].HeaderText = "Tên Sản Phẩm";
            dataGridView1.Columns[5].Width = 205;

            dataGridView1.Columns[6].HeaderText = "Số Lượng";
            dataGridView1.Columns[6].Width = 205;

            dataGridView1.Columns[7].HeaderText = "Giá Bán";
            dataGridView1.Columns[7].Width = 205;

            dataGridView1.Columns[8].HeaderText = "Tổng Tiền";
            dataGridView1.Columns[8].Width = 205;

            dataGridView1.Columns[9].HeaderText = "Ngày Lập";
            dataGridView1.Columns[9].Width = 205;


        }

        private void button2_Click(object sender, EventArgs e)
        {   string query = "select MaSP, TongTien from HoaDon ";
                DataTable table = DataProvider.Instance.ExecuteQuery(query);
                // DataTable dt = new DataTable();
                chart1.ChartAreas["ChartArea1"].AxisX.Title = "Mã Sản Phẩm";
                chart1.ChartAreas["ChartArea1"].AxisX.Title = "Tổng Tiền";
                // chart1.ChartAreas["ChartArea1"].AxisX.Interval = 1;

                chart1.DataSource = table;
                chart1.Series["TongTien"].XValueMember = "MaSP";
                chart1.Series["TongTien"].YValueMembers = "TongTien";


             

        }

        private void button3_Click(object sender, EventArgs e)
        {
            fGiaoDienChinh f = new fGiaoDienChinh();
            f.Show();
            this.Dispose(false);
        }


        //void LoadDateTimePickerBill()
        //{
        //    DateTime today = DateTime.Now;
        //    dateTimePicker1.Value = new DateTime(today.Year, today.Month, 1);
        //    dateTimePicker2.Value = dateTimePicker1.Value.AddMonths(1).AddDays(-1);
        //}

        //void LoadListBillByDate(DateTime ThangDauVao, DateTime ThangCuoi)
        //{
        //    dataGridView1.DataSource = HoaDonDAO.Instance.GetBillListByDate(ThangDauVao, ThangCuoi);
        //}



        //private void button1_Click(object sender, EventArgs e)
        //{
        //    LoadListBillByDate(dateTimePicker1.Value, dateTimePicker2.Value);
        //}
    }
}
