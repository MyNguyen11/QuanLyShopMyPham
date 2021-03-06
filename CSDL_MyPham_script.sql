USE [master]
GO
/****** Object:  Database [MyPham_CSDLPT]    Script Date: 4/21/2021 12:23:59 AM ******/
CREATE DATABASE [MyPham_CSDLPT]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'MyPham_CSDLPT', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MAYCHUTPHCM\MSSQL\DATA\MyPham_CSDLPT.mdf' , SIZE = 25664KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'MyPham_CSDLPT_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MAYCHUTPHCM\MSSQL\DATA\MyPham_CSDLPT_log.ldf' , SIZE = 36288KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [MyPham_CSDLPT] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [MyPham_CSDLPT].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [MyPham_CSDLPT] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [MyPham_CSDLPT] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [MyPham_CSDLPT] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [MyPham_CSDLPT] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [MyPham_CSDLPT] SET ARITHABORT OFF 
GO
ALTER DATABASE [MyPham_CSDLPT] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [MyPham_CSDLPT] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [MyPham_CSDLPT] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [MyPham_CSDLPT] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [MyPham_CSDLPT] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [MyPham_CSDLPT] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [MyPham_CSDLPT] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [MyPham_CSDLPT] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [MyPham_CSDLPT] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [MyPham_CSDLPT] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [MyPham_CSDLPT] SET  ENABLE_BROKER 
GO
ALTER DATABASE [MyPham_CSDLPT] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [MyPham_CSDLPT] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [MyPham_CSDLPT] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [MyPham_CSDLPT] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [MyPham_CSDLPT] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [MyPham_CSDLPT] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [MyPham_CSDLPT] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [MyPham_CSDLPT] SET RECOVERY FULL 
GO
ALTER DATABASE [MyPham_CSDLPT] SET  MULTI_USER 
GO
ALTER DATABASE [MyPham_CSDLPT] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [MyPham_CSDLPT] SET DB_CHAINING OFF 
GO
ALTER DATABASE [MyPham_CSDLPT] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [MyPham_CSDLPT] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
EXEC sys.sp_db_vardecimal_storage_format N'MyPham_CSDLPT', N'ON'
GO
USE [MyPham_CSDLPT]
GO
/****** Object:  DatabaseRole [MSmerge_PAL_role]    Script Date: 4/21/2021 12:23:59 AM ******/
CREATE ROLE [MSmerge_PAL_role]
GO
/****** Object:  DatabaseRole [MSmerge_AB1F05CECE24415B87717EDE0EFE1D98]    Script Date: 4/21/2021 12:23:59 AM ******/
CREATE ROLE [MSmerge_AB1F05CECE24415B87717EDE0EFE1D98]
GO
/****** Object:  DatabaseRole [MSmerge_5BEDBD38D5E44288A3C413A2B1511542]    Script Date: 4/21/2021 12:23:59 AM ******/
CREATE ROLE [MSmerge_5BEDBD38D5E44288A3C413A2B1511542]
GO
ALTER ROLE [MSmerge_PAL_role] ADD MEMBER [MSmerge_AB1F05CECE24415B87717EDE0EFE1D98]
GO
ALTER ROLE [MSmerge_PAL_role] ADD MEMBER [MSmerge_5BEDBD38D5E44288A3C413A2B1511542]
GO
/****** Object:  Schema [MSmerge_PAL_role]    Script Date: 4/21/2021 12:23:59 AM ******/
CREATE SCHEMA [MSmerge_PAL_role]
GO
/****** Object:  StoredProcedure [dbo].[KiemtraPK_KhachHang]    Script Date: 4/21/2021 12:23:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[KiemtraPK_KhachHang]
(
	@MaKH nchar(30),
	@TenKH nvarchar(30),
	@DiaChi nvarchar(100),
	@SDT char(15),
	@Email nvarchar(50),
	@CongViec nvarchar(30),
	@Phai nchar(5),
	@NgaySinh date,
	@MaCN nchar(30)
)
as
Begin
	if not exists (select *from KhachHang where MaKH=@MaKH)
		begin
			insert KhachHang(MaKH,TenKH,DiaChi,SDT,Email,CongViec,Phai,NgaySinh,MaCN)
			Values (@MaKH,@TenKH,@DiaChi,@SDT,@Email,@CongViec,@Phai,@NgaySinh,@MaCN)
		end
	else
		begin 
			Raiserror ('Trùng Khóa rồi bạn ơi',11,1);
		end
end;

GO
/****** Object:  StoredProcedure [dbo].[KiemtraPK_LoaiSP]    Script Date: 4/21/2021 12:23:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create proc [dbo].[KiemtraPK_LoaiSP]
(
	@MaLoai nchar(30),
	@TenLoai nvarchar(100)
)
as
Begin
	if not exists (select *from LoaiSP where MaLoai=@MaLoai)
		begin
			insert LoaiSP(MaLoai,TenLoai)
			Values (@MaLoai,@TenLoai)
		end
	else
		begin 
			Raiserror ('Trùng Khóa rồi bạn ơi',11,1);
		end
end;
GO
/****** Object:  StoredProcedure [dbo].[KiemtraPK_NhanVien]    Script Date: 4/21/2021 12:23:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[KiemtraPK_NhanVien]
(
	@MaNV nchar(30),
	@HoTen nvarchar(100),
	@SDT char(15),
	@QueQuan nvarchar(100),
	@NgayVaoLam date,
	@Luong money,
	@Phai nchar(5),
	@MaCN nvarchar(30)
)
as
Begin
	if not exists (select *from NhanVien where MaNV=@MaNV)
		begin
			insert NhanVien(MaNV,HoTen,SDT,QueQuan,NgayVaoLam,Luong,Phai,MaCN)
			Values (@MaNV,@HoTen,@SDT,@QueQuan,@NgayVaoLam,@Luong,@Phai,@MaCN)
		end
	else
		begin 
			Raiserror ('Trùng Khóa rồi bạn ơi',11,1);
		end
end;
GO
/****** Object:  StoredProcedure [dbo].[SP_ThongTinKhachHang]    Script Date: 4/21/2021 12:23:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_ThongTinKhachHang] @MAKH NVARCHAR (30)
AS
SELECT TenKH FROM KhachHang KH
WHERE KH.MaKH=@MAKH;
GO
/****** Object:  StoredProcedure [dbo].[themSanPham]    Script Date: 4/21/2021 12:23:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[themSanPham]
	(@MaSP nchar(30),
	@TenSP nvarchar(100),
	@Hinh nvarchar(100),
	@Size nvarchar(100),
	@GiaNhap money,
	@GiaBan money,
	@MaNSX nchar(30),
	@MaLoai nchar(30)
	)
As
Begin
	if exists (select *from LoaiSP where MaLoai=@MaLoai)
		begin
			insert SanPham(MaSP,TenSP,Hinh,Size,GiaNhap,GiaBan,MaNSX,MaLoai)
			Values (@MaSP,@TenSP,@Hinh,@Size,@GiaNhap,@GiaBan,@MaNSX,@MaLoai)
		end
	else
		begin 
			Raiserror ('Không tìm thấy mã loại sản phẩm bạn nhập',11,1);
		end
end;
GO
/****** Object:  StoredProcedure [dbo].[themSanPhamKiemTraNSX]    Script Date: 4/21/2021 12:23:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create proc [dbo].[themSanPhamKiemTraNSX]
	(@MaSP nchar(30),
	@TenSP nvarchar(100),
	@Hinh nvarchar(100),
	@Size nvarchar(100),
	@GiaNhap money,
	@GiaBan money,
	@MaNSX nchar(30),
	@MaLoai nchar(30)
	)
As
Begin
	if exists (select *from NhaSanXuat where MaNSX=@MaNSX)
		begin
			insert SanPham(MaSP,TenSP,Hinh,Size,GiaNhap,GiaBan,MaNSX,MaLoai)
			Values (@MaSP,@TenSP,@Hinh,@Size,@GiaNhap,@GiaBan,@MaNSX,@MaLoai)
		end
	else
		begin 
			Raiserror ('Không tìm thấy mã nhà sản xuất bạn nhập',11,1);
		end
end;

GO
/****** Object:  StoredProcedure [dbo].[ThongKe_DoanhThu]    Script Date: 4/21/2021 12:23:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[ThongKe_DoanhThu]
	@ThangDauVao datetime,
	@ThangCuoi datetime,
	@@TongDoanhThu float output
	AS
	Begin
	if (@ThangDauVao<=@ThangCuoi)
	begin
		select sum (HoaDon.TongTien) as N'Tổng Doanh Thu Hệ Thống'
		from HoaDon 
		where NgayLap>=@ThangDauVao and NgayLap<=@ThangCuoi
		select @@TongDoanhThu=(select sum (HoaDon.TongTien)
		from HoaDon 
		where NgayLap>=@ThangDauVao and NgayLap<=@ThangCuoi);
	end; 
	else
		print N'Lỗi rồi kìa bà, Thời gian bắt đầu sau lớn hơn thời gian kết thúc thế !!';
	end;
GO
/****** Object:  Table [dbo].[ChiNhanh]    Script Date: 4/21/2021 12:23:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ChiNhanh](
	[MaCN] [nchar](30) NOT NULL,
	[TenChiNhanh] [nvarchar](100) NULL,
	[DiaChi] [nvarchar](100) NULL,
	[MaVung] [int] NULL,
	[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[MaCN] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[HoaDon]    Script Date: 4/21/2021 12:23:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HoaDon](
	[MaHD] [nchar](30) NOT NULL,
	[MaKH] [nchar](30) NOT NULL,
	[MaSP] [nchar](30) NOT NULL,
	[MaCN] [nchar](30) NOT NULL,
	[MaNV] [nchar](30) NOT NULL,
	[TenSP] [nvarchar](100) NOT NULL,
	[SoLuong] [int] NULL,
	[GiaBan] [money] NULL,
	[TongTien] [money] NULL,
	[NgayLap] [datetime] NULL,
	[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[MaHD] ASC,
	[MaSP] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[KhachHang]    Script Date: 4/21/2021 12:23:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[KhachHang](
	[MaKH] [nchar](30) NOT NULL,
	[TenKH] [nvarchar](30) NOT NULL,
	[DiaChi] [nvarchar](100) NOT NULL,
	[SDT] [char](15) NOT NULL,
	[Email] [nvarchar](50) NOT NULL,
	[CongViec] [nvarchar](30) NULL,
	[Phai] [nchar](5) NULL,
	[NgaySinh] [date] NULL,
	[MaCN] [nchar](30) NOT NULL,
	[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[MaKH] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LoaiSP]    Script Date: 4/21/2021 12:23:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LoaiSP](
	[MaLoai] [nchar](30) NOT NULL,
	[TenLoai] [nvarchar](100) NOT NULL,
	[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[MaLoai] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[NhaKho]    Script Date: 4/21/2021 12:23:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NhaKho](
	[MaKho] [nchar](30) NOT NULL,
	[MaLoai] [nchar](30) NOT NULL,
	[MaSP] [nchar](30) NOT NULL,
	[SLNhap] [int] NULL,
	[SLTon] [int] NULL,
	[MaCN] [nchar](30) NULL,
	[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[MaKho] ASC,
	[MaLoai] ASC,
	[MaSP] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[NhanVien]    Script Date: 4/21/2021 12:23:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[NhanVien](
	[MaNV] [nchar](30) NOT NULL,
	[HoTen] [nvarchar](100) NULL,
	[SDT] [char](15) NULL,
	[QueQuan] [nvarchar](100) NULL,
	[NgayVaoLam] [date] NULL,
	[Luong] [money] NULL,
	[Phai] [nchar](5) NULL,
	[MaCN] [nchar](30) NOT NULL,
	[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[MaNV] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[NhaSanXuat]    Script Date: 4/21/2021 12:23:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NhaSanXuat](
	[MaNSX] [nchar](30) NOT NULL,
	[TenNSX] [nvarchar](60) NOT NULL,
	[DiaChi] [nvarchar](200) NULL,
	[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[MaNSX] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[QuanLy]    Script Date: 4/21/2021 12:23:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[QuanLy](
	[MaQL] [nchar](30) NOT NULL,
	[TenNguoiQL] [nvarchar](100) NULL,
	[SDT] [nchar](15) NULL,
	[MaNV] [nchar](30) NOT NULL,
	[MaCN] [nchar](30) NOT NULL,
	[Phai] [nchar](5) NULL,
	[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[MaQL] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SanPham]    Script Date: 4/21/2021 12:23:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SanPham](
	[MaSP] [nchar](30) NOT NULL,
	[TenSP] [nvarchar](100) NOT NULL,
	[Hinh] [nvarchar](100) NOT NULL,
	[Size] [nvarchar](100) NOT NULL,
	[GiaNhap] [money] NULL,
	[GiaBan] [money] NULL,
	[MaNSX] [nchar](30) NOT NULL,
	[MaLoai] [nchar](30) NOT NULL,
	[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[MaSP] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  View [dbo].[V_DS_PHANMANH]    Script Date: 4/21/2021 12:23:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[V_DS_PHANMANH]
AS
SELECT   PUBS.description AS TENCN, SUBS.subscriber_server AS TENSERVER
FROM     dbo.sysmergepublications AS PUBS INNER JOIN
         dbo.sysmergesubscriptions AS SUBS ON PUBS.pubid = SUBS.pubid AND PUBS.publisher <> SUBS.subscriber_server

GO
INSERT [dbo].[ChiNhanh] ([MaCN], [TenChiNhanh], [DiaChi], [MaVung], [rowguid]) VALUES (N'CNDT                          ', N'Mỹ Phẩm Laura Sunshine 1', N'102 Tân Khánh Trung, Lấp Vò, Đồng Tháp', 2, N'785ca6a5-579c-eb11-897a-5c5f677edceb')
INSERT [dbo].[ChiNhanh] ([MaCN], [TenChiNhanh], [DiaChi], [MaVung], [rowguid]) VALUES (N'CNLA                          ', N'Mỹ Phẩm Laura Sunshine 2', N'66 Tân An,Hà Đông,Long An', 3, N'795ca6a5-579c-eb11-897a-5c5f677edceb')
INSERT [dbo].[HoaDon] ([MaHD], [MaKH], [MaSP], [MaCN], [MaNV], [TenSP], [SoLuong], [GiaBan], [TongTien], [NgayLap], [rowguid]) VALUES (N'HD002                         ', N'KH003                         ', N'SP001                         ', N'CNLA                          ', N'NV003                         ', N'Kem Chống Lão Hóa', 1, 250000.0000, 250000.0000, CAST(N'2021-04-13 19:11:14.607' AS DateTime), N'a45ca6a5-579c-eb11-897a-5c5f677edceb')
INSERT [dbo].[HoaDon] ([MaHD], [MaKH], [MaSP], [MaCN], [MaNV], [TenSP], [SoLuong], [GiaBan], [TongTien], [NgayLap], [rowguid]) VALUES (N'HD003                         ', N'KH004                         ', N'SP003                         ', N'CNDT                          ', N'NV002                         ', N'Xịt Khoáng', 1, 200000.0000, 200000.0000, CAST(N'2021-04-13 19:11:14.607' AS DateTime), N'a55ca6a5-579c-eb11-897a-5c5f677edceb')
INSERT [dbo].[HoaDon] ([MaHD], [MaKH], [MaSP], [MaCN], [MaNV], [TenSP], [SoLuong], [GiaBan], [TongTien], [NgayLap], [rowguid]) VALUES (N'HD004                         ', N'KH006                         ', N'SP004                         ', N'CNLA                          ', N'NV004                         ', N'Bộ Phấn mắt', 1, 300000.0000, 300000.0000, CAST(N'2021-04-13 19:11:14.607' AS DateTime), N'a65ca6a5-579c-eb11-897a-5c5f677edceb')
INSERT [dbo].[HoaDon] ([MaHD], [MaKH], [MaSP], [MaCN], [MaNV], [TenSP], [SoLuong], [GiaBan], [TongTien], [NgayLap], [rowguid]) VALUES (N'HD005                         ', N'KH009                         ', N'SP002                         ', N'CNLA                          ', N'NV003                         ', N'Kem Chống Lão Hóa', 1, 250000.0000, 250000.0000, CAST(N'2021-04-14 08:41:11.000' AS DateTime), N'a0c49a7d-c29c-eb11-897a-5c5f677edceb')
INSERT [dbo].[HoaDon] ([MaHD], [MaKH], [MaSP], [MaCN], [MaNV], [TenSP], [SoLuong], [GiaBan], [TongTien], [NgayLap], [rowguid]) VALUES (N'HD006                         ', N'KH001                         ', N'SP002                         ', N'CNDT                          ', N'NV001                         ', N'Kem Chống Lão Hóa', 2, 250000.0000, 500000.0000, CAST(N'2021-04-14 10:22:28.000' AS DateTime), N'bb55aaa3-d09c-eb11-897a-5c5f677edceb')
INSERT [dbo].[KhachHang] ([MaKH], [TenKH], [DiaChi], [SDT], [Email], [CongViec], [Phai], [NgaySinh], [MaCN], [rowguid]) VALUES (N'KH001                         ', N'Lý Nhã Kỳ', N'Đồng Tháp', N'0795802685     ', N'ky@gmail.com', N'Văn Phòng', N'Nữ   ', CAST(N'1988-03-12' AS Date), N'CNDT                          ', N'825ca6a5-579c-eb11-897a-5c5f677edceb')
INSERT [dbo].[KhachHang] ([MaKH], [TenKH], [DiaChi], [SDT], [Email], [CongViec], [Phai], [NgaySinh], [MaCN], [rowguid]) VALUES (N'KH0010                        ', N'Võ Nguyễn Hoài Lâm', N'Đồng Tháp', N'0998653434     ', N'lam@gmail.com', N'Sinh Viên', N'Nam  ', CAST(N'2001-09-09' AS Date), N'CNDT                          ', N'835ca6a5-579c-eb11-897a-5c5f677edceb')
INSERT [dbo].[KhachHang] ([MaKH], [TenKH], [DiaChi], [SDT], [Email], [CongViec], [Phai], [NgaySinh], [MaCN], [rowguid]) VALUES (N'KH0011                        ', N'Nguyễn Ngọc Thủy', N'Đồng Tháp', N'0794353685     ', N'thuy@gmail.com', N'Sinh Viên', N'Nữ   ', CAST(N'2000-09-18' AS Date), N'CNDT                          ', N'845ca6a5-579c-eb11-897a-5c5f677edceb')
INSERT [dbo].[KhachHang] ([MaKH], [TenKH], [DiaChi], [SDT], [Email], [CongViec], [Phai], [NgaySinh], [MaCN], [rowguid]) VALUES (N'KH002                         ', N'Ninh Dương Lan Ngọc', N'Đồng Tháp', N'0795795435     ', N'ngoc@gmail.com', N'Diễn Viên', N'Nữ   ', CAST(N'1980-04-23' AS Date), N'CNDT                          ', N'855ca6a5-579c-eb11-897a-5c5f677edceb')
INSERT [dbo].[KhachHang] ([MaKH], [TenKH], [DiaChi], [SDT], [Email], [CongViec], [Phai], [NgaySinh], [MaCN], [rowguid]) VALUES (N'KH003                         ', N'Nguyễn Tiến Luật', N'Long An', N'0795782672     ', N'luat@gmail.com', N'Diễn Viên', N'Nam  ', CAST(N'1986-09-21' AS Date), N'CNLA                          ', N'865ca6a5-579c-eb11-897a-5c5f677edceb')
INSERT [dbo].[KhachHang] ([MaKH], [TenKH], [DiaChi], [SDT], [Email], [CongViec], [Phai], [NgaySinh], [MaCN], [rowguid]) VALUES (N'KH004                         ', N'Lâm Vỹ Dạ', N'Đồng Tháp', N'0795984282     ', N'da@gmail.com', N'Nội Trợ', N'Nữ   ', CAST(N'1991-05-16' AS Date), N'CNDT                          ', N'875ca6a5-579c-eb11-897a-5c5f677edceb')
INSERT [dbo].[KhachHang] ([MaKH], [TenKH], [DiaChi], [SDT], [Email], [CongViec], [Phai], [NgaySinh], [MaCN], [rowguid]) VALUES (N'KH005                         ', N'Vũ Minh Minh', N'Long An', N'09395802464    ', N'minh@gmail.com', N'Văn Phòng', N'Nam  ', CAST(N'1990-03-15' AS Date), N'CNLA                          ', N'885ca6a5-579c-eb11-897a-5c5f677edceb')
INSERT [dbo].[KhachHang] ([MaKH], [TenKH], [DiaChi], [SDT], [Email], [CongViec], [Phai], [NgaySinh], [MaCN], [rowguid]) VALUES (N'KH006                         ', N'Hà Tiễn Chúc', N'Long An', N'0785494295     ', N'chuc@gmail.com', N'Nội Trợ', N'Nữ   ', CAST(N'1987-10-26' AS Date), N'CNLA                          ', N'895ca6a5-579c-eb11-897a-5c5f677edceb')
INSERT [dbo].[KhachHang] ([MaKH], [TenKH], [DiaChi], [SDT], [Email], [CongViec], [Phai], [NgaySinh], [MaCN], [rowguid]) VALUES (N'KH007                         ', N'Nguyễn Thị Ngọc Mỹ', N'Đồng Tháp', N'0795848885     ', N'my@gmail.com', N'Sinh Viên', N'Nữ   ', CAST(N'2000-10-11' AS Date), N'CNDT                          ', N'8a5ca6a5-579c-eb11-897a-5c5f677edceb')
INSERT [dbo].[KhachHang] ([MaKH], [TenKH], [DiaChi], [SDT], [Email], [CongViec], [Phai], [NgaySinh], [MaCN], [rowguid]) VALUES (N'KH008                         ', N'Nguyễn Anh Thư', N'Long An', N'0889502685     ', N'thu@gmail.com', N'Sinh Viên', N'Nữ   ', CAST(N'2000-04-29' AS Date), N'CNLA                          ', N'8b5ca6a5-579c-eb11-897a-5c5f677edceb')
INSERT [dbo].[KhachHang] ([MaKH], [TenKH], [DiaChi], [SDT], [Email], [CongViec], [Phai], [NgaySinh], [MaCN], [rowguid]) VALUES (N'KH009                         ', N'Lương Thế Vinh', N'Long An', N'0795806786     ', N'vinh@gmail.com', N'Văn Phòng', N'Nam  ', CAST(N'1982-11-29' AS Date), N'CNLA                          ', N'8c5ca6a5-579c-eb11-897a-5c5f677edceb')
INSERT [dbo].[LoaiSP] ([MaLoai], [TenLoai], [rowguid]) VALUES (N'KemBanDem                     ', N'Kem Ban Đêm', N'7a5ca6a5-579c-eb11-897a-5c5f677edceb')
INSERT [dbo].[LoaiSP] ([MaLoai], [TenLoai], [rowguid]) VALUES (N'KemDuong                      ', N'Kem Dưỡng', N'7b5ca6a5-579c-eb11-897a-5c5f677edceb')
INSERT [dbo].[LoaiSP] ([MaLoai], [TenLoai], [rowguid]) VALUES (N'KemTrang                      ', N'Kem Trắng Da', N'7c5ca6a5-579c-eb11-897a-5c5f677edceb')
INSERT [dbo].[LoaiSP] ([MaLoai], [TenLoai], [rowguid]) VALUES (N'TrangDiem                     ', N'Dụng Cụ Trang Điểm', N'7d5ca6a5-579c-eb11-897a-5c5f677edceb')
INSERT [dbo].[NhaKho] ([MaKho], [MaLoai], [MaSP], [SLNhap], [SLTon], [MaCN], [rowguid]) VALUES (N'KhoDT                         ', N'KemBanDem                     ', N'SP002                         ', 60, 60, N'CNDT                          ', N'9a5ca6a5-579c-eb11-897a-5c5f677edceb')
INSERT [dbo].[NhaKho] ([MaKho], [MaLoai], [MaSP], [SLNhap], [SLTon], [MaCN], [rowguid]) VALUES (N'KhoDT                         ', N'KemDuong                      ', N'SP003                         ', 100, 51, N'CNDT                          ', N'9b5ca6a5-579c-eb11-897a-5c5f677edceb')
INSERT [dbo].[NhaKho] ([MaKho], [MaLoai], [MaSP], [SLNhap], [SLTon], [MaCN], [rowguid]) VALUES (N'KhoDT                         ', N'KemTrang                      ', N'SP001                         ', 30, 17, N'CNDT                          ', N'9c5ca6a5-579c-eb11-897a-5c5f677edceb')
INSERT [dbo].[NhaKho] ([MaKho], [MaLoai], [MaSP], [SLNhap], [SLTon], [MaCN], [rowguid]) VALUES (N'KhoDT                         ', N'TrangDiem                     ', N'SP004                         ', 30, 30, N'CNDT                          ', N'9d5ca6a5-579c-eb11-897a-5c5f677edceb')
INSERT [dbo].[NhaKho] ([MaKho], [MaLoai], [MaSP], [SLNhap], [SLTon], [MaCN], [rowguid]) VALUES (N'KhoLA                         ', N'KemBanDem                     ', N'SP002                         ', 60, 60, N'CNLA                          ', N'9e5ca6a5-579c-eb11-897a-5c5f677edceb')
INSERT [dbo].[NhaKho] ([MaKho], [MaLoai], [MaSP], [SLNhap], [SLTon], [MaCN], [rowguid]) VALUES (N'KhoLA                         ', N'KemDuong                      ', N'SP003                         ', 270, 111, N'CNLA                          ', N'9f5ca6a5-579c-eb11-897a-5c5f677edceb')
INSERT [dbo].[NhaKho] ([MaKho], [MaLoai], [MaSP], [SLNhap], [SLTon], [MaCN], [rowguid]) VALUES (N'KhoLA                         ', N'KemTrang                      ', N'SP001                         ', 30, 31, N'CNLA                          ', N'a05ca6a5-579c-eb11-897a-5c5f677edceb')
INSERT [dbo].[NhaKho] ([MaKho], [MaLoai], [MaSP], [SLNhap], [SLTon], [MaCN], [rowguid]) VALUES (N'KhoLA                         ', N'TrangDiem                     ', N'SP004                         ', 50, 27, N'CNLA                          ', N'a15ca6a5-579c-eb11-897a-5c5f677edceb')
INSERT [dbo].[NhanVien] ([MaNV], [HoTen], [SDT], [QueQuan], [NgayVaoLam], [Luong], [Phai], [MaCN], [rowguid]) VALUES (N'NV001                         ', N'Cao thị Hồng Liên', N'0794700773     ', N'Vĩnh Long', CAST(N'2020-03-28' AS Date), 4500000.0000, N'Nữ   ', N'CNDT                          ', N'8d5ca6a5-579c-eb11-897a-5c5f677edceb')
INSERT [dbo].[NhanVien] ([MaNV], [HoTen], [SDT], [QueQuan], [NgayVaoLam], [Luong], [Phai], [MaCN], [rowguid]) VALUES (N'NV002                         ', N'Nguyễn Tiến Dũng', N'07943828572    ', N'Đồng Tháp', CAST(N'2020-03-21' AS Date), 4500000.0000, N'Nam  ', N'CNDT                          ', N'8e5ca6a5-579c-eb11-897a-5c5f677edceb')
INSERT [dbo].[NhanVien] ([MaNV], [HoTen], [SDT], [QueQuan], [NgayVaoLam], [Luong], [Phai], [MaCN], [rowguid]) VALUES (N'NV003                         ', N'Võ Hoàng Tiến', N'0668923224     ', N'Long An', CAST(N'2021-01-16' AS Date), 3500000.0000, N'Nam  ', N'CNLA                          ', N'8f5ca6a5-579c-eb11-897a-5c5f677edceb')
INSERT [dbo].[NhanVien] ([MaNV], [HoTen], [SDT], [QueQuan], [NgayVaoLam], [Luong], [Phai], [MaCN], [rowguid]) VALUES (N'NV004                         ', N'Nguyễn Thị Mỹ Hằng', N'0982364325     ', N'Vĩnh Long', CAST(N'2020-01-08' AS Date), 5000000.0000, N'Nữ   ', N'CNLA                          ', N'905ca6a5-579c-eb11-897a-5c5f677edceb')
INSERT [dbo].[NhaSanXuat] ([MaNSX], [TenNSX], [DiaChi], [rowguid]) VALUES (N'NSX001                        ', N'ResHPCos', N'TPHCM', N'7e5ca6a5-579c-eb11-897a-5c5f677edceb')
INSERT [dbo].[NhaSanXuat] ([MaNSX], [TenNSX], [DiaChi], [rowguid]) VALUES (N'NSX002                        ', N'Kanna Cosmetics', N'TPHCM', N'7f5ca6a5-579c-eb11-897a-5c5f677edceb')
INSERT [dbo].[NhaSanXuat] ([MaNSX], [TenNSX], [DiaChi], [rowguid]) VALUES (N'NSX003                        ', N'Tân Ngọc Phát', N'TPHCM', N'805ca6a5-579c-eb11-897a-5c5f677edceb')
INSERT [dbo].[NhaSanXuat] ([MaNSX], [TenNSX], [DiaChi], [rowguid]) VALUES (N'NSX004                        ', N'Lahy’s', N'TPHCM', N'815ca6a5-579c-eb11-897a-5c5f677edceb')
INSERT [dbo].[QuanLy] ([MaQL], [TenNguoiQL], [SDT], [MaNV], [MaCN], [Phai], [rowguid]) VALUES (N'QL01                          ', N'Cao Kỳ Duyên', N'0123456789     ', N'NV001                         ', N'CNDT                          ', N'Nữ   ', N'915ca6a5-579c-eb11-897a-5c5f677edceb')
INSERT [dbo].[QuanLy] ([MaQL], [TenNguoiQL], [SDT], [MaNV], [MaCN], [Phai], [rowguid]) VALUES (N'QL02                          ', N'Trương Triệu Vũ', N'0908765432     ', N'NV003                         ', N'CNLA                          ', N'Nam  ', N'925ca6a5-579c-eb11-897a-5c5f677edceb')
INSERT [dbo].[SanPham] ([MaSP], [TenSP], [Hinh], [Size], [GiaNhap], [GiaBan], [MaNSX], [MaLoai], [rowguid]) VALUES (N'SP001                         ', N'Kem Dưỡng Da Nha Đam', N'Hinhnhadam.jpg', N'20g', 150000.0000, 200000.0000, N'NSX001                        ', N'KemDuong                      ', N'935ca6a5-579c-eb11-897a-5c5f677edceb')
INSERT [dbo].[SanPham] ([MaSP], [TenSP], [Hinh], [Size], [GiaNhap], [GiaBan], [MaNSX], [MaLoai], [rowguid]) VALUES (N'SP002                         ', N'Kem Chống Lão Hóa', N'Hinhlaohoa.jpg', N'20g', 100000.0000, 250000.0000, N'NSX001                        ', N'KemBanDem                     ', N'945ca6a5-579c-eb11-897a-5c5f677edceb')
INSERT [dbo].[SanPham] ([MaSP], [TenSP], [Hinh], [Size], [GiaNhap], [GiaBan], [MaNSX], [MaLoai], [rowguid]) VALUES (N'SP003                         ', N'Xịt Khoáng', N'Hinhxitkhoang.jpg', N'300ml', 150000.0000, 200000.0000, N'NSX002                        ', N'KemDuong                      ', N'955ca6a5-579c-eb11-897a-5c5f677edceb')
INSERT [dbo].[SanPham] ([MaSP], [TenSP], [Hinh], [Size], [GiaNhap], [GiaBan], [MaNSX], [MaLoai], [rowguid]) VALUES (N'SP004                         ', N'Bộ Phấn mắt', N'Hinhmaskara.jpg', N'20g', 250000.0000, 300000.0000, N'NSX003                        ', N'TrangDiem                     ', N'965ca6a5-579c-eb11-897a-5c5f677edceb')
INSERT [dbo].[SanPham] ([MaSP], [TenSP], [Hinh], [Size], [GiaNhap], [GiaBan], [MaNSX], [MaLoai], [rowguid]) VALUES (N'SP005                         ', N'Nước Tẩy Trang', N'Hinhtaytrang.jpg', N'300ml', 150000.0000, 200000.0000, N'NSX002                        ', N'TrangDiem                     ', N'975ca6a5-579c-eb11-897a-5c5f677edceb')
INSERT [dbo].[SanPham] ([MaSP], [TenSP], [Hinh], [Size], [GiaNhap], [GiaBan], [MaNSX], [MaLoai], [rowguid]) VALUES (N'SP006                         ', N'Kem Body Ngọc Trai', N'Hinhkembody.jpg', N'50g', 150000.0000, 300000.0000, N'NSX003                        ', N'KemTrang                      ', N'985ca6a5-579c-eb11-897a-5c5f677edceb')
INSERT [dbo].[SanPham] ([MaSP], [TenSP], [Hinh], [Size], [GiaNhap], [GiaBan], [MaNSX], [MaLoai], [rowguid]) VALUES (N'SP007                         ', N'Kem Body Nhân Sâm', N'kembody.jpg', N'20g', 250000.0000, 350000.0000, N'NSX003                        ', N'KemBanDem                     ', N'995ca6a5-579c-eb11-897a-5c5f677edceb')
INSERT [dbo].[SanPham] ([MaSP], [TenSP], [Hinh], [Size], [GiaNhap], [GiaBan], [MaNSX], [MaLoai], [rowguid]) VALUES (N'SP008                         ', N'Kem Dưỡng Trắng Ban Đêm', N'Hinhkembandem.jpg', N'20g', 160000.0000, 220000.0000, N'NSX002                        ', N'KemBanDem                     ', N'8ecfcc40-5f9c-eb11-897a-5c5f677edceb')
INSERT [dbo].[SanPham] ([MaSP], [TenSP], [Hinh], [Size], [GiaNhap], [GiaBan], [MaNSX], [MaLoai], [rowguid]) VALUES (N'SP009                         ', N'Kem 5 BÀ TRỘN', N'HinhKEM5BATRON.jpg', N'20g', 150000.0000, 300000.0000, N'NSX002                        ', N'KemDuong                      ', N'f1fe2898-a29d-eb11-897a-5c5f677edceb')
SET ANSI_PADDING ON

GO
/****** Object:  Index [UQ__ChiNhanh__E92E48A41790112D]    Script Date: 4/21/2021 12:23:59 AM ******/
ALTER TABLE [dbo].[ChiNhanh] ADD UNIQUE NONCLUSTERED 
(
	[TenChiNhanh] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [MSmerge_index_309576141]    Script Date: 4/21/2021 12:23:59 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [MSmerge_index_309576141] ON [dbo].[ChiNhanh]
(
	[rowguid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [MSmerge_index_1293247662]    Script Date: 4/21/2021 12:23:59 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [MSmerge_index_1293247662] ON [dbo].[HoaDon]
(
	[rowguid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [MSmerge_index_1053246807]    Script Date: 4/21/2021 12:23:59 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [MSmerge_index_1053246807] ON [dbo].[KhachHang]
(
	[rowguid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [MSmerge_index_405576483]    Script Date: 4/21/2021 12:23:59 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [MSmerge_index_405576483] ON [dbo].[LoaiSP]
(
	[rowguid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [MSmerge_index_501576825]    Script Date: 4/21/2021 12:23:59 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [MSmerge_index_501576825] ON [dbo].[NhaKho]
(
	[rowguid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [MSmerge_index_1245247491]    Script Date: 4/21/2021 12:23:59 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [MSmerge_index_1245247491] ON [dbo].[NhanVien]
(
	[rowguid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [MSmerge_index_277576027]    Script Date: 4/21/2021 12:23:59 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [MSmerge_index_277576027] ON [dbo].[NhaSanXuat]
(
	[rowguid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [MSmerge_index_1389248004]    Script Date: 4/21/2021 12:23:59 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [MSmerge_index_1389248004] ON [dbo].[QuanLy]
(
	[rowguid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [MSmerge_index_437576597]    Script Date: 4/21/2021 12:23:59 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [MSmerge_index_437576597] ON [dbo].[SanPham]
(
	[rowguid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ChiNhanh] ADD  CONSTRAINT [MSmerge_df_rowguid_F0C1B1EACA9B4AE1A76715962F925056]  DEFAULT (newsequentialid()) FOR [rowguid]
GO
ALTER TABLE [dbo].[HoaDon] ADD  DEFAULT (getdate()) FOR [NgayLap]
GO
ALTER TABLE [dbo].[HoaDon] ADD  CONSTRAINT [MSmerge_df_rowguid_85B2E69A2C574054B8A29A71140130CE]  DEFAULT (newsequentialid()) FOR [rowguid]
GO
ALTER TABLE [dbo].[KhachHang] ADD  CONSTRAINT [MSmerge_df_rowguid_0C36F2FC0D6347BEB11503E2744413F0]  DEFAULT (newsequentialid()) FOR [rowguid]
GO
ALTER TABLE [dbo].[LoaiSP] ADD  CONSTRAINT [MSmerge_df_rowguid_4A73B2662D694AABB8C64EAF1909C8F9]  DEFAULT (newsequentialid()) FOR [rowguid]
GO
ALTER TABLE [dbo].[NhaKho] ADD  CONSTRAINT [MSmerge_df_rowguid_B516D6D1BF71415C91FDAFB1EADA1D7C]  DEFAULT (newsequentialid()) FOR [rowguid]
GO
ALTER TABLE [dbo].[NhanVien] ADD  CONSTRAINT [MSmerge_df_rowguid_6B10D1C23A6847E3BF7CD73D6534340D]  DEFAULT (newsequentialid()) FOR [rowguid]
GO
ALTER TABLE [dbo].[NhaSanXuat] ADD  CONSTRAINT [MSmerge_df_rowguid_F3F921FF89164676B3A63A0B78AE30DB]  DEFAULT (newsequentialid()) FOR [rowguid]
GO
ALTER TABLE [dbo].[QuanLy] ADD  CONSTRAINT [MSmerge_df_rowguid_30B5F2C2B42B429E85161D93DDE8D7F2]  DEFAULT (newsequentialid()) FOR [rowguid]
GO
ALTER TABLE [dbo].[SanPham] ADD  CONSTRAINT [MSmerge_df_rowguid_22FEDA8FCED249BD9AD50C4B8A63102A]  DEFAULT (newsequentialid()) FOR [rowguid]
GO
ALTER TABLE [dbo].[HoaDon]  WITH CHECK ADD  CONSTRAINT [FK_HD_CN] FOREIGN KEY([MaCN])
REFERENCES [dbo].[ChiNhanh] ([MaCN])
GO
ALTER TABLE [dbo].[HoaDon] CHECK CONSTRAINT [FK_HD_CN]
GO
ALTER TABLE [dbo].[HoaDon]  WITH CHECK ADD  CONSTRAINT [fk_HD_KH] FOREIGN KEY([MaKH])
REFERENCES [dbo].[KhachHang] ([MaKH])
GO
ALTER TABLE [dbo].[HoaDon] CHECK CONSTRAINT [fk_HD_KH]
GO
ALTER TABLE [dbo].[HoaDon]  WITH CHECK ADD  CONSTRAINT [fk_HD_SP] FOREIGN KEY([MaSP])
REFERENCES [dbo].[SanPham] ([MaSP])
GO
ALTER TABLE [dbo].[HoaDon] CHECK CONSTRAINT [fk_HD_SP]
GO
ALTER TABLE [dbo].[KhachHang]  WITH CHECK ADD  CONSTRAINT [FK_KH_CN] FOREIGN KEY([MaCN])
REFERENCES [dbo].[ChiNhanh] ([MaCN])
GO
ALTER TABLE [dbo].[KhachHang] CHECK CONSTRAINT [FK_KH_CN]
GO
ALTER TABLE [dbo].[NhaKho]  WITH CHECK ADD  CONSTRAINT [fk_NK_CN] FOREIGN KEY([MaCN])
REFERENCES [dbo].[ChiNhanh] ([MaCN])
GO
ALTER TABLE [dbo].[NhaKho] CHECK CONSTRAINT [fk_NK_CN]
GO
ALTER TABLE [dbo].[NhaKho]  WITH CHECK ADD  CONSTRAINT [fk_NK_Loai] FOREIGN KEY([MaLoai])
REFERENCES [dbo].[LoaiSP] ([MaLoai])
GO
ALTER TABLE [dbo].[NhaKho] CHECK CONSTRAINT [fk_NK_Loai]
GO
ALTER TABLE [dbo].[NhaKho]  WITH CHECK ADD  CONSTRAINT [fk_NK_SP] FOREIGN KEY([MaSP])
REFERENCES [dbo].[SanPham] ([MaSP])
GO
ALTER TABLE [dbo].[NhaKho] CHECK CONSTRAINT [fk_NK_SP]
GO
ALTER TABLE [dbo].[NhanVien]  WITH CHECK ADD  CONSTRAINT [fk_NV_CN] FOREIGN KEY([MaCN])
REFERENCES [dbo].[ChiNhanh] ([MaCN])
GO
ALTER TABLE [dbo].[NhanVien] CHECK CONSTRAINT [fk_NV_CN]
GO
ALTER TABLE [dbo].[QuanLy]  WITH CHECK ADD  CONSTRAINT [FK_QL_CN] FOREIGN KEY([MaCN])
REFERENCES [dbo].[ChiNhanh] ([MaCN])
GO
ALTER TABLE [dbo].[QuanLy] CHECK CONSTRAINT [FK_QL_CN]
GO
ALTER TABLE [dbo].[QuanLy]  WITH CHECK ADD  CONSTRAINT [FK_QL_NV] FOREIGN KEY([MaNV])
REFERENCES [dbo].[NhanVien] ([MaNV])
GO
ALTER TABLE [dbo].[QuanLy] CHECK CONSTRAINT [FK_QL_NV]
GO
ALTER TABLE [dbo].[SanPham]  WITH CHECK ADD  CONSTRAINT [fk_SP_Loai] FOREIGN KEY([MaLoai])
REFERENCES [dbo].[LoaiSP] ([MaLoai])
GO
ALTER TABLE [dbo].[SanPham] CHECK CONSTRAINT [fk_SP_Loai]
GO
ALTER TABLE [dbo].[SanPham]  WITH CHECK ADD  CONSTRAINT [fk_SP_NSX] FOREIGN KEY([MaNSX])
REFERENCES [dbo].[NhaSanXuat] ([MaNSX])
GO
ALTER TABLE [dbo].[SanPham] CHECK CONSTRAINT [fk_SP_NSX]
GO
USE [master]
GO
ALTER DATABASE [MyPham_CSDLPT] SET  READ_WRITE 
GO
