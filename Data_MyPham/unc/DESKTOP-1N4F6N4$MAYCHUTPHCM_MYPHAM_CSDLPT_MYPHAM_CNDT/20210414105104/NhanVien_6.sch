drop Table [dbo].[NhanVien]
go
SET ANSI_PADDING ON
go

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
	[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL
)

GO
ALTER TABLE [dbo].[NhanVien] ADD  CONSTRAINT [MSmerge_df_rowguid_6B10D1C23A6847E3BF7CD73D6534340D]  DEFAULT (newsequentialid()) FOR [rowguid]
GO
SET ANSI_NULLS ON

go

SET QUOTED_IDENTIFIER ON

go

SET ANSI_PADDING ON

GO
ALTER TABLE [dbo].[NhanVien] ADD  CONSTRAINT [PK__NhanVien__2725D70A51901917] PRIMARY KEY CLUSTERED 
(
	[MaNV] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO
