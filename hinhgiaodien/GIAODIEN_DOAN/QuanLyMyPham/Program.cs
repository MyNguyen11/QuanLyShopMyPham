using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace QuanLyMyPham
{

    static class Program
    {
        public static string connectionstring;
        public static string TenCN;
        public static string TenServer;
        public static string TenDataBase = "MyPham_CSDLPT";
        public static String loginUser = "";
        /// <summary>
        /// The main entry point for the application.
        /// </summary>
        [STAThread]
        static void Main()
        {
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            Application.Run(new frmLogin());
            // Application.Run(new fGiaoDienChinh());
            
        }
    }
    //}
}
