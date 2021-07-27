using QuanLyMyPham.Process;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace QuanLyMyPham
{
    public partial class frmLogin : Form
    {
        public frmLogin()
        {
            InitializeComponent();
        }

        
        private void cbbBranches_SelectedValueChanged(object sender, EventArgs e)
        {
            ComboBox comboBox = sender as ComboBox;
            if (comboBox.SelectedIndex > -1)
            {
                string tenServer = comboBox.SelectedValue.ToString();
                Program.TenCN = comboBox.Text;
                Program.TenServer = comboBox.SelectedValue.ToString();

            }
        }
        private void label3_Click(object sender, EventArgs e)
        {

        }

        private void label2_Click(object sender, EventArgs e)
        {

        }

        private void label1_Click(object sender, EventArgs e)
        {

        }

        private void textBox2_TextChanged(object sender, EventArgs e)
        {

        }

        private void textBox1_TextChanged(object sender, EventArgs e)
        {

        }

        private void pictureBox1_Click(object sender, EventArgs e)
        {

        }

        private void label1_Click_1(object sender, EventArgs e)
        {

        }

        private void groupBox1_Enter(object sender, EventArgs e)
        {

        }

        private void frmLogin_Load(object sender, EventArgs e)
        {
            string connectionStringHO = ConfigurationManager.AppSettings["HOISO"];

            using (SqlConnection conn = new SqlConnection(connectionStringHO))
            {
                try
                {
                    string query = "select TENCN, TENSERVER from V_DS_PHANMANH";
                    SqlDataAdapter da = new SqlDataAdapter(query, conn);
                    conn.Open();
                    DataSet ds = new DataSet();
                    da.Fill(ds, "PHANMANH");
                    cbbBranches.DisplayMember = "TENSERVER";
                    cbbBranches.ValueMember = "TENSERVER";
                    cbbBranches.DataSource = ds.Tables["PHANMANH"];
                }
                catch (Exception ex)
                {
                   
                    MessageBox.Show("Có lỗi khi kết nối đến database server chủ! Kiểm tra thông tin trong App.config");
                }
            }
        }

        private void label3_Click_1(object sender, EventArgs e)
        {

        }

        private void btnLogin_Click(object sender, EventArgs e)
        {
            if (txtUsername.Text.Trim() == "" || txtPassword.Text.Trim() == "")
            {
                MessageBox.Show("Bạn chưa nhập tài khoản hoặc mật khẩu");
                return;
            }
            Program.loginUser = txtUsername.Text.Trim();

            int rs = db_connect.KTDangNhap(txtUsername.Text, txtPassword.Text);
            if (rs>0)
            {
                Form frm = this.CheckExists(typeof(fGiaoDienChinh));
                if (frm != null) frm.Activate();
                else
                {
                    MessageBox.Show("Đăng nhập thành công");
                    fGiaoDienChinh f = new fGiaoDienChinh();
                   // f.MdiParent = this.MdiParent;
                    f.Show();
                    this.Visible = false;
                }

            }
            else if(rs==0)
            {
                MessageBox.Show("Tài khoản hoặc mật khẩu không đúng! \n Vui lòng kiểm tra lại");
            }
            else
                MessageBox.Show("Có lỗi khi kết nối đến database của chi nhánh");

        }

        private void panel1_Paint(object sender, PaintEventArgs e)
        {

        }

        private void txtUsername_TextChanged(object sender, EventArgs e)
        {

        }

        private void txtPassword_TextChanged(object sender, EventArgs e)
        {

        }
        private Form CheckExists(Type ftype)
        {
            foreach (Form f in this.MdiChildren)
                if (f.GetType() == ftype)
                    return f;
            return null;
        }

        private void cbbBranches_SelectedIndexChanged(object sender, EventArgs e)
        {

        }
    }
}
