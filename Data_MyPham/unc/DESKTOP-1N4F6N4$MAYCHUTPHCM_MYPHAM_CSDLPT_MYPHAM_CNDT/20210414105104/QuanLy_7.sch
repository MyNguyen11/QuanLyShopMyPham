drop Table [dbo].[QuanLy]
go
SET ANSI_PADDING OFF
go

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
	[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL
)

GO
ALTER TABLE [dbo].[QuanLy] ADD  CONSTRAINT [MSmerge_df_rowguid_30B5F2C2B42B429E85161D93DDE8D7F2]  DEFAULT (newsequentialid()) FOR [rowguid]
GO
SET ANSI_NULLS ON

go

SET QUOTED_IDENTIFIER ON

go

SET ANSI_PADDING ON

GO
ALTER TABLE [dbo].[QuanLy] ADD  CONSTRAINT [PK__QuanLy__2725F852E1AAF6A7] PRIMARY KEY CLUSTERED 
(
	[MaQL] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO
