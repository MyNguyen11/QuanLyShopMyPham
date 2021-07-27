/****** Scripting replication configuration. Script Date: 4/13/2021 7:52:22 PM ******/
/****** Please Note: For security reasons, all password parameters were scripted with either NULL or an empty string. ******/

/****** Installing the server as a Distributor. Script Date: 4/13/2021 7:52:22 PM ******/
use master
exec sp_adddistributor @distributor = N'DESKTOP-1N4F6N4\MAYCHUTPHCM', @password = N''
GO
exec sp_adddistributiondb @database = N'distribution', @data_folder = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MAYCHUTPHCM\MSSQL\Data', @log_folder = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MAYCHUTPHCM\MSSQL\Data', @log_file_size = 2, @min_distretention = 0, @max_distretention = 72, @history_retention = 48, @security_mode = 1
GO

use [distribution] 
if (not exists (select * from sysobjects where name = 'UIProperties' and type = 'U ')) 
	create table UIProperties(id int) 
if (exists (select * from ::fn_listextendedproperty('SnapshotFolder', 'user', 'dbo', 'table', 'UIProperties', null, null))) 
	EXEC sp_updateextendedproperty N'SnapshotFolder', N'\\DESKTOP-1N4F6N4\Users\HP\Desktop\CSDLNC_ST6\DOAN_CSDLNC\Data_MyPham', 'user', dbo, 'table', 'UIProperties' 
else 
	EXEC sp_addextendedproperty N'SnapshotFolder', N'\\DESKTOP-1N4F6N4\Users\HP\Desktop\CSDLNC_ST6\DOAN_CSDLNC\Data_MyPham', 'user', dbo, 'table', 'UIProperties'
GO

exec sp_adddistpublisher @publisher = N'DESKTOP-1N4F6N4\MAYCHUTPHCM', @distribution_db = N'distribution', @security_mode = 0, @login = N'sa', @password = N'', @working_directory = N'\\DESKTOP-1N4F6N4\Users\HP\Desktop\CSDLNC_ST6\DOAN_CSDLNC\Data_MyPham', @trusted = N'false', @thirdparty_flag = 0, @publisher_type = N'MSSQLSERVER'
GO
