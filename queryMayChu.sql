-- Kiểm tra phân tán có thành công chưa, xem các chi nhánh được phân tán dữ liệu từ máy chủ

SELECT   PUBS.description AS TENCN, SUBS.subscriber_server AS TENSERVER
FROM            dbo.sysmergepublications AS PUBS INNER JOIN
                dbo.sysmergesubscriptions AS SUBS ON PUBS.pubid = SUBS.pubid AND PUBS.publisher <> SUBS.subscriber_server


--- Tạo bảng ảo view để chứa 2 cột Tên chi nhánh và tên server

CREATE VIEW [dbo].[V_DS_PHANMANH]
AS
SELECT   PUBS.description AS TENCN, SUBS.subscriber_server AS TENSERVER
FROM     dbo.sysmergepublications AS PUBS INNER JOIN
         dbo.sysmergesubscriptions AS SUBS ON PUBS.pubid = SUBS.pubid AND PUBS.publisher <> SUBS.subscriber_server
GO

select TENCN, TENSERVER from V_DS_PHANMANH


-- cập nhật số lượng hàng trong kho sau khi có khách mua hàng thanh toán hóa đơn

Create trigger trg_BanHang on HoaDon after insert as
begin 
	update NhaKho
	set SLTon = SLTon-(
	select SoLuong
	from inserted
	where MaSP=NhaKho.MaSP
	)
from NhaKho
join inserted on NhaKho.MaSP=inserted.MaSP
end;

--cập nhật lại sản phẩm trong kho sau khi hủy hóa đơn

create trigger trg_HuyHD on HoaDon for delete as
begin
	update NhaKho
	set SLTon=SLTon +
		(select SoLuong from deleted where MaSP =NhaKho.MaSP)
	from NhaKho
	join deleted on NhaKho.MaSP=deleted.MaSP
end;

--cập nhật lại hàng trong kho sau khi cập nhật lại hóa đơn

Create trigger tr_CapNhatHD_Kho on HoaDon after update as
begin
	update NhaKho set SLTon=SLTon-
	(Select SoLuong from inserted where MaSP=NhaKho.MaSP)+
	(select SoLuong from deleted where MaSP=NhaKho.MaSP)
from NhaKho
join deleted on NhaKho.MaSP=deleted.MaSP
end;



---------------------------------------------------------------
--- viết trigger kiểm tra số lượng sản phẩm tồn
create trigger KT_SLTon on NhaKho
instead of insert
as
Declare @makho nchar(30);
Declare @maloai nchar(30);
Declare @masp nchar(30);
declare @slNhap int;
declare @slTon int;
Declare @macn nchar(30);


select @makho=MaKho from inserted;
Select @slTon=SLTon from inserted;

 begin 
	select @slTon=Count(*) from NhaKho nk 
	inner join LoaiSP lsp on lsp.MaLoai = nk.MaLoai
	inner join HoaDon hd on hd.MaSP=nk.MaSP
	where nk.SLTon -(nk.SLTon*@slTon) <0
if(@slTon <0)
	begin
		print N'Hết sản phẩm trong kho rồi, Nhập thêm thôi'
	end;
end;

-----------------------------------------------

CREATE PROCEDURE ThemNhanVien

	@MaNV nchar(30),
	@HoTen nvarchar(100),
	@SDT char(15),
	@QueQuan nvarchar(100),
	@NgayVaoLam date,
	@Luong money,
	@MaCN nchar(30),
	@Phai nchar(5),

	
---------------------------------------------------------------
--Kiểm tra Mã Loại Nhập vào bảng Sản Phẩm đã tồn tại chưa

alter proc themSanPham
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



--Thêm kiểm tra NSX trong quá trình thêm san pham
Create proc themSanPhamKiemTraNSX
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

-------------------------------------------------------------

create proc KiemtraPK_KhachHang
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

---Gọi thực Proce vừa tạo để kiểm tra

select *from KhachHang

exec KiemtraPK_KhachHang 'KH001',N'Lý Nhã Kỳ',N'Đồng Tháp','0795802685','ky@gmail.com',N'Văn Phòng',N'Nữ','12-03-1988','CNDT'

--------------------------------------------------------------------------------------

create proc KiemtraPK_LoaiSP
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

-------------------------------------------------------
create proc KiemtraPK_NhanVien
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

----------------------------------------------------------------------------------
--------------------------------------------------------Tạo hàm tăng tự động cho Mã Sản Phẩm
CREATE FUNCTION themmaso(@MaKT char(3))
	RETURNS char(30)
	AS
	BEGIN 
		DECLARE @iMaso int 
  		DECLARE @vMaso varchar(9) 
  		IF @MaKT='SP' SET @iMaso= (SELECT MAX(RIGHT(MaSP, 4)) FROM SanPham)  	
		IF (@iMaso IS NULL) SET @vMaso= @MaKT+ CONVERT(varchar(6),'0001')
		ELSE
		BEGIN
			SET @iMaso= @iMaso+1
	    		SET @vMaso= '000'+ CONVERT(varchar,@iMaso) 
	    		SET @vMaso= @MaKT+ RIGHT(@vMaso,4)
		END
	RETURN @vMaso 
	END
	go

-----------------------------------------------------------------------------------
-----------------------------------------------------Tạo Proc tính tổng doanh thu

alter proc ThongKe_DoanhThu
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

Declare @@TongDoanhThuShop float
execute ThongKe_DoanhThu '04/11/2021','04/20/2021',@@TongDoanhThuShop
output 
	if(@@TongDoanhThuShop>100000)
		print N'Tổng Doanh Thu Chi Nhánh Là: '+Cast (@@TongDoanhThuShop as nvarchar(100))
	else
		print N'Tổng Doanh Thu Ít Thế Ta !' 
	
select*from HoaDon

select MasP, sum(TongTien) from HoaDon group by MaSP