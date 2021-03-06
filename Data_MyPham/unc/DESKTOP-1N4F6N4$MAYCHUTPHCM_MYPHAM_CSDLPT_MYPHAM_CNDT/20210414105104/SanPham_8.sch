drop Table [dbo].[SanPham]
go
SET ANSI_PADDING OFF
go

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
	[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL
)

GO
ALTER TABLE [dbo].[SanPham] ADD  CONSTRAINT [MSmerge_df_rowguid_22FEDA8FCED249BD9AD50C4B8A63102A]  DEFAULT (newsequentialid()) FOR [rowguid]
GO
SET ANSI_NULLS ON

go

SET QUOTED_IDENTIFIER ON

go

SET ANSI_PADDING ON

GO
ALTER TABLE [dbo].[SanPham] ADD  CONSTRAINT [PK__SanPham__2725081CBA71F7C9] PRIMARY KEY CLUSTERED 
(
	[MaSP] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO
