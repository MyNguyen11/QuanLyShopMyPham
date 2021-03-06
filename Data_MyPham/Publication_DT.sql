use [MyPham_CSDLPT]
exec sp_replicationdboption @dbname = N'MyPham_CSDLPT', @optname = N'merge publish', @value = N'true'
GO
-- Adding the merge publication
use [MyPham_CSDLPT]
exec sp_addmergepublication @publication = N'MYPHAM_CNDT', @description = N'Merge publication of database ''MyPham_CSDLPT'' from Publisher ''DESKTOP-1N4F6N4\MAYCHUTPHCM''.', @sync_mode = N'native', @retention = 14, @allow_push = N'true', @allow_pull = N'true', @allow_anonymous = N'true', @enabled_for_internet = N'false', @snapshot_in_defaultfolder = N'true', @compress_snapshot = N'false', @ftp_port = 21, @ftp_subdirectory = N'ftp', @ftp_login = N'anonymous', @allow_subscription_copy = N'false', @add_to_active_directory = N'false', @dynamic_filters = N'false', @conflict_retention = 14, @keep_partition_changes = N'false', @allow_synctoalternate = N'false', @max_concurrent_merge = 0, @max_concurrent_dynamic_snapshots = 0, @use_partition_groups = null, @publication_compatibility_level = N'100RTM', @replicate_ddl = 1, @allow_subscriber_initiated_snapshot = N'false', @allow_web_synchronization = N'false', @allow_partition_realignment = N'true', @retention_period_unit = N'days', @conflict_logging = N'both', @automatic_reinitialization_policy = 0
GO


exec sp_addpublication_snapshot @publication = N'MYPHAM_CNDT', @frequency_type = 1, @frequency_interval = 0, @frequency_relative_interval = 0, @frequency_recurrence_factor = 0, @frequency_subday = 0, @frequency_subday_interval = 0, @active_start_time_of_day = 500, @active_end_time_of_day = 235959, @active_start_date = 0, @active_end_date = 0, @job_login = null, @job_password = null, @publisher_security_mode = 0, @publisher_login = N'sa', @publisher_password = N''


use [MyPham_CSDLPT]
exec sp_addmergearticle @publication = N'MYPHAM_CNDT', @article = N'ChiNhanh', @source_owner = N'dbo', @source_object = N'ChiNhanh', @type = N'table', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000010C034FD1, @identityrangemanagementoption = N'manual', @destination_owner = N'dbo', @force_reinit_subscription = 1, @column_tracking = N'false', @subset_filterclause = N'[MaCN] =''CNDT''', @vertical_partition = N'false', @verify_resolver_signature = 1, @allow_interactive_resolver = N'false', @fast_multicol_updateproc = N'true', @check_permissions = 0, @subscriber_upload_options = 0, @delete_tracking = N'true', @compensate_for_errors = N'false', @stream_blob_columns = N'false', @partition_options = 0
GO


use [MyPham_CSDLPT]
exec sp_addmergearticle @publication = N'MYPHAM_CNDT', @article = N'HoaDon', @source_owner = N'dbo', @source_object = N'HoaDon', @type = N'table', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000010C034FD1, @identityrangemanagementoption = N'manual', @destination_owner = N'dbo', @force_reinit_subscription = 1, @column_tracking = N'false', @subset_filterclause = null, @vertical_partition = N'false', @verify_resolver_signature = 1, @allow_interactive_resolver = N'false', @fast_multicol_updateproc = N'true', @check_permissions = 0, @subscriber_upload_options = 0, @delete_tracking = N'true', @compensate_for_errors = N'false', @stream_blob_columns = N'false', @partition_options = 0
GO


use [MyPham_CSDLPT]
exec sp_addmergearticle @publication = N'MYPHAM_CNDT', @article = N'KhachHang', @source_owner = N'dbo', @source_object = N'KhachHang', @type = N'table', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000010C034FD1, @identityrangemanagementoption = N'manual', @destination_owner = N'dbo', @force_reinit_subscription = 1, @column_tracking = N'false', @subset_filterclause = null, @vertical_partition = N'false', @verify_resolver_signature = 1, @allow_interactive_resolver = N'false', @fast_multicol_updateproc = N'true', @check_permissions = 0, @subscriber_upload_options = 0, @delete_tracking = N'true', @compensate_for_errors = N'false', @stream_blob_columns = N'false', @partition_options = 0
GO


use [MyPham_CSDLPT]
exec sp_addmergearticle @publication = N'MYPHAM_CNDT', @article = N'LoaiSP', @source_owner = N'dbo', @source_object = N'LoaiSP', @type = N'table', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000010C034FD1, @identityrangemanagementoption = N'manual', @destination_owner = N'dbo', @force_reinit_subscription = 1, @column_tracking = N'false', @subset_filterclause = null, @vertical_partition = N'false', @verify_resolver_signature = 1, @allow_interactive_resolver = N'false', @fast_multicol_updateproc = N'true', @check_permissions = 0, @subscriber_upload_options = 0, @delete_tracking = N'true', @compensate_for_errors = N'false', @stream_blob_columns = N'false', @partition_options = 0
GO


use [MyPham_CSDLPT]
exec sp_addmergearticle @publication = N'MYPHAM_CNDT', @article = N'NhaKho', @source_owner = N'dbo', @source_object = N'NhaKho', @type = N'table', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000010C034FD1, @identityrangemanagementoption = N'manual', @destination_owner = N'dbo', @force_reinit_subscription = 1, @column_tracking = N'false', @subset_filterclause = null, @vertical_partition = N'false', @verify_resolver_signature = 1, @allow_interactive_resolver = N'false', @fast_multicol_updateproc = N'true', @check_permissions = 0, @subscriber_upload_options = 0, @delete_tracking = N'true', @compensate_for_errors = N'false', @stream_blob_columns = N'false', @partition_options = 0
GO


use [MyPham_CSDLPT]
exec sp_addmergearticle @publication = N'MYPHAM_CNDT', @article = N'NhanVien', @source_owner = N'dbo', @source_object = N'NhanVien', @type = N'table', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000010C034FD1, @identityrangemanagementoption = N'manual', @destination_owner = N'dbo', @force_reinit_subscription = 1, @column_tracking = N'false', @subset_filterclause = null, @vertical_partition = N'false', @verify_resolver_signature = 1, @allow_interactive_resolver = N'false', @fast_multicol_updateproc = N'true', @check_permissions = 0, @subscriber_upload_options = 0, @delete_tracking = N'true', @compensate_for_errors = N'false', @stream_blob_columns = N'false', @partition_options = 0
GO


use [MyPham_CSDLPT]
exec sp_addmergearticle @publication = N'MYPHAM_CNDT', @article = N'NhaSanXuat', @source_owner = N'dbo', @source_object = N'NhaSanXuat', @type = N'table', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000010C034FD1, @identityrangemanagementoption = N'manual', @destination_owner = N'dbo', @force_reinit_subscription = 1, @column_tracking = N'false', @subset_filterclause = null, @vertical_partition = N'false', @verify_resolver_signature = 1, @allow_interactive_resolver = N'false', @fast_multicol_updateproc = N'true', @check_permissions = 0, @subscriber_upload_options = 0, @delete_tracking = N'true', @compensate_for_errors = N'false', @stream_blob_columns = N'false', @partition_options = 0
GO


use [MyPham_CSDLPT]
exec sp_addmergearticle @publication = N'MYPHAM_CNDT', @article = N'QuanLy', @source_owner = N'dbo', @source_object = N'QuanLy', @type = N'table', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000010C034FD1, @identityrangemanagementoption = N'manual', @destination_owner = N'dbo', @force_reinit_subscription = 1, @column_tracking = N'false', @subset_filterclause = null, @vertical_partition = N'false', @verify_resolver_signature = 1, @allow_interactive_resolver = N'false', @fast_multicol_updateproc = N'true', @check_permissions = 0, @subscriber_upload_options = 0, @delete_tracking = N'true', @compensate_for_errors = N'false', @stream_blob_columns = N'false', @partition_options = 0
GO


use [MyPham_CSDLPT]
exec sp_addmergearticle @publication = N'MYPHAM_CNDT', @article = N'SanPham', @source_owner = N'dbo', @source_object = N'SanPham', @type = N'table', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000010C034FD1, @identityrangemanagementoption = N'manual', @destination_owner = N'dbo', @force_reinit_subscription = 1, @column_tracking = N'false', @subset_filterclause = null, @vertical_partition = N'false', @verify_resolver_signature = 1, @allow_interactive_resolver = N'false', @fast_multicol_updateproc = N'true', @check_permissions = 0, @subscriber_upload_options = 0, @delete_tracking = N'true', @compensate_for_errors = N'false', @stream_blob_columns = N'false', @partition_options = 0
GO


exec sp_addmergefilter @publication = N'MYPHAM_CNDT', @article = N'HoaDon', @filtername = N'HoaDon_ChiNhanh', @join_articlename = N'ChiNhanh', @join_filterclause = N'[ChiNhanh].[MaCN] = [HoaDon].[MaCN]', @join_unique_key = 1, @filter_type = 1, @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
GO
exec sp_addmergefilter @publication = N'MYPHAM_CNDT', @article = N'KhachHang', @filtername = N'KhachHang_ChiNhanh', @join_articlename = N'ChiNhanh', @join_filterclause = N'[ChiNhanh].[MaCN] = [KhachHang].[MaCN]', @join_unique_key = 1, @filter_type = 1, @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
GO
exec sp_addmergefilter @publication = N'MYPHAM_CNDT', @article = N'NhanVien', @filtername = N'NhanVien_ChiNhanh', @join_articlename = N'ChiNhanh', @join_filterclause = N'[ChiNhanh].[MaCN] = [NhanVien].[MaCN]', @join_unique_key = 1, @filter_type = 1, @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
GO
exec sp_addmergefilter @publication = N'MYPHAM_CNDT', @article = N'QuanLy', @filtername = N'QuanLy_ChiNhanh', @join_articlename = N'ChiNhanh', @join_filterclause = N'[ChiNhanh].[MaCN] = [QuanLy].[MaCN]', @join_unique_key = 1, @filter_type = 1, @force_invalidate_snapshot = 1, @force_reinit_subscription = 1
GO
