drop Table [dbo].[NhaKho]
go
SET ANSI_PADDING OFF
go

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
	[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL
)

GO
ALTER TABLE [dbo].[NhaKho] ADD  CONSTRAINT [MSmerge_df_rowguid_B516D6D1BF71415C91FDAFB1EADA1D7C]  DEFAULT (newsequentialid()) FOR [rowguid]
GO
SET ANSI_NULLS ON

go

SET QUOTED_IDENTIFIER ON

go

SET ANSI_PADDING ON

GO
ALTER TABLE [dbo].[NhaKho] ADD  CONSTRAINT [PK__NhaKho__A1CD132D0580DF16] PRIMARY KEY CLUSTERED 
(
	[MaKho] ASC,
	[MaLoai] ASC,
	[MaSP] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO
