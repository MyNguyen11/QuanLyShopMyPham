Create database MyPham_CSDLPT
use MyPham_CSDLPT


Create table NhaSanXuat
(
	MaNSX nchar(30) not null primary key,
	TenNSX nvarchar(60) not null,
	DiaChi nvarchar(200)
)


Create table ChiNhanh
(
	MaCN nchar(30) not null,
	TenChiNhanh nvarchar(100) unique,
	DiaChi nvarchar(100),
	MaVung int,
	primary key(MaCN)
)

create table KhachHang
(
	MaKH nchar(30) not null primary key,
	TenKH nvarchar(30) not null,
	DiaChi nvarchar(100) not null,
	SDT char(15) not null,
	Email nvarchar(50) not null,
	CongViec nvarchar(30),
	Phai nchar(5),
	NgaySinh date,
	MaCN nchar(30) not null,
	constraint FK_KH_CN foreign key (MaCN) references ChiNhanh(MaCN)
) 


create table NhanVien
(
	MaNV nchar(30) not null primary key,
	HoTen nvarchar(100),
	SDT char(15),
	QueQuan nvarchar(100),
	NgayVaoLam Date,
	Luong money,
	Phai nchar(5),
	MaCN nchar(30) not null,
	constraint fk_NV_CN foreign key (MaCN) references ChiNhanh(MaCN)
)


create table LoaiSP
(
	MaLoai nchar(30) not null primary key,
	TenLoai nvarchar(100) not null,
)

create table SanPham
(
	MaSP nchar(30) not null primary key,
	TenSP nvarchar(100) not null,
	Hinh nvarchar(100) not null,
	Size nvarchar(100) not null,
	GiaNhap money,
	GiaBan money,
	MaNSX nchar(30) not null,
	MaLoai nchar(30) not null,
	constraint fk_SP_NSX foreign key(MaNSX) references NhaSanXuat(MaNSX),
	constraint fk_SP_Loai foreign key(MaLoai) references LoaiSP(MaLoai),
)

Create table NhaKho
(
	MaKho nchar(30) not null,
	MaLoai nchar(30) not null,
	MaSP nchar(30) not null,
	SLNhap int,
	SLTon int,
	MaCN nchar(30),
	primary key (MaKho,MaLoai,MaSP),
	constraint fk_NK_CN foreign key (MaCN) references ChiNhanh(MaCN),
	constraint fk_NK_Loai foreign key(MaLoai) references LoaiSP(MaLoai),
	constraint fk_NK_SP foreign key(MaSP) references SanPham(MaSP),
)

create table HoaDon
(
	MaHD nchar(30) not null,
	MaKH nchar(30) not null,
	MaSP nchar(30) not null,
	MaCN nchar(30) not null,
	MaNV nchar(30) not null,
	TenSP nvarchar(100) not null,
	SoLuong int,
	GiaBan money,
	TongTien money,
	NgayLap datetime default getdate(),
	primary key (MaHD,MaSP),
	constraint fk_HD_KH foreign key(MaKH) references KhachHang(MaKH),
	constraint fk_HD_SP foreign key(MaSP) references SanPham(MaSP),
	constraint FK_HD_CN foreign key (MaCN) references ChiNhanh(MaCN)
)


---======================================================**DỮ LIỆU**=================================================---

---==========================================================================---
insert into NhaSanXuat(MaNSX,TenNSX,DiaChi)
values ('NSX001',N'ResHPCos','TPHCM')

insert into NhaSanXuat(MaNSX,TenNSX,DiaChi)
values ('NSX002',N'Kanna Cosmetics','TPHCM')

insert into NhaSanXuat(MaNSX,TenNSX,DiaChi)
values ('NSX003',N'Tân Ngọc Phát','TPHCM')

insert into NhaSanXuat(MaNSX,TenNSX,DiaChi)
values ('NSX004',N'Lahy’s','TPHCM')

---==========================================================================---

insert into ChiNhanh(MaCN,TenChiNhanh,DiaChi,MaVung)
values ('CNDT',N'Mỹ Phẩm Laura Sunshine 1',N'102 Tân Khánh Trung, Lấp Vò, Đồng Tháp',2)

insert into ChiNhanh(MaCN,TenChiNhanh,DiaChi,MaVung)
values ('CNLA',N'Mỹ Phẩm Laura Sunshine 2',N'66 Tân An,Hà Đông,Long An',3)

---==========================================================================---
set dateformat dmy;

insert into KhachHang(MaKH,TenKH,DiaChi,SDT,Email,CongViec,Phai,NgaySinh,MaCN)
Values ('KH001',N'Lý Nhã Kỳ',N'Đồng Tháp','0795802685','ky@gmail.com',N'Văn Phòng',N'Nữ','12-03-1988','CNDT')

insert into KhachHang(MaKH,TenKH,DiaChi,SDT,Email,CongViec,Phai,NgaySinh,MaCN)
Values ('KH002',N'Ninh Dương Lan Ngọc',N'Đồng Tháp','0795795435','ngoc@gmail.com',N'Văn Phòng',N'Nữ','23-04-1980','CNDT')

insert into KhachHang(MaKH,TenKH,DiaChi,SDT,Email,CongViec,Phai,NgaySinh,MaCN)
Values ('KH003',N'Nguyễn Tiến Luật',N'Long An','0795782672','luat@gmail.com',N'Diễn Viên','Nam','21-09-1986','CNLA')

insert into KhachHang(MaKH,TenKH,DiaChi,SDT,Email,CongViec,Phai,NgaySinh,MaCN)
Values ('KH004',N'Lâm Vỹ Dạ',N'Đồng Tháp','0795984282','da@gmail.com',N'Nội Trợ',N'Nữ','16-05-1991','CNDT')

insert into KhachHang(MaKH,TenKH,DiaChi,SDT,Email,CongViec,Phai,NgaySinh,MaCN)
Values ('KH005',N'Vũ Minh Minh',N'Long An','09395802464','minh@gmail.com',N'Văn Phòng','Nam','15-03-1990','CNLA')

insert into KhachHang(MaKH,TenKH,DiaChi,SDT,Email,CongViec,Phai,NgaySinh,MaCN)
Values ('KH006',N'Hà Tiễn Chúc',N'Long An','0785494295','chuc@gmail.com',N'Nội Trợ',N'Nữ','26-10-1987','CNLA')

insert into KhachHang(MaKH,TenKH,DiaChi,SDT,Email,CongViec,Phai,NgaySinh,MaCN)
Values ('KH007',N'Nguyễn Thị Ngọc Mỹ',N'Đồng Tháp','0795848885','my@gmail.com',N'Sinh Viên',N'Nữ','11-10-2000','CNDT')

insert into KhachHang(MaKH,TenKH,DiaChi,SDT,Email,CongViec,Phai,NgaySinh,MaCN)
Values ('KH008',N'Nguyễn Anh Thư',N'Long An','0889502685','thu@gmail.com',N'Sinh Viên',N'Nữ','29-04-2000','CNLA')

insert into KhachHang(MaKH,TenKH,DiaChi,SDT,Email,CongViec,Phai,NgaySinh,MaCN)
Values ('KH009',N'Lương Thế Vinh',N'Long An','0795806786','vinh@gmail.com',N'Văn Phòng','Nam','29-11-1982','CNLA')

insert into KhachHang(MaKH,TenKH,DiaChi,SDT,Email,CongViec,Phai,NgaySinh,MaCN)
Values ('KH0010',N'Võ Nguyễn Hoài Lâm',N'Đồng Tháp','0998653434','lam@gmail.com',N'Sinh Viên','Nam','09-09-2001','CNDT')

insert into KhachHang(MaKH,TenKH,DiaChi,SDT,Email,CongViec,Phai,NgaySinh,MaCN)
Values ('KH0011',N'Nguyễn Ngọc Thủy',N'Đồng Tháp','0794353685','thuy@gmail.com',N'Sinh Viên',N'Nữ','18-09-2000','CNDT')

--=================================================================================================

insert into NhanVien(MaNV,HoTen,SDT,QueQuan,NgayVaoLam,Luong,MaCN,Phai)
values ('NV001',N'Cao thị Hồng Liên','0794700773',N'Vĩnh Long','28-03-2020',4500000,'CNDT',N'Nữ')

insert into NhanVien(MaNV,HoTen,SDT,QueQuan,NgayVaoLam,Luong,MaCN,Phai)
values ('NV002',N'Nguyễn Tiến Dũng','07943828572',N'Đồng Tháp','21-03-2020',4500000,'CNDT','Nam')

insert into NhanVien(MaNV,HoTen,SDT,QueQuan,NgayVaoLam,Luong,MaCN,Phai)
values ('NV003',N'Võ Hoàng Tiến','0668923224',N'Long An','16-01-2021',3500000,'CNLA','Nam')

insert into NhanVien(MaNV,HoTen,SDT,QueQuan,NgayVaoLam,Luong,MaCN,Phai)
values ('NV004',N'Nguyễn Thị Mỹ Hằng','0982364325',N'Vĩnh Long','08-01-2020',5000000,'CNLA',N'Nữ')



---==========================================================================---

insert into LoaiSP(MaLoai,TenLoai)
values ('KemDuong',N'Kem Dưỡng')

insert into LoaiSP(MaLoai,TenLoai)
values ('TrangDiem',N'Dụng Cụ Trang Điểm')

insert into LoaiSP(MaLoai,TenLoai)
values ('KemTrang',N'Kem Trắng Da')

insert into LoaiSP(MaLoai,TenLoai)
values ('KemBanDem',N'Kem Ban Đêm')

---==========================================================================---

insert into SanPham(MaSP,TenSP,Hinh,Size,GiaNhap,GiaBan,MaNSX,MaLoai)
Values('SP001',N'Kem Dưỡng Da Nha Đam','Hinhnhadam.jpg','20g',150000,200000,'NSX001','KemDuong')

insert into SanPham(MaSP,TenSP,Hinh,Size,GiaNhap,GiaBan,MaNSX,MaLoai)
Values('SP002',N'Kem Chống Lão Hóa','Hinhlaohoa.jpg','20g',100000,250000,'NSX001','KemBanDem')

insert into SanPham(MaSP,TenSP,Hinh,Size,GiaNhap,GiaBan,MaNSX,MaLoai)
Values('SP003',N'Xịt Khoáng','Hinhxitkhoang.jpg','300ml',150000,200000,'NSX002','KemDuong')

insert into SanPham(MaSP,TenSP,Hinh,Size,GiaNhap,GiaBan,MaNSX,MaLoai)
Values('SP004',N'Bộ Phấn mắt','Hinhmaskara.jpg','20g',250000,300000,'NSX003','TrangDiem')

insert into SanPham(MaSP,TenSP,Hinh,Size,GiaNhap,GiaBan,MaNSX,MaLoai)
Values('SP005',N'Nước Tẩy Trang','Hinhtaytrang.jpg','300ml',150000,200000,'NSX002','TrangDiem')

insert into SanPham(MaSP,TenSP,Hinh,Size,GiaNhap,GiaBan,MaNSX,MaLoai)
Values('SP006',N'Kem Body Ngọc Trai','Hinhkembody.jpg','50g',150000,300000,'NSX003','KemTrang')

---==========================================================================---
insert into NhaKho (MaKho,MaLoai,MaSP,SLNhap,SLTon,MaCN)
Values ('KhoDT','KemTrang','SP001',30,20,'CNDT')

insert into NhaKho (MaKho,MaLoai,MaSP,SLNhap,SLTon,MaCN)
Values ('KhoDT','KemBanDem','SP002',60,20,'CNDT')

insert into NhaKho (MaKho,MaLoai,MaSP,SLNhap,SLTon,MaCN)
Values ('KhoDT','TrangDiem','SP004',30,20,'CNDT')

insert into NhaKho (MaKho,MaLoai,MaSP,SLNhap,SLTon,MaCN)
Values ('KhoDT','KemDuong','SP003',100,50,'CNDT')

insert into NhaKho (MaKho,MaLoai,MaSP,SLNhap,SLTon,MaCN)
Values ('KhoLA','KemTrang','SP001',30,30,'CNLA')

insert into NhaKho (MaKho,MaLoai,MaSP,SLNhap,SLTon,MaCN)
Values ('KhoLA','KemBanDem','SP002',60,37,'CNLA')

insert into NhaKho (MaKho,MaLoai,MaSP,SLNhap,SLTon,MaCN)
Values ('KhoLA','TrangDiem','SP004',50,27,'CNLA')

insert into NhaKho (MaKho,MaLoai,MaSP,SLNhap,SLTon,MaCN)
Values ('KhoLA','KemDuong','SP003',270,110,'CNLA')

---==========================================================================---

insert into HoaDon(MaHD,MaKH,MaSP,MaCN,MaNV,TenSP,SoLuong,GiaBan,TongTien)
Values ('HD001','KH001','SP002','CNDT','NV001',N'Kem Chống Lão Hóa',1,250000,250000)

insert into HoaDon(MaHD,MaKH,MaSP,MaCN,MaNV,TenSP,SoLuong,GiaBan,TongTien)
Values ('HD001','KH001','SP003','CNDT','NV001',N'Xịt Khoáng',1,200000,200000)

insert into HoaDon(MaHD,MaKH,MaSP,MaCN,MaNV,TenSP,SoLuong,GiaBan,TongTien)
Values ('HD002','KH003','SP002','CNLA','NV003',N'Kem Chống Lão Hóa',1,250000,250000)

insert into HoaDon(MaHD,MaKH,MaSP,MaCN,MaNV,TenSP,SoLuong,GiaBan,TongTien)
Values ('HD003','KH004','SP003','CNDT','NV002',N'Xịt Khoáng',1,200000,200000)

insert into HoaDon(MaHD,MaKH,MaSP,MaCN,MaNV,TenSP,SoLuong,GiaBan,TongTien)
Values ('HD004','KH006','SP004','CNLA','NV004',N'Bộ Phấn mắt',1,300000,300000)

---------------------------------------------------------------------------------

create table QuanLy
(
	MaQL nchar(30) not null primary key,
	TenNguoiQL nvarchar(100),
	SDT nchar(15),
	MaNV nchar(30) not null,
	MaCN nchar(30) not null,
	Phai nchar(5),
	constraint FK_QL_CN foreign key (MaCN) references ChiNhanh(MaCN),
	constraint FK_QL_NV foreign key (MaNV) references NhanVien(MaNV)
)

insert into QuanLy(MaQL,TenNguoiQL,SDT,MaNV,MaCN,Phai)
Values('QL01',N'Cao Kỳ Duyên','0123456789','NV001','CNDT',N'Nữ')

insert into QuanLy(MaQL,TenNguoiQL,SDT,MaNV,MaCN,Phai)
Values('QL02',N'Trương Triệu Vũ','0908765432','NV003','CNLA',N'Nam')

----------------------------------------------------------------------------
SELECT   PUBS.description AS TENCN, SUBS.subscriber_server AS TENSERVER
FROM            dbo.sysmergepublications AS PUBS INNER JOIN
                dbo.sysmergesubscriptions AS SUBS ON PUBS.pubid = SUBS.pubid AND PUBS.publisher <> SUBS.subscriber_server




CREATE VIEW [dbo].[V_DS_PHANMANH]
AS
SELECT   PUBS.description AS TENCN, SUBS.subscriber_server AS TENSERVER
FROM     dbo.sysmergepublications AS PUBS INNER JOIN
         dbo.sysmergesubscriptions AS SUBS ON PUBS.pubid = SUBS.pubid AND PUBS.publisher <> SUBS.subscriber_server
GO


select *
from [dbo].V_DS_PHANMANH