using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Linq;
using System.Threading.Tasks;
using System.Windows.Forms;
using DevExpress.XtraEditors;
using ComboBox = System.Windows.Forms.ComboBox;
using NGANHANG.Process;

namespace NGANHANG.Forms
{
    public partial class Login : DevExpress.XtraEditors.XtraForm
    {
        public Login()
        {
            InitializeComponent();
            
        }

        private void Login_Load(object sender, EventArgs e)
        {
            // TODO: This line of code loads data into the 'dS_PHANMANH.V_DS_PHANMANH' table. You can move, or remove it, as needed.
            this.v_DS_PHANMANHTableAdapter.Fill(this.dS_PHANMANH.V_DS_PHANMANH);
            // TODO: This line of code loads data into the 'nGANHANGDataSet.V_DS_PHANMANH' table. You can move, or remove it, as needed.
            Program.ChiNhanhbds = this.v_DS_PHANMANHBindingSource;

        }

        private Form CheckExists(Type ftype)
        {
            foreach (Form f in this.MdiChildren)
                if (f.GetType() == ftype)
                    return f;
            return null;
        }


        private void button1_Click(object sender, EventArgs e)
        {
            if(textBox1.Text.Trim() == "" || textBox2.Text.Trim() == "")
            {
                MessageBox.Show("Bạn chưa nhập tài khoản hoặc mật khẩu");
                return;
            }
            Program.mlogin = textBox1.Text;
            Program.password = textBox2.Text;
            Program.maChiNhanh = comboBox1.GetItemText(comboBox1.Items[comboBox1.SelectedIndex]);
            
            bool rs = db_connect.KTDangNhap(textBox1.Text, textBox2.Text);
            if (rs)
            {
                Program.loginDN = Program.mlogin;
                Program.passwordDN = Program.password;

                db_connect.ThongTinTaiKhoanDangNhap();

                Form frm = this.CheckExists(typeof(Main));
                if (frm != null) frm.Activate();
                else
                {
                    Main f = new Main();
                    f.MdiParent = this.MdiParent;
                    f.Show();
                    this.Visible = false;
                }

            }
            else
            {
                MessageBox.Show("Tài khoản hoặc mật khẩu không đúng! \n Vui lòng kiểm tra lại");
            }
        }
        
        private void button2_Click(object sender, EventArgs e)
        {
            DialogResult result = MessageBox.Show("Bạn có chắc chắn muốn thoát chương trình", "Confirmation", MessageBoxButtons.YesNo);
            if (result == DialogResult.Yes)
            {
                this.Close();
            }
            else if (result == DialogResult.No)
            {
                return;
            }
        }

        private void comboBox1_SelectedValueChanged_1(object sender, EventArgs e)
        {
            ComboBox comboBox = sender as ComboBox;
            if (comboBox.SelectedIndex > -1) { 
                Program.TenServer = comboBox.SelectedValue.ToString();
            }
            
        }

        private void button1_Click_1(object sender, EventArgs e)
        {

        }

        private void comboBox1_SelectedIndexChanged(object sender, EventArgs e)
        {

        }
    }
}