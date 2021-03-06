drop Table [dbo].[HoaDon]
go
SET ANSI_PADDING OFF
go

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
	[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL
)

GO
ALTER TABLE [dbo].[HoaDon] ADD  CONSTRAINT [DF__HoaDon__NgayLap__4EFDAD20]  DEFAULT (getdate()) FOR [NgayLap]
GO
ALTER TABLE [dbo].[HoaDon] ADD  CONSTRAINT [MSmerge_df_rowguid_85B2E69A2C574054B8A29A71140130CE]  DEFAULT (newsequentialid()) FOR [rowguid]
GO
SET ANSI_NULLS ON

go

SET QUOTED_IDENTIFIER ON

go

SET ANSI_PADDING ON

GO
ALTER TABLE [dbo].[HoaDon] ADD  CONSTRAINT [PK__HoaDon__F557F66149AF77A0] PRIMARY KEY CLUSTERED 
(
	[MaHD] ASC,
	[MaSP] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO
