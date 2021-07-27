insert into HoaDon(MaHD,MaKH,MaSP,MaCN,MaNV,TenSP,SoLuong,GiaBan,TongTien)
Values ('HD009','KH006','SP003','CNLA','NV003',N'Xịt Khoáng',1,200000,200000)

select*from HoaDon
-------------------------------------------------------------------

CREATE PROC [dbo].[SP_KIEMTRA_NV] @MANV NVARCHAR (15)
AS
DECLARE @CNT INT
SELECT @CNT=COUNT(*) 
FROM NHANVIEN A WHERE RTRIM(A.MANV) =@MANV
RETURN @CNT


CREATE PROC [dbo].[SP_ThongTinSanPham] @MASANPHAM NVARCHAR (20)
AS
SELECT MASP,TENSP,GiaBan,Hinh FROM SanPham A
WHERE A.MaSP=@MASANPHAM;


CREATE PROC [dbo].[SP_ThongTinKhachHang] @MAKH NVARCHAR (30)
AS
SELECT TenKH FROM KhachHang KH
WHERE KH.MaKH=@MAKH;


----------------------------------------

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

