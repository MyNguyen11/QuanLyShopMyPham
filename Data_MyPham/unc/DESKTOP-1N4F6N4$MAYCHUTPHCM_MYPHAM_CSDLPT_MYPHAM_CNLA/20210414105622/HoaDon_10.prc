SET QUOTED_IDENTIFIER ON

go

-- these are subscriber side procs
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON


go

-- drop all the procedures first
if object_id('MSmerge_ins_sp_343D2BD21205418AAB1F05CECE24415B','P') is not NULL
    drop procedure MSmerge_ins_sp_343D2BD21205418AAB1F05CECE24415B
if object_id('MSmerge_ins_sp_343D2BD21205418AAB1F05CECE24415B_batch','P') is not NULL
    drop procedure MSmerge_ins_sp_343D2BD21205418AAB1F05CECE24415B_batch
if object_id('MSmerge_upd_sp_343D2BD21205418AAB1F05CECE24415B','P') is not NULL
    drop procedure MSmerge_upd_sp_343D2BD21205418AAB1F05CECE24415B
if object_id('MSmerge_upd_sp_343D2BD21205418AAB1F05CECE24415B_batch','P') is not NULL
    drop procedure MSmerge_upd_sp_343D2BD21205418AAB1F05CECE24415B_batch
if object_id('MSmerge_del_sp_343D2BD21205418AAB1F05CECE24415B','P') is not NULL
    drop procedure MSmerge_del_sp_343D2BD21205418AAB1F05CECE24415B
if object_id('MSmerge_sel_sp_343D2BD21205418AAB1F05CECE24415B','P') is not NULL
    drop procedure MSmerge_sel_sp_343D2BD21205418AAB1F05CECE24415B
if object_id('MSmerge_sel_sp_343D2BD21205418AAB1F05CECE24415B_metadata','P') is not NULL
    drop procedure MSmerge_sel_sp_343D2BD21205418AAB1F05CECE24415B_metadata
if object_id('MSmerge_cft_sp_343D2BD21205418AAB1F05CECE24415B','P') is not NULL
    drop procedure MSmerge_cft_sp_343D2BD21205418AAB1F05CECE24415B


go
create procedure dbo.[MSmerge_ins_sp_343D2BD21205418AAB1F05CECE24415B] (@rowguid uniqueidentifier, 
            @generation bigint, @lineage varbinary(311),  @colv varbinary(1) 
, 
        @p1 nvarchar(30)
, 
        @p2 nvarchar(30)
, 
        @p3 nvarchar(30)
, 
        @p4 nvarchar(30)
, 
        @p5 nvarchar(30)
, 
        @p6 nvarchar(100)
, 
        @p7 int
, 
        @p8 money
, 
        @p9 money
, 
        @p10 datetime
, 
        @p11 uniqueidentifier
,@metadata_type tinyint = NULL, @lineage_old varbinary(311) = NULL, @compatlevel int = 10 
) as
    declare @errcode    int
    declare @retcode    int
    declare @rowcount   int
    declare @error      int
    declare @tablenick  int
    declare @started_transaction bit
    declare @publication_number smallint
    
    set nocount on

    select @started_transaction = 0
    select @publication_number = 2

    set @errcode= 0
    select @tablenick= 57128000
    
    if ({ fn ISPALUSER('AB1F05CE-CE24-415B-8771-7EDE0EFE1D98') } <> 1)
    begin
        RAISERROR (14126, 11, -1)
        return 4
    end



    declare @resend int

    set @resend = 0 

    if @@trancount = 0 
    begin
        begin transaction
        select @started_transaction = 1
    end
    if @metadata_type = 1 or @metadata_type = 5
    begin
        if @compatlevel < 90 and @lineage_old is not null
            set @lineage_old= {fn LINEAGE_80_TO_90(@lineage_old)}
        -- check meta consistency
        if not exists (select * from dbo.MSmerge_tombstone where tablenick = @tablenick and rowguid = @rowguid and
                        lineage = @lineage_old)
        begin
            set @errcode= 2
            goto Failure
        end
    end
    -- set row meta data
    
        exec @retcode= sys.sp_MSsetrowmetadata 
            @tablenick, @rowguid, @generation, 
            @lineage, @colv, 2, @resend OUTPUT,
            @compatlevel, 1, 'AB1F05CE-CE24-415B-8771-7EDE0EFE1D98'
        if @retcode<>0 or @@ERROR<>0
        begin
            set @errcode= 0
            goto Failure
        end 
    insert into [dbo].[HoaDon] (
[MaHD]
, 
        [MaKH]
, 
        [MaSP]
, 
        [MaCN]
, 
        [MaNV]
, 
        [TenSP]
, 
        [SoLuong]
, 
        [GiaBan]
, 
        [TongTien]
, 
        [NgayLap]
, 
        [rowguid]
) values (
@p1
, 
        @p2
, 
        @p3
, 
        @p4
, 
        @p5
, 
        @p6
, 
        @p7
, 
        @p8
, 
        @p9
, 
        @p10
, 
        @p11
)
        select @rowcount= @@rowcount, @error= @@error
        if (@rowcount <> 1)
        begin
            set @errcode= 3
            goto Failure
        end


    -- set row meta data
    if @resend > 0  
        update dbo.MSmerge_contents set generation = 0, partchangegen = 0 
            where rowguid = @rowguid and tablenick = @tablenick 

    if @started_transaction = 1
        commit tran
    

    delete from dbo.MSmerge_metadataaction_request
        where tablenick=@tablenick and rowguid=@rowguid


    return(1)

Failure:
    if @started_transaction = 1
        rollback tran

    


    declare @REPOLEExtErrorDupKey            int
    declare @REPOLEExtErrorDupUniqueIndex    int

    set @REPOLEExtErrorDupKey= 2627
    set @REPOLEExtErrorDupUniqueIndex= 2601
    
    if @error in (@REPOLEExtErrorDupUniqueIndex, @REPOLEExtErrorDupKey)
    begin
        update mc
            set mc.generation= 0
            from dbo.MSmerge_contents mc join [dbo].[HoaDon] t on mc.rowguid=t.rowguidcol
            where
                mc.tablenick = 57128000 and
                (

                        (t.[MaHD]=@p1 and t.[MaSP]=@p3)

                        )
            end

    return(@errcode)
    

go
Create procedure dbo.[MSmerge_upd_sp_343D2BD21205418AAB1F05CECE24415B] (@rowguid uniqueidentifier, @setbm varbinary(125) = NULL,
        @metadata_type tinyint, @lineage_old varbinary(311), @generation bigint,
        @lineage_new varbinary(311), @colv varbinary(1) 
,
        @p1 nvarchar(30) = NULL 
,
        @p2 nvarchar(30) = NULL 
,
        @p3 nvarchar(30) = NULL 
,
        @p4 nvarchar(30) = NULL 
,
        @p5 nvarchar(30) = NULL 
,
        @p6 nvarchar(100) = NULL 
,
        @p7 int = NULL 
,
        @p8 money = NULL 
,
        @p9 money = NULL 
,
        @p10 datetime = NULL 
,
        @p11 uniqueidentifier = NULL 
, @compatlevel int = 10 
)
as
    declare @match int 

    declare @fset int
    declare @errcode int
    declare @retcode smallint
    declare @rowcount int
    declare @error int
    declare @hasperm bit
    declare @tablenick int
    declare @started_transaction bit
    declare @indexing_column_updated bit
    declare @publication_number smallint

    set nocount on

    if ({ fn ISPALUSER('AB1F05CE-CE24-415B-8771-7EDE0EFE1D98') } <> 1)
    begin
        RAISERROR (14126, 11, -1)
        return 4
    end

    select @started_transaction = 0
    select @publication_number = 2
    select @tablenick = 57128000

    if is_member('db_owner') = 1
        select @hasperm = 1
    else
        select @hasperm = 0

    select @indexing_column_updated = 0

    declare @l1 nvarchar(30)

    declare @iscol1set bit

    declare @l3 nvarchar(30)

    declare @iscol3set bit

    declare @l4 nvarchar(30)

    if @@trancount = 0
    begin
        begin transaction sub
        select @started_transaction = 1
    end


    select 

        @l1 = [MaHD]
, 
        @l3 = [MaSP]
, 
        @l4 = [MaCN]
        from [dbo].[HoaDon] where rowguidcol = @rowguid
    set @match = NULL

       
    declare @firstUpdStmtCol bit
    declare @nUpdateCols int
    declare @updatestmt nvarchar(4000) 
    
    select @firstUpdStmtCol = 1
    select @nUpdateCols = 0
    select @updatestmt = 'update ' + '[dbo].[HoaDon]' + ' set '
            

    if convert(varbinary(60), @p4)
            = convert(varbinary(60), @l4)
        set @fset = 0
    else if ( @l4 is null and @p4 is null) 
        set @fset = 0
    else if @p4 is not null
        set @fset = 1
    else if @setbm = 0x0
        set @fset = 0
    else
        exec @fset = sys.sp_MStestbit @setbm, 4
    if @fset <> 0
    begin

        if @match is NULL
        begin
            if @metadata_type = 3
            begin
                update [dbo].[HoaDon] set [MaCN] = @p4 
                from [dbo].[HoaDon] t 
                where t.[rowguid] = @rowguid and
                   not exists (select 1 from dbo.MSmerge_contents c with (rowlock)
                                where c.rowguid = @rowguid and 
                                      c.tablenick = 57128000)
            end
            else if @metadata_type = 2
            begin
                update [dbo].[HoaDon] set [MaCN] = @p4 
                from [dbo].[HoaDon] t 
                where t.[rowguid] = @rowguid and
                      exists (select 1 from dbo.MSmerge_contents c with (rowlock)
                                where c.rowguid = @rowguid and 
                                      c.tablenick = 57128000 and
                                      c.lineage = @lineage_old)
            end
            else
            begin
                set @errcode=2
                goto Failure
            end
        end
        else
        begin
            update [dbo].[HoaDon] set [MaCN] = @p4 
                where rowguidcol = @rowguid
        end
        select @rowcount= @@rowcount, @error= @@error
        if (@rowcount <> 1)
        begin
            set @errcode= 3
            goto Failure
        end
        select @match = 1
    end 

    if convert(varbinary(60), @p1)
            = convert(varbinary(60), @l1)
        set @fset = 0
    else if ( @l1 is null and @p1 is null) 
        set @fset = 0
    else if @p1 is not null
        set @fset = 1
    else if @setbm = 0x0
        set @fset = 0
    else
        exec @fset = sys.sp_MStestbit @setbm, 1
    if @fset <> 0
    begin

        select @indexing_column_updated = 1
        select @iscol1set = 1
        if @firstUpdStmtCol = 1
            select @firstUpdStmtCol = 0
        else
            select @updatestmt = @updatestmt + ','
        select @updatestmt = @updatestmt + '[MaHD] = @p1'
        select @nUpdateCols = @nUpdateCols + 1
    end
    else
    begin
        select @iscol1set = 0
    end

    if convert(varbinary(60), @p3)
            = convert(varbinary(60), @l3)
        set @fset = 0
    else if ( @l3 is null and @p3 is null) 
        set @fset = 0
    else if @p3 is not null
        set @fset = 1
    else if @setbm = 0x0
        set @fset = 0
    else
        exec @fset = sys.sp_MStestbit @setbm, 3
    if @fset <> 0
    begin

        select @indexing_column_updated = 1
        select @iscol3set = 1
        if @firstUpdStmtCol = 1
            select @firstUpdStmtCol = 0
        else
            select @updatestmt = @updatestmt + ','
        select @updatestmt = @updatestmt + '[MaSP] = @p3'
        select @nUpdateCols = @nUpdateCols + 1
    end
    else
    begin
        select @iscol3set = 0
    end

    if @indexing_column_updated = 1
    begin
        if @hasperm = 0
        begin
            update [dbo].[HoaDon] set 

                [MaHD] = case @iscol1set when 1 then @p1 else t.[MaHD] end
,
                [MaSP] = case @iscol3set when 1 then @p3 else t.[MaSP] end
 
             from [dbo].[HoaDon] t 
                left outer join dbo.MSmerge_contents c with (rowlock)
                    on c.rowguid = t.[rowguid] and 
                       c.tablenick = 57128000 and
                       t.[rowguid] = @rowguid
             where t.[rowguid] = @rowguid and
             ((@match is not NULL and @match = 1) or 
              ((@metadata_type = 3 and c.rowguid is NULL) or
               (@metadata_type = 2 and c.rowguid is not NULL and c.lineage = @lineage_old)))

            select @rowcount= @@rowcount, @error= @@error

        end
        else -- we can do sp_executesql since the current user has permissions to update the table
        begin 
            if @match is NULL
            begin
                if @metadata_type = 3
                begin
                    select @updatestmt = @updatestmt + '
                       from [dbo].[HoaDon] t 
                       where t.[rowguid] = @rowguid and
                             not exists (select 1 from dbo.MSmerge_contents c with (rowlock)
                                         where c.rowguid = @rowguid and 
                                               c.tablenick = 57128000)'
                end
                else if @metadata_type = 2
                begin
                    select @updatestmt = @updatestmt + '
                       from [dbo].[HoaDon] t 
                       where t.[rowguid] = @rowguid and
                             exists (select 1 from dbo.MSmerge_contents c with (rowlock)
                                     where c.rowguid = @rowguid and 
                                           c.tablenick = 57128000 and
                                           c.lineage = @lineage_old)'
                end
            end
            else
            begin
                select @updatestmt = @updatestmt + '
                    where rowguidcol = @rowguid '
            end
            select @updatestmt = @updatestmt + '
                select @rowcount = @@rowcount, @error = @@error'
            exec sys.sp_executesql @stmt = @updatestmt, @parameters = N'

                    @p1 nvarchar(30)
,

                    @p3 nvarchar(30)
, @rowguid uniqueidentifier = ''00000000-0000-0000-0000-000000000000'', @lineage_old varbinary(311), @rowcount int output, @error int output',

                    @p1 = @p1
,

                    @p3 = @p3

                    , @rowguid = @rowguid, @lineage_old = @lineage_old, @rowcount = @rowcount OUTPUT, @error = @error OUTPUT 
        end  -- end if @hasperm
        if (@rowcount <> 1)
        begin
            set @errcode= 3
            goto Failure
        end    
        select @match = 1    
    end -- end if @indexing_column_updated 

    if @match is NULL
    begin
        update [dbo].[HoaDon] set 

            [MaKH] = case when @p2 is NULL then (case when sys.fn_IsBitSetInBitmask(@setbm, 2) <> 0 then @p2 else t.[MaKH] end) else @p2 end 
,

            [MaNV] = case when @p5 is NULL then (case when sys.fn_IsBitSetInBitmask(@setbm, 5) <> 0 then @p5 else t.[MaNV] end) else @p5 end 
,

            [TenSP] = case when @p6 is NULL then (case when sys.fn_IsBitSetInBitmask(@setbm, 6) <> 0 then @p6 else t.[TenSP] end) else @p6 end 
,

            [SoLuong] = case when @p7 is NULL then (case when sys.fn_IsBitSetInBitmask(@setbm, 7) <> 0 then @p7 else t.[SoLuong] end) else @p7 end 
,

            [GiaBan] = case when @p8 is NULL then (case when sys.fn_IsBitSetInBitmask(@setbm, 8) <> 0 then @p8 else t.[GiaBan] end) else @p8 end 
,

            [TongTien] = case when @p9 is NULL then (case when sys.fn_IsBitSetInBitmask(@setbm, 9) <> 0 then @p9 else t.[TongTien] end) else @p9 end 
,

            [NgayLap] = case when @p10 is NULL then (case when sys.fn_IsBitSetInBitmask(@setbm, 10) <> 0 then @p10 else t.[NgayLap] end) else @p10 end 
 
         from [dbo].[HoaDon] t 
            left outer join dbo.MSmerge_contents c with (rowlock)
                on c.rowguid = t.[rowguid] and 
                   c.tablenick = 57128000 and
                   t.[rowguid] = @rowguid
         where t.[rowguid] = @rowguid and
         ((@match is not NULL and @match = 1) or 
          ((@metadata_type = 3 and c.rowguid is NULL) or
           (@metadata_type = 2 and c.rowguid is not NULL and c.lineage = @lineage_old)))

        select @rowcount= @@rowcount, @error= @@error
    end
    else
    begin
        update [dbo].[HoaDon] set 

            [MaKH] = case when @p2 is NULL then (case when sys.fn_IsBitSetInBitmask(@setbm, 2) <> 0 then @p2 else t.[MaKH] end) else @p2 end 
,

            [MaNV] = case when @p5 is NULL then (case when sys.fn_IsBitSetInBitmask(@setbm, 5) <> 0 then @p5 else t.[MaNV] end) else @p5 end 
,

            [TenSP] = case when @p6 is NULL then (case when sys.fn_IsBitSetInBitmask(@setbm, 6) <> 0 then @p6 else t.[TenSP] end) else @p6 end 
,

            [SoLuong] = case when @p7 is NULL then (case when sys.fn_IsBitSetInBitmask(@setbm, 7) <> 0 then @p7 else t.[SoLuong] end) else @p7 end 
,

            [GiaBan] = case when @p8 is NULL then (case when sys.fn_IsBitSetInBitmask(@setbm, 8) <> 0 then @p8 else t.[GiaBan] end) else @p8 end 
,

            [TongTien] = case when @p9 is NULL then (case when sys.fn_IsBitSetInBitmask(@setbm, 9) <> 0 then @p9 else t.[TongTien] end) else @p9 end 
,

            [NgayLap] = case when @p10 is NULL then (case when sys.fn_IsBitSetInBitmask(@setbm, 10) <> 0 then @p10 else t.[NgayLap] end) else @p10 end 
 
         from [dbo].[HoaDon] t 
             where t.[rowguid] = @rowguid

        select @rowcount= @@rowcount, @error= @@error
    end

    if (@rowcount <> 1) or (@error <> 0)
    begin
        set @errcode= 3
        goto Failure
    end

    select @match = 1
 
    exec @retcode= sys.sp_MSsetrowmetadata 
        @tablenick, @rowguid, @generation, 
        @lineage_new, @colv, 2, NULL, 
        @compatlevel, 0, 'AB1F05CE-CE24-415B-8771-7EDE0EFE1D98'
    if @retcode<>0 or @@ERROR<>0
    begin
        set @errcode= 3
        goto Failure
    end 

delete from dbo.MSmerge_metadataaction_request
    where tablenick=@tablenick and rowguid=@rowguid

    if @started_transaction = 1
        commit transaction


    return(1)

Failure:
    --rollback transaction sub
    --commit transaction
    if @started_transaction = 1    
        rollback transaction




    declare @REPOLEExtErrorDupKey            int
    declare @REPOLEExtErrorDupUniqueIndex    int

    set @REPOLEExtErrorDupKey= 2627
    set @REPOLEExtErrorDupUniqueIndex= 2601
    
    if @error in (@REPOLEExtErrorDupUniqueIndex, @REPOLEExtErrorDupKey)
    begin
        update mc
            set mc.generation= 0
            from dbo.MSmerge_contents mc join [dbo].[HoaDon] t on mc.rowguid=t.rowguidcol
            where
                mc.tablenick = 57128000 and
                (

                        (t.[MaHD]=@p1 and t.[MaSP]=@p3)

                        )
            end

    return @errcode

go

create procedure dbo.[MSmerge_del_sp_343D2BD21205418AAB1F05CECE24415B]
(
    @rowstobedeleted int, 
    @partition_id int = NULL 
,
    @rowguid1 uniqueidentifier = NULL,
    @metadata_type1 tinyint = NULL,
    @generation1 bigint = NULL,
    @lineage_old1 varbinary(311) = NULL,
    @lineage_new1 varbinary(311) = NULL,
    @rowguid2 uniqueidentifier = NULL,
    @metadata_type2 tinyint = NULL,
    @generation2 bigint = NULL,
    @lineage_old2 varbinary(311) = NULL,
    @lineage_new2 varbinary(311) = NULL,
    @rowguid3 uniqueidentifier = NULL,
    @metadata_type3 tinyint = NULL,
    @generation3 bigint = NULL,
    @lineage_old3 varbinary(311) = NULL,
    @lineage_new3 varbinary(311) = NULL,
    @rowguid4 uniqueidentifier = NULL,
    @metadata_type4 tinyint = NULL,
    @generation4 bigint = NULL,
    @lineage_old4 varbinary(311) = NULL,
    @lineage_new4 varbinary(311) = NULL,
    @rowguid5 uniqueidentifier = NULL,
    @metadata_type5 tinyint = NULL,
    @generation5 bigint = NULL,
    @lineage_old5 varbinary(311) = NULL,
    @lineage_new5 varbinary(311) = NULL,
    @rowguid6 uniqueidentifier = NULL,
    @metadata_type6 tinyint = NULL,
    @generation6 bigint = NULL,
    @lineage_old6 varbinary(311) = NULL,
    @lineage_new6 varbinary(311) = NULL,
    @rowguid7 uniqueidentifier = NULL,
    @metadata_type7 tinyint = NULL,
    @generation7 bigint = NULL,
    @lineage_old7 varbinary(311) = NULL,
    @lineage_new7 varbinary(311) = NULL,
    @rowguid8 uniqueidentifier = NULL,
    @metadata_type8 tinyint = NULL,
    @generation8 bigint = NULL,
    @lineage_old8 varbinary(311) = NULL,
    @lineage_new8 varbinary(311) = NULL,
    @rowguid9 uniqueidentifier = NULL,
    @metadata_type9 tinyint = NULL,
    @generation9 bigint = NULL,
    @lineage_old9 varbinary(311) = NULL,
    @lineage_new9 varbinary(311) = NULL,
    @rowguid10 uniqueidentifier = NULL,
    @metadata_type10 tinyint = NULL,
    @generation10 bigint = NULL,
    @lineage_old10 varbinary(311) = NULL,
    @lineage_new10 varbinary(311) = NULL
,
    @rowguid11 uniqueidentifier = NULL,
    @metadata_type11 tinyint = NULL,
    @generation11 bigint = NULL,
    @lineage_old11 varbinary(311) = NULL,
    @lineage_new11 varbinary(311) = NULL,
    @rowguid12 uniqueidentifier = NULL,
    @metadata_type12 tinyint = NULL,
    @generation12 bigint = NULL,
    @lineage_old12 varbinary(311) = NULL,
    @lineage_new12 varbinary(311) = NULL,
    @rowguid13 uniqueidentifier = NULL,
    @metadata_type13 tinyint = NULL,
    @generation13 bigint = NULL,
    @lineage_old13 varbinary(311) = NULL,
    @lineage_new13 varbinary(311) = NULL,
    @rowguid14 uniqueidentifier = NULL,
    @metadata_type14 tinyint = NULL,
    @generation14 bigint = NULL,
    @lineage_old14 varbinary(311) = NULL,
    @lineage_new14 varbinary(311) = NULL,
    @rowguid15 uniqueidentifier = NULL,
    @metadata_type15 tinyint = NULL,
    @generation15 bigint = NULL,
    @lineage_old15 varbinary(311) = NULL,
    @lineage_new15 varbinary(311) = NULL,
    @rowguid16 uniqueidentifier = NULL,
    @metadata_type16 tinyint = NULL,
    @generation16 bigint = NULL,
    @lineage_old16 varbinary(311) = NULL,
    @lineage_new16 varbinary(311) = NULL,
    @rowguid17 uniqueidentifier = NULL,
    @metadata_type17 tinyint = NULL,
    @generation17 bigint = NULL,
    @lineage_old17 varbinary(311) = NULL,
    @lineage_new17 varbinary(311) = NULL,
    @rowguid18 uniqueidentifier = NULL,
    @metadata_type18 tinyint = NULL,
    @generation18 bigint = NULL,
    @lineage_old18 varbinary(311) = NULL,
    @lineage_new18 varbinary(311) = NULL,
    @rowguid19 uniqueidentifier = NULL,
    @metadata_type19 tinyint = NULL,
    @generation19 bigint = NULL,
    @lineage_old19 varbinary(311) = NULL,
    @lineage_new19 varbinary(311) = NULL,
    @rowguid20 uniqueidentifier = NULL,
    @metadata_type20 tinyint = NULL,
    @generation20 bigint = NULL,
    @lineage_old20 varbinary(311) = NULL,
    @lineage_new20 varbinary(311) = NULL
,
    @rowguid21 uniqueidentifier = NULL,
    @metadata_type21 tinyint = NULL,
    @generation21 bigint = NULL,
    @lineage_old21 varbinary(311) = NULL,
    @lineage_new21 varbinary(311) = NULL,
    @rowguid22 uniqueidentifier = NULL,
    @metadata_type22 tinyint = NULL,
    @generation22 bigint = NULL,
    @lineage_old22 varbinary(311) = NULL,
    @lineage_new22 varbinary(311) = NULL,
    @rowguid23 uniqueidentifier = NULL,
    @metadata_type23 tinyint = NULL,
    @generation23 bigint = NULL,
    @lineage_old23 varbinary(311) = NULL,
    @lineage_new23 varbinary(311) = NULL,
    @rowguid24 uniqueidentifier = NULL,
    @metadata_type24 tinyint = NULL,
    @generation24 bigint = NULL,
    @lineage_old24 varbinary(311) = NULL,
    @lineage_new24 varbinary(311) = NULL,
    @rowguid25 uniqueidentifier = NULL,
    @metadata_type25 tinyint = NULL,
    @generation25 bigint = NULL,
    @lineage_old25 varbinary(311) = NULL,
    @lineage_new25 varbinary(311) = NULL,
    @rowguid26 uniqueidentifier = NULL,
    @metadata_type26 tinyint = NULL,
    @generation26 bigint = NULL,
    @lineage_old26 varbinary(311) = NULL,
    @lineage_new26 varbinary(311) = NULL,
    @rowguid27 uniqueidentifier = NULL,
    @metadata_type27 tinyint = NULL,
    @generation27 bigint = NULL,
    @lineage_old27 varbinary(311) = NULL,
    @lineage_new27 varbinary(311) = NULL,
    @rowguid28 uniqueidentifier = NULL,
    @metadata_type28 tinyint = NULL,
    @generation28 bigint = NULL,
    @lineage_old28 varbinary(311) = NULL,
    @lineage_new28 varbinary(311) = NULL,
    @rowguid29 uniqueidentifier = NULL,
    @metadata_type29 tinyint = NULL,
    @generation29 bigint = NULL,
    @lineage_old29 varbinary(311) = NULL,
    @lineage_new29 varbinary(311) = NULL,
    @rowguid30 uniqueidentifier = NULL,
    @metadata_type30 tinyint = NULL,
    @generation30 bigint = NULL,
    @lineage_old30 varbinary(311) = NULL,
    @lineage_new30 varbinary(311) = NULL
,
    @rowguid31 uniqueidentifier = NULL,
    @metadata_type31 tinyint = NULL,
    @generation31 bigint = NULL,
    @lineage_old31 varbinary(311) = NULL,
    @lineage_new31 varbinary(311) = NULL,
    @rowguid32 uniqueidentifier = NULL,
    @metadata_type32 tinyint = NULL,
    @generation32 bigint = NULL,
    @lineage_old32 varbinary(311) = NULL,
    @lineage_new32 varbinary(311) = NULL,
    @rowguid33 uniqueidentifier = NULL,
    @metadata_type33 tinyint = NULL,
    @generation33 bigint = NULL,
    @lineage_old33 varbinary(311) = NULL,
    @lineage_new33 varbinary(311) = NULL,
    @rowguid34 uniqueidentifier = NULL,
    @metadata_type34 tinyint = NULL,
    @generation34 bigint = NULL,
    @lineage_old34 varbinary(311) = NULL,
    @lineage_new34 varbinary(311) = NULL,
    @rowguid35 uniqueidentifier = NULL,
    @metadata_type35 tinyint = NULL,
    @generation35 bigint = NULL,
    @lineage_old35 varbinary(311) = NULL,
    @lineage_new35 varbinary(311) = NULL,
    @rowguid36 uniqueidentifier = NULL,
    @metadata_type36 tinyint = NULL,
    @generation36 bigint = NULL,
    @lineage_old36 varbinary(311) = NULL,
    @lineage_new36 varbinary(311) = NULL,
    @rowguid37 uniqueidentifier = NULL,
    @metadata_type37 tinyint = NULL,
    @generation37 bigint = NULL,
    @lineage_old37 varbinary(311) = NULL,
    @lineage_new37 varbinary(311) = NULL,
    @rowguid38 uniqueidentifier = NULL,
    @metadata_type38 tinyint = NULL,
    @generation38 bigint = NULL,
    @lineage_old38 varbinary(311) = NULL,
    @lineage_new38 varbinary(311) = NULL,
    @rowguid39 uniqueidentifier = NULL,
    @metadata_type39 tinyint = NULL,
    @generation39 bigint = NULL,
    @lineage_old39 varbinary(311) = NULL,
    @lineage_new39 varbinary(311) = NULL,
    @rowguid40 uniqueidentifier = NULL,
    @metadata_type40 tinyint = NULL,
    @generation40 bigint = NULL,
    @lineage_old40 varbinary(311) = NULL,
    @lineage_new40 varbinary(311) = NULL
,
    @rowguid41 uniqueidentifier = NULL,
    @metadata_type41 tinyint = NULL,
    @generation41 bigint = NULL,
    @lineage_old41 varbinary(311) = NULL,
    @lineage_new41 varbinary(311) = NULL,
    @rowguid42 uniqueidentifier = NULL,
    @metadata_type42 tinyint = NULL,
    @generation42 bigint = NULL,
    @lineage_old42 varbinary(311) = NULL,
    @lineage_new42 varbinary(311) = NULL,
    @rowguid43 uniqueidentifier = NULL,
    @metadata_type43 tinyint = NULL,
    @generation43 bigint = NULL,
    @lineage_old43 varbinary(311) = NULL,
    @lineage_new43 varbinary(311) = NULL,
    @rowguid44 uniqueidentifier = NULL,
    @metadata_type44 tinyint = NULL,
    @generation44 bigint = NULL,
    @lineage_old44 varbinary(311) = NULL,
    @lineage_new44 varbinary(311) = NULL,
    @rowguid45 uniqueidentifier = NULL,
    @metadata_type45 tinyint = NULL,
    @generation45 bigint = NULL,
    @lineage_old45 varbinary(311) = NULL,
    @lineage_new45 varbinary(311) = NULL,
    @rowguid46 uniqueidentifier = NULL,
    @metadata_type46 tinyint = NULL,
    @generation46 bigint = NULL,
    @lineage_old46 varbinary(311) = NULL,
    @lineage_new46 varbinary(311) = NULL,
    @rowguid47 uniqueidentifier = NULL,
    @metadata_type47 tinyint = NULL,
    @generation47 bigint = NULL,
    @lineage_old47 varbinary(311) = NULL,
    @lineage_new47 varbinary(311) = NULL,
    @rowguid48 uniqueidentifier = NULL,
    @metadata_type48 tinyint = NULL,
    @generation48 bigint = NULL,
    @lineage_old48 varbinary(311) = NULL,
    @lineage_new48 varbinary(311) = NULL,
    @rowguid49 uniqueidentifier = NULL,
    @metadata_type49 tinyint = NULL,
    @generation49 bigint = NULL,
    @lineage_old49 varbinary(311) = NULL,
    @lineage_new49 varbinary(311) = NULL,
    @rowguid50 uniqueidentifier = NULL,
    @metadata_type50 tinyint = NULL,
    @generation50 bigint = NULL,
    @lineage_old50 varbinary(311) = NULL,
    @lineage_new50 varbinary(311) = NULL
,
    @rowguid51 uniqueidentifier = NULL,
    @metadata_type51 tinyint = NULL,
    @generation51 bigint = NULL,
    @lineage_old51 varbinary(311) = NULL,
    @lineage_new51 varbinary(311) = NULL,
    @rowguid52 uniqueidentifier = NULL,
    @metadata_type52 tinyint = NULL,
    @generation52 bigint = NULL,
    @lineage_old52 varbinary(311) = NULL,
    @lineage_new52 varbinary(311) = NULL,
    @rowguid53 uniqueidentifier = NULL,
    @metadata_type53 tinyint = NULL,
    @generation53 bigint = NULL,
    @lineage_old53 varbinary(311) = NULL,
    @lineage_new53 varbinary(311) = NULL,
    @rowguid54 uniqueidentifier = NULL,
    @metadata_type54 tinyint = NULL,
    @generation54 bigint = NULL,
    @lineage_old54 varbinary(311) = NULL,
    @lineage_new54 varbinary(311) = NULL,
    @rowguid55 uniqueidentifier = NULL,
    @metadata_type55 tinyint = NULL,
    @generation55 bigint = NULL,
    @lineage_old55 varbinary(311) = NULL,
    @lineage_new55 varbinary(311) = NULL,
    @rowguid56 uniqueidentifier = NULL,
    @metadata_type56 tinyint = NULL,
    @generation56 bigint = NULL,
    @lineage_old56 varbinary(311) = NULL,
    @lineage_new56 varbinary(311) = NULL,
    @rowguid57 uniqueidentifier = NULL,
    @metadata_type57 tinyint = NULL,
    @generation57 bigint = NULL,
    @lineage_old57 varbinary(311) = NULL,
    @lineage_new57 varbinary(311) = NULL,
    @rowguid58 uniqueidentifier = NULL,
    @metadata_type58 tinyint = NULL,
    @generation58 bigint = NULL,
    @lineage_old58 varbinary(311) = NULL,
    @lineage_new58 varbinary(311) = NULL,
    @rowguid59 uniqueidentifier = NULL,
    @metadata_type59 tinyint = NULL,
    @generation59 bigint = NULL,
    @lineage_old59 varbinary(311) = NULL,
    @lineage_new59 varbinary(311) = NULL,
    @rowguid60 uniqueidentifier = NULL,
    @metadata_type60 tinyint = NULL,
    @generation60 bigint = NULL,
    @lineage_old60 varbinary(311) = NULL,
    @lineage_new60 varbinary(311) = NULL
,
    @rowguid61 uniqueidentifier = NULL,
    @metadata_type61 tinyint = NULL,
    @generation61 bigint = NULL,
    @lineage_old61 varbinary(311) = NULL,
    @lineage_new61 varbinary(311) = NULL,
    @rowguid62 uniqueidentifier = NULL,
    @metadata_type62 tinyint = NULL,
    @generation62 bigint = NULL,
    @lineage_old62 varbinary(311) = NULL,
    @lineage_new62 varbinary(311) = NULL,
    @rowguid63 uniqueidentifier = NULL,
    @metadata_type63 tinyint = NULL,
    @generation63 bigint = NULL,
    @lineage_old63 varbinary(311) = NULL,
    @lineage_new63 varbinary(311) = NULL,
    @rowguid64 uniqueidentifier = NULL,
    @metadata_type64 tinyint = NULL,
    @generation64 bigint = NULL,
    @lineage_old64 varbinary(311) = NULL,
    @lineage_new64 varbinary(311) = NULL,
    @rowguid65 uniqueidentifier = NULL,
    @metadata_type65 tinyint = NULL,
    @generation65 bigint = NULL,
    @lineage_old65 varbinary(311) = NULL,
    @lineage_new65 varbinary(311) = NULL,
    @rowguid66 uniqueidentifier = NULL,
    @metadata_type66 tinyint = NULL,
    @generation66 bigint = NULL,
    @lineage_old66 varbinary(311) = NULL,
    @lineage_new66 varbinary(311) = NULL,
    @rowguid67 uniqueidentifier = NULL,
    @metadata_type67 tinyint = NULL,
    @generation67 bigint = NULL,
    @lineage_old67 varbinary(311) = NULL,
    @lineage_new67 varbinary(311) = NULL,
    @rowguid68 uniqueidentifier = NULL,
    @metadata_type68 tinyint = NULL,
    @generation68 bigint = NULL,
    @lineage_old68 varbinary(311) = NULL,
    @lineage_new68 varbinary(311) = NULL,
    @rowguid69 uniqueidentifier = NULL,
    @metadata_type69 tinyint = NULL,
    @generation69 bigint = NULL,
    @lineage_old69 varbinary(311) = NULL,
    @lineage_new69 varbinary(311) = NULL,
    @rowguid70 uniqueidentifier = NULL,
    @metadata_type70 tinyint = NULL,
    @generation70 bigint = NULL,
    @lineage_old70 varbinary(311) = NULL,
    @lineage_new70 varbinary(311) = NULL
,
    @rowguid71 uniqueidentifier = NULL,
    @metadata_type71 tinyint = NULL,
    @generation71 bigint = NULL,
    @lineage_old71 varbinary(311) = NULL,
    @lineage_new71 varbinary(311) = NULL,
    @rowguid72 uniqueidentifier = NULL,
    @metadata_type72 tinyint = NULL,
    @generation72 bigint = NULL,
    @lineage_old72 varbinary(311) = NULL,
    @lineage_new72 varbinary(311) = NULL,
    @rowguid73 uniqueidentifier = NULL,
    @metadata_type73 tinyint = NULL,
    @generation73 bigint = NULL,
    @lineage_old73 varbinary(311) = NULL,
    @lineage_new73 varbinary(311) = NULL,
    @rowguid74 uniqueidentifier = NULL,
    @metadata_type74 tinyint = NULL,
    @generation74 bigint = NULL,
    @lineage_old74 varbinary(311) = NULL,
    @lineage_new74 varbinary(311) = NULL,
    @rowguid75 uniqueidentifier = NULL,
    @metadata_type75 tinyint = NULL,
    @generation75 bigint = NULL,
    @lineage_old75 varbinary(311) = NULL,
    @lineage_new75 varbinary(311) = NULL,
    @rowguid76 uniqueidentifier = NULL,
    @metadata_type76 tinyint = NULL,
    @generation76 bigint = NULL,
    @lineage_old76 varbinary(311) = NULL,
    @lineage_new76 varbinary(311) = NULL,
    @rowguid77 uniqueidentifier = NULL,
    @metadata_type77 tinyint = NULL,
    @generation77 bigint = NULL,
    @lineage_old77 varbinary(311) = NULL,
    @lineage_new77 varbinary(311) = NULL,
    @rowguid78 uniqueidentifier = NULL,
    @metadata_type78 tinyint = NULL,
    @generation78 bigint = NULL,
    @lineage_old78 varbinary(311) = NULL,
    @lineage_new78 varbinary(311) = NULL,
    @rowguid79 uniqueidentifier = NULL,
    @metadata_type79 tinyint = NULL,
    @generation79 bigint = NULL,
    @lineage_old79 varbinary(311) = NULL,
    @lineage_new79 varbinary(311) = NULL,
    @rowguid80 uniqueidentifier = NULL,
    @metadata_type80 tinyint = NULL,
    @generation80 bigint = NULL,
    @lineage_old80 varbinary(311) = NULL,
    @lineage_new80 varbinary(311) = NULL
,
    @rowguid81 uniqueidentifier = NULL,
    @metadata_type81 tinyint = NULL,
    @generation81 bigint = NULL,
    @lineage_old81 varbinary(311) = NULL,
    @lineage_new81 varbinary(311) = NULL,
    @rowguid82 uniqueidentifier = NULL,
    @metadata_type82 tinyint = NULL,
    @generation82 bigint = NULL,
    @lineage_old82 varbinary(311) = NULL,
    @lineage_new82 varbinary(311) = NULL,
    @rowguid83 uniqueidentifier = NULL,
    @metadata_type83 tinyint = NULL,
    @generation83 bigint = NULL,
    @lineage_old83 varbinary(311) = NULL,
    @lineage_new83 varbinary(311) = NULL,
    @rowguid84 uniqueidentifier = NULL,
    @metadata_type84 tinyint = NULL,
    @generation84 bigint = NULL,
    @lineage_old84 varbinary(311) = NULL,
    @lineage_new84 varbinary(311) = NULL,
    @rowguid85 uniqueidentifier = NULL,
    @metadata_type85 tinyint = NULL,
    @generation85 bigint = NULL,
    @lineage_old85 varbinary(311) = NULL,
    @lineage_new85 varbinary(311) = NULL,
    @rowguid86 uniqueidentifier = NULL,
    @metadata_type86 tinyint = NULL,
    @generation86 bigint = NULL,
    @lineage_old86 varbinary(311) = NULL,
    @lineage_new86 varbinary(311) = NULL,
    @rowguid87 uniqueidentifier = NULL,
    @metadata_type87 tinyint = NULL,
    @generation87 bigint = NULL,
    @lineage_old87 varbinary(311) = NULL,
    @lineage_new87 varbinary(311) = NULL,
    @rowguid88 uniqueidentifier = NULL,
    @metadata_type88 tinyint = NULL,
    @generation88 bigint = NULL,
    @lineage_old88 varbinary(311) = NULL,
    @lineage_new88 varbinary(311) = NULL,
    @rowguid89 uniqueidentifier = NULL,
    @metadata_type89 tinyint = NULL,
    @generation89 bigint = NULL,
    @lineage_old89 varbinary(311) = NULL,
    @lineage_new89 varbinary(311) = NULL,
    @rowguid90 uniqueidentifier = NULL,
    @metadata_type90 tinyint = NULL,
    @generation90 bigint = NULL,
    @lineage_old90 varbinary(311) = NULL,
    @lineage_new90 varbinary(311) = NULL
,
    @rowguid91 uniqueidentifier = NULL,
    @metadata_type91 tinyint = NULL,
    @generation91 bigint = NULL,
    @lineage_old91 varbinary(311) = NULL,
    @lineage_new91 varbinary(311) = NULL,
    @rowguid92 uniqueidentifier = NULL,
    @metadata_type92 tinyint = NULL,
    @generation92 bigint = NULL,
    @lineage_old92 varbinary(311) = NULL,
    @lineage_new92 varbinary(311) = NULL,
    @rowguid93 uniqueidentifier = NULL,
    @metadata_type93 tinyint = NULL,
    @generation93 bigint = NULL,
    @lineage_old93 varbinary(311) = NULL,
    @lineage_new93 varbinary(311) = NULL,
    @rowguid94 uniqueidentifier = NULL,
    @metadata_type94 tinyint = NULL,
    @generation94 bigint = NULL,
    @lineage_old94 varbinary(311) = NULL,
    @lineage_new94 varbinary(311) = NULL,
    @rowguid95 uniqueidentifier = NULL,
    @metadata_type95 tinyint = NULL,
    @generation95 bigint = NULL,
    @lineage_old95 varbinary(311) = NULL,
    @lineage_new95 varbinary(311) = NULL,
    @rowguid96 uniqueidentifier = NULL,
    @metadata_type96 tinyint = NULL,
    @generation96 bigint = NULL,
    @lineage_old96 varbinary(311) = NULL,
    @lineage_new96 varbinary(311) = NULL,
    @rowguid97 uniqueidentifier = NULL,
    @metadata_type97 tinyint = NULL,
    @generation97 bigint = NULL,
    @lineage_old97 varbinary(311) = NULL,
    @lineage_new97 varbinary(311) = NULL,
    @rowguid98 uniqueidentifier = NULL,
    @metadata_type98 tinyint = NULL,
    @generation98 bigint = NULL,
    @lineage_old98 varbinary(311) = NULL,
    @lineage_new98 varbinary(311) = NULL,
    @rowguid99 uniqueidentifier = NULL,
    @metadata_type99 tinyint = NULL,
    @generation99 bigint = NULL,
    @lineage_old99 varbinary(311) = NULL,
    @lineage_new99 varbinary(311) = NULL,
    @rowguid100 uniqueidentifier = NULL,
    @metadata_type100 tinyint = NULL,
    @generation100 bigint = NULL,
    @lineage_old100 varbinary(311) = NULL,
    @lineage_new100 varbinary(311) = NULL

)
as
begin


    -- this proc returns 0 to indicate error and 1 to indicate success
    declare @retcode    int
    set nocount on
    declare @rows_deleted int
    declare @rows_remaining int
    declare @error int
    declare @tomb_rows_updated int
    declare @publication_number smallint
    declare @rows_in_syncview int
        
    if ({ fn ISPALUSER('AB1F05CE-CE24-415B-8771-7EDE0EFE1D98') } <> 1)
    begin       
        RAISERROR (14126, 11, -1)
        return 0
    end
    
    select @publication_number = 2

    if @rowstobedeleted is NULL or @rowstobedeleted <= 0
        return 0

    begin tran
    save tran batchdeleteproc


    delete [dbo].[HoaDon] with (rowlock)
    from 
    (

    select @rowguid1 as rowguid, @metadata_type1 as metadata_type, @lineage_old1 as lineage_old, @lineage_new1 as lineage_new, @generation1 as generation  union all 
    select @rowguid2 as rowguid, @metadata_type2 as metadata_type, @lineage_old2 as lineage_old, @lineage_new2 as lineage_new, @generation2 as generation  union all 
    select @rowguid3 as rowguid, @metadata_type3 as metadata_type, @lineage_old3 as lineage_old, @lineage_new3 as lineage_new, @generation3 as generation  union all 
    select @rowguid4 as rowguid, @metadata_type4 as metadata_type, @lineage_old4 as lineage_old, @lineage_new4 as lineage_new, @generation4 as generation  union all 
    select @rowguid5 as rowguid, @metadata_type5 as metadata_type, @lineage_old5 as lineage_old, @lineage_new5 as lineage_new, @generation5 as generation  union all 
    select @rowguid6 as rowguid, @metadata_type6 as metadata_type, @lineage_old6 as lineage_old, @lineage_new6 as lineage_new, @generation6 as generation  union all 
    select @rowguid7 as rowguid, @metadata_type7 as metadata_type, @lineage_old7 as lineage_old, @lineage_new7 as lineage_new, @generation7 as generation  union all 
    select @rowguid8 as rowguid, @metadata_type8 as metadata_type, @lineage_old8 as lineage_old, @lineage_new8 as lineage_new, @generation8 as generation  union all 
    select @rowguid9 as rowguid, @metadata_type9 as metadata_type, @lineage_old9 as lineage_old, @lineage_new9 as lineage_new, @generation9 as generation  union all 
    select @rowguid10 as rowguid, @metadata_type10 as metadata_type, @lineage_old10 as lineage_old, @lineage_new10 as lineage_new, @generation10 as generation 
 union all 
    select @rowguid11 as rowguid, @metadata_type11 as metadata_type, @lineage_old11 as lineage_old, @lineage_new11 as lineage_new, @generation11 as generation  union all 
    select @rowguid12 as rowguid, @metadata_type12 as metadata_type, @lineage_old12 as lineage_old, @lineage_new12 as lineage_new, @generation12 as generation  union all 
    select @rowguid13 as rowguid, @metadata_type13 as metadata_type, @lineage_old13 as lineage_old, @lineage_new13 as lineage_new, @generation13 as generation  union all 
    select @rowguid14 as rowguid, @metadata_type14 as metadata_type, @lineage_old14 as lineage_old, @lineage_new14 as lineage_new, @generation14 as generation  union all 
    select @rowguid15 as rowguid, @metadata_type15 as metadata_type, @lineage_old15 as lineage_old, @lineage_new15 as lineage_new, @generation15 as generation  union all 
    select @rowguid16 as rowguid, @metadata_type16 as metadata_type, @lineage_old16 as lineage_old, @lineage_new16 as lineage_new, @generation16 as generation  union all 
    select @rowguid17 as rowguid, @metadata_type17 as metadata_type, @lineage_old17 as lineage_old, @lineage_new17 as lineage_new, @generation17 as generation  union all 
    select @rowguid18 as rowguid, @metadata_type18 as metadata_type, @lineage_old18 as lineage_old, @lineage_new18 as lineage_new, @generation18 as generation  union all 
    select @rowguid19 as rowguid, @metadata_type19 as metadata_type, @lineage_old19 as lineage_old, @lineage_new19 as lineage_new, @generation19 as generation  union all 
    select @rowguid20 as rowguid, @metadata_type20 as metadata_type, @lineage_old20 as lineage_old, @lineage_new20 as lineage_new, @generation20 as generation 
 union all 
    select @rowguid21 as rowguid, @metadata_type21 as metadata_type, @lineage_old21 as lineage_old, @lineage_new21 as lineage_new, @generation21 as generation  union all 
    select @rowguid22 as rowguid, @metadata_type22 as metadata_type, @lineage_old22 as lineage_old, @lineage_new22 as lineage_new, @generation22 as generation  union all 
    select @rowguid23 as rowguid, @metadata_type23 as metadata_type, @lineage_old23 as lineage_old, @lineage_new23 as lineage_new, @generation23 as generation  union all 
    select @rowguid24 as rowguid, @metadata_type24 as metadata_type, @lineage_old24 as lineage_old, @lineage_new24 as lineage_new, @generation24 as generation  union all 
    select @rowguid25 as rowguid, @metadata_type25 as metadata_type, @lineage_old25 as lineage_old, @lineage_new25 as lineage_new, @generation25 as generation  union all 
    select @rowguid26 as rowguid, @metadata_type26 as metadata_type, @lineage_old26 as lineage_old, @lineage_new26 as lineage_new, @generation26 as generation  union all 
    select @rowguid27 as rowguid, @metadata_type27 as metadata_type, @lineage_old27 as lineage_old, @lineage_new27 as lineage_new, @generation27 as generation  union all 
    select @rowguid28 as rowguid, @metadata_type28 as metadata_type, @lineage_old28 as lineage_old, @lineage_new28 as lineage_new, @generation28 as generation  union all 
    select @rowguid29 as rowguid, @metadata_type29 as metadata_type, @lineage_old29 as lineage_old, @lineage_new29 as lineage_new, @generation29 as generation  union all 
    select @rowguid30 as rowguid, @metadata_type30 as metadata_type, @lineage_old30 as lineage_old, @lineage_new30 as lineage_new, @generation30 as generation 
 union all 
    select @rowguid31 as rowguid, @metadata_type31 as metadata_type, @lineage_old31 as lineage_old, @lineage_new31 as lineage_new, @generation31 as generation  union all 
    select @rowguid32 as rowguid, @metadata_type32 as metadata_type, @lineage_old32 as lineage_old, @lineage_new32 as lineage_new, @generation32 as generation  union all 
    select @rowguid33 as rowguid, @metadata_type33 as metadata_type, @lineage_old33 as lineage_old, @lineage_new33 as lineage_new, @generation33 as generation  union all 
    select @rowguid34 as rowguid, @metadata_type34 as metadata_type, @lineage_old34 as lineage_old, @lineage_new34 as lineage_new, @generation34 as generation  union all 
    select @rowguid35 as rowguid, @metadata_type35 as metadata_type, @lineage_old35 as lineage_old, @lineage_new35 as lineage_new, @generation35 as generation  union all 
    select @rowguid36 as rowguid, @metadata_type36 as metadata_type, @lineage_old36 as lineage_old, @lineage_new36 as lineage_new, @generation36 as generation  union all 
    select @rowguid37 as rowguid, @metadata_type37 as metadata_type, @lineage_old37 as lineage_old, @lineage_new37 as lineage_new, @generation37 as generation  union all 
    select @rowguid38 as rowguid, @metadata_type38 as metadata_type, @lineage_old38 as lineage_old, @lineage_new38 as lineage_new, @generation38 as generation  union all 
    select @rowguid39 as rowguid, @metadata_type39 as metadata_type, @lineage_old39 as lineage_old, @lineage_new39 as lineage_new, @generation39 as generation  union all 
    select @rowguid40 as rowguid, @metadata_type40 as metadata_type, @lineage_old40 as lineage_old, @lineage_new40 as lineage_new, @generation40 as generation 
 union all 
    select @rowguid41 as rowguid, @metadata_type41 as metadata_type, @lineage_old41 as lineage_old, @lineage_new41 as lineage_new, @generation41 as generation  union all 
    select @rowguid42 as rowguid, @metadata_type42 as metadata_type, @lineage_old42 as lineage_old, @lineage_new42 as lineage_new, @generation42 as generation  union all 
    select @rowguid43 as rowguid, @metadata_type43 as metadata_type, @lineage_old43 as lineage_old, @lineage_new43 as lineage_new, @generation43 as generation  union all 
    select @rowguid44 as rowguid, @metadata_type44 as metadata_type, @lineage_old44 as lineage_old, @lineage_new44 as lineage_new, @generation44 as generation  union all 
    select @rowguid45 as rowguid, @metadata_type45 as metadata_type, @lineage_old45 as lineage_old, @lineage_new45 as lineage_new, @generation45 as generation  union all 
    select @rowguid46 as rowguid, @metadata_type46 as metadata_type, @lineage_old46 as lineage_old, @lineage_new46 as lineage_new, @generation46 as generation  union all 
    select @rowguid47 as rowguid, @metadata_type47 as metadata_type, @lineage_old47 as lineage_old, @lineage_new47 as lineage_new, @generation47 as generation  union all 
    select @rowguid48 as rowguid, @metadata_type48 as metadata_type, @lineage_old48 as lineage_old, @lineage_new48 as lineage_new, @generation48 as generation  union all 
    select @rowguid49 as rowguid, @metadata_type49 as metadata_type, @lineage_old49 as lineage_old, @lineage_new49 as lineage_new, @generation49 as generation  union all 
    select @rowguid50 as rowguid, @metadata_type50 as metadata_type, @lineage_old50 as lineage_old, @lineage_new50 as lineage_new, @generation50 as generation 
 union all 
    select @rowguid51 as rowguid, @metadata_type51 as metadata_type, @lineage_old51 as lineage_old, @lineage_new51 as lineage_new, @generation51 as generation  union all 
    select @rowguid52 as rowguid, @metadata_type52 as metadata_type, @lineage_old52 as lineage_old, @lineage_new52 as lineage_new, @generation52 as generation  union all 
    select @rowguid53 as rowguid, @metadata_type53 as metadata_type, @lineage_old53 as lineage_old, @lineage_new53 as lineage_new, @generation53 as generation  union all 
    select @rowguid54 as rowguid, @metadata_type54 as metadata_type, @lineage_old54 as lineage_old, @lineage_new54 as lineage_new, @generation54 as generation  union all 
    select @rowguid55 as rowguid, @metadata_type55 as metadata_type, @lineage_old55 as lineage_old, @lineage_new55 as lineage_new, @generation55 as generation  union all 
    select @rowguid56 as rowguid, @metadata_type56 as metadata_type, @lineage_old56 as lineage_old, @lineage_new56 as lineage_new, @generation56 as generation  union all 
    select @rowguid57 as rowguid, @metadata_type57 as metadata_type, @lineage_old57 as lineage_old, @lineage_new57 as lineage_new, @generation57 as generation  union all 
    select @rowguid58 as rowguid, @metadata_type58 as metadata_type, @lineage_old58 as lineage_old, @lineage_new58 as lineage_new, @generation58 as generation  union all 
    select @rowguid59 as rowguid, @metadata_type59 as metadata_type, @lineage_old59 as lineage_old, @lineage_new59 as lineage_new, @generation59 as generation  union all 
    select @rowguid60 as rowguid, @metadata_type60 as metadata_type, @lineage_old60 as lineage_old, @lineage_new60 as lineage_new, @generation60 as generation 
 union all 
    select @rowguid61 as rowguid, @metadata_type61 as metadata_type, @lineage_old61 as lineage_old, @lineage_new61 as lineage_new, @generation61 as generation  union all 
    select @rowguid62 as rowguid, @metadata_type62 as metadata_type, @lineage_old62 as lineage_old, @lineage_new62 as lineage_new, @generation62 as generation  union all 
    select @rowguid63 as rowguid, @metadata_type63 as metadata_type, @lineage_old63 as lineage_old, @lineage_new63 as lineage_new, @generation63 as generation  union all 
    select @rowguid64 as rowguid, @metadata_type64 as metadata_type, @lineage_old64 as lineage_old, @lineage_new64 as lineage_new, @generation64 as generation  union all 
    select @rowguid65 as rowguid, @metadata_type65 as metadata_type, @lineage_old65 as lineage_old, @lineage_new65 as lineage_new, @generation65 as generation  union all 
    select @rowguid66 as rowguid, @metadata_type66 as metadata_type, @lineage_old66 as lineage_old, @lineage_new66 as lineage_new, @generation66 as generation  union all 
    select @rowguid67 as rowguid, @metadata_type67 as metadata_type, @lineage_old67 as lineage_old, @lineage_new67 as lineage_new, @generation67 as generation  union all 
    select @rowguid68 as rowguid, @metadata_type68 as metadata_type, @lineage_old68 as lineage_old, @lineage_new68 as lineage_new, @generation68 as generation  union all 
    select @rowguid69 as rowguid, @metadata_type69 as metadata_type, @lineage_old69 as lineage_old, @lineage_new69 as lineage_new, @generation69 as generation  union all 
    select @rowguid70 as rowguid, @metadata_type70 as metadata_type, @lineage_old70 as lineage_old, @lineage_new70 as lineage_new, @generation70 as generation 
 union all 
    select @rowguid71 as rowguid, @metadata_type71 as metadata_type, @lineage_old71 as lineage_old, @lineage_new71 as lineage_new, @generation71 as generation  union all 
    select @rowguid72 as rowguid, @metadata_type72 as metadata_type, @lineage_old72 as lineage_old, @lineage_new72 as lineage_new, @generation72 as generation  union all 
    select @rowguid73 as rowguid, @metadata_type73 as metadata_type, @lineage_old73 as lineage_old, @lineage_new73 as lineage_new, @generation73 as generation  union all 
    select @rowguid74 as rowguid, @metadata_type74 as metadata_type, @lineage_old74 as lineage_old, @lineage_new74 as lineage_new, @generation74 as generation  union all 
    select @rowguid75 as rowguid, @metadata_type75 as metadata_type, @lineage_old75 as lineage_old, @lineage_new75 as lineage_new, @generation75 as generation  union all 
    select @rowguid76 as rowguid, @metadata_type76 as metadata_type, @lineage_old76 as lineage_old, @lineage_new76 as lineage_new, @generation76 as generation  union all 
    select @rowguid77 as rowguid, @metadata_type77 as metadata_type, @lineage_old77 as lineage_old, @lineage_new77 as lineage_new, @generation77 as generation  union all 
    select @rowguid78 as rowguid, @metadata_type78 as metadata_type, @lineage_old78 as lineage_old, @lineage_new78 as lineage_new, @generation78 as generation  union all 
    select @rowguid79 as rowguid, @metadata_type79 as metadata_type, @lineage_old79 as lineage_old, @lineage_new79 as lineage_new, @generation79 as generation  union all 
    select @rowguid80 as rowguid, @metadata_type80 as metadata_type, @lineage_old80 as lineage_old, @lineage_new80 as lineage_new, @generation80 as generation 
 union all 
    select @rowguid81 as rowguid, @metadata_type81 as metadata_type, @lineage_old81 as lineage_old, @lineage_new81 as lineage_new, @generation81 as generation  union all 
    select @rowguid82 as rowguid, @metadata_type82 as metadata_type, @lineage_old82 as lineage_old, @lineage_new82 as lineage_new, @generation82 as generation  union all 
    select @rowguid83 as rowguid, @metadata_type83 as metadata_type, @lineage_old83 as lineage_old, @lineage_new83 as lineage_new, @generation83 as generation  union all 
    select @rowguid84 as rowguid, @metadata_type84 as metadata_type, @lineage_old84 as lineage_old, @lineage_new84 as lineage_new, @generation84 as generation  union all 
    select @rowguid85 as rowguid, @metadata_type85 as metadata_type, @lineage_old85 as lineage_old, @lineage_new85 as lineage_new, @generation85 as generation  union all 
    select @rowguid86 as rowguid, @metadata_type86 as metadata_type, @lineage_old86 as lineage_old, @lineage_new86 as lineage_new, @generation86 as generation  union all 
    select @rowguid87 as rowguid, @metadata_type87 as metadata_type, @lineage_old87 as lineage_old, @lineage_new87 as lineage_new, @generation87 as generation  union all 
    select @rowguid88 as rowguid, @metadata_type88 as metadata_type, @lineage_old88 as lineage_old, @lineage_new88 as lineage_new, @generation88 as generation  union all 
    select @rowguid89 as rowguid, @metadata_type89 as metadata_type, @lineage_old89 as lineage_old, @lineage_new89 as lineage_new, @generation89 as generation  union all 
    select @rowguid90 as rowguid, @metadata_type90 as metadata_type, @lineage_old90 as lineage_old, @lineage_new90 as lineage_new, @generation90 as generation 
 union all 
    select @rowguid91 as rowguid, @metadata_type91 as metadata_type, @lineage_old91 as lineage_old, @lineage_new91 as lineage_new, @generation91 as generation  union all 
    select @rowguid92 as rowguid, @metadata_type92 as metadata_type, @lineage_old92 as lineage_old, @lineage_new92 as lineage_new, @generation92 as generation  union all 
    select @rowguid93 as rowguid, @metadata_type93 as metadata_type, @lineage_old93 as lineage_old, @lineage_new93 as lineage_new, @generation93 as generation  union all 
    select @rowguid94 as rowguid, @metadata_type94 as metadata_type, @lineage_old94 as lineage_old, @lineage_new94 as lineage_new, @generation94 as generation  union all 
    select @rowguid95 as rowguid, @metadata_type95 as metadata_type, @lineage_old95 as lineage_old, @lineage_new95 as lineage_new, @generation95 as generation  union all 
    select @rowguid96 as rowguid, @metadata_type96 as metadata_type, @lineage_old96 as lineage_old, @lineage_new96 as lineage_new, @generation96 as generation  union all 
    select @rowguid97 as rowguid, @metadata_type97 as metadata_type, @lineage_old97 as lineage_old, @lineage_new97 as lineage_new, @generation97 as generation  union all 
    select @rowguid98 as rowguid, @metadata_type98 as metadata_type, @lineage_old98 as lineage_old, @lineage_new98 as lineage_new, @generation98 as generation  union all 
    select @rowguid99 as rowguid, @metadata_type99 as metadata_type, @lineage_old99 as lineage_old, @lineage_new99 as lineage_new, @generation99 as generation  union all 
    select @rowguid100 as rowguid, @metadata_type100 as metadata_type, @lineage_old100 as lineage_old, @lineage_new100 as lineage_new, @generation100 as generation 
) as rows
    inner join [dbo].[HoaDon] t with (rowlock) on rows.rowguid = t.[rowguid] and rows.rowguid is not NULL

    left outer join dbo.MSmerge_contents cont with (rowlock) 
    on rows.rowguid = cont.rowguid and cont.tablenick = 57128000 
    and rows.rowguid is not NULL
    where ((rows.metadata_type = 3 and cont.rowguid is NULL) or
           ((rows.metadata_type = 5 or  rows.metadata_type = 6) and (cont.rowguid is NULL or cont.lineage = rows.lineage_old)) or
           (cont.rowguid is not NULL and cont.lineage = rows.lineage_old))
           and rows.rowguid is not NULL 

    select @rows_deleted = @@rowcount, @error = @@error
    if @error<>0
        goto Failure
    if @rows_deleted > @rowstobedeleted
    begin
        -- this is just not possible
        raiserror(20684, 16, -1, '[dbo].[HoaDon]')
        goto Failure
    end
    if @rows_deleted <> @rowstobedeleted
    begin

        -- we will now check if any of the rows we wanted to delete were not deleted. If the rows were not deleted
        -- by the previous delete because it was already deleted, we will still assume that this is a success
        select @rows_remaining = count(*) from 
        ( 

         select @rowguid1 as rowguid union all 
         select @rowguid2 as rowguid union all 
         select @rowguid3 as rowguid union all 
         select @rowguid4 as rowguid union all 
         select @rowguid5 as rowguid union all 
         select @rowguid6 as rowguid union all 
         select @rowguid7 as rowguid union all 
         select @rowguid8 as rowguid union all 
         select @rowguid9 as rowguid union all 
         select @rowguid10 as rowguid union all 
         select @rowguid11 as rowguid union all 
         select @rowguid12 as rowguid union all 
         select @rowguid13 as rowguid union all 
         select @rowguid14 as rowguid union all 
         select @rowguid15 as rowguid union all 
         select @rowguid16 as rowguid union all 
         select @rowguid17 as rowguid union all 
         select @rowguid18 as rowguid union all 
         select @rowguid19 as rowguid union all 
         select @rowguid20 as rowguid union all 
         select @rowguid21 as rowguid union all 
         select @rowguid22 as rowguid union all 
         select @rowguid23 as rowguid union all 
         select @rowguid24 as rowguid union all 
         select @rowguid25 as rowguid union all 
         select @rowguid26 as rowguid union all 
         select @rowguid27 as rowguid union all 
         select @rowguid28 as rowguid union all 
         select @rowguid29 as rowguid union all 
         select @rowguid30 as rowguid union all 
         select @rowguid31 as rowguid union all 
         select @rowguid32 as rowguid union all 
         select @rowguid33 as rowguid union all 
         select @rowguid34 as rowguid union all 
         select @rowguid35 as rowguid union all 
         select @rowguid36 as rowguid union all 
         select @rowguid37 as rowguid union all 
         select @rowguid38 as rowguid union all 
         select @rowguid39 as rowguid union all 
         select @rowguid40 as rowguid union all 
         select @rowguid41 as rowguid union all 
         select @rowguid42 as rowguid union all 
         select @rowguid43 as rowguid union all 
         select @rowguid44 as rowguid union all 
         select @rowguid45 as rowguid union all 
         select @rowguid46 as rowguid union all 
         select @rowguid47 as rowguid union all 
         select @rowguid48 as rowguid union all 
         select @rowguid49 as rowguid union all 
         select @rowguid50 as rowguid union all

         select @rowguid51 as rowguid union all 
         select @rowguid52 as rowguid union all 
         select @rowguid53 as rowguid union all 
         select @rowguid54 as rowguid union all 
         select @rowguid55 as rowguid union all 
         select @rowguid56 as rowguid union all 
         select @rowguid57 as rowguid union all 
         select @rowguid58 as rowguid union all 
         select @rowguid59 as rowguid union all 
         select @rowguid60 as rowguid union all 
         select @rowguid61 as rowguid union all 
         select @rowguid62 as rowguid union all 
         select @rowguid63 as rowguid union all 
         select @rowguid64 as rowguid union all 
         select @rowguid65 as rowguid union all 
         select @rowguid66 as rowguid union all 
         select @rowguid67 as rowguid union all 
         select @rowguid68 as rowguid union all 
         select @rowguid69 as rowguid union all 
         select @rowguid70 as rowguid union all 
         select @rowguid71 as rowguid union all 
         select @rowguid72 as rowguid union all 
         select @rowguid73 as rowguid union all 
         select @rowguid74 as rowguid union all 
         select @rowguid75 as rowguid union all 
         select @rowguid76 as rowguid union all 
         select @rowguid77 as rowguid union all 
         select @rowguid78 as rowguid union all 
         select @rowguid79 as rowguid union all 
         select @rowguid80 as rowguid union all 
         select @rowguid81 as rowguid union all 
         select @rowguid82 as rowguid union all 
         select @rowguid83 as rowguid union all 
         select @rowguid84 as rowguid union all 
         select @rowguid85 as rowguid union all 
         select @rowguid86 as rowguid union all 
         select @rowguid87 as rowguid union all 
         select @rowguid88 as rowguid union all 
         select @rowguid89 as rowguid union all 
         select @rowguid90 as rowguid union all 
         select @rowguid91 as rowguid union all 
         select @rowguid92 as rowguid union all 
         select @rowguid93 as rowguid union all 
         select @rowguid94 as rowguid union all 
         select @rowguid95 as rowguid union all 
         select @rowguid96 as rowguid union all 
         select @rowguid97 as rowguid union all 
         select @rowguid98 as rowguid union all 
         select @rowguid99 as rowguid union all 
         select @rowguid100 as rowguid

        ) as rows
        inner join [dbo].[HoaDon] t with (rowlock) 
        on t.[rowguid] = rows.rowguid
        and rows.rowguid is not NULL
        
        if @@error <> 0
            goto Failure
        
        if @rows_remaining <> 0
        begin
            -- failed deleting one or more rows. Could be because of metadata mismatch
            --raiserror(20682, 10, -1, @rows_remaining, '[dbo].[HoaDon]')
            goto Failure
        end        
    end

    -- if we get here it means that all the rows that we intend to delete were either deleted by us
    -- or they were already deleted by someone else and do not exist in the user table
    -- we insert a tombstone entry for the rows we have deleted and delete the contents rows if exists

    -- if the rows were previously deleted we still want to update the metadatatype, generation and lineage
    -- in MSmerge_tombstone. We could find rows in the following update also if the trigger got called by
    -- the user table delete and it inserted the rows into tombstone (it would have inserted with type 1)
    update dbo.MSmerge_tombstone with (rowlock)
        set type = case when (rows.metadata_type=5 or rows.metadata_type=6) then rows.metadata_type else 1 end,
            generation = rows.generation,
            lineage = rows.lineage_new
    from 
    (

    select @rowguid1 as rowguid, @metadata_type1 as metadata_type, @lineage_old1 as lineage_old, @lineage_new1 as lineage_new, @generation1 as generation  union all 
    select @rowguid2 as rowguid, @metadata_type2 as metadata_type, @lineage_old2 as lineage_old, @lineage_new2 as lineage_new, @generation2 as generation  union all 
    select @rowguid3 as rowguid, @metadata_type3 as metadata_type, @lineage_old3 as lineage_old, @lineage_new3 as lineage_new, @generation3 as generation  union all 
    select @rowguid4 as rowguid, @metadata_type4 as metadata_type, @lineage_old4 as lineage_old, @lineage_new4 as lineage_new, @generation4 as generation  union all 
    select @rowguid5 as rowguid, @metadata_type5 as metadata_type, @lineage_old5 as lineage_old, @lineage_new5 as lineage_new, @generation5 as generation  union all 
    select @rowguid6 as rowguid, @metadata_type6 as metadata_type, @lineage_old6 as lineage_old, @lineage_new6 as lineage_new, @generation6 as generation  union all 
    select @rowguid7 as rowguid, @metadata_type7 as metadata_type, @lineage_old7 as lineage_old, @lineage_new7 as lineage_new, @generation7 as generation  union all 
    select @rowguid8 as rowguid, @metadata_type8 as metadata_type, @lineage_old8 as lineage_old, @lineage_new8 as lineage_new, @generation8 as generation  union all 
    select @rowguid9 as rowguid, @metadata_type9 as metadata_type, @lineage_old9 as lineage_old, @lineage_new9 as lineage_new, @generation9 as generation  union all 
    select @rowguid10 as rowguid, @metadata_type10 as metadata_type, @lineage_old10 as lineage_old, @lineage_new10 as lineage_new, @generation10 as generation 
 union all 
    select @rowguid11 as rowguid, @metadata_type11 as metadata_type, @lineage_old11 as lineage_old, @lineage_new11 as lineage_new, @generation11 as generation  union all 
    select @rowguid12 as rowguid, @metadata_type12 as metadata_type, @lineage_old12 as lineage_old, @lineage_new12 as lineage_new, @generation12 as generation  union all 
    select @rowguid13 as rowguid, @metadata_type13 as metadata_type, @lineage_old13 as lineage_old, @lineage_new13 as lineage_new, @generation13 as generation  union all 
    select @rowguid14 as rowguid, @metadata_type14 as metadata_type, @lineage_old14 as lineage_old, @lineage_new14 as lineage_new, @generation14 as generation  union all 
    select @rowguid15 as rowguid, @metadata_type15 as metadata_type, @lineage_old15 as lineage_old, @lineage_new15 as lineage_new, @generation15 as generation  union all 
    select @rowguid16 as rowguid, @metadata_type16 as metadata_type, @lineage_old16 as lineage_old, @lineage_new16 as lineage_new, @generation16 as generation  union all 
    select @rowguid17 as rowguid, @metadata_type17 as metadata_type, @lineage_old17 as lineage_old, @lineage_new17 as lineage_new, @generation17 as generation  union all 
    select @rowguid18 as rowguid, @metadata_type18 as metadata_type, @lineage_old18 as lineage_old, @lineage_new18 as lineage_new, @generation18 as generation  union all 
    select @rowguid19 as rowguid, @metadata_type19 as metadata_type, @lineage_old19 as lineage_old, @lineage_new19 as lineage_new, @generation19 as generation  union all 
    select @rowguid20 as rowguid, @metadata_type20 as metadata_type, @lineage_old20 as lineage_old, @lineage_new20 as lineage_new, @generation20 as generation 
 union all 
    select @rowguid21 as rowguid, @metadata_type21 as metadata_type, @lineage_old21 as lineage_old, @lineage_new21 as lineage_new, @generation21 as generation  union all 
    select @rowguid22 as rowguid, @metadata_type22 as metadata_type, @lineage_old22 as lineage_old, @lineage_new22 as lineage_new, @generation22 as generation  union all 
    select @rowguid23 as rowguid, @metadata_type23 as metadata_type, @lineage_old23 as lineage_old, @lineage_new23 as lineage_new, @generation23 as generation  union all 
    select @rowguid24 as rowguid, @metadata_type24 as metadata_type, @lineage_old24 as lineage_old, @lineage_new24 as lineage_new, @generation24 as generation  union all 
    select @rowguid25 as rowguid, @metadata_type25 as metadata_type, @lineage_old25 as lineage_old, @lineage_new25 as lineage_new, @generation25 as generation  union all 
    select @rowguid26 as rowguid, @metadata_type26 as metadata_type, @lineage_old26 as lineage_old, @lineage_new26 as lineage_new, @generation26 as generation  union all 
    select @rowguid27 as rowguid, @metadata_type27 as metadata_type, @lineage_old27 as lineage_old, @lineage_new27 as lineage_new, @generation27 as generation  union all 
    select @rowguid28 as rowguid, @metadata_type28 as metadata_type, @lineage_old28 as lineage_old, @lineage_new28 as lineage_new, @generation28 as generation  union all 
    select @rowguid29 as rowguid, @metadata_type29 as metadata_type, @lineage_old29 as lineage_old, @lineage_new29 as lineage_new, @generation29 as generation  union all 
    select @rowguid30 as rowguid, @metadata_type30 as metadata_type, @lineage_old30 as lineage_old, @lineage_new30 as lineage_new, @generation30 as generation 
 union all 
    select @rowguid31 as rowguid, @metadata_type31 as metadata_type, @lineage_old31 as lineage_old, @lineage_new31 as lineage_new, @generation31 as generation  union all 
    select @rowguid32 as rowguid, @metadata_type32 as metadata_type, @lineage_old32 as lineage_old, @lineage_new32 as lineage_new, @generation32 as generation  union all 
    select @rowguid33 as rowguid, @metadata_type33 as metadata_type, @lineage_old33 as lineage_old, @lineage_new33 as lineage_new, @generation33 as generation  union all 
    select @rowguid34 as rowguid, @metadata_type34 as metadata_type, @lineage_old34 as lineage_old, @lineage_new34 as lineage_new, @generation34 as generation  union all 
    select @rowguid35 as rowguid, @metadata_type35 as metadata_type, @lineage_old35 as lineage_old, @lineage_new35 as lineage_new, @generation35 as generation  union all 
    select @rowguid36 as rowguid, @metadata_type36 as metadata_type, @lineage_old36 as lineage_old, @lineage_new36 as lineage_new, @generation36 as generation  union all 
    select @rowguid37 as rowguid, @metadata_type37 as metadata_type, @lineage_old37 as lineage_old, @lineage_new37 as lineage_new, @generation37 as generation  union all 
    select @rowguid38 as rowguid, @metadata_type38 as metadata_type, @lineage_old38 as lineage_old, @lineage_new38 as lineage_new, @generation38 as generation  union all 
    select @rowguid39 as rowguid, @metadata_type39 as metadata_type, @lineage_old39 as lineage_old, @lineage_new39 as lineage_new, @generation39 as generation  union all 
    select @rowguid40 as rowguid, @metadata_type40 as metadata_type, @lineage_old40 as lineage_old, @lineage_new40 as lineage_new, @generation40 as generation 
 union all 
    select @rowguid41 as rowguid, @metadata_type41 as metadata_type, @lineage_old41 as lineage_old, @lineage_new41 as lineage_new, @generation41 as generation  union all 
    select @rowguid42 as rowguid, @metadata_type42 as metadata_type, @lineage_old42 as lineage_old, @lineage_new42 as lineage_new, @generation42 as generation  union all 
    select @rowguid43 as rowguid, @metadata_type43 as metadata_type, @lineage_old43 as lineage_old, @lineage_new43 as lineage_new, @generation43 as generation  union all 
    select @rowguid44 as rowguid, @metadata_type44 as metadata_type, @lineage_old44 as lineage_old, @lineage_new44 as lineage_new, @generation44 as generation  union all 
    select @rowguid45 as rowguid, @metadata_type45 as metadata_type, @lineage_old45 as lineage_old, @lineage_new45 as lineage_new, @generation45 as generation  union all 
    select @rowguid46 as rowguid, @metadata_type46 as metadata_type, @lineage_old46 as lineage_old, @lineage_new46 as lineage_new, @generation46 as generation  union all 
    select @rowguid47 as rowguid, @metadata_type47 as metadata_type, @lineage_old47 as lineage_old, @lineage_new47 as lineage_new, @generation47 as generation  union all 
    select @rowguid48 as rowguid, @metadata_type48 as metadata_type, @lineage_old48 as lineage_old, @lineage_new48 as lineage_new, @generation48 as generation  union all 
    select @rowguid49 as rowguid, @metadata_type49 as metadata_type, @lineage_old49 as lineage_old, @lineage_new49 as lineage_new, @generation49 as generation  union all 
    select @rowguid50 as rowguid, @metadata_type50 as metadata_type, @lineage_old50 as lineage_old, @lineage_new50 as lineage_new, @generation50 as generation 
 union all 
    select @rowguid51 as rowguid, @metadata_type51 as metadata_type, @lineage_old51 as lineage_old, @lineage_new51 as lineage_new, @generation51 as generation  union all 
    select @rowguid52 as rowguid, @metadata_type52 as metadata_type, @lineage_old52 as lineage_old, @lineage_new52 as lineage_new, @generation52 as generation  union all 
    select @rowguid53 as rowguid, @metadata_type53 as metadata_type, @lineage_old53 as lineage_old, @lineage_new53 as lineage_new, @generation53 as generation  union all 
    select @rowguid54 as rowguid, @metadata_type54 as metadata_type, @lineage_old54 as lineage_old, @lineage_new54 as lineage_new, @generation54 as generation  union all 
    select @rowguid55 as rowguid, @metadata_type55 as metadata_type, @lineage_old55 as lineage_old, @lineage_new55 as lineage_new, @generation55 as generation  union all 
    select @rowguid56 as rowguid, @metadata_type56 as metadata_type, @lineage_old56 as lineage_old, @lineage_new56 as lineage_new, @generation56 as generation  union all 
    select @rowguid57 as rowguid, @metadata_type57 as metadata_type, @lineage_old57 as lineage_old, @lineage_new57 as lineage_new, @generation57 as generation  union all 
    select @rowguid58 as rowguid, @metadata_type58 as metadata_type, @lineage_old58 as lineage_old, @lineage_new58 as lineage_new, @generation58 as generation  union all 
    select @rowguid59 as rowguid, @metadata_type59 as metadata_type, @lineage_old59 as lineage_old, @lineage_new59 as lineage_new, @generation59 as generation  union all 
    select @rowguid60 as rowguid, @metadata_type60 as metadata_type, @lineage_old60 as lineage_old, @lineage_new60 as lineage_new, @generation60 as generation 
 union all 
    select @rowguid61 as rowguid, @metadata_type61 as metadata_type, @lineage_old61 as lineage_old, @lineage_new61 as lineage_new, @generation61 as generation  union all 
    select @rowguid62 as rowguid, @metadata_type62 as metadata_type, @lineage_old62 as lineage_old, @lineage_new62 as lineage_new, @generation62 as generation  union all 
    select @rowguid63 as rowguid, @metadata_type63 as metadata_type, @lineage_old63 as lineage_old, @lineage_new63 as lineage_new, @generation63 as generation  union all 
    select @rowguid64 as rowguid, @metadata_type64 as metadata_type, @lineage_old64 as lineage_old, @lineage_new64 as lineage_new, @generation64 as generation  union all 
    select @rowguid65 as rowguid, @metadata_type65 as metadata_type, @lineage_old65 as lineage_old, @lineage_new65 as lineage_new, @generation65 as generation  union all 
    select @rowguid66 as rowguid, @metadata_type66 as metadata_type, @lineage_old66 as lineage_old, @lineage_new66 as lineage_new, @generation66 as generation  union all 
    select @rowguid67 as rowguid, @metadata_type67 as metadata_type, @lineage_old67 as lineage_old, @lineage_new67 as lineage_new, @generation67 as generation  union all 
    select @rowguid68 as rowguid, @metadata_type68 as metadata_type, @lineage_old68 as lineage_old, @lineage_new68 as lineage_new, @generation68 as generation  union all 
    select @rowguid69 as rowguid, @metadata_type69 as metadata_type, @lineage_old69 as lineage_old, @lineage_new69 as lineage_new, @generation69 as generation  union all 
    select @rowguid70 as rowguid, @metadata_type70 as metadata_type, @lineage_old70 as lineage_old, @lineage_new70 as lineage_new, @generation70 as generation 
 union all 
    select @rowguid71 as rowguid, @metadata_type71 as metadata_type, @lineage_old71 as lineage_old, @lineage_new71 as lineage_new, @generation71 as generation  union all 
    select @rowguid72 as rowguid, @metadata_type72 as metadata_type, @lineage_old72 as lineage_old, @lineage_new72 as lineage_new, @generation72 as generation  union all 
    select @rowguid73 as rowguid, @metadata_type73 as metadata_type, @lineage_old73 as lineage_old, @lineage_new73 as lineage_new, @generation73 as generation  union all 
    select @rowguid74 as rowguid, @metadata_type74 as metadata_type, @lineage_old74 as lineage_old, @lineage_new74 as lineage_new, @generation74 as generation  union all 
    select @rowguid75 as rowguid, @metadata_type75 as metadata_type, @lineage_old75 as lineage_old, @lineage_new75 as lineage_new, @generation75 as generation  union all 
    select @rowguid76 as rowguid, @metadata_type76 as metadata_type, @lineage_old76 as lineage_old, @lineage_new76 as lineage_new, @generation76 as generation  union all 
    select @rowguid77 as rowguid, @metadata_type77 as metadata_type, @lineage_old77 as lineage_old, @lineage_new77 as lineage_new, @generation77 as generation  union all 
    select @rowguid78 as rowguid, @metadata_type78 as metadata_type, @lineage_old78 as lineage_old, @lineage_new78 as lineage_new, @generation78 as generation  union all 
    select @rowguid79 as rowguid, @metadata_type79 as metadata_type, @lineage_old79 as lineage_old, @lineage_new79 as lineage_new, @generation79 as generation  union all 
    select @rowguid80 as rowguid, @metadata_type80 as metadata_type, @lineage_old80 as lineage_old, @lineage_new80 as lineage_new, @generation80 as generation 
 union all 
    select @rowguid81 as rowguid, @metadata_type81 as metadata_type, @lineage_old81 as lineage_old, @lineage_new81 as lineage_new, @generation81 as generation  union all 
    select @rowguid82 as rowguid, @metadata_type82 as metadata_type, @lineage_old82 as lineage_old, @lineage_new82 as lineage_new, @generation82 as generation  union all 
    select @rowguid83 as rowguid, @metadata_type83 as metadata_type, @lineage_old83 as lineage_old, @lineage_new83 as lineage_new, @generation83 as generation  union all 
    select @rowguid84 as rowguid, @metadata_type84 as metadata_type, @lineage_old84 as lineage_old, @lineage_new84 as lineage_new, @generation84 as generation  union all 
    select @rowguid85 as rowguid, @metadata_type85 as metadata_type, @lineage_old85 as lineage_old, @lineage_new85 as lineage_new, @generation85 as generation  union all 
    select @rowguid86 as rowguid, @metadata_type86 as metadata_type, @lineage_old86 as lineage_old, @lineage_new86 as lineage_new, @generation86 as generation  union all 
    select @rowguid87 as rowguid, @metadata_type87 as metadata_type, @lineage_old87 as lineage_old, @lineage_new87 as lineage_new, @generation87 as generation  union all 
    select @rowguid88 as rowguid, @metadata_type88 as metadata_type, @lineage_old88 as lineage_old, @lineage_new88 as lineage_new, @generation88 as generation  union all 
    select @rowguid89 as rowguid, @metadata_type89 as metadata_type, @lineage_old89 as lineage_old, @lineage_new89 as lineage_new, @generation89 as generation  union all 
    select @rowguid90 as rowguid, @metadata_type90 as metadata_type, @lineage_old90 as lineage_old, @lineage_new90 as lineage_new, @generation90 as generation 
 union all 
    select @rowguid91 as rowguid, @metadata_type91 as metadata_type, @lineage_old91 as lineage_old, @lineage_new91 as lineage_new, @generation91 as generation  union all 
    select @rowguid92 as rowguid, @metadata_type92 as metadata_type, @lineage_old92 as lineage_old, @lineage_new92 as lineage_new, @generation92 as generation  union all 
    select @rowguid93 as rowguid, @metadata_type93 as metadata_type, @lineage_old93 as lineage_old, @lineage_new93 as lineage_new, @generation93 as generation  union all 
    select @rowguid94 as rowguid, @metadata_type94 as metadata_type, @lineage_old94 as lineage_old, @lineage_new94 as lineage_new, @generation94 as generation  union all 
    select @rowguid95 as rowguid, @metadata_type95 as metadata_type, @lineage_old95 as lineage_old, @lineage_new95 as lineage_new, @generation95 as generation  union all 
    select @rowguid96 as rowguid, @metadata_type96 as metadata_type, @lineage_old96 as lineage_old, @lineage_new96 as lineage_new, @generation96 as generation  union all 
    select @rowguid97 as rowguid, @metadata_type97 as metadata_type, @lineage_old97 as lineage_old, @lineage_new97 as lineage_new, @generation97 as generation  union all 
    select @rowguid98 as rowguid, @metadata_type98 as metadata_type, @lineage_old98 as lineage_old, @lineage_new98 as lineage_new, @generation98 as generation  union all 
    select @rowguid99 as rowguid, @metadata_type99 as metadata_type, @lineage_old99 as lineage_old, @lineage_new99 as lineage_new, @generation99 as generation  union all 
    select @rowguid100 as rowguid, @metadata_type100 as metadata_type, @lineage_old100 as lineage_old, @lineage_new100 as lineage_new, @generation100 as generation 

    ) as rows
    inner join dbo.MSmerge_tombstone tomb with (rowlock) 
    on tomb.rowguid = rows.rowguid and tomb.tablenick = 57128000
    and rows.rowguid is not null
    and rows.lineage_new is not NULL
    option (force order, loop join)
    select @tomb_rows_updated = @@rowcount, @error = @@error
    if @error<>0
        goto Failure

        -- the trigger would have inserted a row in past partition mapping for the currently deleted
        -- row. We need to update that row with the current generation if it exists
        update dbo.MSmerge_past_partition_mappings with (rowlock)
        set generation = rows.generation
    from
    (

    select @rowguid1 as rowguid, @metadata_type1 as metadata_type, @lineage_old1 as lineage_old, @lineage_new1 as lineage_new, @generation1 as generation  union all 
    select @rowguid2 as rowguid, @metadata_type2 as metadata_type, @lineage_old2 as lineage_old, @lineage_new2 as lineage_new, @generation2 as generation  union all 
    select @rowguid3 as rowguid, @metadata_type3 as metadata_type, @lineage_old3 as lineage_old, @lineage_new3 as lineage_new, @generation3 as generation  union all 
    select @rowguid4 as rowguid, @metadata_type4 as metadata_type, @lineage_old4 as lineage_old, @lineage_new4 as lineage_new, @generation4 as generation  union all 
    select @rowguid5 as rowguid, @metadata_type5 as metadata_type, @lineage_old5 as lineage_old, @lineage_new5 as lineage_new, @generation5 as generation  union all 
    select @rowguid6 as rowguid, @metadata_type6 as metadata_type, @lineage_old6 as lineage_old, @lineage_new6 as lineage_new, @generation6 as generation  union all 
    select @rowguid7 as rowguid, @metadata_type7 as metadata_type, @lineage_old7 as lineage_old, @lineage_new7 as lineage_new, @generation7 as generation  union all 
    select @rowguid8 as rowguid, @metadata_type8 as metadata_type, @lineage_old8 as lineage_old, @lineage_new8 as lineage_new, @generation8 as generation  union all 
    select @rowguid9 as rowguid, @metadata_type9 as metadata_type, @lineage_old9 as lineage_old, @lineage_new9 as lineage_new, @generation9 as generation  union all 
    select @rowguid10 as rowguid, @metadata_type10 as metadata_type, @lineage_old10 as lineage_old, @lineage_new10 as lineage_new, @generation10 as generation 
 union all 
    select @rowguid11 as rowguid, @metadata_type11 as metadata_type, @lineage_old11 as lineage_old, @lineage_new11 as lineage_new, @generation11 as generation  union all 
    select @rowguid12 as rowguid, @metadata_type12 as metadata_type, @lineage_old12 as lineage_old, @lineage_new12 as lineage_new, @generation12 as generation  union all 
    select @rowguid13 as rowguid, @metadata_type13 as metadata_type, @lineage_old13 as lineage_old, @lineage_new13 as lineage_new, @generation13 as generation  union all 
    select @rowguid14 as rowguid, @metadata_type14 as metadata_type, @lineage_old14 as lineage_old, @lineage_new14 as lineage_new, @generation14 as generation  union all 
    select @rowguid15 as rowguid, @metadata_type15 as metadata_type, @lineage_old15 as lineage_old, @lineage_new15 as lineage_new, @generation15 as generation  union all 
    select @rowguid16 as rowguid, @metadata_type16 as metadata_type, @lineage_old16 as lineage_old, @lineage_new16 as lineage_new, @generation16 as generation  union all 
    select @rowguid17 as rowguid, @metadata_type17 as metadata_type, @lineage_old17 as lineage_old, @lineage_new17 as lineage_new, @generation17 as generation  union all 
    select @rowguid18 as rowguid, @metadata_type18 as metadata_type, @lineage_old18 as lineage_old, @lineage_new18 as lineage_new, @generation18 as generation  union all 
    select @rowguid19 as rowguid, @metadata_type19 as metadata_type, @lineage_old19 as lineage_old, @lineage_new19 as lineage_new, @generation19 as generation  union all 
    select @rowguid20 as rowguid, @metadata_type20 as metadata_type, @lineage_old20 as lineage_old, @lineage_new20 as lineage_new, @generation20 as generation 
 union all 
    select @rowguid21 as rowguid, @metadata_type21 as metadata_type, @lineage_old21 as lineage_old, @lineage_new21 as lineage_new, @generation21 as generation  union all 
    select @rowguid22 as rowguid, @metadata_type22 as metadata_type, @lineage_old22 as lineage_old, @lineage_new22 as lineage_new, @generation22 as generation  union all 
    select @rowguid23 as rowguid, @metadata_type23 as metadata_type, @lineage_old23 as lineage_old, @lineage_new23 as lineage_new, @generation23 as generation  union all 
    select @rowguid24 as rowguid, @metadata_type24 as metadata_type, @lineage_old24 as lineage_old, @lineage_new24 as lineage_new, @generation24 as generation  union all 
    select @rowguid25 as rowguid, @metadata_type25 as metadata_type, @lineage_old25 as lineage_old, @lineage_new25 as lineage_new, @generation25 as generation  union all 
    select @rowguid26 as rowguid, @metadata_type26 as metadata_type, @lineage_old26 as lineage_old, @lineage_new26 as lineage_new, @generation26 as generation  union all 
    select @rowguid27 as rowguid, @metadata_type27 as metadata_type, @lineage_old27 as lineage_old, @lineage_new27 as lineage_new, @generation27 as generation  union all 
    select @rowguid28 as rowguid, @metadata_type28 as metadata_type, @lineage_old28 as lineage_old, @lineage_new28 as lineage_new, @generation28 as generation  union all 
    select @rowguid29 as rowguid, @metadata_type29 as metadata_type, @lineage_old29 as lineage_old, @lineage_new29 as lineage_new, @generation29 as generation  union all 
    select @rowguid30 as rowguid, @metadata_type30 as metadata_type, @lineage_old30 as lineage_old, @lineage_new30 as lineage_new, @generation30 as generation 
 union all 
    select @rowguid31 as rowguid, @metadata_type31 as metadata_type, @lineage_old31 as lineage_old, @lineage_new31 as lineage_new, @generation31 as generation  union all 
    select @rowguid32 as rowguid, @metadata_type32 as metadata_type, @lineage_old32 as lineage_old, @lineage_new32 as lineage_new, @generation32 as generation  union all 
    select @rowguid33 as rowguid, @metadata_type33 as metadata_type, @lineage_old33 as lineage_old, @lineage_new33 as lineage_new, @generation33 as generation  union all 
    select @rowguid34 as rowguid, @metadata_type34 as metadata_type, @lineage_old34 as lineage_old, @lineage_new34 as lineage_new, @generation34 as generation  union all 
    select @rowguid35 as rowguid, @metadata_type35 as metadata_type, @lineage_old35 as lineage_old, @lineage_new35 as lineage_new, @generation35 as generation  union all 
    select @rowguid36 as rowguid, @metadata_type36 as metadata_type, @lineage_old36 as lineage_old, @lineage_new36 as lineage_new, @generation36 as generation  union all 
    select @rowguid37 as rowguid, @metadata_type37 as metadata_type, @lineage_old37 as lineage_old, @lineage_new37 as lineage_new, @generation37 as generation  union all 
    select @rowguid38 as rowguid, @metadata_type38 as metadata_type, @lineage_old38 as lineage_old, @lineage_new38 as lineage_new, @generation38 as generation  union all 
    select @rowguid39 as rowguid, @metadata_type39 as metadata_type, @lineage_old39 as lineage_old, @lineage_new39 as lineage_new, @generation39 as generation  union all 
    select @rowguid40 as rowguid, @metadata_type40 as metadata_type, @lineage_old40 as lineage_old, @lineage_new40 as lineage_new, @generation40 as generation 
 union all 
    select @rowguid41 as rowguid, @metadata_type41 as metadata_type, @lineage_old41 as lineage_old, @lineage_new41 as lineage_new, @generation41 as generation  union all 
    select @rowguid42 as rowguid, @metadata_type42 as metadata_type, @lineage_old42 as lineage_old, @lineage_new42 as lineage_new, @generation42 as generation  union all 
    select @rowguid43 as rowguid, @metadata_type43 as metadata_type, @lineage_old43 as lineage_old, @lineage_new43 as lineage_new, @generation43 as generation  union all 
    select @rowguid44 as rowguid, @metadata_type44 as metadata_type, @lineage_old44 as lineage_old, @lineage_new44 as lineage_new, @generation44 as generation  union all 
    select @rowguid45 as rowguid, @metadata_type45 as metadata_type, @lineage_old45 as lineage_old, @lineage_new45 as lineage_new, @generation45 as generation  union all 
    select @rowguid46 as rowguid, @metadata_type46 as metadata_type, @lineage_old46 as lineage_old, @lineage_new46 as lineage_new, @generation46 as generation  union all 
    select @rowguid47 as rowguid, @metadata_type47 as metadata_type, @lineage_old47 as lineage_old, @lineage_new47 as lineage_new, @generation47 as generation  union all 
    select @rowguid48 as rowguid, @metadata_type48 as metadata_type, @lineage_old48 as lineage_old, @lineage_new48 as lineage_new, @generation48 as generation  union all 
    select @rowguid49 as rowguid, @metadata_type49 as metadata_type, @lineage_old49 as lineage_old, @lineage_new49 as lineage_new, @generation49 as generation  union all 
    select @rowguid50 as rowguid, @metadata_type50 as metadata_type, @lineage_old50 as lineage_old, @lineage_new50 as lineage_new, @generation50 as generation 
 union all 
    select @rowguid51 as rowguid, @metadata_type51 as metadata_type, @lineage_old51 as lineage_old, @lineage_new51 as lineage_new, @generation51 as generation  union all 
    select @rowguid52 as rowguid, @metadata_type52 as metadata_type, @lineage_old52 as lineage_old, @lineage_new52 as lineage_new, @generation52 as generation  union all 
    select @rowguid53 as rowguid, @metadata_type53 as metadata_type, @lineage_old53 as lineage_old, @lineage_new53 as lineage_new, @generation53 as generation  union all 
    select @rowguid54 as rowguid, @metadata_type54 as metadata_type, @lineage_old54 as lineage_old, @lineage_new54 as lineage_new, @generation54 as generation  union all 
    select @rowguid55 as rowguid, @metadata_type55 as metadata_type, @lineage_old55 as lineage_old, @lineage_new55 as lineage_new, @generation55 as generation  union all 
    select @rowguid56 as rowguid, @metadata_type56 as metadata_type, @lineage_old56 as lineage_old, @lineage_new56 as lineage_new, @generation56 as generation  union all 
    select @rowguid57 as rowguid, @metadata_type57 as metadata_type, @lineage_old57 as lineage_old, @lineage_new57 as lineage_new, @generation57 as generation  union all 
    select @rowguid58 as rowguid, @metadata_type58 as metadata_type, @lineage_old58 as lineage_old, @lineage_new58 as lineage_new, @generation58 as generation  union all 
    select @rowguid59 as rowguid, @metadata_type59 as metadata_type, @lineage_old59 as lineage_old, @lineage_new59 as lineage_new, @generation59 as generation  union all 
    select @rowguid60 as rowguid, @metadata_type60 as metadata_type, @lineage_old60 as lineage_old, @lineage_new60 as lineage_new, @generation60 as generation 
 union all 
    select @rowguid61 as rowguid, @metadata_type61 as metadata_type, @lineage_old61 as lineage_old, @lineage_new61 as lineage_new, @generation61 as generation  union all 
    select @rowguid62 as rowguid, @metadata_type62 as metadata_type, @lineage_old62 as lineage_old, @lineage_new62 as lineage_new, @generation62 as generation  union all 
    select @rowguid63 as rowguid, @metadata_type63 as metadata_type, @lineage_old63 as lineage_old, @lineage_new63 as lineage_new, @generation63 as generation  union all 
    select @rowguid64 as rowguid, @metadata_type64 as metadata_type, @lineage_old64 as lineage_old, @lineage_new64 as lineage_new, @generation64 as generation  union all 
    select @rowguid65 as rowguid, @metadata_type65 as metadata_type, @lineage_old65 as lineage_old, @lineage_new65 as lineage_new, @generation65 as generation  union all 
    select @rowguid66 as rowguid, @metadata_type66 as metadata_type, @lineage_old66 as lineage_old, @lineage_new66 as lineage_new, @generation66 as generation  union all 
    select @rowguid67 as rowguid, @metadata_type67 as metadata_type, @lineage_old67 as lineage_old, @lineage_new67 as lineage_new, @generation67 as generation  union all 
    select @rowguid68 as rowguid, @metadata_type68 as metadata_type, @lineage_old68 as lineage_old, @lineage_new68 as lineage_new, @generation68 as generation  union all 
    select @rowguid69 as rowguid, @metadata_type69 as metadata_type, @lineage_old69 as lineage_old, @lineage_new69 as lineage_new, @generation69 as generation  union all 
    select @rowguid70 as rowguid, @metadata_type70 as metadata_type, @lineage_old70 as lineage_old, @lineage_new70 as lineage_new, @generation70 as generation 
 union all 
    select @rowguid71 as rowguid, @metadata_type71 as metadata_type, @lineage_old71 as lineage_old, @lineage_new71 as lineage_new, @generation71 as generation  union all 
    select @rowguid72 as rowguid, @metadata_type72 as metadata_type, @lineage_old72 as lineage_old, @lineage_new72 as lineage_new, @generation72 as generation  union all 
    select @rowguid73 as rowguid, @metadata_type73 as metadata_type, @lineage_old73 as lineage_old, @lineage_new73 as lineage_new, @generation73 as generation  union all 
    select @rowguid74 as rowguid, @metadata_type74 as metadata_type, @lineage_old74 as lineage_old, @lineage_new74 as lineage_new, @generation74 as generation  union all 
    select @rowguid75 as rowguid, @metadata_type75 as metadata_type, @lineage_old75 as lineage_old, @lineage_new75 as lineage_new, @generation75 as generation  union all 
    select @rowguid76 as rowguid, @metadata_type76 as metadata_type, @lineage_old76 as lineage_old, @lineage_new76 as lineage_new, @generation76 as generation  union all 
    select @rowguid77 as rowguid, @metadata_type77 as metadata_type, @lineage_old77 as lineage_old, @lineage_new77 as lineage_new, @generation77 as generation  union all 
    select @rowguid78 as rowguid, @metadata_type78 as metadata_type, @lineage_old78 as lineage_old, @lineage_new78 as lineage_new, @generation78 as generation  union all 
    select @rowguid79 as rowguid, @metadata_type79 as metadata_type, @lineage_old79 as lineage_old, @lineage_new79 as lineage_new, @generation79 as generation  union all 
    select @rowguid80 as rowguid, @metadata_type80 as metadata_type, @lineage_old80 as lineage_old, @lineage_new80 as lineage_new, @generation80 as generation 
 union all 
    select @rowguid81 as rowguid, @metadata_type81 as metadata_type, @lineage_old81 as lineage_old, @lineage_new81 as lineage_new, @generation81 as generation  union all 
    select @rowguid82 as rowguid, @metadata_type82 as metadata_type, @lineage_old82 as lineage_old, @lineage_new82 as lineage_new, @generation82 as generation  union all 
    select @rowguid83 as rowguid, @metadata_type83 as metadata_type, @lineage_old83 as lineage_old, @lineage_new83 as lineage_new, @generation83 as generation  union all 
    select @rowguid84 as rowguid, @metadata_type84 as metadata_type, @lineage_old84 as lineage_old, @lineage_new84 as lineage_new, @generation84 as generation  union all 
    select @rowguid85 as rowguid, @metadata_type85 as metadata_type, @lineage_old85 as lineage_old, @lineage_new85 as lineage_new, @generation85 as generation  union all 
    select @rowguid86 as rowguid, @metadata_type86 as metadata_type, @lineage_old86 as lineage_old, @lineage_new86 as lineage_new, @generation86 as generation  union all 
    select @rowguid87 as rowguid, @metadata_type87 as metadata_type, @lineage_old87 as lineage_old, @lineage_new87 as lineage_new, @generation87 as generation  union all 
    select @rowguid88 as rowguid, @metadata_type88 as metadata_type, @lineage_old88 as lineage_old, @lineage_new88 as lineage_new, @generation88 as generation  union all 
    select @rowguid89 as rowguid, @metadata_type89 as metadata_type, @lineage_old89 as lineage_old, @lineage_new89 as lineage_new, @generation89 as generation  union all 
    select @rowguid90 as rowguid, @metadata_type90 as metadata_type, @lineage_old90 as lineage_old, @lineage_new90 as lineage_new, @generation90 as generation 
 union all 
    select @rowguid91 as rowguid, @metadata_type91 as metadata_type, @lineage_old91 as lineage_old, @lineage_new91 as lineage_new, @generation91 as generation  union all 
    select @rowguid92 as rowguid, @metadata_type92 as metadata_type, @lineage_old92 as lineage_old, @lineage_new92 as lineage_new, @generation92 as generation  union all 
    select @rowguid93 as rowguid, @metadata_type93 as metadata_type, @lineage_old93 as lineage_old, @lineage_new93 as lineage_new, @generation93 as generation  union all 
    select @rowguid94 as rowguid, @metadata_type94 as metadata_type, @lineage_old94 as lineage_old, @lineage_new94 as lineage_new, @generation94 as generation  union all 
    select @rowguid95 as rowguid, @metadata_type95 as metadata_type, @lineage_old95 as lineage_old, @lineage_new95 as lineage_new, @generation95 as generation  union all 
    select @rowguid96 as rowguid, @metadata_type96 as metadata_type, @lineage_old96 as lineage_old, @lineage_new96 as lineage_new, @generation96 as generation  union all 
    select @rowguid97 as rowguid, @metadata_type97 as metadata_type, @lineage_old97 as lineage_old, @lineage_new97 as lineage_new, @generation97 as generation  union all 
    select @rowguid98 as rowguid, @metadata_type98 as metadata_type, @lineage_old98 as lineage_old, @lineage_new98 as lineage_new, @generation98 as generation  union all 
    select @rowguid99 as rowguid, @metadata_type99 as metadata_type, @lineage_old99 as lineage_old, @lineage_new99 as lineage_new, @generation99 as generation  union all 
    select @rowguid100 as rowguid, @metadata_type100 as metadata_type, @lineage_old100 as lineage_old, @lineage_new100 as lineage_new, @generation100 as generation 

        ) as rows
        inner join dbo.MSmerge_past_partition_mappings ppm with (rowlock) 
        on ppm.rowguid = rows.rowguid and ppm.tablenick = 57128000 
        and ppm.generation = 0
        and rows.rowguid is not NULL
        and rows.lineage_new is not null
        option (force order, loop join)
        if @error<>0
                goto Failure

    if @tomb_rows_updated <> @rowstobedeleted
    begin
        -- now insert rows that are not in tombstone
        insert into dbo.MSmerge_tombstone with (rowlock)
            (rowguid, tablenick, type, generation, lineage)
        select rows.rowguid, 57128000, 
               case when (rows.metadata_type=5 or rows.metadata_type=6) then rows.metadata_type else 1 end, 
               rows.generation, rows.lineage_new
        from 
        (

    select @rowguid1 as rowguid, @metadata_type1 as metadata_type, @lineage_old1 as lineage_old, @lineage_new1 as lineage_new, @generation1 as generation  union all 
    select @rowguid2 as rowguid, @metadata_type2 as metadata_type, @lineage_old2 as lineage_old, @lineage_new2 as lineage_new, @generation2 as generation  union all 
    select @rowguid3 as rowguid, @metadata_type3 as metadata_type, @lineage_old3 as lineage_old, @lineage_new3 as lineage_new, @generation3 as generation  union all 
    select @rowguid4 as rowguid, @metadata_type4 as metadata_type, @lineage_old4 as lineage_old, @lineage_new4 as lineage_new, @generation4 as generation  union all 
    select @rowguid5 as rowguid, @metadata_type5 as metadata_type, @lineage_old5 as lineage_old, @lineage_new5 as lineage_new, @generation5 as generation  union all 
    select @rowguid6 as rowguid, @metadata_type6 as metadata_type, @lineage_old6 as lineage_old, @lineage_new6 as lineage_new, @generation6 as generation  union all 
    select @rowguid7 as rowguid, @metadata_type7 as metadata_type, @lineage_old7 as lineage_old, @lineage_new7 as lineage_new, @generation7 as generation  union all 
    select @rowguid8 as rowguid, @metadata_type8 as metadata_type, @lineage_old8 as lineage_old, @lineage_new8 as lineage_new, @generation8 as generation  union all 
    select @rowguid9 as rowguid, @metadata_type9 as metadata_type, @lineage_old9 as lineage_old, @lineage_new9 as lineage_new, @generation9 as generation  union all 
    select @rowguid10 as rowguid, @metadata_type10 as metadata_type, @lineage_old10 as lineage_old, @lineage_new10 as lineage_new, @generation10 as generation 
 union all 
    select @rowguid11 as rowguid, @metadata_type11 as metadata_type, @lineage_old11 as lineage_old, @lineage_new11 as lineage_new, @generation11 as generation  union all 
    select @rowguid12 as rowguid, @metadata_type12 as metadata_type, @lineage_old12 as lineage_old, @lineage_new12 as lineage_new, @generation12 as generation  union all 
    select @rowguid13 as rowguid, @metadata_type13 as metadata_type, @lineage_old13 as lineage_old, @lineage_new13 as lineage_new, @generation13 as generation  union all 
    select @rowguid14 as rowguid, @metadata_type14 as metadata_type, @lineage_old14 as lineage_old, @lineage_new14 as lineage_new, @generation14 as generation  union all 
    select @rowguid15 as rowguid, @metadata_type15 as metadata_type, @lineage_old15 as lineage_old, @lineage_new15 as lineage_new, @generation15 as generation  union all 
    select @rowguid16 as rowguid, @metadata_type16 as metadata_type, @lineage_old16 as lineage_old, @lineage_new16 as lineage_new, @generation16 as generation  union all 
    select @rowguid17 as rowguid, @metadata_type17 as metadata_type, @lineage_old17 as lineage_old, @lineage_new17 as lineage_new, @generation17 as generation  union all 
    select @rowguid18 as rowguid, @metadata_type18 as metadata_type, @lineage_old18 as lineage_old, @lineage_new18 as lineage_new, @generation18 as generation  union all 
    select @rowguid19 as rowguid, @metadata_type19 as metadata_type, @lineage_old19 as lineage_old, @lineage_new19 as lineage_new, @generation19 as generation  union all 
    select @rowguid20 as rowguid, @metadata_type20 as metadata_type, @lineage_old20 as lineage_old, @lineage_new20 as lineage_new, @generation20 as generation 
 union all 
    select @rowguid21 as rowguid, @metadata_type21 as metadata_type, @lineage_old21 as lineage_old, @lineage_new21 as lineage_new, @generation21 as generation  union all 
    select @rowguid22 as rowguid, @metadata_type22 as metadata_type, @lineage_old22 as lineage_old, @lineage_new22 as lineage_new, @generation22 as generation  union all 
    select @rowguid23 as rowguid, @metadata_type23 as metadata_type, @lineage_old23 as lineage_old, @lineage_new23 as lineage_new, @generation23 as generation  union all 
    select @rowguid24 as rowguid, @metadata_type24 as metadata_type, @lineage_old24 as lineage_old, @lineage_new24 as lineage_new, @generation24 as generation  union all 
    select @rowguid25 as rowguid, @metadata_type25 as metadata_type, @lineage_old25 as lineage_old, @lineage_new25 as lineage_new, @generation25 as generation  union all 
    select @rowguid26 as rowguid, @metadata_type26 as metadata_type, @lineage_old26 as lineage_old, @lineage_new26 as lineage_new, @generation26 as generation  union all 
    select @rowguid27 as rowguid, @metadata_type27 as metadata_type, @lineage_old27 as lineage_old, @lineage_new27 as lineage_new, @generation27 as generation  union all 
    select @rowguid28 as rowguid, @metadata_type28 as metadata_type, @lineage_old28 as lineage_old, @lineage_new28 as lineage_new, @generation28 as generation  union all 
    select @rowguid29 as rowguid, @metadata_type29 as metadata_type, @lineage_old29 as lineage_old, @lineage_new29 as lineage_new, @generation29 as generation  union all 
    select @rowguid30 as rowguid, @metadata_type30 as metadata_type, @lineage_old30 as lineage_old, @lineage_new30 as lineage_new, @generation30 as generation 
 union all 
    select @rowguid31 as rowguid, @metadata_type31 as metadata_type, @lineage_old31 as lineage_old, @lineage_new31 as lineage_new, @generation31 as generation  union all 
    select @rowguid32 as rowguid, @metadata_type32 as metadata_type, @lineage_old32 as lineage_old, @lineage_new32 as lineage_new, @generation32 as generation  union all 
    select @rowguid33 as rowguid, @metadata_type33 as metadata_type, @lineage_old33 as lineage_old, @lineage_new33 as lineage_new, @generation33 as generation  union all 
    select @rowguid34 as rowguid, @metadata_type34 as metadata_type, @lineage_old34 as lineage_old, @lineage_new34 as lineage_new, @generation34 as generation  union all 
    select @rowguid35 as rowguid, @metadata_type35 as metadata_type, @lineage_old35 as lineage_old, @lineage_new35 as lineage_new, @generation35 as generation  union all 
    select @rowguid36 as rowguid, @metadata_type36 as metadata_type, @lineage_old36 as lineage_old, @lineage_new36 as lineage_new, @generation36 as generation  union all 
    select @rowguid37 as rowguid, @metadata_type37 as metadata_type, @lineage_old37 as lineage_old, @lineage_new37 as lineage_new, @generation37 as generation  union all 
    select @rowguid38 as rowguid, @metadata_type38 as metadata_type, @lineage_old38 as lineage_old, @lineage_new38 as lineage_new, @generation38 as generation  union all 
    select @rowguid39 as rowguid, @metadata_type39 as metadata_type, @lineage_old39 as lineage_old, @lineage_new39 as lineage_new, @generation39 as generation  union all 
    select @rowguid40 as rowguid, @metadata_type40 as metadata_type, @lineage_old40 as lineage_old, @lineage_new40 as lineage_new, @generation40 as generation 
 union all 
    select @rowguid41 as rowguid, @metadata_type41 as metadata_type, @lineage_old41 as lineage_old, @lineage_new41 as lineage_new, @generation41 as generation  union all 
    select @rowguid42 as rowguid, @metadata_type42 as metadata_type, @lineage_old42 as lineage_old, @lineage_new42 as lineage_new, @generation42 as generation  union all 
    select @rowguid43 as rowguid, @metadata_type43 as metadata_type, @lineage_old43 as lineage_old, @lineage_new43 as lineage_new, @generation43 as generation  union all 
    select @rowguid44 as rowguid, @metadata_type44 as metadata_type, @lineage_old44 as lineage_old, @lineage_new44 as lineage_new, @generation44 as generation  union all 
    select @rowguid45 as rowguid, @metadata_type45 as metadata_type, @lineage_old45 as lineage_old, @lineage_new45 as lineage_new, @generation45 as generation  union all 
    select @rowguid46 as rowguid, @metadata_type46 as metadata_type, @lineage_old46 as lineage_old, @lineage_new46 as lineage_new, @generation46 as generation  union all 
    select @rowguid47 as rowguid, @metadata_type47 as metadata_type, @lineage_old47 as lineage_old, @lineage_new47 as lineage_new, @generation47 as generation  union all 
    select @rowguid48 as rowguid, @metadata_type48 as metadata_type, @lineage_old48 as lineage_old, @lineage_new48 as lineage_new, @generation48 as generation  union all 
    select @rowguid49 as rowguid, @metadata_type49 as metadata_type, @lineage_old49 as lineage_old, @lineage_new49 as lineage_new, @generation49 as generation  union all 
    select @rowguid50 as rowguid, @metadata_type50 as metadata_type, @lineage_old50 as lineage_old, @lineage_new50 as lineage_new, @generation50 as generation 
 union all 
    select @rowguid51 as rowguid, @metadata_type51 as metadata_type, @lineage_old51 as lineage_old, @lineage_new51 as lineage_new, @generation51 as generation  union all 
    select @rowguid52 as rowguid, @metadata_type52 as metadata_type, @lineage_old52 as lineage_old, @lineage_new52 as lineage_new, @generation52 as generation  union all 
    select @rowguid53 as rowguid, @metadata_type53 as metadata_type, @lineage_old53 as lineage_old, @lineage_new53 as lineage_new, @generation53 as generation  union all 
    select @rowguid54 as rowguid, @metadata_type54 as metadata_type, @lineage_old54 as lineage_old, @lineage_new54 as lineage_new, @generation54 as generation  union all 
    select @rowguid55 as rowguid, @metadata_type55 as metadata_type, @lineage_old55 as lineage_old, @lineage_new55 as lineage_new, @generation55 as generation  union all 
    select @rowguid56 as rowguid, @metadata_type56 as metadata_type, @lineage_old56 as lineage_old, @lineage_new56 as lineage_new, @generation56 as generation  union all 
    select @rowguid57 as rowguid, @metadata_type57 as metadata_type, @lineage_old57 as lineage_old, @lineage_new57 as lineage_new, @generation57 as generation  union all 
    select @rowguid58 as rowguid, @metadata_type58 as metadata_type, @lineage_old58 as lineage_old, @lineage_new58 as lineage_new, @generation58 as generation  union all 
    select @rowguid59 as rowguid, @metadata_type59 as metadata_type, @lineage_old59 as lineage_old, @lineage_new59 as lineage_new, @generation59 as generation  union all 
    select @rowguid60 as rowguid, @metadata_type60 as metadata_type, @lineage_old60 as lineage_old, @lineage_new60 as lineage_new, @generation60 as generation 
 union all 
    select @rowguid61 as rowguid, @metadata_type61 as metadata_type, @lineage_old61 as lineage_old, @lineage_new61 as lineage_new, @generation61 as generation  union all 
    select @rowguid62 as rowguid, @metadata_type62 as metadata_type, @lineage_old62 as lineage_old, @lineage_new62 as lineage_new, @generation62 as generation  union all 
    select @rowguid63 as rowguid, @metadata_type63 as metadata_type, @lineage_old63 as lineage_old, @lineage_new63 as lineage_new, @generation63 as generation  union all 
    select @rowguid64 as rowguid, @metadata_type64 as metadata_type, @lineage_old64 as lineage_old, @lineage_new64 as lineage_new, @generation64 as generation  union all 
    select @rowguid65 as rowguid, @metadata_type65 as metadata_type, @lineage_old65 as lineage_old, @lineage_new65 as lineage_new, @generation65 as generation  union all 
    select @rowguid66 as rowguid, @metadata_type66 as metadata_type, @lineage_old66 as lineage_old, @lineage_new66 as lineage_new, @generation66 as generation  union all 
    select @rowguid67 as rowguid, @metadata_type67 as metadata_type, @lineage_old67 as lineage_old, @lineage_new67 as lineage_new, @generation67 as generation  union all 
    select @rowguid68 as rowguid, @metadata_type68 as metadata_type, @lineage_old68 as lineage_old, @lineage_new68 as lineage_new, @generation68 as generation  union all 
    select @rowguid69 as rowguid, @metadata_type69 as metadata_type, @lineage_old69 as lineage_old, @lineage_new69 as lineage_new, @generation69 as generation  union all 
    select @rowguid70 as rowguid, @metadata_type70 as metadata_type, @lineage_old70 as lineage_old, @lineage_new70 as lineage_new, @generation70 as generation 
 union all 
    select @rowguid71 as rowguid, @metadata_type71 as metadata_type, @lineage_old71 as lineage_old, @lineage_new71 as lineage_new, @generation71 as generation  union all 
    select @rowguid72 as rowguid, @metadata_type72 as metadata_type, @lineage_old72 as lineage_old, @lineage_new72 as lineage_new, @generation72 as generation  union all 
    select @rowguid73 as rowguid, @metadata_type73 as metadata_type, @lineage_old73 as lineage_old, @lineage_new73 as lineage_new, @generation73 as generation  union all 
    select @rowguid74 as rowguid, @metadata_type74 as metadata_type, @lineage_old74 as lineage_old, @lineage_new74 as lineage_new, @generation74 as generation  union all 
    select @rowguid75 as rowguid, @metadata_type75 as metadata_type, @lineage_old75 as lineage_old, @lineage_new75 as lineage_new, @generation75 as generation  union all 
    select @rowguid76 as rowguid, @metadata_type76 as metadata_type, @lineage_old76 as lineage_old, @lineage_new76 as lineage_new, @generation76 as generation  union all 
    select @rowguid77 as rowguid, @metadata_type77 as metadata_type, @lineage_old77 as lineage_old, @lineage_new77 as lineage_new, @generation77 as generation  union all 
    select @rowguid78 as rowguid, @metadata_type78 as metadata_type, @lineage_old78 as lineage_old, @lineage_new78 as lineage_new, @generation78 as generation  union all 
    select @rowguid79 as rowguid, @metadata_type79 as metadata_type, @lineage_old79 as lineage_old, @lineage_new79 as lineage_new, @generation79 as generation  union all 
    select @rowguid80 as rowguid, @metadata_type80 as metadata_type, @lineage_old80 as lineage_old, @lineage_new80 as lineage_new, @generation80 as generation 
 union all 
    select @rowguid81 as rowguid, @metadata_type81 as metadata_type, @lineage_old81 as lineage_old, @lineage_new81 as lineage_new, @generation81 as generation  union all 
    select @rowguid82 as rowguid, @metadata_type82 as metadata_type, @lineage_old82 as lineage_old, @lineage_new82 as lineage_new, @generation82 as generation  union all 
    select @rowguid83 as rowguid, @metadata_type83 as metadata_type, @lineage_old83 as lineage_old, @lineage_new83 as lineage_new, @generation83 as generation  union all 
    select @rowguid84 as rowguid, @metadata_type84 as metadata_type, @lineage_old84 as lineage_old, @lineage_new84 as lineage_new, @generation84 as generation  union all 
    select @rowguid85 as rowguid, @metadata_type85 as metadata_type, @lineage_old85 as lineage_old, @lineage_new85 as lineage_new, @generation85 as generation  union all 
    select @rowguid86 as rowguid, @metadata_type86 as metadata_type, @lineage_old86 as lineage_old, @lineage_new86 as lineage_new, @generation86 as generation  union all 
    select @rowguid87 as rowguid, @metadata_type87 as metadata_type, @lineage_old87 as lineage_old, @lineage_new87 as lineage_new, @generation87 as generation  union all 
    select @rowguid88 as rowguid, @metadata_type88 as metadata_type, @lineage_old88 as lineage_old, @lineage_new88 as lineage_new, @generation88 as generation  union all 
    select @rowguid89 as rowguid, @metadata_type89 as metadata_type, @lineage_old89 as lineage_old, @lineage_new89 as lineage_new, @generation89 as generation  union all 
    select @rowguid90 as rowguid, @metadata_type90 as metadata_type, @lineage_old90 as lineage_old, @lineage_new90 as lineage_new, @generation90 as generation 
 union all 
    select @rowguid91 as rowguid, @metadata_type91 as metadata_type, @lineage_old91 as lineage_old, @lineage_new91 as lineage_new, @generation91 as generation  union all 
    select @rowguid92 as rowguid, @metadata_type92 as metadata_type, @lineage_old92 as lineage_old, @lineage_new92 as lineage_new, @generation92 as generation  union all 
    select @rowguid93 as rowguid, @metadata_type93 as metadata_type, @lineage_old93 as lineage_old, @lineage_new93 as lineage_new, @generation93 as generation  union all 
    select @rowguid94 as rowguid, @metadata_type94 as metadata_type, @lineage_old94 as lineage_old, @lineage_new94 as lineage_new, @generation94 as generation  union all 
    select @rowguid95 as rowguid, @metadata_type95 as metadata_type, @lineage_old95 as lineage_old, @lineage_new95 as lineage_new, @generation95 as generation  union all 
    select @rowguid96 as rowguid, @metadata_type96 as metadata_type, @lineage_old96 as lineage_old, @lineage_new96 as lineage_new, @generation96 as generation  union all 
    select @rowguid97 as rowguid, @metadata_type97 as metadata_type, @lineage_old97 as lineage_old, @lineage_new97 as lineage_new, @generation97 as generation  union all 
    select @rowguid98 as rowguid, @metadata_type98 as metadata_type, @lineage_old98 as lineage_old, @lineage_new98 as lineage_new, @generation98 as generation  union all 
    select @rowguid99 as rowguid, @metadata_type99 as metadata_type, @lineage_old99 as lineage_old, @lineage_new99 as lineage_new, @generation99 as generation  union all 
    select @rowguid100 as rowguid, @metadata_type100 as metadata_type, @lineage_old100 as lineage_old, @lineage_new100 as lineage_new, @generation100 as generation 

        ) as rows
        left outer join dbo.MSmerge_tombstone tomb with (rowlock) 
        on tomb.rowguid = rows.rowguid 
        and tomb.tablenick = 57128000
        and rows.rowguid is not NULL and rows.lineage_new is not null
        where tomb.rowguid is NULL 
        and rows.rowguid is not NULL and rows.lineage_new is not null
        
        if @@error<>0
            goto Failure

        -- now delete the contents rows
        delete dbo.MSmerge_contents with (rowlock)
        from 
        (

         select @rowguid1 as rowguid union all 
         select @rowguid2 as rowguid union all 
         select @rowguid3 as rowguid union all 
         select @rowguid4 as rowguid union all 
         select @rowguid5 as rowguid union all 
         select @rowguid6 as rowguid union all 
         select @rowguid7 as rowguid union all 
         select @rowguid8 as rowguid union all 
         select @rowguid9 as rowguid union all 
         select @rowguid10 as rowguid union all 
         select @rowguid11 as rowguid union all 
         select @rowguid12 as rowguid union all 
         select @rowguid13 as rowguid union all 
         select @rowguid14 as rowguid union all 
         select @rowguid15 as rowguid union all 
         select @rowguid16 as rowguid union all 
         select @rowguid17 as rowguid union all 
         select @rowguid18 as rowguid union all 
         select @rowguid19 as rowguid union all 
         select @rowguid20 as rowguid union all 
         select @rowguid21 as rowguid union all 
         select @rowguid22 as rowguid union all 
         select @rowguid23 as rowguid union all 
         select @rowguid24 as rowguid union all 
         select @rowguid25 as rowguid union all 
         select @rowguid26 as rowguid union all 
         select @rowguid27 as rowguid union all 
         select @rowguid28 as rowguid union all 
         select @rowguid29 as rowguid union all 
         select @rowguid30 as rowguid union all 
         select @rowguid31 as rowguid union all 
         select @rowguid32 as rowguid union all 
         select @rowguid33 as rowguid union all 
         select @rowguid34 as rowguid union all 
         select @rowguid35 as rowguid union all 
         select @rowguid36 as rowguid union all 
         select @rowguid37 as rowguid union all 
         select @rowguid38 as rowguid union all 
         select @rowguid39 as rowguid union all 
         select @rowguid40 as rowguid union all 
         select @rowguid41 as rowguid union all 
         select @rowguid42 as rowguid union all 
         select @rowguid43 as rowguid union all 
         select @rowguid44 as rowguid union all 
         select @rowguid45 as rowguid union all 
         select @rowguid46 as rowguid union all 
         select @rowguid47 as rowguid union all 
         select @rowguid48 as rowguid union all 
         select @rowguid49 as rowguid union all 
         select @rowguid50 as rowguid union all

         select @rowguid51 as rowguid union all 
         select @rowguid52 as rowguid union all 
         select @rowguid53 as rowguid union all 
         select @rowguid54 as rowguid union all 
         select @rowguid55 as rowguid union all 
         select @rowguid56 as rowguid union all 
         select @rowguid57 as rowguid union all 
         select @rowguid58 as rowguid union all 
         select @rowguid59 as rowguid union all 
         select @rowguid60 as rowguid union all 
         select @rowguid61 as rowguid union all 
         select @rowguid62 as rowguid union all 
         select @rowguid63 as rowguid union all 
         select @rowguid64 as rowguid union all 
         select @rowguid65 as rowguid union all 
         select @rowguid66 as rowguid union all 
         select @rowguid67 as rowguid union all 
         select @rowguid68 as rowguid union all 
         select @rowguid69 as rowguid union all 
         select @rowguid70 as rowguid union all 
         select @rowguid71 as rowguid union all 
         select @rowguid72 as rowguid union all 
         select @rowguid73 as rowguid union all 
         select @rowguid74 as rowguid union all 
         select @rowguid75 as rowguid union all 
         select @rowguid76 as rowguid union all 
         select @rowguid77 as rowguid union all 
         select @rowguid78 as rowguid union all 
         select @rowguid79 as rowguid union all 
         select @rowguid80 as rowguid union all 
         select @rowguid81 as rowguid union all 
         select @rowguid82 as rowguid union all 
         select @rowguid83 as rowguid union all 
         select @rowguid84 as rowguid union all 
         select @rowguid85 as rowguid union all 
         select @rowguid86 as rowguid union all 
         select @rowguid87 as rowguid union all 
         select @rowguid88 as rowguid union all 
         select @rowguid89 as rowguid union all 
         select @rowguid90 as rowguid union all 
         select @rowguid91 as rowguid union all 
         select @rowguid92 as rowguid union all 
         select @rowguid93 as rowguid union all 
         select @rowguid94 as rowguid union all 
         select @rowguid95 as rowguid union all 
         select @rowguid96 as rowguid union all 
         select @rowguid97 as rowguid union all 
         select @rowguid98 as rowguid union all 
         select @rowguid99 as rowguid union all 
         select @rowguid100 as rowguid

        ) as rows, dbo.MSmerge_contents cont with (rowlock)
        where cont.rowguid = rows.rowguid and cont.tablenick = 57128000
            and rows.rowguid is not NULL
        option (force order, loop join)
        if @@error<>0 
            goto Failure
    end

    exec @retcode = sys.sp_MSdeletemetadataactionrequest 'AB1F05CE-CE24-415B-8771-7EDE0EFE1D98', 57128000, 
        @rowguid1, 
        @rowguid2, 
        @rowguid3, 
        @rowguid4, 
        @rowguid5, 
        @rowguid6, 
        @rowguid7, 
        @rowguid8, 
        @rowguid9, 
        @rowguid10, 
        @rowguid11, 
        @rowguid12, 
        @rowguid13, 
        @rowguid14, 
        @rowguid15, 
        @rowguid16, 
        @rowguid17, 
        @rowguid18, 
        @rowguid19, 
        @rowguid20, 
        @rowguid21, 
        @rowguid22, 
        @rowguid23, 
        @rowguid24, 
        @rowguid25, 
        @rowguid26, 
        @rowguid27, 
        @rowguid28, 
        @rowguid29, 
        @rowguid30, 
        @rowguid31, 
        @rowguid32, 
        @rowguid33, 
        @rowguid34, 
        @rowguid35, 
        @rowguid36, 
        @rowguid37, 
        @rowguid38, 
        @rowguid39, 
        @rowguid40, 
        @rowguid41, 
        @rowguid42, 
        @rowguid43, 
        @rowguid44, 
        @rowguid45, 
        @rowguid46, 
        @rowguid47, 
        @rowguid48, 
        @rowguid49, 
        @rowguid50, 
        @rowguid51, 
        @rowguid52, 
        @rowguid53, 
        @rowguid54, 
        @rowguid55, 
        @rowguid56, 
        @rowguid57, 
        @rowguid58, 
        @rowguid59, 
        @rowguid60, 
        @rowguid61, 
        @rowguid62, 
        @rowguid63, 
        @rowguid64, 
        @rowguid65, 
        @rowguid66, 
        @rowguid67, 
        @rowguid68, 
        @rowguid69, 
        @rowguid70, 
        @rowguid71, 
        @rowguid72, 
        @rowguid73, 
        @rowguid74, 
        @rowguid75, 
        @rowguid76, 
        @rowguid77, 
        @rowguid78, 
        @rowguid79, 
        @rowguid80, 
        @rowguid81, 
        @rowguid82, 
        @rowguid83, 
        @rowguid84, 
        @rowguid85, 
        @rowguid86, 
        @rowguid87, 
        @rowguid88, 
        @rowguid89, 
        @rowguid90, 
        @rowguid91, 
        @rowguid92, 
        @rowguid93, 
        @rowguid94, 
        @rowguid95, 
        @rowguid96, 
        @rowguid97, 
        @rowguid98, 
        @rowguid99, 
        @rowguid100
    if @retcode<>0 or @@error<>0
        goto Failure


    commit tran
    return 1

Failure:
    rollback tran batchdeleteproc
    commit tran
    return 0
end

go
create procedure dbo.[MSmerge_ins_sp_343D2BD21205418AAB1F05CECE24415B_batch] (
        @rows_tobe_inserted int,
        @partition_id int = null 
,
    @rowguid1 uniqueidentifier = NULL,
    @generation1 bigint = NULL,
    @lineage1 varbinary(311) = NULL,
    @colv1 varbinary(1) = NULL,
    @p1 nvarchar(30) = NULL,
    @p2 nvarchar(30) = NULL,
    @p3 nvarchar(30) = NULL,
    @p4 nvarchar(30) = NULL,
    @p5 nvarchar(30) = NULL,
    @p6 nvarchar(100) = NULL,
    @p7 int = NULL,
    @p8 money = NULL,
    @p9 money = NULL,
    @p10 datetime = NULL,
    @p11 uniqueidentifier = NULL,
    @rowguid2 uniqueidentifier = NULL,
    @generation2 bigint = NULL,
    @lineage2 varbinary(311) = NULL,
    @colv2 varbinary(1) = NULL,
    @p12 nvarchar(30) = NULL,
    @p13 nvarchar(30) = NULL,
    @p14 nvarchar(30) = NULL,
    @p15 nvarchar(30) = NULL,
    @p16 nvarchar(30) = NULL,
    @p17 nvarchar(100) = NULL,
    @p18 int = NULL,
    @p19 money = NULL,
    @p20 money = NULL,
    @p21 datetime = NULL,
    @p22 uniqueidentifier = NULL,
    @rowguid3 uniqueidentifier = NULL,
    @generation3 bigint = NULL,
    @lineage3 varbinary(311) = NULL,
    @colv3 varbinary(1) = NULL,
    @p23 nvarchar(30) = NULL,
    @p24 nvarchar(30) = NULL,
    @p25 nvarchar(30) = NULL,
    @p26 nvarchar(30) = NULL,
    @p27 nvarchar(30) = NULL,
    @p28 nvarchar(100) = NULL,
    @p29 int = NULL,
    @p30 money = NULL,
    @p31 money = NULL,
    @p32 datetime = NULL,
    @p33 uniqueidentifier = NULL,
    @rowguid4 uniqueidentifier = NULL,
    @generation4 bigint = NULL,
    @lineage4 varbinary(311) = NULL,
    @colv4 varbinary(1) = NULL,
    @p34 nvarchar(30) = NULL,
    @p35 nvarchar(30) = NULL,
    @p36 nvarchar(30) = NULL,
    @p37 nvarchar(30) = NULL,
    @p38 nvarchar(30) = NULL,
    @p39 nvarchar(100) = NULL,
    @p40 int = NULL,
    @p41 money = NULL,
    @p42 money = NULL,
    @p43 datetime = NULL,
    @p44 uniqueidentifier = NULL,
    @rowguid5 uniqueidentifier = NULL,
    @generation5 bigint = NULL,
    @lineage5 varbinary(311) = NULL,
    @colv5 varbinary(1) = NULL,
    @p45 nvarchar(30) = NULL,
    @p46 nvarchar(30) = NULL,
    @p47 nvarchar(30) = NULL,
    @p48 nvarchar(30) = NULL,
    @p49 nvarchar(30) = NULL,
    @p50 nvarchar(100) = NULL,
    @p51 int = NULL,
    @p52 money = NULL,
    @p53 money = NULL,
    @p54 datetime = NULL,
    @p55 uniqueidentifier = NULL,
    @rowguid6 uniqueidentifier = NULL,
    @generation6 bigint = NULL,
    @lineage6 varbinary(311) = NULL,
    @colv6 varbinary(1) = NULL,
    @p56 nvarchar(30) = NULL,
    @p57 nvarchar(30) = NULL,
    @p58 nvarchar(30) = NULL,
    @p59 nvarchar(30) = NULL,
    @p60 nvarchar(30) = NULL,
    @p61 nvarchar(100) = NULL,
    @p62 int = NULL,
    @p63 money = NULL,
    @p64 money = NULL,
    @p65 datetime = NULL,
    @p66 uniqueidentifier = NULL,
    @rowguid7 uniqueidentifier = NULL,
    @generation7 bigint = NULL,
    @lineage7 varbinary(311) = NULL,
    @colv7 varbinary(1) = NULL,
    @p67 nvarchar(30) = NULL,
    @p68 nvarchar(30) = NULL,
    @p69 nvarchar(30) = NULL,
    @p70 nvarchar(30) = NULL,
    @p71 nvarchar(30) = NULL,
    @p72 nvarchar(100) = NULL,
    @p73 int = NULL,
    @p74 money = NULL,
    @p75 money = NULL,
    @p76 datetime = NULL,
    @p77 uniqueidentifier = NULL,
    @rowguid8 uniqueidentifier = NULL,
    @generation8 bigint = NULL,
    @lineage8 varbinary(311) = NULL,
    @colv8 varbinary(1) = NULL,
    @p78 nvarchar(30) = NULL,
    @p79 nvarchar(30) = NULL,
    @p80 nvarchar(30) = NULL,
    @p81 nvarchar(30) = NULL,
    @p82 nvarchar(30) = NULL,
    @p83 nvarchar(100) = NULL,
    @p84 int = NULL,
    @p85 money = NULL,
    @p86 money = NULL,
    @p87 datetime = NULL,
    @p88 uniqueidentifier = NULL,
    @rowguid9 uniqueidentifier = NULL,
    @generation9 bigint = NULL,
    @lineage9 varbinary(311) = NULL,
    @colv9 varbinary(1) = NULL,
    @p89 nvarchar(30) = NULL
,
    @p90 nvarchar(30) = NULL,
    @p91 nvarchar(30) = NULL,
    @p92 nvarchar(30) = NULL,
    @p93 nvarchar(30) = NULL,
    @p94 nvarchar(100) = NULL,
    @p95 int = NULL,
    @p96 money = NULL,
    @p97 money = NULL,
    @p98 datetime = NULL,
    @p99 uniqueidentifier = NULL,
    @rowguid10 uniqueidentifier = NULL,
    @generation10 bigint = NULL,
    @lineage10 varbinary(311) = NULL,
    @colv10 varbinary(1) = NULL,
    @p100 nvarchar(30) = NULL,
    @p101 nvarchar(30) = NULL,
    @p102 nvarchar(30) = NULL,
    @p103 nvarchar(30) = NULL,
    @p104 nvarchar(30) = NULL,
    @p105 nvarchar(100) = NULL,
    @p106 int = NULL,
    @p107 money = NULL,
    @p108 money = NULL,
    @p109 datetime = NULL,
    @p110 uniqueidentifier = NULL,
    @rowguid11 uniqueidentifier = NULL,
    @generation11 bigint = NULL,
    @lineage11 varbinary(311) = NULL,
    @colv11 varbinary(1) = NULL,
    @p111 nvarchar(30) = NULL,
    @p112 nvarchar(30) = NULL,
    @p113 nvarchar(30) = NULL,
    @p114 nvarchar(30) = NULL,
    @p115 nvarchar(30) = NULL,
    @p116 nvarchar(100) = NULL,
    @p117 int = NULL,
    @p118 money = NULL,
    @p119 money = NULL,
    @p120 datetime = NULL,
    @p121 uniqueidentifier = NULL,
    @rowguid12 uniqueidentifier = NULL,
    @generation12 bigint = NULL,
    @lineage12 varbinary(311) = NULL,
    @colv12 varbinary(1) = NULL,
    @p122 nvarchar(30) = NULL,
    @p123 nvarchar(30) = NULL,
    @p124 nvarchar(30) = NULL,
    @p125 nvarchar(30) = NULL,
    @p126 nvarchar(30) = NULL,
    @p127 nvarchar(100) = NULL,
    @p128 int = NULL,
    @p129 money = NULL,
    @p130 money = NULL,
    @p131 datetime = NULL,
    @p132 uniqueidentifier = NULL,
    @rowguid13 uniqueidentifier = NULL,
    @generation13 bigint = NULL,
    @lineage13 varbinary(311) = NULL,
    @colv13 varbinary(1) = NULL,
    @p133 nvarchar(30) = NULL,
    @p134 nvarchar(30) = NULL,
    @p135 nvarchar(30) = NULL,
    @p136 nvarchar(30) = NULL,
    @p137 nvarchar(30) = NULL,
    @p138 nvarchar(100) = NULL,
    @p139 int = NULL,
    @p140 money = NULL,
    @p141 money = NULL,
    @p142 datetime = NULL,
    @p143 uniqueidentifier = NULL,
    @rowguid14 uniqueidentifier = NULL,
    @generation14 bigint = NULL,
    @lineage14 varbinary(311) = NULL,
    @colv14 varbinary(1) = NULL,
    @p144 nvarchar(30) = NULL,
    @p145 nvarchar(30) = NULL,
    @p146 nvarchar(30) = NULL,
    @p147 nvarchar(30) = NULL,
    @p148 nvarchar(30) = NULL,
    @p149 nvarchar(100) = NULL,
    @p150 int = NULL,
    @p151 money = NULL,
    @p152 money = NULL,
    @p153 datetime = NULL,
    @p154 uniqueidentifier = NULL,
    @rowguid15 uniqueidentifier = NULL,
    @generation15 bigint = NULL,
    @lineage15 varbinary(311) = NULL,
    @colv15 varbinary(1) = NULL,
    @p155 nvarchar(30) = NULL,
    @p156 nvarchar(30) = NULL,
    @p157 nvarchar(30) = NULL,
    @p158 nvarchar(30) = NULL,
    @p159 nvarchar(30) = NULL,
    @p160 nvarchar(100) = NULL,
    @p161 int = NULL,
    @p162 money = NULL,
    @p163 money = NULL,
    @p164 datetime = NULL,
    @p165 uniqueidentifier = NULL,
    @rowguid16 uniqueidentifier = NULL,
    @generation16 bigint = NULL,
    @lineage16 varbinary(311) = NULL,
    @colv16 varbinary(1) = NULL,
    @p166 nvarchar(30) = NULL,
    @p167 nvarchar(30) = NULL,
    @p168 nvarchar(30) = NULL,
    @p169 nvarchar(30) = NULL,
    @p170 nvarchar(30) = NULL,
    @p171 nvarchar(100) = NULL,
    @p172 int = NULL,
    @p173 money = NULL,
    @p174 money = NULL,
    @p175 datetime = NULL,
    @p176 uniqueidentifier = NULL,
    @rowguid17 uniqueidentifier = NULL,
    @generation17 bigint = NULL,
    @lineage17 varbinary(311) = NULL,
    @colv17 varbinary(1) = NULL,
    @p177 nvarchar(30) = NULL
,
    @p178 nvarchar(30) = NULL,
    @p179 nvarchar(30) = NULL,
    @p180 nvarchar(30) = NULL,
    @p181 nvarchar(30) = NULL,
    @p182 nvarchar(100) = NULL,
    @p183 int = NULL,
    @p184 money = NULL,
    @p185 money = NULL,
    @p186 datetime = NULL,
    @p187 uniqueidentifier = NULL,
    @rowguid18 uniqueidentifier = NULL,
    @generation18 bigint = NULL,
    @lineage18 varbinary(311) = NULL,
    @colv18 varbinary(1) = NULL,
    @p188 nvarchar(30) = NULL,
    @p189 nvarchar(30) = NULL,
    @p190 nvarchar(30) = NULL,
    @p191 nvarchar(30) = NULL,
    @p192 nvarchar(30) = NULL,
    @p193 nvarchar(100) = NULL,
    @p194 int = NULL,
    @p195 money = NULL,
    @p196 money = NULL,
    @p197 datetime = NULL,
    @p198 uniqueidentifier = NULL,
    @rowguid19 uniqueidentifier = NULL,
    @generation19 bigint = NULL,
    @lineage19 varbinary(311) = NULL,
    @colv19 varbinary(1) = NULL,
    @p199 nvarchar(30) = NULL,
    @p200 nvarchar(30) = NULL,
    @p201 nvarchar(30) = NULL,
    @p202 nvarchar(30) = NULL,
    @p203 nvarchar(30) = NULL,
    @p204 nvarchar(100) = NULL,
    @p205 int = NULL,
    @p206 money = NULL,
    @p207 money = NULL,
    @p208 datetime = NULL,
    @p209 uniqueidentifier = NULL,
    @rowguid20 uniqueidentifier = NULL,
    @generation20 bigint = NULL,
    @lineage20 varbinary(311) = NULL,
    @colv20 varbinary(1) = NULL,
    @p210 nvarchar(30) = NULL,
    @p211 nvarchar(30) = NULL,
    @p212 nvarchar(30) = NULL,
    @p213 nvarchar(30) = NULL,
    @p214 nvarchar(30) = NULL,
    @p215 nvarchar(100) = NULL,
    @p216 int = NULL,
    @p217 money = NULL,
    @p218 money = NULL,
    @p219 datetime = NULL,
    @p220 uniqueidentifier = NULL,
    @rowguid21 uniqueidentifier = NULL,
    @generation21 bigint = NULL,
    @lineage21 varbinary(311) = NULL,
    @colv21 varbinary(1) = NULL,
    @p221 nvarchar(30) = NULL,
    @p222 nvarchar(30) = NULL,
    @p223 nvarchar(30) = NULL,
    @p224 nvarchar(30) = NULL,
    @p225 nvarchar(30) = NULL,
    @p226 nvarchar(100) = NULL,
    @p227 int = NULL,
    @p228 money = NULL,
    @p229 money = NULL,
    @p230 datetime = NULL,
    @p231 uniqueidentifier = NULL,
    @rowguid22 uniqueidentifier = NULL,
    @generation22 bigint = NULL,
    @lineage22 varbinary(311) = NULL,
    @colv22 varbinary(1) = NULL,
    @p232 nvarchar(30) = NULL,
    @p233 nvarchar(30) = NULL,
    @p234 nvarchar(30) = NULL,
    @p235 nvarchar(30) = NULL,
    @p236 nvarchar(30) = NULL,
    @p237 nvarchar(100) = NULL,
    @p238 int = NULL,
    @p239 money = NULL,
    @p240 money = NULL,
    @p241 datetime = NULL,
    @p242 uniqueidentifier = NULL,
    @rowguid23 uniqueidentifier = NULL,
    @generation23 bigint = NULL,
    @lineage23 varbinary(311) = NULL,
    @colv23 varbinary(1) = NULL,
    @p243 nvarchar(30) = NULL,
    @p244 nvarchar(30) = NULL,
    @p245 nvarchar(30) = NULL,
    @p246 nvarchar(30) = NULL,
    @p247 nvarchar(30) = NULL,
    @p248 nvarchar(100) = NULL,
    @p249 int = NULL,
    @p250 money = NULL,
    @p251 money = NULL,
    @p252 datetime = NULL,
    @p253 uniqueidentifier = NULL,
    @rowguid24 uniqueidentifier = NULL,
    @generation24 bigint = NULL,
    @lineage24 varbinary(311) = NULL,
    @colv24 varbinary(1) = NULL,
    @p254 nvarchar(30) = NULL,
    @p255 nvarchar(30) = NULL,
    @p256 nvarchar(30) = NULL,
    @p257 nvarchar(30) = NULL,
    @p258 nvarchar(30) = NULL,
    @p259 nvarchar(100) = NULL,
    @p260 int = NULL,
    @p261 money = NULL,
    @p262 money = NULL,
    @p263 datetime = NULL,
    @p264 uniqueidentifier = NULL,
    @rowguid25 uniqueidentifier = NULL,
    @generation25 bigint = NULL,
    @lineage25 varbinary(311) = NULL,
    @colv25 varbinary(1) = NULL,
    @p265 nvarchar(30) = NULL
,
    @p266 nvarchar(30) = NULL,
    @p267 nvarchar(30) = NULL,
    @p268 nvarchar(30) = NULL,
    @p269 nvarchar(30) = NULL,
    @p270 nvarchar(100) = NULL,
    @p271 int = NULL,
    @p272 money = NULL,
    @p273 money = NULL,
    @p274 datetime = NULL,
    @p275 uniqueidentifier = NULL,
    @rowguid26 uniqueidentifier = NULL,
    @generation26 bigint = NULL,
    @lineage26 varbinary(311) = NULL,
    @colv26 varbinary(1) = NULL,
    @p276 nvarchar(30) = NULL,
    @p277 nvarchar(30) = NULL,
    @p278 nvarchar(30) = NULL,
    @p279 nvarchar(30) = NULL,
    @p280 nvarchar(30) = NULL,
    @p281 nvarchar(100) = NULL,
    @p282 int = NULL,
    @p283 money = NULL,
    @p284 money = NULL,
    @p285 datetime = NULL,
    @p286 uniqueidentifier = NULL,
    @rowguid27 uniqueidentifier = NULL,
    @generation27 bigint = NULL,
    @lineage27 varbinary(311) = NULL,
    @colv27 varbinary(1) = NULL,
    @p287 nvarchar(30) = NULL,
    @p288 nvarchar(30) = NULL,
    @p289 nvarchar(30) = NULL,
    @p290 nvarchar(30) = NULL,
    @p291 nvarchar(30) = NULL,
    @p292 nvarchar(100) = NULL,
    @p293 int = NULL,
    @p294 money = NULL,
    @p295 money = NULL,
    @p296 datetime = NULL,
    @p297 uniqueidentifier = NULL,
    @rowguid28 uniqueidentifier = NULL,
    @generation28 bigint = NULL,
    @lineage28 varbinary(311) = NULL,
    @colv28 varbinary(1) = NULL,
    @p298 nvarchar(30) = NULL,
    @p299 nvarchar(30) = NULL,
    @p300 nvarchar(30) = NULL,
    @p301 nvarchar(30) = NULL,
    @p302 nvarchar(30) = NULL,
    @p303 nvarchar(100) = NULL,
    @p304 int = NULL,
    @p305 money = NULL,
    @p306 money = NULL,
    @p307 datetime = NULL,
    @p308 uniqueidentifier = NULL,
    @rowguid29 uniqueidentifier = NULL,
    @generation29 bigint = NULL,
    @lineage29 varbinary(311) = NULL,
    @colv29 varbinary(1) = NULL,
    @p309 nvarchar(30) = NULL,
    @p310 nvarchar(30) = NULL,
    @p311 nvarchar(30) = NULL,
    @p312 nvarchar(30) = NULL,
    @p313 nvarchar(30) = NULL,
    @p314 nvarchar(100) = NULL,
    @p315 int = NULL,
    @p316 money = NULL,
    @p317 money = NULL,
    @p318 datetime = NULL,
    @p319 uniqueidentifier = NULL,
    @rowguid30 uniqueidentifier = NULL,
    @generation30 bigint = NULL,
    @lineage30 varbinary(311) = NULL,
    @colv30 varbinary(1) = NULL,
    @p320 nvarchar(30) = NULL,
    @p321 nvarchar(30) = NULL,
    @p322 nvarchar(30) = NULL,
    @p323 nvarchar(30) = NULL,
    @p324 nvarchar(30) = NULL,
    @p325 nvarchar(100) = NULL,
    @p326 int = NULL,
    @p327 money = NULL,
    @p328 money = NULL,
    @p329 datetime = NULL,
    @p330 uniqueidentifier = NULL,
    @rowguid31 uniqueidentifier = NULL,
    @generation31 bigint = NULL,
    @lineage31 varbinary(311) = NULL,
    @colv31 varbinary(1) = NULL,
    @p331 nvarchar(30) = NULL,
    @p332 nvarchar(30) = NULL,
    @p333 nvarchar(30) = NULL,
    @p334 nvarchar(30) = NULL,
    @p335 nvarchar(30) = NULL,
    @p336 nvarchar(100) = NULL,
    @p337 int = NULL,
    @p338 money = NULL,
    @p339 money = NULL,
    @p340 datetime = NULL,
    @p341 uniqueidentifier = NULL,
    @rowguid32 uniqueidentifier = NULL,
    @generation32 bigint = NULL,
    @lineage32 varbinary(311) = NULL,
    @colv32 varbinary(1) = NULL,
    @p342 nvarchar(30) = NULL,
    @p343 nvarchar(30) = NULL,
    @p344 nvarchar(30) = NULL,
    @p345 nvarchar(30) = NULL,
    @p346 nvarchar(30) = NULL,
    @p347 nvarchar(100) = NULL,
    @p348 int = NULL,
    @p349 money = NULL,
    @p350 money = NULL,
    @p351 datetime = NULL,
    @p352 uniqueidentifier = NULL,
    @rowguid33 uniqueidentifier = NULL,
    @generation33 bigint = NULL,
    @lineage33 varbinary(311) = NULL,
    @colv33 varbinary(1) = NULL,
    @p353 nvarchar(30) = NULL
,
    @p354 nvarchar(30) = NULL,
    @p355 nvarchar(30) = NULL,
    @p356 nvarchar(30) = NULL,
    @p357 nvarchar(30) = NULL,
    @p358 nvarchar(100) = NULL,
    @p359 int = NULL,
    @p360 money = NULL,
    @p361 money = NULL,
    @p362 datetime = NULL,
    @p363 uniqueidentifier = NULL,
    @rowguid34 uniqueidentifier = NULL,
    @generation34 bigint = NULL,
    @lineage34 varbinary(311) = NULL,
    @colv34 varbinary(1) = NULL,
    @p364 nvarchar(30) = NULL,
    @p365 nvarchar(30) = NULL,
    @p366 nvarchar(30) = NULL,
    @p367 nvarchar(30) = NULL,
    @p368 nvarchar(30) = NULL,
    @p369 nvarchar(100) = NULL,
    @p370 int = NULL,
    @p371 money = NULL,
    @p372 money = NULL,
    @p373 datetime = NULL,
    @p374 uniqueidentifier = NULL,
    @rowguid35 uniqueidentifier = NULL,
    @generation35 bigint = NULL,
    @lineage35 varbinary(311) = NULL,
    @colv35 varbinary(1) = NULL,
    @p375 nvarchar(30) = NULL,
    @p376 nvarchar(30) = NULL,
    @p377 nvarchar(30) = NULL,
    @p378 nvarchar(30) = NULL,
    @p379 nvarchar(30) = NULL,
    @p380 nvarchar(100) = NULL,
    @p381 int = NULL,
    @p382 money = NULL,
    @p383 money = NULL,
    @p384 datetime = NULL,
    @p385 uniqueidentifier = NULL,
    @rowguid36 uniqueidentifier = NULL,
    @generation36 bigint = NULL,
    @lineage36 varbinary(311) = NULL,
    @colv36 varbinary(1) = NULL,
    @p386 nvarchar(30) = NULL,
    @p387 nvarchar(30) = NULL,
    @p388 nvarchar(30) = NULL,
    @p389 nvarchar(30) = NULL,
    @p390 nvarchar(30) = NULL,
    @p391 nvarchar(100) = NULL,
    @p392 int = NULL,
    @p393 money = NULL,
    @p394 money = NULL,
    @p395 datetime = NULL,
    @p396 uniqueidentifier = NULL,
    @rowguid37 uniqueidentifier = NULL,
    @generation37 bigint = NULL,
    @lineage37 varbinary(311) = NULL,
    @colv37 varbinary(1) = NULL,
    @p397 nvarchar(30) = NULL,
    @p398 nvarchar(30) = NULL,
    @p399 nvarchar(30) = NULL,
    @p400 nvarchar(30) = NULL,
    @p401 nvarchar(30) = NULL,
    @p402 nvarchar(100) = NULL,
    @p403 int = NULL,
    @p404 money = NULL,
    @p405 money = NULL,
    @p406 datetime = NULL,
    @p407 uniqueidentifier = NULL,
    @rowguid38 uniqueidentifier = NULL,
    @generation38 bigint = NULL,
    @lineage38 varbinary(311) = NULL,
    @colv38 varbinary(1) = NULL,
    @p408 nvarchar(30) = NULL,
    @p409 nvarchar(30) = NULL,
    @p410 nvarchar(30) = NULL,
    @p411 nvarchar(30) = NULL,
    @p412 nvarchar(30) = NULL,
    @p413 nvarchar(100) = NULL,
    @p414 int = NULL,
    @p415 money = NULL,
    @p416 money = NULL,
    @p417 datetime = NULL,
    @p418 uniqueidentifier = NULL,
    @rowguid39 uniqueidentifier = NULL,
    @generation39 bigint = NULL,
    @lineage39 varbinary(311) = NULL,
    @colv39 varbinary(1) = NULL,
    @p419 nvarchar(30) = NULL,
    @p420 nvarchar(30) = NULL,
    @p421 nvarchar(30) = NULL,
    @p422 nvarchar(30) = NULL,
    @p423 nvarchar(30) = NULL,
    @p424 nvarchar(100) = NULL,
    @p425 int = NULL,
    @p426 money = NULL,
    @p427 money = NULL,
    @p428 datetime = NULL,
    @p429 uniqueidentifier = NULL,
    @rowguid40 uniqueidentifier = NULL,
    @generation40 bigint = NULL,
    @lineage40 varbinary(311) = NULL,
    @colv40 varbinary(1) = NULL,
    @p430 nvarchar(30) = NULL,
    @p431 nvarchar(30) = NULL,
    @p432 nvarchar(30) = NULL,
    @p433 nvarchar(30) = NULL,
    @p434 nvarchar(30) = NULL,
    @p435 nvarchar(100) = NULL,
    @p436 int = NULL,
    @p437 money = NULL,
    @p438 money = NULL,
    @p439 datetime = NULL,
    @p440 uniqueidentifier = NULL,
    @rowguid41 uniqueidentifier = NULL,
    @generation41 bigint = NULL,
    @lineage41 varbinary(311) = NULL,
    @colv41 varbinary(1) = NULL,
    @p441 nvarchar(30) = NULL
,
    @p442 nvarchar(30) = NULL,
    @p443 nvarchar(30) = NULL,
    @p444 nvarchar(30) = NULL,
    @p445 nvarchar(30) = NULL,
    @p446 nvarchar(100) = NULL,
    @p447 int = NULL,
    @p448 money = NULL,
    @p449 money = NULL,
    @p450 datetime = NULL,
    @p451 uniqueidentifier = NULL,
    @rowguid42 uniqueidentifier = NULL,
    @generation42 bigint = NULL,
    @lineage42 varbinary(311) = NULL,
    @colv42 varbinary(1) = NULL,
    @p452 nvarchar(30) = NULL,
    @p453 nvarchar(30) = NULL,
    @p454 nvarchar(30) = NULL,
    @p455 nvarchar(30) = NULL,
    @p456 nvarchar(30) = NULL,
    @p457 nvarchar(100) = NULL,
    @p458 int = NULL,
    @p459 money = NULL,
    @p460 money = NULL,
    @p461 datetime = NULL,
    @p462 uniqueidentifier = NULL,
    @rowguid43 uniqueidentifier = NULL,
    @generation43 bigint = NULL,
    @lineage43 varbinary(311) = NULL,
    @colv43 varbinary(1) = NULL,
    @p463 nvarchar(30) = NULL,
    @p464 nvarchar(30) = NULL,
    @p465 nvarchar(30) = NULL,
    @p466 nvarchar(30) = NULL,
    @p467 nvarchar(30) = NULL,
    @p468 nvarchar(100) = NULL,
    @p469 int = NULL,
    @p470 money = NULL,
    @p471 money = NULL,
    @p472 datetime = NULL,
    @p473 uniqueidentifier = NULL,
    @rowguid44 uniqueidentifier = NULL,
    @generation44 bigint = NULL,
    @lineage44 varbinary(311) = NULL,
    @colv44 varbinary(1) = NULL,
    @p474 nvarchar(30) = NULL,
    @p475 nvarchar(30) = NULL,
    @p476 nvarchar(30) = NULL,
    @p477 nvarchar(30) = NULL,
    @p478 nvarchar(30) = NULL,
    @p479 nvarchar(100) = NULL,
    @p480 int = NULL,
    @p481 money = NULL,
    @p482 money = NULL,
    @p483 datetime = NULL,
    @p484 uniqueidentifier = NULL,
    @rowguid45 uniqueidentifier = NULL,
    @generation45 bigint = NULL,
    @lineage45 varbinary(311) = NULL,
    @colv45 varbinary(1) = NULL,
    @p485 nvarchar(30) = NULL,
    @p486 nvarchar(30) = NULL,
    @p487 nvarchar(30) = NULL,
    @p488 nvarchar(30) = NULL,
    @p489 nvarchar(30) = NULL,
    @p490 nvarchar(100) = NULL,
    @p491 int = NULL,
    @p492 money = NULL,
    @p493 money = NULL,
    @p494 datetime = NULL,
    @p495 uniqueidentifier = NULL,
    @rowguid46 uniqueidentifier = NULL,
    @generation46 bigint = NULL,
    @lineage46 varbinary(311) = NULL,
    @colv46 varbinary(1) = NULL,
    @p496 nvarchar(30) = NULL,
    @p497 nvarchar(30) = NULL,
    @p498 nvarchar(30) = NULL,
    @p499 nvarchar(30) = NULL,
    @p500 nvarchar(30) = NULL,
    @p501 nvarchar(100) = NULL,
    @p502 int = NULL,
    @p503 money = NULL,
    @p504 money = NULL,
    @p505 datetime = NULL,
    @p506 uniqueidentifier = NULL,
    @rowguid47 uniqueidentifier = NULL,
    @generation47 bigint = NULL,
    @lineage47 varbinary(311) = NULL,
    @colv47 varbinary(1) = NULL,
    @p507 nvarchar(30) = NULL,
    @p508 nvarchar(30) = NULL,
    @p509 nvarchar(30) = NULL,
    @p510 nvarchar(30) = NULL,
    @p511 nvarchar(30) = NULL,
    @p512 nvarchar(100) = NULL,
    @p513 int = NULL,
    @p514 money = NULL,
    @p515 money = NULL,
    @p516 datetime = NULL,
    @p517 uniqueidentifier = NULL,
    @rowguid48 uniqueidentifier = NULL,
    @generation48 bigint = NULL,
    @lineage48 varbinary(311) = NULL,
    @colv48 varbinary(1) = NULL,
    @p518 nvarchar(30) = NULL,
    @p519 nvarchar(30) = NULL,
    @p520 nvarchar(30) = NULL,
    @p521 nvarchar(30) = NULL,
    @p522 nvarchar(30) = NULL,
    @p523 nvarchar(100) = NULL,
    @p524 int = NULL,
    @p525 money = NULL,
    @p526 money = NULL,
    @p527 datetime = NULL,
    @p528 uniqueidentifier = NULL,
    @rowguid49 uniqueidentifier = NULL,
    @generation49 bigint = NULL,
    @lineage49 varbinary(311) = NULL,
    @colv49 varbinary(1) = NULL,
    @p529 nvarchar(30) = NULL
,
    @p530 nvarchar(30) = NULL,
    @p531 nvarchar(30) = NULL,
    @p532 nvarchar(30) = NULL,
    @p533 nvarchar(30) = NULL,
    @p534 nvarchar(100) = NULL,
    @p535 int = NULL,
    @p536 money = NULL,
    @p537 money = NULL,
    @p538 datetime = NULL,
    @p539 uniqueidentifier = NULL,
    @rowguid50 uniqueidentifier = NULL,
    @generation50 bigint = NULL,
    @lineage50 varbinary(311) = NULL,
    @colv50 varbinary(1) = NULL,
    @p540 nvarchar(30) = NULL,
    @p541 nvarchar(30) = NULL,
    @p542 nvarchar(30) = NULL,
    @p543 nvarchar(30) = NULL,
    @p544 nvarchar(30) = NULL,
    @p545 nvarchar(100) = NULL,
    @p546 int = NULL,
    @p547 money = NULL,
    @p548 money = NULL,
    @p549 datetime = NULL,
    @p550 uniqueidentifier = NULL,
    @rowguid51 uniqueidentifier = NULL,
    @generation51 bigint = NULL,
    @lineage51 varbinary(311) = NULL,
    @colv51 varbinary(1) = NULL,
    @p551 nvarchar(30) = NULL,
    @p552 nvarchar(30) = NULL,
    @p553 nvarchar(30) = NULL,
    @p554 nvarchar(30) = NULL,
    @p555 nvarchar(30) = NULL,
    @p556 nvarchar(100) = NULL,
    @p557 int = NULL,
    @p558 money = NULL,
    @p559 money = NULL,
    @p560 datetime = NULL,
    @p561 uniqueidentifier = NULL,
    @rowguid52 uniqueidentifier = NULL,
    @generation52 bigint = NULL,
    @lineage52 varbinary(311) = NULL,
    @colv52 varbinary(1) = NULL,
    @p562 nvarchar(30) = NULL,
    @p563 nvarchar(30) = NULL,
    @p564 nvarchar(30) = NULL,
    @p565 nvarchar(30) = NULL,
    @p566 nvarchar(30) = NULL,
    @p567 nvarchar(100) = NULL,
    @p568 int = NULL,
    @p569 money = NULL,
    @p570 money = NULL,
    @p571 datetime = NULL,
    @p572 uniqueidentifier = NULL,
    @rowguid53 uniqueidentifier = NULL,
    @generation53 bigint = NULL,
    @lineage53 varbinary(311) = NULL,
    @colv53 varbinary(1) = NULL,
    @p573 nvarchar(30) = NULL,
    @p574 nvarchar(30) = NULL,
    @p575 nvarchar(30) = NULL,
    @p576 nvarchar(30) = NULL,
    @p577 nvarchar(30) = NULL,
    @p578 nvarchar(100) = NULL,
    @p579 int = NULL,
    @p580 money = NULL,
    @p581 money = NULL,
    @p582 datetime = NULL,
    @p583 uniqueidentifier = NULL,
    @rowguid54 uniqueidentifier = NULL,
    @generation54 bigint = NULL,
    @lineage54 varbinary(311) = NULL,
    @colv54 varbinary(1) = NULL,
    @p584 nvarchar(30) = NULL,
    @p585 nvarchar(30) = NULL,
    @p586 nvarchar(30) = NULL,
    @p587 nvarchar(30) = NULL,
    @p588 nvarchar(30) = NULL,
    @p589 nvarchar(100) = NULL,
    @p590 int = NULL,
    @p591 money = NULL,
    @p592 money = NULL,
    @p593 datetime = NULL,
    @p594 uniqueidentifier = NULL,
    @rowguid55 uniqueidentifier = NULL,
    @generation55 bigint = NULL,
    @lineage55 varbinary(311) = NULL,
    @colv55 varbinary(1) = NULL,
    @p595 nvarchar(30) = NULL,
    @p596 nvarchar(30) = NULL,
    @p597 nvarchar(30) = NULL,
    @p598 nvarchar(30) = NULL,
    @p599 nvarchar(30) = NULL,
    @p600 nvarchar(100) = NULL,
    @p601 int = NULL,
    @p602 money = NULL,
    @p603 money = NULL,
    @p604 datetime = NULL,
    @p605 uniqueidentifier = NULL,
    @rowguid56 uniqueidentifier = NULL,
    @generation56 bigint = NULL,
    @lineage56 varbinary(311) = NULL,
    @colv56 varbinary(1) = NULL,
    @p606 nvarchar(30) = NULL,
    @p607 nvarchar(30) = NULL,
    @p608 nvarchar(30) = NULL,
    @p609 nvarchar(30) = NULL,
    @p610 nvarchar(30) = NULL,
    @p611 nvarchar(100) = NULL,
    @p612 int = NULL,
    @p613 money = NULL,
    @p614 money = NULL,
    @p615 datetime = NULL,
    @p616 uniqueidentifier = NULL,
    @rowguid57 uniqueidentifier = NULL,
    @generation57 bigint = NULL,
    @lineage57 varbinary(311) = NULL,
    @colv57 varbinary(1) = NULL,
    @p617 nvarchar(30) = NULL
,
    @p618 nvarchar(30) = NULL,
    @p619 nvarchar(30) = NULL,
    @p620 nvarchar(30) = NULL,
    @p621 nvarchar(30) = NULL,
    @p622 nvarchar(100) = NULL,
    @p623 int = NULL,
    @p624 money = NULL,
    @p625 money = NULL,
    @p626 datetime = NULL,
    @p627 uniqueidentifier = NULL,
    @rowguid58 uniqueidentifier = NULL,
    @generation58 bigint = NULL,
    @lineage58 varbinary(311) = NULL,
    @colv58 varbinary(1) = NULL,
    @p628 nvarchar(30) = NULL,
    @p629 nvarchar(30) = NULL,
    @p630 nvarchar(30) = NULL,
    @p631 nvarchar(30) = NULL,
    @p632 nvarchar(30) = NULL,
    @p633 nvarchar(100) = NULL,
    @p634 int = NULL,
    @p635 money = NULL,
    @p636 money = NULL,
    @p637 datetime = NULL,
    @p638 uniqueidentifier = NULL,
    @rowguid59 uniqueidentifier = NULL,
    @generation59 bigint = NULL,
    @lineage59 varbinary(311) = NULL,
    @colv59 varbinary(1) = NULL,
    @p639 nvarchar(30) = NULL,
    @p640 nvarchar(30) = NULL,
    @p641 nvarchar(30) = NULL,
    @p642 nvarchar(30) = NULL,
    @p643 nvarchar(30) = NULL,
    @p644 nvarchar(100) = NULL,
    @p645 int = NULL,
    @p646 money = NULL,
    @p647 money = NULL,
    @p648 datetime = NULL,
    @p649 uniqueidentifier = NULL,
    @rowguid60 uniqueidentifier = NULL,
    @generation60 bigint = NULL,
    @lineage60 varbinary(311) = NULL,
    @colv60 varbinary(1) = NULL,
    @p650 nvarchar(30) = NULL,
    @p651 nvarchar(30) = NULL,
    @p652 nvarchar(30) = NULL,
    @p653 nvarchar(30) = NULL,
    @p654 nvarchar(30) = NULL,
    @p655 nvarchar(100) = NULL,
    @p656 int = NULL,
    @p657 money = NULL,
    @p658 money = NULL,
    @p659 datetime = NULL,
    @p660 uniqueidentifier = NULL,
    @rowguid61 uniqueidentifier = NULL,
    @generation61 bigint = NULL,
    @lineage61 varbinary(311) = NULL,
    @colv61 varbinary(1) = NULL,
    @p661 nvarchar(30) = NULL,
    @p662 nvarchar(30) = NULL,
    @p663 nvarchar(30) = NULL,
    @p664 nvarchar(30) = NULL,
    @p665 nvarchar(30) = NULL,
    @p666 nvarchar(100) = NULL,
    @p667 int = NULL,
    @p668 money = NULL,
    @p669 money = NULL,
    @p670 datetime = NULL,
    @p671 uniqueidentifier = NULL,
    @rowguid62 uniqueidentifier = NULL,
    @generation62 bigint = NULL,
    @lineage62 varbinary(311) = NULL,
    @colv62 varbinary(1) = NULL,
    @p672 nvarchar(30) = NULL,
    @p673 nvarchar(30) = NULL,
    @p674 nvarchar(30) = NULL,
    @p675 nvarchar(30) = NULL,
    @p676 nvarchar(30) = NULL,
    @p677 nvarchar(100) = NULL,
    @p678 int = NULL,
    @p679 money = NULL,
    @p680 money = NULL,
    @p681 datetime = NULL,
    @p682 uniqueidentifier = NULL,
    @rowguid63 uniqueidentifier = NULL,
    @generation63 bigint = NULL,
    @lineage63 varbinary(311) = NULL,
    @colv63 varbinary(1) = NULL,
    @p683 nvarchar(30) = NULL,
    @p684 nvarchar(30) = NULL,
    @p685 nvarchar(30) = NULL,
    @p686 nvarchar(30) = NULL,
    @p687 nvarchar(30) = NULL,
    @p688 nvarchar(100) = NULL,
    @p689 int = NULL,
    @p690 money = NULL,
    @p691 money = NULL,
    @p692 datetime = NULL,
    @p693 uniqueidentifier = NULL,
    @rowguid64 uniqueidentifier = NULL,
    @generation64 bigint = NULL,
    @lineage64 varbinary(311) = NULL,
    @colv64 varbinary(1) = NULL,
    @p694 nvarchar(30) = NULL,
    @p695 nvarchar(30) = NULL,
    @p696 nvarchar(30) = NULL,
    @p697 nvarchar(30) = NULL,
    @p698 nvarchar(30) = NULL,
    @p699 nvarchar(100) = NULL,
    @p700 int = NULL,
    @p701 money = NULL,
    @p702 money = NULL,
    @p703 datetime = NULL,
    @p704 uniqueidentifier = NULL,
    @rowguid65 uniqueidentifier = NULL,
    @generation65 bigint = NULL,
    @lineage65 varbinary(311) = NULL,
    @colv65 varbinary(1) = NULL,
    @p705 nvarchar(30) = NULL
,
    @p706 nvarchar(30) = NULL,
    @p707 nvarchar(30) = NULL,
    @p708 nvarchar(30) = NULL,
    @p709 nvarchar(30) = NULL,
    @p710 nvarchar(100) = NULL,
    @p711 int = NULL,
    @p712 money = NULL,
    @p713 money = NULL,
    @p714 datetime = NULL,
    @p715 uniqueidentifier = NULL,
    @rowguid66 uniqueidentifier = NULL,
    @generation66 bigint = NULL,
    @lineage66 varbinary(311) = NULL,
    @colv66 varbinary(1) = NULL,
    @p716 nvarchar(30) = NULL,
    @p717 nvarchar(30) = NULL,
    @p718 nvarchar(30) = NULL,
    @p719 nvarchar(30) = NULL,
    @p720 nvarchar(30) = NULL,
    @p721 nvarchar(100) = NULL,
    @p722 int = NULL,
    @p723 money = NULL,
    @p724 money = NULL,
    @p725 datetime = NULL,
    @p726 uniqueidentifier = NULL,
    @rowguid67 uniqueidentifier = NULL,
    @generation67 bigint = NULL,
    @lineage67 varbinary(311) = NULL,
    @colv67 varbinary(1) = NULL,
    @p727 nvarchar(30) = NULL,
    @p728 nvarchar(30) = NULL,
    @p729 nvarchar(30) = NULL,
    @p730 nvarchar(30) = NULL,
    @p731 nvarchar(30) = NULL,
    @p732 nvarchar(100) = NULL,
    @p733 int = NULL,
    @p734 money = NULL,
    @p735 money = NULL,
    @p736 datetime = NULL,
    @p737 uniqueidentifier = NULL,
    @rowguid68 uniqueidentifier = NULL,
    @generation68 bigint = NULL,
    @lineage68 varbinary(311) = NULL,
    @colv68 varbinary(1) = NULL,
    @p738 nvarchar(30) = NULL
,
    @p739 nvarchar(30) = NULL
,
    @p740 nvarchar(30) = NULL
,
    @p741 nvarchar(30) = NULL
,
    @p742 nvarchar(30) = NULL
,
    @p743 nvarchar(100) = NULL
,
    @p744 int = NULL
,
    @p745 money = NULL
,
    @p746 money = NULL
,
    @p747 datetime = NULL
,
    @p748 uniqueidentifier = NULL

) as
begin
    declare @errcode    int
    declare @retcode    int
    declare @rowcount   int
    declare @error      int
    declare @rows_in_contents int
    declare @rows_inserted_into_contents int
    declare @publication_number smallint
    declare @gen_cur bigint
    declare @rows_in_tomb bit
    declare @rows_in_syncview int
    declare @marker uniqueidentifier
    
    set nocount on
    
    set @errcode= 0
    set @publication_number = 2
    
    if ({ fn ISPALUSER('AB1F05CE-CE24-415B-8771-7EDE0EFE1D98') } <> 1)
    begin
        RAISERROR (14126, 11, -1)
        return 4
    end

    if @rows_tobe_inserted is NULL or @rows_tobe_inserted <=0
        return 0



    begin tran
    save tran batchinsertproc 

    exec @retcode = sys.sp_MSmerge_getgencur_public 57128000, @rows_tobe_inserted, @gen_cur output
    if @retcode<>0 or @@error<>0
        return 4



    select @rows_in_tomb = 0
    select @rows_in_tomb = 1 from (

         select @rowguid1 as rowguid
 union all 
         select @rowguid2 as rowguid
 union all 
         select @rowguid3 as rowguid
 union all 
         select @rowguid4 as rowguid
 union all 
         select @rowguid5 as rowguid
 union all 
         select @rowguid6 as rowguid
 union all 
         select @rowguid7 as rowguid
 union all 
         select @rowguid8 as rowguid
 union all 
         select @rowguid9 as rowguid
 union all 
         select @rowguid10 as rowguid
 union all 
         select @rowguid11 as rowguid
 union all 
         select @rowguid12 as rowguid
 union all 
         select @rowguid13 as rowguid
 union all 
         select @rowguid14 as rowguid
 union all 
         select @rowguid15 as rowguid
 union all 
         select @rowguid16 as rowguid
 union all 
         select @rowguid17 as rowguid
 union all 
         select @rowguid18 as rowguid
 union all 
         select @rowguid19 as rowguid
 union all 
         select @rowguid20 as rowguid
 union all 
         select @rowguid21 as rowguid
 union all 
         select @rowguid22 as rowguid
 union all 
         select @rowguid23 as rowguid
 union all 
         select @rowguid24 as rowguid
 union all 
         select @rowguid25 as rowguid
 union all 
         select @rowguid26 as rowguid
 union all 
         select @rowguid27 as rowguid
 union all 
         select @rowguid28 as rowguid
 union all 
         select @rowguid29 as rowguid
 union all 
         select @rowguid30 as rowguid
 union all 
         select @rowguid31 as rowguid
 union all 
         select @rowguid32 as rowguid
 union all 
         select @rowguid33 as rowguid
 union all 
         select @rowguid34 as rowguid
 union all 
         select @rowguid35 as rowguid
 union all 
         select @rowguid36 as rowguid
 union all 
         select @rowguid37 as rowguid
 union all 
         select @rowguid38 as rowguid
 union all 
         select @rowguid39 as rowguid
 union all 
         select @rowguid40 as rowguid
 union all 
         select @rowguid41 as rowguid
 union all 
         select @rowguid42 as rowguid
 union all 
         select @rowguid43 as rowguid
 union all 
         select @rowguid44 as rowguid
 union all 
         select @rowguid45 as rowguid
 union all 
         select @rowguid46 as rowguid
 union all 
         select @rowguid47 as rowguid
 union all 
         select @rowguid48 as rowguid
 union all 
         select @rowguid49 as rowguid
 union all 
         select @rowguid50 as rowguid
 union all 
         select @rowguid51 as rowguid
 union all 
         select @rowguid52 as rowguid
 union all 
         select @rowguid53 as rowguid
 union all 
         select @rowguid54 as rowguid
 union all 
         select @rowguid55 as rowguid
 union all 
         select @rowguid56 as rowguid
 union all 
         select @rowguid57 as rowguid
 union all 
         select @rowguid58 as rowguid
 union all 
         select @rowguid59 as rowguid
 union all 
         select @rowguid60 as rowguid
 union all 
         select @rowguid61 as rowguid
 union all 
         select @rowguid62 as rowguid
 union all 
         select @rowguid63 as rowguid
 union all 
         select @rowguid64 as rowguid
 union all 
         select @rowguid65 as rowguid
 union all 
         select @rowguid66 as rowguid
 union all 
         select @rowguid67 as rowguid
 union all 
         select @rowguid68 as rowguid

    ) as rows
    inner join dbo.MSmerge_tombstone tomb with (rowlock) 
    on tomb.rowguid = rows.rowguid
    and tomb.tablenick = 57128000
    and rows.rowguid is not NULL
        
    if @rows_in_tomb = 1
    begin
        raiserror(20692, 16, -1, 'HoaDon')
        set @errcode=3
        goto Failure
    end

    
    select @marker = newid()
    insert into dbo.MSmerge_contents with (rowlock)
    (rowguid, tablenick, generation, partchangegen, lineage, colv1, marker)
    select rows.rowguid, 57128000, rows.generation, (-rows.generation), rows.lineage, rows.colv, @marker
    from (

    select @rowguid1 as rowguid, @generation1 as generation, @lineage1 as lineage, @colv1 as colv union all
    select @rowguid2 as rowguid, @generation2 as generation, @lineage2 as lineage, @colv2 as colv union all
    select @rowguid3 as rowguid, @generation3 as generation, @lineage3 as lineage, @colv3 as colv union all
    select @rowguid4 as rowguid, @generation4 as generation, @lineage4 as lineage, @colv4 as colv union all
    select @rowguid5 as rowguid, @generation5 as generation, @lineage5 as lineage, @colv5 as colv union all
    select @rowguid6 as rowguid, @generation6 as generation, @lineage6 as lineage, @colv6 as colv union all
    select @rowguid7 as rowguid, @generation7 as generation, @lineage7 as lineage, @colv7 as colv union all
    select @rowguid8 as rowguid, @generation8 as generation, @lineage8 as lineage, @colv8 as colv union all
    select @rowguid9 as rowguid, @generation9 as generation, @lineage9 as lineage, @colv9 as colv union all
    select @rowguid10 as rowguid, @generation10 as generation, @lineage10 as lineage, @colv10 as colv union all
    select @rowguid11 as rowguid, @generation11 as generation, @lineage11 as lineage, @colv11 as colv union all
    select @rowguid12 as rowguid, @generation12 as generation, @lineage12 as lineage, @colv12 as colv union all
    select @rowguid13 as rowguid, @generation13 as generation, @lineage13 as lineage, @colv13 as colv union all
    select @rowguid14 as rowguid, @generation14 as generation, @lineage14 as lineage, @colv14 as colv union all
    select @rowguid15 as rowguid, @generation15 as generation, @lineage15 as lineage, @colv15 as colv union all
    select @rowguid16 as rowguid, @generation16 as generation, @lineage16 as lineage, @colv16 as colv union all
    select @rowguid17 as rowguid, @generation17 as generation, @lineage17 as lineage, @colv17 as colv union all
    select @rowguid18 as rowguid, @generation18 as generation, @lineage18 as lineage, @colv18 as colv union all
    select @rowguid19 as rowguid, @generation19 as generation, @lineage19 as lineage, @colv19 as colv union all
    select @rowguid20 as rowguid, @generation20 as generation, @lineage20 as lineage, @colv20 as colv union all
    select @rowguid21 as rowguid, @generation21 as generation, @lineage21 as lineage, @colv21 as colv union all
    select @rowguid22 as rowguid, @generation22 as generation, @lineage22 as lineage, @colv22 as colv union all
    select @rowguid23 as rowguid, @generation23 as generation, @lineage23 as lineage, @colv23 as colv union all
    select @rowguid24 as rowguid, @generation24 as generation, @lineage24 as lineage, @colv24 as colv union all
    select @rowguid25 as rowguid, @generation25 as generation, @lineage25 as lineage, @colv25 as colv union all
    select @rowguid26 as rowguid, @generation26 as generation, @lineage26 as lineage, @colv26 as colv union all
    select @rowguid27 as rowguid, @generation27 as generation, @lineage27 as lineage, @colv27 as colv union all
    select @rowguid28 as rowguid, @generation28 as generation, @lineage28 as lineage, @colv28 as colv union all
    select @rowguid29 as rowguid, @generation29 as generation, @lineage29 as lineage, @colv29 as colv union all
    select @rowguid30 as rowguid, @generation30 as generation, @lineage30 as lineage, @colv30 as colv union all
    select @rowguid31 as rowguid, @generation31 as generation, @lineage31 as lineage, @colv31 as colv union all
    select @rowguid32 as rowguid, @generation32 as generation, @lineage32 as lineage, @colv32 as colv union all
    select @rowguid33 as rowguid, @generation33 as generation, @lineage33 as lineage, @colv33 as colv union all
    select @rowguid34 as rowguid, @generation34 as generation, @lineage34 as lineage, @colv34 as colv
 union all
    select @rowguid35 as rowguid, @generation35 as generation, @lineage35 as lineage, @colv35 as colv union all
    select @rowguid36 as rowguid, @generation36 as generation, @lineage36 as lineage, @colv36 as colv union all
    select @rowguid37 as rowguid, @generation37 as generation, @lineage37 as lineage, @colv37 as colv union all
    select @rowguid38 as rowguid, @generation38 as generation, @lineage38 as lineage, @colv38 as colv union all
    select @rowguid39 as rowguid, @generation39 as generation, @lineage39 as lineage, @colv39 as colv union all
    select @rowguid40 as rowguid, @generation40 as generation, @lineage40 as lineage, @colv40 as colv union all
    select @rowguid41 as rowguid, @generation41 as generation, @lineage41 as lineage, @colv41 as colv union all
    select @rowguid42 as rowguid, @generation42 as generation, @lineage42 as lineage, @colv42 as colv union all
    select @rowguid43 as rowguid, @generation43 as generation, @lineage43 as lineage, @colv43 as colv union all
    select @rowguid44 as rowguid, @generation44 as generation, @lineage44 as lineage, @colv44 as colv union all
    select @rowguid45 as rowguid, @generation45 as generation, @lineage45 as lineage, @colv45 as colv union all
    select @rowguid46 as rowguid, @generation46 as generation, @lineage46 as lineage, @colv46 as colv union all
    select @rowguid47 as rowguid, @generation47 as generation, @lineage47 as lineage, @colv47 as colv union all
    select @rowguid48 as rowguid, @generation48 as generation, @lineage48 as lineage, @colv48 as colv union all
    select @rowguid49 as rowguid, @generation49 as generation, @lineage49 as lineage, @colv49 as colv union all
    select @rowguid50 as rowguid, @generation50 as generation, @lineage50 as lineage, @colv50 as colv union all
    select @rowguid51 as rowguid, @generation51 as generation, @lineage51 as lineage, @colv51 as colv union all
    select @rowguid52 as rowguid, @generation52 as generation, @lineage52 as lineage, @colv52 as colv union all
    select @rowguid53 as rowguid, @generation53 as generation, @lineage53 as lineage, @colv53 as colv union all
    select @rowguid54 as rowguid, @generation54 as generation, @lineage54 as lineage, @colv54 as colv union all
    select @rowguid55 as rowguid, @generation55 as generation, @lineage55 as lineage, @colv55 as colv union all
    select @rowguid56 as rowguid, @generation56 as generation, @lineage56 as lineage, @colv56 as colv union all
    select @rowguid57 as rowguid, @generation57 as generation, @lineage57 as lineage, @colv57 as colv union all
    select @rowguid58 as rowguid, @generation58 as generation, @lineage58 as lineage, @colv58 as colv union all
    select @rowguid59 as rowguid, @generation59 as generation, @lineage59 as lineage, @colv59 as colv union all
    select @rowguid60 as rowguid, @generation60 as generation, @lineage60 as lineage, @colv60 as colv union all
    select @rowguid61 as rowguid, @generation61 as generation, @lineage61 as lineage, @colv61 as colv union all
    select @rowguid62 as rowguid, @generation62 as generation, @lineage62 as lineage, @colv62 as colv union all
    select @rowguid63 as rowguid, @generation63 as generation, @lineage63 as lineage, @colv63 as colv union all
    select @rowguid64 as rowguid, @generation64 as generation, @lineage64 as lineage, @colv64 as colv union all
    select @rowguid65 as rowguid, @generation65 as generation, @lineage65 as lineage, @colv65 as colv union all
    select @rowguid66 as rowguid, @generation66 as generation, @lineage66 as lineage, @colv66 as colv union all
    select @rowguid67 as rowguid, @generation67 as generation, @lineage67 as lineage, @colv67 as colv union all
    select @rowguid68 as rowguid, @generation68 as generation, @lineage68 as lineage, @colv68 as colv

    ) as rows
    where rows.rowguid is not NULL 

    select @rows_inserted_into_contents = @@rowcount, @error = @@error
    if @error<>0
    begin
        set @errcode=3
        goto Failure
    end

    if (@rows_inserted_into_contents <> @rows_tobe_inserted)
    begin
        raiserror(20693, 16, -1, 'HoaDon')
        set @errcode=4
        goto Failure
    end

    insert into [dbo].[HoaDon] with (rowlock) (
[MaHD]
, 
        [MaKH]
, 
        [MaSP]
, 
        [MaCN]
, 
        [MaNV]
, 
        [TenSP]
, 
        [SoLuong]
, 
        [GiaBan]
, 
        [TongTien]
, 
        [NgayLap]
, 
        [rowguid]
)
    select 
c1
, 
        c2
, 
        c3
, 
        c4
, 
        c5
, 
        c6
, 
        c7
, 
        c8
, 
        c9
, 
        c10
, 
        rowguid

    from (

    select @p1 as c1, @p2 as c2, @p3 as c3, @p4 as c4, @p5 as c5, @p6 as c6, @p7 as c7, @p8 as c8, @p9 as c9, 
        @p10 as c10, @p11 as rowguid union all
    select @p12 as c1, @p13 as c2, @p14 as c3, @p15 as c4, @p16 as c5, @p17 as c6, @p18 as c7, @p19 as c8, @p20 as c9, 
        @p21 as c10, @p22 as rowguid union all
    select @p23 as c1, @p24 as c2, @p25 as c3, @p26 as c4, @p27 as c5, @p28 as c6, @p29 as c7, @p30 as c8, @p31 as c9, 
        @p32 as c10, @p33 as rowguid union all
    select @p34 as c1, @p35 as c2, @p36 as c3, @p37 as c4, @p38 as c5, @p39 as c6, @p40 as c7, @p41 as c8, @p42 as c9, 
        @p43 as c10, @p44 as rowguid union all
    select @p45 as c1, @p46 as c2, @p47 as c3, @p48 as c4, @p49 as c5, @p50 as c6, @p51 as c7, @p52 as c8, @p53 as c9, 
        @p54 as c10, @p55 as rowguid union all
    select @p56 as c1, @p57 as c2, @p58 as c3, @p59 as c4, @p60 as c5, @p61 as c6, @p62 as c7, @p63 as c8, @p64 as c9, 
        @p65 as c10, @p66 as rowguid union all
    select @p67 as c1, @p68 as c2, @p69 as c3, @p70 as c4, @p71 as c5, @p72 as c6, @p73 as c7, @p74 as c8, @p75 as c9, 
        @p76 as c10, @p77 as rowguid union all
    select @p78 as c1, @p79 as c2, @p80 as c3, @p81 as c4, @p82 as c5, @p83 as c6, @p84 as c7, @p85 as c8, @p86 as c9, 
        @p87 as c10, @p88 as rowguid union all
    select @p89 as c1, @p90 as c2, @p91 as c3, @p92 as c4, @p93 as c5, @p94 as c6, @p95 as c7, @p96 as c8, @p97 as c9, 
        @p98 as c10, @p99 as rowguid union all
    select @p100 as c1, @p101 as c2, @p102 as c3, @p103 as c4, @p104 as c5, @p105 as c6, @p106 as c7, @p107 as c8, @p108 as c9, 
        @p109 as c10, @p110 as rowguid union all
    select @p111 as c1, @p112 as c2, @p113 as c3, @p114 as c4, @p115 as c5, @p116 as c6, @p117 as c7, @p118 as c8, @p119 as c9, 
        @p120 as c10, @p121 as rowguid union all
    select @p122 as c1, @p123 as c2, @p124 as c3, @p125 as c4, @p126 as c5, @p127 as c6, @p128 as c7, @p129 as c8, @p130 as c9, 
        @p131 as c10, @p132 as rowguid union all
    select @p133 as c1, @p134 as c2, @p135 as c3, @p136 as c4, @p137 as c5, @p138 as c6, @p139 as c7, @p140 as c8, @p141 as c9, 
        @p142 as c10, @p143 as rowguid union all
    select @p144 as c1, @p145 as c2, @p146 as c3, @p147 as c4, @p148 as c5, @p149 as c6, @p150 as c7, @p151 as c8, @p152 as c9, 
        @p153 as c10, @p154 as rowguid union all
    select @p155 as c1, @p156 as c2, @p157 as c3, @p158 as c4, @p159 as c5, @p160 as c6, @p161 as c7, @p162 as c8, @p163 as c9, 
        @p164 as c10, @p165 as rowguid union all
    select @p166 as c1, @p167 as c2, @p168 as c3, @p169 as c4, @p170 as c5, @p171 as c6, @p172 as c7, @p173 as c8, @p174 as c9, 
        @p175 as c10, @p176 as rowguid union all
    select @p177 as c1, @p178 as c2, @p179 as c3, @p180 as c4, @p181 as c5, @p182 as c6, @p183 as c7, @p184 as c8, @p185 as c9, 
        @p186 as c10, @p187 as rowguid union all
    select @p188 as c1, @p189 as c2, @p190 as c3, @p191 as c4, @p192 as c5, @p193 as c6, @p194 as c7, @p195 as c8, @p196 as c9, 
        @p197 as c10, @p198 as rowguid union all
    select @p199 as c1, @p200 as c2, @p201 as c3, @p202 as c4, @p203 as c5, @p204 as c6, @p205 as c7, @p206 as c8, @p207 as c9, 
        @p208 as c10, @p209 as rowguid union all
    select @p210 as c1, @p211 as c2, @p212 as c3, @p213 as c4, @p214 as c5, @p215 as c6, @p216 as c7, @p217 as c8, @p218 as c9, 
        @p219 as c10, @p220 as rowguid union all
    select @p221 as c1, @p222 as c2, @p223 as c3, @p224 as c4, @p225 as c5, @p226 as c6, @p227 as c7, @p228 as c8, @p229 as c9, 
        @p230 as c10, @p231 as rowguid union all
    select @p232 as c1, @p233 as c2, @p234 as c3, @p235 as c4, @p236 as c5, @p237 as c6
, @p238 as c7, @p239 as c8, @p240 as c9, 
        @p241 as c10, @p242 as rowguid union all
    select @p243 as c1, @p244 as c2, @p245 as c3, @p246 as c4, @p247 as c5, @p248 as c6, @p249 as c7, @p250 as c8, @p251 as c9, 
        @p252 as c10, @p253 as rowguid union all
    select @p254 as c1, @p255 as c2, @p256 as c3, @p257 as c4, @p258 as c5, @p259 as c6, @p260 as c7, @p261 as c8, @p262 as c9, 
        @p263 as c10, @p264 as rowguid union all
    select @p265 as c1, @p266 as c2, @p267 as c3, @p268 as c4, @p269 as c5, @p270 as c6, @p271 as c7, @p272 as c8, @p273 as c9, 
        @p274 as c10, @p275 as rowguid union all
    select @p276 as c1, @p277 as c2, @p278 as c3, @p279 as c4, @p280 as c5, @p281 as c6, @p282 as c7, @p283 as c8, @p284 as c9, 
        @p285 as c10, @p286 as rowguid union all
    select @p287 as c1, @p288 as c2, @p289 as c3, @p290 as c4, @p291 as c5, @p292 as c6, @p293 as c7, @p294 as c8, @p295 as c9, 
        @p296 as c10, @p297 as rowguid union all
    select @p298 as c1, @p299 as c2, @p300 as c3, @p301 as c4, @p302 as c5, @p303 as c6, @p304 as c7, @p305 as c8, @p306 as c9, 
        @p307 as c10, @p308 as rowguid union all
    select @p309 as c1, @p310 as c2, @p311 as c3, @p312 as c4, @p313 as c5, @p314 as c6, @p315 as c7, @p316 as c8, @p317 as c9, 
        @p318 as c10, @p319 as rowguid union all
    select @p320 as c1, @p321 as c2, @p322 as c3, @p323 as c4, @p324 as c5, @p325 as c6, @p326 as c7, @p327 as c8, @p328 as c9, 
        @p329 as c10, @p330 as rowguid union all
    select @p331 as c1, @p332 as c2, @p333 as c3, @p334 as c4, @p335 as c5, @p336 as c6, @p337 as c7, @p338 as c8, @p339 as c9, 
        @p340 as c10, @p341 as rowguid union all
    select @p342 as c1, @p343 as c2, @p344 as c3, @p345 as c4, @p346 as c5, @p347 as c6, @p348 as c7, @p349 as c8, @p350 as c9, 
        @p351 as c10, @p352 as rowguid union all
    select @p353 as c1, @p354 as c2, @p355 as c3, @p356 as c4, @p357 as c5, @p358 as c6, @p359 as c7, @p360 as c8, @p361 as c9, 
        @p362 as c10, @p363 as rowguid union all
    select @p364 as c1, @p365 as c2, @p366 as c3, @p367 as c4, @p368 as c5, @p369 as c6, @p370 as c7, @p371 as c8, @p372 as c9, 
        @p373 as c10, @p374 as rowguid union all
    select @p375 as c1, @p376 as c2, @p377 as c3, @p378 as c4, @p379 as c5, @p380 as c6, @p381 as c7, @p382 as c8, @p383 as c9, 
        @p384 as c10, @p385 as rowguid union all
    select @p386 as c1, @p387 as c2, @p388 as c3, @p389 as c4, @p390 as c5, @p391 as c6, @p392 as c7, @p393 as c8, @p394 as c9, 
        @p395 as c10, @p396 as rowguid union all
    select @p397 as c1, @p398 as c2, @p399 as c3, @p400 as c4, @p401 as c5, @p402 as c6, @p403 as c7, @p404 as c8, @p405 as c9, 
        @p406 as c10, @p407 as rowguid union all
    select @p408 as c1, @p409 as c2, @p410 as c3, @p411 as c4, @p412 as c5, @p413 as c6, @p414 as c7, @p415 as c8, @p416 as c9, 
        @p417 as c10, @p418 as rowguid union all
    select @p419 as c1, @p420 as c2, @p421 as c3, @p422 as c4, @p423 as c5, @p424 as c6, @p425 as c7, @p426 as c8, @p427 as c9, 
        @p428 as c10, @p429 as rowguid union all
    select @p430 as c1, @p431 as c2, @p432 as c3, @p433 as c4, @p434 as c5, @p435 as c6, @p436 as c7, @p437 as c8, @p438 as c9, 
        @p439 as c10, @p440 as rowguid union all
    select @p441 as c1, @p442 as c2, @p443 as c3, @p444 as c4, @p445 as c5, @p446 as c6, @p447 as c7, @p448 as c8, @p449 as c9, 
        @p450 as c10, @p451 as rowguid union all
    select @p452 as c1, @p453 as c2, @p454 as c3, @p455 as c4, @p456 as c5, @p457 as c6, @p458 as c7, @p459 as c8, @p460 as c9, 
        @p461 as c10, @p462 as rowguid union all
    select @p463 as c1, @p464 as c2, @p465 as c3, @p466 as c4
, @p467 as c5, @p468 as c6, @p469 as c7, @p470 as c8, @p471 as c9, 
        @p472 as c10, @p473 as rowguid union all
    select @p474 as c1, @p475 as c2, @p476 as c3, @p477 as c4, @p478 as c5, @p479 as c6, @p480 as c7, @p481 as c8, @p482 as c9, 
        @p483 as c10, @p484 as rowguid union all
    select @p485 as c1, @p486 as c2, @p487 as c3, @p488 as c4, @p489 as c5, @p490 as c6, @p491 as c7, @p492 as c8, @p493 as c9, 
        @p494 as c10, @p495 as rowguid union all
    select @p496 as c1, @p497 as c2, @p498 as c3, @p499 as c4, @p500 as c5, @p501 as c6, @p502 as c7, @p503 as c8, @p504 as c9, 
        @p505 as c10, @p506 as rowguid union all
    select @p507 as c1, @p508 as c2, @p509 as c3, @p510 as c4, @p511 as c5, @p512 as c6, @p513 as c7, @p514 as c8, @p515 as c9, 
        @p516 as c10, @p517 as rowguid union all
    select @p518 as c1, @p519 as c2, @p520 as c3, @p521 as c4, @p522 as c5, @p523 as c6, @p524 as c7, @p525 as c8, @p526 as c9, 
        @p527 as c10, @p528 as rowguid union all
    select @p529 as c1, @p530 as c2, @p531 as c3, @p532 as c4, @p533 as c5, @p534 as c6, @p535 as c7, @p536 as c8, @p537 as c9, 
        @p538 as c10, @p539 as rowguid union all
    select @p540 as c1, @p541 as c2, @p542 as c3, @p543 as c4, @p544 as c5, @p545 as c6, @p546 as c7, @p547 as c8, @p548 as c9, 
        @p549 as c10, @p550 as rowguid union all
    select @p551 as c1, @p552 as c2, @p553 as c3, @p554 as c4, @p555 as c5, @p556 as c6, @p557 as c7, @p558 as c8, @p559 as c9, 
        @p560 as c10, @p561 as rowguid union all
    select @p562 as c1, @p563 as c2, @p564 as c3, @p565 as c4, @p566 as c5, @p567 as c6, @p568 as c7, @p569 as c8, @p570 as c9, 
        @p571 as c10, @p572 as rowguid union all
    select @p573 as c1, @p574 as c2, @p575 as c3, @p576 as c4, @p577 as c5, @p578 as c6, @p579 as c7, @p580 as c8, @p581 as c9, 
        @p582 as c10, @p583 as rowguid union all
    select @p584 as c1, @p585 as c2, @p586 as c3, @p587 as c4, @p588 as c5, @p589 as c6, @p590 as c7, @p591 as c8, @p592 as c9, 
        @p593 as c10, @p594 as rowguid union all
    select @p595 as c1, @p596 as c2, @p597 as c3, @p598 as c4, @p599 as c5, @p600 as c6, @p601 as c7, @p602 as c8, @p603 as c9, 
        @p604 as c10, @p605 as rowguid union all
    select @p606 as c1, @p607 as c2, @p608 as c3, @p609 as c4, @p610 as c5, @p611 as c6, @p612 as c7, @p613 as c8, @p614 as c9, 
        @p615 as c10, @p616 as rowguid union all
    select @p617 as c1, @p618 as c2, @p619 as c3, @p620 as c4, @p621 as c5, @p622 as c6, @p623 as c7, @p624 as c8, @p625 as c9, 
        @p626 as c10, @p627 as rowguid union all
    select @p628 as c1, @p629 as c2, @p630 as c3, @p631 as c4, @p632 as c5, @p633 as c6, @p634 as c7, @p635 as c8, @p636 as c9, 
        @p637 as c10, @p638 as rowguid union all
    select @p639 as c1, @p640 as c2, @p641 as c3, @p642 as c4, @p643 as c5, @p644 as c6, @p645 as c7, @p646 as c8, @p647 as c9, 
        @p648 as c10, @p649 as rowguid union all
    select @p650 as c1, @p651 as c2, @p652 as c3, @p653 as c4, @p654 as c5, @p655 as c6, @p656 as c7, @p657 as c8, @p658 as c9, 
        @p659 as c10, @p660 as rowguid union all
    select @p661 as c1, @p662 as c2, @p663 as c3, @p664 as c4, @p665 as c5, @p666 as c6, @p667 as c7, @p668 as c8, @p669 as c9, 
        @p670 as c10, @p671 as rowguid union all
    select @p672 as c1, @p673 as c2, @p674 as c3, @p675 as c4, @p676 as c5, @p677 as c6, @p678 as c7, @p679 as c8, @p680 as c9, 
        @p681 as c10, @p682 as rowguid union all
    select @p683 as c1, @p684 as c2, @p685 as c3, @p686 as c4, @p687 as c5, @p688 as c6, @p689 as c7, @p690 as c8, @p691 as c9, 
        @p692 as c10, @p693 as rowguid union all
    select @p694 as c1, @p695 as c2
, @p696 as c3, @p697 as c4, @p698 as c5, @p699 as c6, @p700 as c7, @p701 as c8, @p702 as c9, 
        @p703 as c10, @p704 as rowguid union all
    select @p705 as c1, @p706 as c2, @p707 as c3, @p708 as c4, @p709 as c5, @p710 as c6, @p711 as c7, @p712 as c8, @p713 as c9, 
        @p714 as c10, @p715 as rowguid union all
    select @p716 as c1, @p717 as c2, @p718 as c3, @p719 as c4, @p720 as c5, @p721 as c6, @p722 as c7, @p723 as c8, @p724 as c9, 
        @p725 as c10, @p726 as rowguid union all
    select @p727 as c1, @p728 as c2, @p729 as c3, @p730 as c4, @p731 as c5, @p732 as c6, @p733 as c7, @p734 as c8, @p735 as c9, 
        @p736 as c10, @p737 as rowguid union all
    select @p738 as c1
, @p739 as c2
, @p740 as c3
, @p741 as c4
, @p742 as c5
, @p743 as c6
, @p744 as c7
, @p745 as c8
, @p746 as c9
, 
        @p747 as c10
, @p748 as rowguid

    ) as rows
    where rows.rowguid is not NULL
    select @rowcount = @@rowcount, @error = @@error

    if (@rowcount <> @rows_tobe_inserted) or (@error <> 0)
    begin
        set @errcode= 3
        goto Failure
    end


    exec @retcode = sys.sp_MSdeletemetadataactionrequest 'AB1F05CE-CE24-415B-8771-7EDE0EFE1D98', 57128000, 
        @rowguid1, 
        @rowguid2, 
        @rowguid3, 
        @rowguid4, 
        @rowguid5, 
        @rowguid6, 
        @rowguid7, 
        @rowguid8, 
        @rowguid9, 
        @rowguid10, 
        @rowguid11, 
        @rowguid12, 
        @rowguid13, 
        @rowguid14, 
        @rowguid15, 
        @rowguid16, 
        @rowguid17, 
        @rowguid18, 
        @rowguid19, 
        @rowguid20, 
        @rowguid21, 
        @rowguid22, 
        @rowguid23, 
        @rowguid24, 
        @rowguid25, 
        @rowguid26, 
        @rowguid27, 
        @rowguid28, 
        @rowguid29, 
        @rowguid30, 
        @rowguid31, 
        @rowguid32, 
        @rowguid33, 
        @rowguid34, 
        @rowguid35, 
        @rowguid36, 
        @rowguid37, 
        @rowguid38, 
        @rowguid39, 
        @rowguid40, 
        @rowguid41, 
        @rowguid42, 
        @rowguid43, 
        @rowguid44, 
        @rowguid45, 
        @rowguid46, 
        @rowguid47, 
        @rowguid48, 
        @rowguid49, 
        @rowguid50, 
        @rowguid51, 
        @rowguid52, 
        @rowguid53, 
        @rowguid54, 
        @rowguid55, 
        @rowguid56, 
        @rowguid57, 
        @rowguid58, 
        @rowguid59, 
        @rowguid60, 
        @rowguid61, 
        @rowguid62, 
        @rowguid63, 
        @rowguid64, 
        @rowguid65, 
        @rowguid66, 
        @rowguid67, 
        @rowguid68
    if @retcode<>0 or @@error<>0
        goto Failure
    

    commit tran
    return 1

Failure:
    rollback tran batchinsertproc
    commit tran
    return 0
end


go
create procedure dbo.[MSmerge_upd_sp_343D2BD21205418AAB1F05CECE24415B_batch] (
        @rows_tobe_updated int,
        @partition_id int = null 
,
    @rowguid1 uniqueidentifier = NULL,
    @setbm1 varbinary(125) = NULL,
    @metadata_type1 tinyint = NULL,
    @lineage_old1 varbinary(311) = NULL,
    @generation1 bigint = NULL,
    @lineage_new1 varbinary(311) = NULL,
    @colv1 varbinary(1) = NULL,
    @p1 nvarchar(30) = NULL,
    @p2 nvarchar(30) = NULL,
    @p3 nvarchar(30) = NULL,
    @p4 nvarchar(30) = NULL,
    @p5 nvarchar(30) = NULL,
    @p6 nvarchar(100) = NULL,
    @p7 int = NULL,
    @p8 money = NULL,
    @p9 money = NULL,
    @p10 datetime = NULL,
    @p11 uniqueidentifier = NULL,
    @rowguid2 uniqueidentifier = NULL,
    @setbm2 varbinary(125) = NULL,
    @metadata_type2 tinyint = NULL,
    @lineage_old2 varbinary(311) = NULL,
    @generation2 bigint = NULL,
    @lineage_new2 varbinary(311) = NULL,
    @colv2 varbinary(1) = NULL,
    @p12 nvarchar(30) = NULL,
    @p13 nvarchar(30) = NULL,
    @p14 nvarchar(30) = NULL,
    @p15 nvarchar(30) = NULL,
    @p16 nvarchar(30) = NULL,
    @p17 nvarchar(100) = NULL,
    @p18 int = NULL,
    @p19 money = NULL,
    @p20 money = NULL,
    @p21 datetime = NULL,
    @p22 uniqueidentifier = NULL,
    @rowguid3 uniqueidentifier = NULL,
    @setbm3 varbinary(125) = NULL,
    @metadata_type3 tinyint = NULL,
    @lineage_old3 varbinary(311) = NULL,
    @generation3 bigint = NULL,
    @lineage_new3 varbinary(311) = NULL,
    @colv3 varbinary(1) = NULL,
    @p23 nvarchar(30) = NULL,
    @p24 nvarchar(30) = NULL,
    @p25 nvarchar(30) = NULL,
    @p26 nvarchar(30) = NULL,
    @p27 nvarchar(30) = NULL,
    @p28 nvarchar(100) = NULL,
    @p29 int = NULL,
    @p30 money = NULL,
    @p31 money = NULL,
    @p32 datetime = NULL,
    @p33 uniqueidentifier = NULL,
    @rowguid4 uniqueidentifier = NULL,
    @setbm4 varbinary(125) = NULL,
    @metadata_type4 tinyint = NULL,
    @lineage_old4 varbinary(311) = NULL,
    @generation4 bigint = NULL,
    @lineage_new4 varbinary(311) = NULL,
    @colv4 varbinary(1) = NULL,
    @p34 nvarchar(30) = NULL,
    @p35 nvarchar(30) = NULL,
    @p36 nvarchar(30) = NULL,
    @p37 nvarchar(30) = NULL,
    @p38 nvarchar(30) = NULL,
    @p39 nvarchar(100) = NULL,
    @p40 int = NULL,
    @p41 money = NULL,
    @p42 money = NULL,
    @p43 datetime = NULL,
    @p44 uniqueidentifier = NULL,
    @rowguid5 uniqueidentifier = NULL,
    @setbm5 varbinary(125) = NULL,
    @metadata_type5 tinyint = NULL,
    @lineage_old5 varbinary(311) = NULL,
    @generation5 bigint = NULL,
    @lineage_new5 varbinary(311) = NULL,
    @colv5 varbinary(1) = NULL,
    @p45 nvarchar(30) = NULL,
    @p46 nvarchar(30) = NULL,
    @p47 nvarchar(30) = NULL,
    @p48 nvarchar(30) = NULL,
    @p49 nvarchar(30) = NULL,
    @p50 nvarchar(100) = NULL,
    @p51 int = NULL,
    @p52 money = NULL,
    @p53 money = NULL,
    @p54 datetime = NULL,
    @p55 uniqueidentifier = NULL,
    @rowguid6 uniqueidentifier = NULL,
    @setbm6 varbinary(125) = NULL,
    @metadata_type6 tinyint = NULL,
    @lineage_old6 varbinary(311) = NULL,
    @generation6 bigint = NULL,
    @lineage_new6 varbinary(311) = NULL,
    @colv6 varbinary(1) = NULL,
    @p56 nvarchar(30) = NULL,
    @p57 nvarchar(30) = NULL,
    @p58 nvarchar(30) = NULL,
    @p59 nvarchar(30) = NULL,
    @p60 nvarchar(30) = NULL,
    @p61 nvarchar(100) = NULL,
    @p62 int = NULL,
    @p63 money = NULL,
    @p64 money = NULL,
    @p65 datetime = NULL,
    @p66 uniqueidentifier = NULL,
    @rowguid7 uniqueidentifier = NULL,
    @setbm7 varbinary(125) = NULL,
    @metadata_type7 tinyint = NULL,
    @lineage_old7 varbinary(311) = NULL,
    @generation7 bigint = NULL,
    @lineage_new7 varbinary(311) = NULL,
    @colv7 varbinary(1) = NULL,
    @p67 nvarchar(30) = NULL
,
    @p68 nvarchar(30) = NULL,
    @p69 nvarchar(30) = NULL,
    @p70 nvarchar(30) = NULL,
    @p71 nvarchar(30) = NULL,
    @p72 nvarchar(100) = NULL,
    @p73 int = NULL,
    @p74 money = NULL,
    @p75 money = NULL,
    @p76 datetime = NULL,
    @p77 uniqueidentifier = NULL,
    @rowguid8 uniqueidentifier = NULL,
    @setbm8 varbinary(125) = NULL,
    @metadata_type8 tinyint = NULL,
    @lineage_old8 varbinary(311) = NULL,
    @generation8 bigint = NULL,
    @lineage_new8 varbinary(311) = NULL,
    @colv8 varbinary(1) = NULL,
    @p78 nvarchar(30) = NULL,
    @p79 nvarchar(30) = NULL,
    @p80 nvarchar(30) = NULL,
    @p81 nvarchar(30) = NULL,
    @p82 nvarchar(30) = NULL,
    @p83 nvarchar(100) = NULL,
    @p84 int = NULL,
    @p85 money = NULL,
    @p86 money = NULL,
    @p87 datetime = NULL,
    @p88 uniqueidentifier = NULL,
    @rowguid9 uniqueidentifier = NULL,
    @setbm9 varbinary(125) = NULL,
    @metadata_type9 tinyint = NULL,
    @lineage_old9 varbinary(311) = NULL,
    @generation9 bigint = NULL,
    @lineage_new9 varbinary(311) = NULL,
    @colv9 varbinary(1) = NULL,
    @p89 nvarchar(30) = NULL,
    @p90 nvarchar(30) = NULL,
    @p91 nvarchar(30) = NULL,
    @p92 nvarchar(30) = NULL,
    @p93 nvarchar(30) = NULL,
    @p94 nvarchar(100) = NULL,
    @p95 int = NULL,
    @p96 money = NULL,
    @p97 money = NULL,
    @p98 datetime = NULL,
    @p99 uniqueidentifier = NULL,
    @rowguid10 uniqueidentifier = NULL,
    @setbm10 varbinary(125) = NULL,
    @metadata_type10 tinyint = NULL,
    @lineage_old10 varbinary(311) = NULL,
    @generation10 bigint = NULL,
    @lineage_new10 varbinary(311) = NULL,
    @colv10 varbinary(1) = NULL,
    @p100 nvarchar(30) = NULL,
    @p101 nvarchar(30) = NULL,
    @p102 nvarchar(30) = NULL,
    @p103 nvarchar(30) = NULL,
    @p104 nvarchar(30) = NULL,
    @p105 nvarchar(100) = NULL,
    @p106 int = NULL,
    @p107 money = NULL,
    @p108 money = NULL,
    @p109 datetime = NULL,
    @p110 uniqueidentifier = NULL,
    @rowguid11 uniqueidentifier = NULL,
    @setbm11 varbinary(125) = NULL,
    @metadata_type11 tinyint = NULL,
    @lineage_old11 varbinary(311) = NULL,
    @generation11 bigint = NULL,
    @lineage_new11 varbinary(311) = NULL,
    @colv11 varbinary(1) = NULL,
    @p111 nvarchar(30) = NULL,
    @p112 nvarchar(30) = NULL,
    @p113 nvarchar(30) = NULL,
    @p114 nvarchar(30) = NULL,
    @p115 nvarchar(30) = NULL,
    @p116 nvarchar(100) = NULL,
    @p117 int = NULL,
    @p118 money = NULL,
    @p119 money = NULL,
    @p120 datetime = NULL,
    @p121 uniqueidentifier = NULL,
    @rowguid12 uniqueidentifier = NULL,
    @setbm12 varbinary(125) = NULL,
    @metadata_type12 tinyint = NULL,
    @lineage_old12 varbinary(311) = NULL,
    @generation12 bigint = NULL,
    @lineage_new12 varbinary(311) = NULL,
    @colv12 varbinary(1) = NULL,
    @p122 nvarchar(30) = NULL,
    @p123 nvarchar(30) = NULL,
    @p124 nvarchar(30) = NULL,
    @p125 nvarchar(30) = NULL,
    @p126 nvarchar(30) = NULL,
    @p127 nvarchar(100) = NULL,
    @p128 int = NULL,
    @p129 money = NULL,
    @p130 money = NULL,
    @p131 datetime = NULL,
    @p132 uniqueidentifier = NULL,
    @rowguid13 uniqueidentifier = NULL,
    @setbm13 varbinary(125) = NULL,
    @metadata_type13 tinyint = NULL,
    @lineage_old13 varbinary(311) = NULL,
    @generation13 bigint = NULL,
    @lineage_new13 varbinary(311) = NULL,
    @colv13 varbinary(1) = NULL,
    @p133 nvarchar(30) = NULL
,
    @p134 nvarchar(30) = NULL,
    @p135 nvarchar(30) = NULL,
    @p136 nvarchar(30) = NULL,
    @p137 nvarchar(30) = NULL,
    @p138 nvarchar(100) = NULL,
    @p139 int = NULL,
    @p140 money = NULL,
    @p141 money = NULL,
    @p142 datetime = NULL,
    @p143 uniqueidentifier = NULL,
    @rowguid14 uniqueidentifier = NULL,
    @setbm14 varbinary(125) = NULL,
    @metadata_type14 tinyint = NULL,
    @lineage_old14 varbinary(311) = NULL,
    @generation14 bigint = NULL,
    @lineage_new14 varbinary(311) = NULL,
    @colv14 varbinary(1) = NULL,
    @p144 nvarchar(30) = NULL,
    @p145 nvarchar(30) = NULL,
    @p146 nvarchar(30) = NULL,
    @p147 nvarchar(30) = NULL,
    @p148 nvarchar(30) = NULL,
    @p149 nvarchar(100) = NULL,
    @p150 int = NULL,
    @p151 money = NULL,
    @p152 money = NULL,
    @p153 datetime = NULL,
    @p154 uniqueidentifier = NULL,
    @rowguid15 uniqueidentifier = NULL,
    @setbm15 varbinary(125) = NULL,
    @metadata_type15 tinyint = NULL,
    @lineage_old15 varbinary(311) = NULL,
    @generation15 bigint = NULL,
    @lineage_new15 varbinary(311) = NULL,
    @colv15 varbinary(1) = NULL,
    @p155 nvarchar(30) = NULL,
    @p156 nvarchar(30) = NULL,
    @p157 nvarchar(30) = NULL,
    @p158 nvarchar(30) = NULL,
    @p159 nvarchar(30) = NULL,
    @p160 nvarchar(100) = NULL,
    @p161 int = NULL,
    @p162 money = NULL,
    @p163 money = NULL,
    @p164 datetime = NULL,
    @p165 uniqueidentifier = NULL,
    @rowguid16 uniqueidentifier = NULL,
    @setbm16 varbinary(125) = NULL,
    @metadata_type16 tinyint = NULL,
    @lineage_old16 varbinary(311) = NULL,
    @generation16 bigint = NULL,
    @lineage_new16 varbinary(311) = NULL,
    @colv16 varbinary(1) = NULL,
    @p166 nvarchar(30) = NULL,
    @p167 nvarchar(30) = NULL,
    @p168 nvarchar(30) = NULL,
    @p169 nvarchar(30) = NULL,
    @p170 nvarchar(30) = NULL,
    @p171 nvarchar(100) = NULL,
    @p172 int = NULL,
    @p173 money = NULL,
    @p174 money = NULL,
    @p175 datetime = NULL,
    @p176 uniqueidentifier = NULL,
    @rowguid17 uniqueidentifier = NULL,
    @setbm17 varbinary(125) = NULL,
    @metadata_type17 tinyint = NULL,
    @lineage_old17 varbinary(311) = NULL,
    @generation17 bigint = NULL,
    @lineage_new17 varbinary(311) = NULL,
    @colv17 varbinary(1) = NULL,
    @p177 nvarchar(30) = NULL,
    @p178 nvarchar(30) = NULL,
    @p179 nvarchar(30) = NULL,
    @p180 nvarchar(30) = NULL,
    @p181 nvarchar(30) = NULL,
    @p182 nvarchar(100) = NULL,
    @p183 int = NULL,
    @p184 money = NULL,
    @p185 money = NULL,
    @p186 datetime = NULL,
    @p187 uniqueidentifier = NULL,
    @rowguid18 uniqueidentifier = NULL,
    @setbm18 varbinary(125) = NULL,
    @metadata_type18 tinyint = NULL,
    @lineage_old18 varbinary(311) = NULL,
    @generation18 bigint = NULL,
    @lineage_new18 varbinary(311) = NULL,
    @colv18 varbinary(1) = NULL,
    @p188 nvarchar(30) = NULL,
    @p189 nvarchar(30) = NULL,
    @p190 nvarchar(30) = NULL,
    @p191 nvarchar(30) = NULL,
    @p192 nvarchar(30) = NULL,
    @p193 nvarchar(100) = NULL,
    @p194 int = NULL,
    @p195 money = NULL,
    @p196 money = NULL,
    @p197 datetime = NULL,
    @p198 uniqueidentifier = NULL,
    @rowguid19 uniqueidentifier = NULL,
    @setbm19 varbinary(125) = NULL,
    @metadata_type19 tinyint = NULL,
    @lineage_old19 varbinary(311) = NULL,
    @generation19 bigint = NULL,
    @lineage_new19 varbinary(311) = NULL,
    @colv19 varbinary(1) = NULL,
    @p199 nvarchar(30) = NULL
,
    @p200 nvarchar(30) = NULL,
    @p201 nvarchar(30) = NULL,
    @p202 nvarchar(30) = NULL,
    @p203 nvarchar(30) = NULL,
    @p204 nvarchar(100) = NULL,
    @p205 int = NULL,
    @p206 money = NULL,
    @p207 money = NULL,
    @p208 datetime = NULL,
    @p209 uniqueidentifier = NULL,
    @rowguid20 uniqueidentifier = NULL,
    @setbm20 varbinary(125) = NULL,
    @metadata_type20 tinyint = NULL,
    @lineage_old20 varbinary(311) = NULL,
    @generation20 bigint = NULL,
    @lineage_new20 varbinary(311) = NULL,
    @colv20 varbinary(1) = NULL,
    @p210 nvarchar(30) = NULL,
    @p211 nvarchar(30) = NULL,
    @p212 nvarchar(30) = NULL,
    @p213 nvarchar(30) = NULL,
    @p214 nvarchar(30) = NULL,
    @p215 nvarchar(100) = NULL,
    @p216 int = NULL,
    @p217 money = NULL,
    @p218 money = NULL,
    @p219 datetime = NULL,
    @p220 uniqueidentifier = NULL,
    @rowguid21 uniqueidentifier = NULL,
    @setbm21 varbinary(125) = NULL,
    @metadata_type21 tinyint = NULL,
    @lineage_old21 varbinary(311) = NULL,
    @generation21 bigint = NULL,
    @lineage_new21 varbinary(311) = NULL,
    @colv21 varbinary(1) = NULL,
    @p221 nvarchar(30) = NULL,
    @p222 nvarchar(30) = NULL,
    @p223 nvarchar(30) = NULL,
    @p224 nvarchar(30) = NULL,
    @p225 nvarchar(30) = NULL,
    @p226 nvarchar(100) = NULL,
    @p227 int = NULL,
    @p228 money = NULL,
    @p229 money = NULL,
    @p230 datetime = NULL,
    @p231 uniqueidentifier = NULL,
    @rowguid22 uniqueidentifier = NULL,
    @setbm22 varbinary(125) = NULL,
    @metadata_type22 tinyint = NULL,
    @lineage_old22 varbinary(311) = NULL,
    @generation22 bigint = NULL,
    @lineage_new22 varbinary(311) = NULL,
    @colv22 varbinary(1) = NULL,
    @p232 nvarchar(30) = NULL,
    @p233 nvarchar(30) = NULL,
    @p234 nvarchar(30) = NULL,
    @p235 nvarchar(30) = NULL,
    @p236 nvarchar(30) = NULL,
    @p237 nvarchar(100) = NULL,
    @p238 int = NULL,
    @p239 money = NULL,
    @p240 money = NULL,
    @p241 datetime = NULL,
    @p242 uniqueidentifier = NULL,
    @rowguid23 uniqueidentifier = NULL,
    @setbm23 varbinary(125) = NULL,
    @metadata_type23 tinyint = NULL,
    @lineage_old23 varbinary(311) = NULL,
    @generation23 bigint = NULL,
    @lineage_new23 varbinary(311) = NULL,
    @colv23 varbinary(1) = NULL,
    @p243 nvarchar(30) = NULL,
    @p244 nvarchar(30) = NULL,
    @p245 nvarchar(30) = NULL,
    @p246 nvarchar(30) = NULL,
    @p247 nvarchar(30) = NULL,
    @p248 nvarchar(100) = NULL,
    @p249 int = NULL,
    @p250 money = NULL,
    @p251 money = NULL,
    @p252 datetime = NULL,
    @p253 uniqueidentifier = NULL,
    @rowguid24 uniqueidentifier = NULL,
    @setbm24 varbinary(125) = NULL,
    @metadata_type24 tinyint = NULL,
    @lineage_old24 varbinary(311) = NULL,
    @generation24 bigint = NULL,
    @lineage_new24 varbinary(311) = NULL,
    @colv24 varbinary(1) = NULL,
    @p254 nvarchar(30) = NULL,
    @p255 nvarchar(30) = NULL,
    @p256 nvarchar(30) = NULL,
    @p257 nvarchar(30) = NULL,
    @p258 nvarchar(30) = NULL,
    @p259 nvarchar(100) = NULL,
    @p260 int = NULL,
    @p261 money = NULL,
    @p262 money = NULL,
    @p263 datetime = NULL,
    @p264 uniqueidentifier = NULL,
    @rowguid25 uniqueidentifier = NULL,
    @setbm25 varbinary(125) = NULL,
    @metadata_type25 tinyint = NULL,
    @lineage_old25 varbinary(311) = NULL,
    @generation25 bigint = NULL,
    @lineage_new25 varbinary(311) = NULL,
    @colv25 varbinary(1) = NULL,
    @p265 nvarchar(30) = NULL
,
    @p266 nvarchar(30) = NULL,
    @p267 nvarchar(30) = NULL,
    @p268 nvarchar(30) = NULL,
    @p269 nvarchar(30) = NULL,
    @p270 nvarchar(100) = NULL,
    @p271 int = NULL,
    @p272 money = NULL,
    @p273 money = NULL,
    @p274 datetime = NULL,
    @p275 uniqueidentifier = NULL,
    @rowguid26 uniqueidentifier = NULL,
    @setbm26 varbinary(125) = NULL,
    @metadata_type26 tinyint = NULL,
    @lineage_old26 varbinary(311) = NULL,
    @generation26 bigint = NULL,
    @lineage_new26 varbinary(311) = NULL,
    @colv26 varbinary(1) = NULL,
    @p276 nvarchar(30) = NULL,
    @p277 nvarchar(30) = NULL,
    @p278 nvarchar(30) = NULL,
    @p279 nvarchar(30) = NULL,
    @p280 nvarchar(30) = NULL,
    @p281 nvarchar(100) = NULL,
    @p282 int = NULL,
    @p283 money = NULL,
    @p284 money = NULL,
    @p285 datetime = NULL,
    @p286 uniqueidentifier = NULL,
    @rowguid27 uniqueidentifier = NULL,
    @setbm27 varbinary(125) = NULL,
    @metadata_type27 tinyint = NULL,
    @lineage_old27 varbinary(311) = NULL,
    @generation27 bigint = NULL,
    @lineage_new27 varbinary(311) = NULL,
    @colv27 varbinary(1) = NULL,
    @p287 nvarchar(30) = NULL,
    @p288 nvarchar(30) = NULL,
    @p289 nvarchar(30) = NULL,
    @p290 nvarchar(30) = NULL,
    @p291 nvarchar(30) = NULL,
    @p292 nvarchar(100) = NULL,
    @p293 int = NULL,
    @p294 money = NULL,
    @p295 money = NULL,
    @p296 datetime = NULL,
    @p297 uniqueidentifier = NULL,
    @rowguid28 uniqueidentifier = NULL,
    @setbm28 varbinary(125) = NULL,
    @metadata_type28 tinyint = NULL,
    @lineage_old28 varbinary(311) = NULL,
    @generation28 bigint = NULL,
    @lineage_new28 varbinary(311) = NULL,
    @colv28 varbinary(1) = NULL,
    @p298 nvarchar(30) = NULL,
    @p299 nvarchar(30) = NULL,
    @p300 nvarchar(30) = NULL,
    @p301 nvarchar(30) = NULL,
    @p302 nvarchar(30) = NULL,
    @p303 nvarchar(100) = NULL,
    @p304 int = NULL,
    @p305 money = NULL,
    @p306 money = NULL,
    @p307 datetime = NULL,
    @p308 uniqueidentifier = NULL,
    @rowguid29 uniqueidentifier = NULL,
    @setbm29 varbinary(125) = NULL,
    @metadata_type29 tinyint = NULL,
    @lineage_old29 varbinary(311) = NULL,
    @generation29 bigint = NULL,
    @lineage_new29 varbinary(311) = NULL,
    @colv29 varbinary(1) = NULL,
    @p309 nvarchar(30) = NULL,
    @p310 nvarchar(30) = NULL,
    @p311 nvarchar(30) = NULL,
    @p312 nvarchar(30) = NULL,
    @p313 nvarchar(30) = NULL,
    @p314 nvarchar(100) = NULL,
    @p315 int = NULL,
    @p316 money = NULL,
    @p317 money = NULL,
    @p318 datetime = NULL,
    @p319 uniqueidentifier = NULL,
    @rowguid30 uniqueidentifier = NULL,
    @setbm30 varbinary(125) = NULL,
    @metadata_type30 tinyint = NULL,
    @lineage_old30 varbinary(311) = NULL,
    @generation30 bigint = NULL,
    @lineage_new30 varbinary(311) = NULL,
    @colv30 varbinary(1) = NULL,
    @p320 nvarchar(30) = NULL,
    @p321 nvarchar(30) = NULL,
    @p322 nvarchar(30) = NULL,
    @p323 nvarchar(30) = NULL,
    @p324 nvarchar(30) = NULL,
    @p325 nvarchar(100) = NULL,
    @p326 int = NULL,
    @p327 money = NULL,
    @p328 money = NULL,
    @p329 datetime = NULL,
    @p330 uniqueidentifier = NULL,
    @rowguid31 uniqueidentifier = NULL,
    @setbm31 varbinary(125) = NULL,
    @metadata_type31 tinyint = NULL,
    @lineage_old31 varbinary(311) = NULL,
    @generation31 bigint = NULL,
    @lineage_new31 varbinary(311) = NULL,
    @colv31 varbinary(1) = NULL,
    @p331 nvarchar(30) = NULL
,
    @p332 nvarchar(30) = NULL,
    @p333 nvarchar(30) = NULL,
    @p334 nvarchar(30) = NULL,
    @p335 nvarchar(30) = NULL,
    @p336 nvarchar(100) = NULL,
    @p337 int = NULL,
    @p338 money = NULL,
    @p339 money = NULL,
    @p340 datetime = NULL,
    @p341 uniqueidentifier = NULL,
    @rowguid32 uniqueidentifier = NULL,
    @setbm32 varbinary(125) = NULL,
    @metadata_type32 tinyint = NULL,
    @lineage_old32 varbinary(311) = NULL,
    @generation32 bigint = NULL,
    @lineage_new32 varbinary(311) = NULL,
    @colv32 varbinary(1) = NULL,
    @p342 nvarchar(30) = NULL,
    @p343 nvarchar(30) = NULL,
    @p344 nvarchar(30) = NULL,
    @p345 nvarchar(30) = NULL,
    @p346 nvarchar(30) = NULL,
    @p347 nvarchar(100) = NULL,
    @p348 int = NULL,
    @p349 money = NULL,
    @p350 money = NULL,
    @p351 datetime = NULL,
    @p352 uniqueidentifier = NULL,
    @rowguid33 uniqueidentifier = NULL,
    @setbm33 varbinary(125) = NULL,
    @metadata_type33 tinyint = NULL,
    @lineage_old33 varbinary(311) = NULL,
    @generation33 bigint = NULL,
    @lineage_new33 varbinary(311) = NULL,
    @colv33 varbinary(1) = NULL,
    @p353 nvarchar(30) = NULL,
    @p354 nvarchar(30) = NULL,
    @p355 nvarchar(30) = NULL,
    @p356 nvarchar(30) = NULL,
    @p357 nvarchar(30) = NULL,
    @p358 nvarchar(100) = NULL,
    @p359 int = NULL,
    @p360 money = NULL,
    @p361 money = NULL,
    @p362 datetime = NULL,
    @p363 uniqueidentifier = NULL,
    @rowguid34 uniqueidentifier = NULL,
    @setbm34 varbinary(125) = NULL,
    @metadata_type34 tinyint = NULL,
    @lineage_old34 varbinary(311) = NULL,
    @generation34 bigint = NULL,
    @lineage_new34 varbinary(311) = NULL,
    @colv34 varbinary(1) = NULL,
    @p364 nvarchar(30) = NULL,
    @p365 nvarchar(30) = NULL,
    @p366 nvarchar(30) = NULL,
    @p367 nvarchar(30) = NULL,
    @p368 nvarchar(30) = NULL,
    @p369 nvarchar(100) = NULL,
    @p370 int = NULL,
    @p371 money = NULL,
    @p372 money = NULL,
    @p373 datetime = NULL,
    @p374 uniqueidentifier = NULL,
    @rowguid35 uniqueidentifier = NULL,
    @setbm35 varbinary(125) = NULL,
    @metadata_type35 tinyint = NULL,
    @lineage_old35 varbinary(311) = NULL,
    @generation35 bigint = NULL,
    @lineage_new35 varbinary(311) = NULL,
    @colv35 varbinary(1) = NULL,
    @p375 nvarchar(30) = NULL,
    @p376 nvarchar(30) = NULL,
    @p377 nvarchar(30) = NULL,
    @p378 nvarchar(30) = NULL,
    @p379 nvarchar(30) = NULL,
    @p380 nvarchar(100) = NULL,
    @p381 int = NULL,
    @p382 money = NULL,
    @p383 money = NULL,
    @p384 datetime = NULL,
    @p385 uniqueidentifier = NULL,
    @rowguid36 uniqueidentifier = NULL,
    @setbm36 varbinary(125) = NULL,
    @metadata_type36 tinyint = NULL,
    @lineage_old36 varbinary(311) = NULL,
    @generation36 bigint = NULL,
    @lineage_new36 varbinary(311) = NULL,
    @colv36 varbinary(1) = NULL,
    @p386 nvarchar(30) = NULL,
    @p387 nvarchar(30) = NULL,
    @p388 nvarchar(30) = NULL,
    @p389 nvarchar(30) = NULL,
    @p390 nvarchar(30) = NULL,
    @p391 nvarchar(100) = NULL,
    @p392 int = NULL,
    @p393 money = NULL,
    @p394 money = NULL,
    @p395 datetime = NULL,
    @p396 uniqueidentifier = NULL,
    @rowguid37 uniqueidentifier = NULL,
    @setbm37 varbinary(125) = NULL,
    @metadata_type37 tinyint = NULL,
    @lineage_old37 varbinary(311) = NULL,
    @generation37 bigint = NULL,
    @lineage_new37 varbinary(311) = NULL,
    @colv37 varbinary(1) = NULL,
    @p397 nvarchar(30) = NULL
,
    @p398 nvarchar(30) = NULL,
    @p399 nvarchar(30) = NULL,
    @p400 nvarchar(30) = NULL,
    @p401 nvarchar(30) = NULL,
    @p402 nvarchar(100) = NULL,
    @p403 int = NULL,
    @p404 money = NULL,
    @p405 money = NULL,
    @p406 datetime = NULL,
    @p407 uniqueidentifier = NULL,
    @rowguid38 uniqueidentifier = NULL,
    @setbm38 varbinary(125) = NULL,
    @metadata_type38 tinyint = NULL,
    @lineage_old38 varbinary(311) = NULL,
    @generation38 bigint = NULL,
    @lineage_new38 varbinary(311) = NULL,
    @colv38 varbinary(1) = NULL,
    @p408 nvarchar(30) = NULL,
    @p409 nvarchar(30) = NULL,
    @p410 nvarchar(30) = NULL,
    @p411 nvarchar(30) = NULL,
    @p412 nvarchar(30) = NULL,
    @p413 nvarchar(100) = NULL,
    @p414 int = NULL,
    @p415 money = NULL,
    @p416 money = NULL,
    @p417 datetime = NULL,
    @p418 uniqueidentifier = NULL,
    @rowguid39 uniqueidentifier = NULL,
    @setbm39 varbinary(125) = NULL,
    @metadata_type39 tinyint = NULL,
    @lineage_old39 varbinary(311) = NULL,
    @generation39 bigint = NULL,
    @lineage_new39 varbinary(311) = NULL,
    @colv39 varbinary(1) = NULL,
    @p419 nvarchar(30) = NULL,
    @p420 nvarchar(30) = NULL,
    @p421 nvarchar(30) = NULL,
    @p422 nvarchar(30) = NULL,
    @p423 nvarchar(30) = NULL,
    @p424 nvarchar(100) = NULL,
    @p425 int = NULL,
    @p426 money = NULL,
    @p427 money = NULL,
    @p428 datetime = NULL,
    @p429 uniqueidentifier = NULL,
    @rowguid40 uniqueidentifier = NULL,
    @setbm40 varbinary(125) = NULL,
    @metadata_type40 tinyint = NULL,
    @lineage_old40 varbinary(311) = NULL,
    @generation40 bigint = NULL,
    @lineage_new40 varbinary(311) = NULL,
    @colv40 varbinary(1) = NULL,
    @p430 nvarchar(30) = NULL,
    @p431 nvarchar(30) = NULL,
    @p432 nvarchar(30) = NULL,
    @p433 nvarchar(30) = NULL,
    @p434 nvarchar(30) = NULL,
    @p435 nvarchar(100) = NULL,
    @p436 int = NULL,
    @p437 money = NULL,
    @p438 money = NULL,
    @p439 datetime = NULL,
    @p440 uniqueidentifier = NULL,
    @rowguid41 uniqueidentifier = NULL,
    @setbm41 varbinary(125) = NULL,
    @metadata_type41 tinyint = NULL,
    @lineage_old41 varbinary(311) = NULL,
    @generation41 bigint = NULL,
    @lineage_new41 varbinary(311) = NULL,
    @colv41 varbinary(1) = NULL,
    @p441 nvarchar(30) = NULL,
    @p442 nvarchar(30) = NULL,
    @p443 nvarchar(30) = NULL,
    @p444 nvarchar(30) = NULL,
    @p445 nvarchar(30) = NULL,
    @p446 nvarchar(100) = NULL,
    @p447 int = NULL,
    @p448 money = NULL,
    @p449 money = NULL,
    @p450 datetime = NULL,
    @p451 uniqueidentifier = NULL,
    @rowguid42 uniqueidentifier = NULL,
    @setbm42 varbinary(125) = NULL,
    @metadata_type42 tinyint = NULL,
    @lineage_old42 varbinary(311) = NULL,
    @generation42 bigint = NULL,
    @lineage_new42 varbinary(311) = NULL,
    @colv42 varbinary(1) = NULL,
    @p452 nvarchar(30) = NULL,
    @p453 nvarchar(30) = NULL,
    @p454 nvarchar(30) = NULL,
    @p455 nvarchar(30) = NULL,
    @p456 nvarchar(30) = NULL,
    @p457 nvarchar(100) = NULL,
    @p458 int = NULL,
    @p459 money = NULL,
    @p460 money = NULL,
    @p461 datetime = NULL,
    @p462 uniqueidentifier = NULL,
    @rowguid43 uniqueidentifier = NULL,
    @setbm43 varbinary(125) = NULL,
    @metadata_type43 tinyint = NULL,
    @lineage_old43 varbinary(311) = NULL,
    @generation43 bigint = NULL,
    @lineage_new43 varbinary(311) = NULL,
    @colv43 varbinary(1) = NULL,
    @p463 nvarchar(30) = NULL
,
    @p464 nvarchar(30) = NULL,
    @p465 nvarchar(30) = NULL,
    @p466 nvarchar(30) = NULL,
    @p467 nvarchar(30) = NULL,
    @p468 nvarchar(100) = NULL,
    @p469 int = NULL,
    @p470 money = NULL,
    @p471 money = NULL,
    @p472 datetime = NULL,
    @p473 uniqueidentifier = NULL,
    @rowguid44 uniqueidentifier = NULL,
    @setbm44 varbinary(125) = NULL,
    @metadata_type44 tinyint = NULL,
    @lineage_old44 varbinary(311) = NULL,
    @generation44 bigint = NULL,
    @lineage_new44 varbinary(311) = NULL,
    @colv44 varbinary(1) = NULL,
    @p474 nvarchar(30) = NULL,
    @p475 nvarchar(30) = NULL,
    @p476 nvarchar(30) = NULL,
    @p477 nvarchar(30) = NULL,
    @p478 nvarchar(30) = NULL,
    @p479 nvarchar(100) = NULL,
    @p480 int = NULL,
    @p481 money = NULL,
    @p482 money = NULL,
    @p483 datetime = NULL,
    @p484 uniqueidentifier = NULL,
    @rowguid45 uniqueidentifier = NULL,
    @setbm45 varbinary(125) = NULL,
    @metadata_type45 tinyint = NULL,
    @lineage_old45 varbinary(311) = NULL,
    @generation45 bigint = NULL,
    @lineage_new45 varbinary(311) = NULL,
    @colv45 varbinary(1) = NULL,
    @p485 nvarchar(30) = NULL,
    @p486 nvarchar(30) = NULL,
    @p487 nvarchar(30) = NULL,
    @p488 nvarchar(30) = NULL,
    @p489 nvarchar(30) = NULL,
    @p490 nvarchar(100) = NULL,
    @p491 int = NULL,
    @p492 money = NULL,
    @p493 money = NULL,
    @p494 datetime = NULL,
    @p495 uniqueidentifier = NULL,
    @rowguid46 uniqueidentifier = NULL,
    @setbm46 varbinary(125) = NULL,
    @metadata_type46 tinyint = NULL,
    @lineage_old46 varbinary(311) = NULL,
    @generation46 bigint = NULL,
    @lineage_new46 varbinary(311) = NULL,
    @colv46 varbinary(1) = NULL,
    @p496 nvarchar(30) = NULL,
    @p497 nvarchar(30) = NULL,
    @p498 nvarchar(30) = NULL,
    @p499 nvarchar(30) = NULL,
    @p500 nvarchar(30) = NULL,
    @p501 nvarchar(100) = NULL,
    @p502 int = NULL,
    @p503 money = NULL,
    @p504 money = NULL,
    @p505 datetime = NULL,
    @p506 uniqueidentifier = NULL,
    @rowguid47 uniqueidentifier = NULL,
    @setbm47 varbinary(125) = NULL,
    @metadata_type47 tinyint = NULL,
    @lineage_old47 varbinary(311) = NULL,
    @generation47 bigint = NULL,
    @lineage_new47 varbinary(311) = NULL,
    @colv47 varbinary(1) = NULL,
    @p507 nvarchar(30) = NULL,
    @p508 nvarchar(30) = NULL,
    @p509 nvarchar(30) = NULL,
    @p510 nvarchar(30) = NULL,
    @p511 nvarchar(30) = NULL,
    @p512 nvarchar(100) = NULL,
    @p513 int = NULL,
    @p514 money = NULL,
    @p515 money = NULL,
    @p516 datetime = NULL,
    @p517 uniqueidentifier = NULL,
    @rowguid48 uniqueidentifier = NULL,
    @setbm48 varbinary(125) = NULL,
    @metadata_type48 tinyint = NULL,
    @lineage_old48 varbinary(311) = NULL,
    @generation48 bigint = NULL,
    @lineage_new48 varbinary(311) = NULL,
    @colv48 varbinary(1) = NULL,
    @p518 nvarchar(30) = NULL,
    @p519 nvarchar(30) = NULL,
    @p520 nvarchar(30) = NULL,
    @p521 nvarchar(30) = NULL,
    @p522 nvarchar(30) = NULL,
    @p523 nvarchar(100) = NULL,
    @p524 int = NULL,
    @p525 money = NULL,
    @p526 money = NULL,
    @p527 datetime = NULL,
    @p528 uniqueidentifier = NULL,
    @rowguid49 uniqueidentifier = NULL,
    @setbm49 varbinary(125) = NULL,
    @metadata_type49 tinyint = NULL,
    @lineage_old49 varbinary(311) = NULL,
    @generation49 bigint = NULL,
    @lineage_new49 varbinary(311) = NULL,
    @colv49 varbinary(1) = NULL,
    @p529 nvarchar(30) = NULL
,
    @p530 nvarchar(30) = NULL,
    @p531 nvarchar(30) = NULL,
    @p532 nvarchar(30) = NULL,
    @p533 nvarchar(30) = NULL,
    @p534 nvarchar(100) = NULL,
    @p535 int = NULL,
    @p536 money = NULL,
    @p537 money = NULL,
    @p538 datetime = NULL,
    @p539 uniqueidentifier = NULL,
    @rowguid50 uniqueidentifier = NULL,
    @setbm50 varbinary(125) = NULL,
    @metadata_type50 tinyint = NULL,
    @lineage_old50 varbinary(311) = NULL,
    @generation50 bigint = NULL,
    @lineage_new50 varbinary(311) = NULL,
    @colv50 varbinary(1) = NULL,
    @p540 nvarchar(30) = NULL,
    @p541 nvarchar(30) = NULL,
    @p542 nvarchar(30) = NULL,
    @p543 nvarchar(30) = NULL,
    @p544 nvarchar(30) = NULL,
    @p545 nvarchar(100) = NULL,
    @p546 int = NULL,
    @p547 money = NULL,
    @p548 money = NULL,
    @p549 datetime = NULL,
    @p550 uniqueidentifier = NULL,
    @rowguid51 uniqueidentifier = NULL,
    @setbm51 varbinary(125) = NULL,
    @metadata_type51 tinyint = NULL,
    @lineage_old51 varbinary(311) = NULL,
    @generation51 bigint = NULL,
    @lineage_new51 varbinary(311) = NULL,
    @colv51 varbinary(1) = NULL,
    @p551 nvarchar(30) = NULL,
    @p552 nvarchar(30) = NULL,
    @p553 nvarchar(30) = NULL,
    @p554 nvarchar(30) = NULL,
    @p555 nvarchar(30) = NULL,
    @p556 nvarchar(100) = NULL,
    @p557 int = NULL,
    @p558 money = NULL,
    @p559 money = NULL,
    @p560 datetime = NULL,
    @p561 uniqueidentifier = NULL,
    @rowguid52 uniqueidentifier = NULL,
    @setbm52 varbinary(125) = NULL,
    @metadata_type52 tinyint = NULL,
    @lineage_old52 varbinary(311) = NULL,
    @generation52 bigint = NULL,
    @lineage_new52 varbinary(311) = NULL,
    @colv52 varbinary(1) = NULL,
    @p562 nvarchar(30) = NULL,
    @p563 nvarchar(30) = NULL,
    @p564 nvarchar(30) = NULL,
    @p565 nvarchar(30) = NULL,
    @p566 nvarchar(30) = NULL,
    @p567 nvarchar(100) = NULL,
    @p568 int = NULL,
    @p569 money = NULL,
    @p570 money = NULL,
    @p571 datetime = NULL,
    @p572 uniqueidentifier = NULL,
    @rowguid53 uniqueidentifier = NULL,
    @setbm53 varbinary(125) = NULL,
    @metadata_type53 tinyint = NULL,
    @lineage_old53 varbinary(311) = NULL,
    @generation53 bigint = NULL,
    @lineage_new53 varbinary(311) = NULL,
    @colv53 varbinary(1) = NULL,
    @p573 nvarchar(30) = NULL,
    @p574 nvarchar(30) = NULL,
    @p575 nvarchar(30) = NULL,
    @p576 nvarchar(30) = NULL,
    @p577 nvarchar(30) = NULL,
    @p578 nvarchar(100) = NULL,
    @p579 int = NULL,
    @p580 money = NULL,
    @p581 money = NULL,
    @p582 datetime = NULL,
    @p583 uniqueidentifier = NULL,
    @rowguid54 uniqueidentifier = NULL,
    @setbm54 varbinary(125) = NULL,
    @metadata_type54 tinyint = NULL,
    @lineage_old54 varbinary(311) = NULL,
    @generation54 bigint = NULL,
    @lineage_new54 varbinary(311) = NULL,
    @colv54 varbinary(1) = NULL,
    @p584 nvarchar(30) = NULL,
    @p585 nvarchar(30) = NULL,
    @p586 nvarchar(30) = NULL,
    @p587 nvarchar(30) = NULL,
    @p588 nvarchar(30) = NULL,
    @p589 nvarchar(100) = NULL,
    @p590 int = NULL,
    @p591 money = NULL,
    @p592 money = NULL,
    @p593 datetime = NULL,
    @p594 uniqueidentifier = NULL,
    @rowguid55 uniqueidentifier = NULL,
    @setbm55 varbinary(125) = NULL,
    @metadata_type55 tinyint = NULL,
    @lineage_old55 varbinary(311) = NULL,
    @generation55 bigint = NULL,
    @lineage_new55 varbinary(311) = NULL,
    @colv55 varbinary(1) = NULL,
    @p595 nvarchar(30) = NULL
,
    @p596 nvarchar(30) = NULL,
    @p597 nvarchar(30) = NULL,
    @p598 nvarchar(30) = NULL,
    @p599 nvarchar(30) = NULL,
    @p600 nvarchar(100) = NULL,
    @p601 int = NULL,
    @p602 money = NULL,
    @p603 money = NULL,
    @p604 datetime = NULL,
    @p605 uniqueidentifier = NULL,
    @rowguid56 uniqueidentifier = NULL,
    @setbm56 varbinary(125) = NULL,
    @metadata_type56 tinyint = NULL,
    @lineage_old56 varbinary(311) = NULL,
    @generation56 bigint = NULL,
    @lineage_new56 varbinary(311) = NULL,
    @colv56 varbinary(1) = NULL,
    @p606 nvarchar(30) = NULL
,
    @p607 nvarchar(30) = NULL
,
    @p608 nvarchar(30) = NULL
,
    @p609 nvarchar(30) = NULL
,
    @p610 nvarchar(30) = NULL
,
    @p611 nvarchar(100) = NULL
,
    @p612 int = NULL
,
    @p613 money = NULL
,
    @p614 money = NULL
,
    @p615 datetime = NULL
,
    @p616 uniqueidentifier = NULL

) as
begin
    declare @errcode    int
    declare @retcode    int
    declare @rowcount   int
    declare @error      int
    declare @publication_number smallint
    declare @filtering_column_updated bit
    declare @rows_updated int
    declare @cont_rows_updated int
    declare @rows_in_syncview int
    
    set nocount on
    
    set @errcode= 0
    set @publication_number = 2
    
    if ({ fn ISPALUSER('AB1F05CE-CE24-415B-8771-7EDE0EFE1D98') } <> 1)
    begin
        RAISERROR (14126, 11, -1)
        return 4
    end

    if @rows_tobe_updated is NULL or @rows_tobe_updated <=0
        return 0

    select @filtering_column_updated = 0
    select @rows_updated = 0
    select @cont_rows_updated = 0 

    begin tran
    save tran batchupdateproc 

    select @filtering_column_updated = 0

    -- case 1 of setting the filtering column where we are setting it to NULL and the table has a non NULL value for this column
    select @filtering_column_updated = 1 from 
        (

            select @rowguid1 as rowguid, @p4 as c4, @setbm1 as setbm
 union all
            select @rowguid2 as rowguid, @p15 as c4, @setbm2 as setbm
 union all
            select @rowguid3 as rowguid, @p26 as c4, @setbm3 as setbm
 union all
            select @rowguid4 as rowguid, @p37 as c4, @setbm4 as setbm
 union all
            select @rowguid5 as rowguid, @p48 as c4, @setbm5 as setbm
 union all
            select @rowguid6 as rowguid, @p59 as c4, @setbm6 as setbm
 union all
            select @rowguid7 as rowguid, @p70 as c4, @setbm7 as setbm
 union all
            select @rowguid8 as rowguid, @p81 as c4, @setbm8 as setbm
 union all
            select @rowguid9 as rowguid, @p92 as c4, @setbm9 as setbm
 union all
            select @rowguid10 as rowguid, @p103 as c4, @setbm10 as setbm
 union all
            select @rowguid11 as rowguid, @p114 as c4, @setbm11 as setbm
 union all
            select @rowguid12 as rowguid, @p125 as c4, @setbm12 as setbm
 union all
            select @rowguid13 as rowguid, @p136 as c4, @setbm13 as setbm
 union all
            select @rowguid14 as rowguid, @p147 as c4, @setbm14 as setbm
 union all
            select @rowguid15 as rowguid, @p158 as c4, @setbm15 as setbm
 union all
            select @rowguid16 as rowguid, @p169 as c4, @setbm16 as setbm
 union all
            select @rowguid17 as rowguid, @p180 as c4, @setbm17 as setbm
 union all
            select @rowguid18 as rowguid, @p191 as c4, @setbm18 as setbm
 union all
            select @rowguid19 as rowguid, @p202 as c4, @setbm19 as setbm
 union all
            select @rowguid20 as rowguid, @p213 as c4, @setbm20 as setbm
 union all
            select @rowguid21 as rowguid, @p224 as c4, @setbm21 as setbm
 union all
            select @rowguid22 as rowguid, @p235 as c4, @setbm22 as setbm
 union all
            select @rowguid23 as rowguid, @p246 as c4, @setbm23 as setbm
 union all
            select @rowguid24 as rowguid, @p257 as c4, @setbm24 as setbm
 union all
            select @rowguid25 as rowguid, @p268 as c4, @setbm25 as setbm
 union all
            select @rowguid26 as rowguid, @p279 as c4, @setbm26 as setbm
 union all
            select @rowguid27 as rowguid, @p290 as c4, @setbm27 as setbm
 union all
            select @rowguid28 as rowguid, @p301 as c4, @setbm28 as setbm
 union all
            select @rowguid29 as rowguid, @p312 as c4, @setbm29 as setbm
 union all
            select @rowguid30 as rowguid, @p323 as c4, @setbm30 as setbm
 union all
            select @rowguid31 as rowguid, @p334 as c4, @setbm31 as setbm
 union all
            select @rowguid32 as rowguid, @p345 as c4, @setbm32 as setbm
 union all
            select @rowguid33 as rowguid, @p356 as c4, @setbm33 as setbm
 union all
            select @rowguid34 as rowguid, @p367 as c4, @setbm34 as setbm
 union all
            select @rowguid35 as rowguid, @p378 as c4, @setbm35 as setbm
 union all
            select @rowguid36 as rowguid, @p389 as c4, @setbm36 as setbm
 union all
            select @rowguid37 as rowguid, @p400 as c4, @setbm37 as setbm
 union all
            select @rowguid38 as rowguid, @p411 as c4, @setbm38 as setbm
 union all
            select @rowguid39 as rowguid, @p422 as c4, @setbm39 as setbm
 union all
            select @rowguid40 as rowguid, @p433 as c4, @setbm40 as setbm
 union all
            select @rowguid41 as rowguid, @p444 as c4, @setbm41 as setbm
 union all
            select @rowguid42 as rowguid, @p455 as c4, @setbm42 as setbm
 union all
            select @rowguid43 as rowguid, @p466 as c4, @setbm43 as setbm
 union all
            select @rowguid44 as rowguid, @p477 as c4, @setbm44 as setbm
 union all
            select @rowguid45 as rowguid, @p488 as c4, @setbm45 as setbm
 union all
            select @rowguid46 as rowguid, @p499 as c4, @setbm46 as setbm
 union all
            select @rowguid47 as rowguid, @p510 as c4, @setbm47 as setbm
 union all
            select @rowguid48 as rowguid, @p521 as c4, @setbm48 as setbm
 union all
            select @rowguid49 as rowguid, @p532 as c4, @setbm49 as setbm
 union all
            select @rowguid50 as rowguid, @p543 as c4, @setbm50 as setbm
 union all
            select @rowguid51 as rowguid, @p554 as c4, @setbm51 as setbm
 union all
            select @rowguid52 as rowguid, @p565 as c4, @setbm52 as setbm
 union all
            select @rowguid53 as rowguid, @p576 as c4, @setbm53 as setbm
 union all
            select @rowguid54 as rowguid, @p587 as c4, @setbm54 as setbm
 union all
            select @rowguid55 as rowguid, @p598 as c4, @setbm55 as setbm
 union all
            select @rowguid56 as rowguid, @p609 as c4, @setbm56 as setbm

        ) as rows
        inner join [dbo].[HoaDon] t with (rowlock) 
        on t.[rowguid] = rows.rowguid and rows.rowguid is not NULL
        where rows.c4 is NULL and sys.fn_IsBitSetInBitmask(rows.setbm, 4) <> 0 and t.[MaCN] is not NULL
        
    if @filtering_column_updated = 1
    begin
        raiserror(20694, 16, -1, 'HoaDon', '[MaCN]')
        set @errcode=4
        goto Failure
    end

    -- case 2 of setting the filtering column where we are setting it to a not null value and the value is not equal to the value in the table
    select @filtering_column_updated = 1 from 
        (

            select @rowguid1 as rowguid, @p4 as c4
 union all
            select @rowguid2 as rowguid, @p15 as c4
 union all
            select @rowguid3 as rowguid, @p26 as c4
 union all
            select @rowguid4 as rowguid, @p37 as c4
 union all
            select @rowguid5 as rowguid, @p48 as c4
 union all
            select @rowguid6 as rowguid, @p59 as c4
 union all
            select @rowguid7 as rowguid, @p70 as c4
 union all
            select @rowguid8 as rowguid, @p81 as c4
 union all
            select @rowguid9 as rowguid, @p92 as c4
 union all
            select @rowguid10 as rowguid, @p103 as c4
 union all
            select @rowguid11 as rowguid, @p114 as c4
 union all
            select @rowguid12 as rowguid, @p125 as c4
 union all
            select @rowguid13 as rowguid, @p136 as c4
 union all
            select @rowguid14 as rowguid, @p147 as c4
 union all
            select @rowguid15 as rowguid, @p158 as c4
 union all
            select @rowguid16 as rowguid, @p169 as c4
 union all
            select @rowguid17 as rowguid, @p180 as c4
 union all
            select @rowguid18 as rowguid, @p191 as c4
 union all
            select @rowguid19 as rowguid, @p202 as c4
 union all
            select @rowguid20 as rowguid, @p213 as c4
 union all
            select @rowguid21 as rowguid, @p224 as c4
 union all
            select @rowguid22 as rowguid, @p235 as c4
 union all
            select @rowguid23 as rowguid, @p246 as c4
 union all
            select @rowguid24 as rowguid, @p257 as c4
 union all
            select @rowguid25 as rowguid, @p268 as c4
 union all
            select @rowguid26 as rowguid, @p279 as c4
 union all
            select @rowguid27 as rowguid, @p290 as c4
 union all
            select @rowguid28 as rowguid, @p301 as c4
 union all
            select @rowguid29 as rowguid, @p312 as c4
 union all
            select @rowguid30 as rowguid, @p323 as c4
 union all
            select @rowguid31 as rowguid, @p334 as c4
 union all
            select @rowguid32 as rowguid, @p345 as c4
 union all
            select @rowguid33 as rowguid, @p356 as c4
 union all
            select @rowguid34 as rowguid, @p367 as c4
 union all
            select @rowguid35 as rowguid, @p378 as c4
 union all
            select @rowguid36 as rowguid, @p389 as c4
 union all
            select @rowguid37 as rowguid, @p400 as c4
 union all
            select @rowguid38 as rowguid, @p411 as c4
 union all
            select @rowguid39 as rowguid, @p422 as c4
 union all
            select @rowguid40 as rowguid, @p433 as c4
 union all
            select @rowguid41 as rowguid, @p444 as c4
 union all
            select @rowguid42 as rowguid, @p455 as c4
 union all
            select @rowguid43 as rowguid, @p466 as c4
 union all
            select @rowguid44 as rowguid, @p477 as c4
 union all
            select @rowguid45 as rowguid, @p488 as c4
 union all
            select @rowguid46 as rowguid, @p499 as c4
 union all
            select @rowguid47 as rowguid, @p510 as c4
 union all
            select @rowguid48 as rowguid, @p521 as c4
 union all
            select @rowguid49 as rowguid, @p532 as c4
 union all
            select @rowguid50 as rowguid, @p543 as c4
 union all
            select @rowguid51 as rowguid, @p554 as c4
 union all
            select @rowguid52 as rowguid, @p565 as c4
 union all
            select @rowguid53 as rowguid, @p576 as c4
 union all
            select @rowguid54 as rowguid, @p587 as c4
 union all
            select @rowguid55 as rowguid, @p598 as c4
 union all
            select @rowguid56 as rowguid, @p609 as c4

        ) as rows
        inner join [dbo].[HoaDon] t with (rowlock) 
        on t.[rowguid] = rows.rowguid and rows.rowguid is not NULL
        where rows.c4 is not NULL and (t.[MaCN] is NULL or t.[MaCN] <> rows.c4 )   

    if @filtering_column_updated = 1
    begin
        raiserror(20694, 16, -1, 'HoaDon', '[MaCN]')
        set @errcode=4
        goto Failure
    end

    update [dbo].[HoaDon] with (rowlock)
    set 

        [MaHD] = case when rows.c1 is NULL then (case when sys.fn_IsBitSetInBitmask(rows.setbm, 1) <> 0 then rows.c1 else t.[MaHD] end) else rows.c1 end 
,
        [MaKH] = case when rows.c2 is NULL then (case when sys.fn_IsBitSetInBitmask(rows.setbm, 2) <> 0 then rows.c2 else t.[MaKH] end) else rows.c2 end 
,
        [MaSP] = case when rows.c3 is NULL then (case when sys.fn_IsBitSetInBitmask(rows.setbm, 3) <> 0 then rows.c3 else t.[MaSP] end) else rows.c3 end 
,
        [MaNV] = case when rows.c5 is NULL then (case when sys.fn_IsBitSetInBitmask(rows.setbm, 5) <> 0 then rows.c5 else t.[MaNV] end) else rows.c5 end 
,
        [TenSP] = case when rows.c6 is NULL then (case when sys.fn_IsBitSetInBitmask(rows.setbm, 6) <> 0 then rows.c6 else t.[TenSP] end) else rows.c6 end 
,
        [SoLuong] = case when rows.c7 is NULL then (case when sys.fn_IsBitSetInBitmask(rows.setbm, 7) <> 0 then rows.c7 else t.[SoLuong] end) else rows.c7 end 
,
        [GiaBan] = case when rows.c8 is NULL then (case when sys.fn_IsBitSetInBitmask(rows.setbm, 8) <> 0 then rows.c8 else t.[GiaBan] end) else rows.c8 end 
,
        [TongTien] = case when rows.c9 is NULL then (case when sys.fn_IsBitSetInBitmask(rows.setbm, 9) <> 0 then rows.c9 else t.[TongTien] end) else rows.c9 end 
,
        [NgayLap] = case when rows.c10 is NULL then (case when sys.fn_IsBitSetInBitmask(rows.setbm, 10) <> 0 then rows.c10 else t.[NgayLap] end) else rows.c10 end 

    from (

    select @rowguid1 as rowguid, @setbm1 as setbm, @metadata_type1 as metadata_type, @lineage_old1 as lineage_old, @p1 as c1, @p2 as c2, @p3 as c3, @p5 as c5, @p6 as c6, @p7 as c7, @p8 as c8, @p9 as c9, 
            @p10 as c10 union all
    select @rowguid2 as rowguid, @setbm2 as setbm, @metadata_type2 as metadata_type, @lineage_old2 as lineage_old, @p12 as c1, @p13 as c2, @p14 as c3, @p16 as c5, @p17 as c6, @p18 as c7, @p19 as c8, @p20 as c9, 
            @p21 as c10 union all
    select @rowguid3 as rowguid, @setbm3 as setbm, @metadata_type3 as metadata_type, @lineage_old3 as lineage_old, @p23 as c1, @p24 as c2, @p25 as c3, @p27 as c5, @p28 as c6, @p29 as c7, @p30 as c8, @p31 as c9, 
            @p32 as c10 union all
    select @rowguid4 as rowguid, @setbm4 as setbm, @metadata_type4 as metadata_type, @lineage_old4 as lineage_old, @p34 as c1, @p35 as c2, @p36 as c3, @p38 as c5, @p39 as c6, @p40 as c7, @p41 as c8, @p42 as c9, 
            @p43 as c10 union all
    select @rowguid5 as rowguid, @setbm5 as setbm, @metadata_type5 as metadata_type, @lineage_old5 as lineage_old, @p45 as c1, @p46 as c2, @p47 as c3, @p49 as c5, @p50 as c6, @p51 as c7, @p52 as c8, @p53 as c9, 
            @p54 as c10 union all
    select @rowguid6 as rowguid, @setbm6 as setbm, @metadata_type6 as metadata_type, @lineage_old6 as lineage_old, @p56 as c1, @p57 as c2, @p58 as c3, @p60 as c5, @p61 as c6, @p62 as c7, @p63 as c8, @p64 as c9, 
            @p65 as c10 union all
    select @rowguid7 as rowguid, @setbm7 as setbm, @metadata_type7 as metadata_type, @lineage_old7 as lineage_old, @p67 as c1, @p68 as c2, @p69 as c3, @p71 as c5, @p72 as c6, @p73 as c7, @p74 as c8, @p75 as c9, 
            @p76 as c10 union all
    select @rowguid8 as rowguid, @setbm8 as setbm, @metadata_type8 as metadata_type, @lineage_old8 as lineage_old, @p78 as c1, @p79 as c2, @p80 as c3, @p82 as c5, @p83 as c6, @p84 as c7, @p85 as c8, @p86 as c9, 
            @p87 as c10 union all
    select @rowguid9 as rowguid, @setbm9 as setbm, @metadata_type9 as metadata_type, @lineage_old9 as lineage_old, @p89 as c1, @p90 as c2, @p91 as c3, @p93 as c5, @p94 as c6, @p95 as c7, @p96 as c8, @p97 as c9, 
            @p98 as c10 union all
    select @rowguid10 as rowguid, @setbm10 as setbm, @metadata_type10 as metadata_type, @lineage_old10 as lineage_old, @p100 as c1, @p101 as c2, @p102 as c3, @p104 as c5, @p105 as c6, @p106 as c7, @p107 as c8, @p108 as c9, 
            @p109 as c10 union all
    select @rowguid11 as rowguid, @setbm11 as setbm, @metadata_type11 as metadata_type, @lineage_old11 as lineage_old, @p111 as c1, @p112 as c2, @p113 as c3, @p115 as c5, @p116 as c6, @p117 as c7, @p118 as c8, @p119 as c9, 
            @p120 as c10 union all
    select @rowguid12 as rowguid, @setbm12 as setbm, @metadata_type12 as metadata_type, @lineage_old12 as lineage_old, @p122 as c1, @p123 as c2, @p124 as c3, @p126 as c5, @p127 as c6, @p128 as c7, @p129 as c8, @p130 as c9, 
            @p131 as c10 union all
    select @rowguid13 as rowguid, @setbm13 as setbm, @metadata_type13 as metadata_type, @lineage_old13 as lineage_old, @p133 as c1, @p134 as c2, @p135 as c3, @p137 as c5, @p138 as c6, @p139 as c7, @p140 as c8, @p141 as c9, 
            @p142 as c10 union all
    select @rowguid14 as rowguid, @setbm14 as setbm, @metadata_type14 as metadata_type, @lineage_old14 as lineage_old, @p144 as c1, @p145 as c2, @p146 as c3, @p148 as c5, @p149 as c6, @p150 as c7, @p151 as c8, @p152 as c9, 
            @p153 as c10 union all
    select @rowguid15 as rowguid, @setbm15 as setbm, @metadata_type15 as metadata_type, @lineage_old15 as lineage_old, @p155 as c1, @p156 as c2, @p157 as c3, @p159 as c5, @p160 as c6, @p161 as c7, @p162 as c8, @p163 as c9
, 
            @p164 as c10 union all
    select @rowguid16 as rowguid, @setbm16 as setbm, @metadata_type16 as metadata_type, @lineage_old16 as lineage_old, @p166 as c1, @p167 as c2, @p168 as c3, @p170 as c5, @p171 as c6, @p172 as c7, @p173 as c8, @p174 as c9, 
            @p175 as c10 union all
    select @rowguid17 as rowguid, @setbm17 as setbm, @metadata_type17 as metadata_type, @lineage_old17 as lineage_old, @p177 as c1, @p178 as c2, @p179 as c3, @p181 as c5, @p182 as c6, @p183 as c7, @p184 as c8, @p185 as c9, 
            @p186 as c10 union all
    select @rowguid18 as rowguid, @setbm18 as setbm, @metadata_type18 as metadata_type, @lineage_old18 as lineage_old, @p188 as c1, @p189 as c2, @p190 as c3, @p192 as c5, @p193 as c6, @p194 as c7, @p195 as c8, @p196 as c9, 
            @p197 as c10 union all
    select @rowguid19 as rowguid, @setbm19 as setbm, @metadata_type19 as metadata_type, @lineage_old19 as lineage_old, @p199 as c1, @p200 as c2, @p201 as c3, @p203 as c5, @p204 as c6, @p205 as c7, @p206 as c8, @p207 as c9, 
            @p208 as c10 union all
    select @rowguid20 as rowguid, @setbm20 as setbm, @metadata_type20 as metadata_type, @lineage_old20 as lineage_old, @p210 as c1, @p211 as c2, @p212 as c3, @p214 as c5, @p215 as c6, @p216 as c7, @p217 as c8, @p218 as c9, 
            @p219 as c10 union all
    select @rowguid21 as rowguid, @setbm21 as setbm, @metadata_type21 as metadata_type, @lineage_old21 as lineage_old, @p221 as c1, @p222 as c2, @p223 as c3, @p225 as c5, @p226 as c6, @p227 as c7, @p228 as c8, @p229 as c9, 
            @p230 as c10 union all
    select @rowguid22 as rowguid, @setbm22 as setbm, @metadata_type22 as metadata_type, @lineage_old22 as lineage_old, @p232 as c1, @p233 as c2, @p234 as c3, @p236 as c5, @p237 as c6, @p238 as c7, @p239 as c8, @p240 as c9, 
            @p241 as c10 union all
    select @rowguid23 as rowguid, @setbm23 as setbm, @metadata_type23 as metadata_type, @lineage_old23 as lineage_old, @p243 as c1, @p244 as c2, @p245 as c3, @p247 as c5, @p248 as c6, @p249 as c7, @p250 as c8, @p251 as c9, 
            @p252 as c10 union all
    select @rowguid24 as rowguid, @setbm24 as setbm, @metadata_type24 as metadata_type, @lineage_old24 as lineage_old, @p254 as c1, @p255 as c2, @p256 as c3, @p258 as c5, @p259 as c6, @p260 as c7, @p261 as c8, @p262 as c9, 
            @p263 as c10 union all
    select @rowguid25 as rowguid, @setbm25 as setbm, @metadata_type25 as metadata_type, @lineage_old25 as lineage_old, @p265 as c1, @p266 as c2, @p267 as c3, @p269 as c5, @p270 as c6, @p271 as c7, @p272 as c8, @p273 as c9, 
            @p274 as c10 union all
    select @rowguid26 as rowguid, @setbm26 as setbm, @metadata_type26 as metadata_type, @lineage_old26 as lineage_old, @p276 as c1, @p277 as c2, @p278 as c3, @p280 as c5, @p281 as c6, @p282 as c7, @p283 as c8, @p284 as c9, 
            @p285 as c10 union all
    select @rowguid27 as rowguid, @setbm27 as setbm, @metadata_type27 as metadata_type, @lineage_old27 as lineage_old, @p287 as c1, @p288 as c2, @p289 as c3, @p291 as c5, @p292 as c6, @p293 as c7, @p294 as c8, @p295 as c9, 
            @p296 as c10 union all
    select @rowguid28 as rowguid, @setbm28 as setbm, @metadata_type28 as metadata_type, @lineage_old28 as lineage_old, @p298 as c1, @p299 as c2, @p300 as c3, @p302 as c5, @p303 as c6, @p304 as c7, @p305 as c8, @p306 as c9, 
            @p307 as c10 union all
    select @rowguid29 as rowguid, @setbm29 as setbm, @metadata_type29 as metadata_type, @lineage_old29 as lineage_old, @p309 as c1, @p310 as c2, @p311 as c3, @p313 as c5, @p314 as c6, @p315 as c7, @p316 as c8, @p317 as c9, 
            @p318 as c10 union all
    select @rowguid30 as rowguid, @setbm30 as setbm, @metadata_type30 as metadata_type, @lineage_old30 as lineage_old, @p320 as c1
, @p321 as c2, @p322 as c3, @p324 as c5, @p325 as c6, @p326 as c7, @p327 as c8, @p328 as c9, 
            @p329 as c10 union all
    select @rowguid31 as rowguid, @setbm31 as setbm, @metadata_type31 as metadata_type, @lineage_old31 as lineage_old, @p331 as c1, @p332 as c2, @p333 as c3, @p335 as c5, @p336 as c6, @p337 as c7, @p338 as c8, @p339 as c9, 
            @p340 as c10 union all
    select @rowguid32 as rowguid, @setbm32 as setbm, @metadata_type32 as metadata_type, @lineage_old32 as lineage_old, @p342 as c1, @p343 as c2, @p344 as c3, @p346 as c5, @p347 as c6, @p348 as c7, @p349 as c8, @p350 as c9, 
            @p351 as c10 union all
    select @rowguid33 as rowguid, @setbm33 as setbm, @metadata_type33 as metadata_type, @lineage_old33 as lineage_old, @p353 as c1, @p354 as c2, @p355 as c3, @p357 as c5, @p358 as c6, @p359 as c7, @p360 as c8, @p361 as c9, 
            @p362 as c10 union all
    select @rowguid34 as rowguid, @setbm34 as setbm, @metadata_type34 as metadata_type, @lineage_old34 as lineage_old, @p364 as c1, @p365 as c2, @p366 as c3, @p368 as c5, @p369 as c6, @p370 as c7, @p371 as c8, @p372 as c9, 
            @p373 as c10 union all
    select @rowguid35 as rowguid, @setbm35 as setbm, @metadata_type35 as metadata_type, @lineage_old35 as lineage_old, @p375 as c1, @p376 as c2, @p377 as c3, @p379 as c5, @p380 as c6, @p381 as c7, @p382 as c8, @p383 as c9, 
            @p384 as c10 union all
    select @rowguid36 as rowguid, @setbm36 as setbm, @metadata_type36 as metadata_type, @lineage_old36 as lineage_old, @p386 as c1, @p387 as c2, @p388 as c3, @p390 as c5, @p391 as c6, @p392 as c7, @p393 as c8, @p394 as c9, 
            @p395 as c10 union all
    select @rowguid37 as rowguid, @setbm37 as setbm, @metadata_type37 as metadata_type, @lineage_old37 as lineage_old, @p397 as c1, @p398 as c2, @p399 as c3, @p401 as c5, @p402 as c6, @p403 as c7, @p404 as c8, @p405 as c9, 
            @p406 as c10 union all
    select @rowguid38 as rowguid, @setbm38 as setbm, @metadata_type38 as metadata_type, @lineage_old38 as lineage_old, @p408 as c1, @p409 as c2, @p410 as c3, @p412 as c5, @p413 as c6, @p414 as c7, @p415 as c8, @p416 as c9, 
            @p417 as c10 union all
    select @rowguid39 as rowguid, @setbm39 as setbm, @metadata_type39 as metadata_type, @lineage_old39 as lineage_old, @p419 as c1, @p420 as c2, @p421 as c3, @p423 as c5, @p424 as c6, @p425 as c7, @p426 as c8, @p427 as c9, 
            @p428 as c10 union all
    select @rowguid40 as rowguid, @setbm40 as setbm, @metadata_type40 as metadata_type, @lineage_old40 as lineage_old, @p430 as c1, @p431 as c2, @p432 as c3, @p434 as c5, @p435 as c6, @p436 as c7, @p437 as c8, @p438 as c9, 
            @p439 as c10 union all
    select @rowguid41 as rowguid, @setbm41 as setbm, @metadata_type41 as metadata_type, @lineage_old41 as lineage_old, @p441 as c1, @p442 as c2, @p443 as c3, @p445 as c5, @p446 as c6, @p447 as c7, @p448 as c8, @p449 as c9, 
            @p450 as c10 union all
    select @rowguid42 as rowguid, @setbm42 as setbm, @metadata_type42 as metadata_type, @lineage_old42 as lineage_old, @p452 as c1, @p453 as c2, @p454 as c3, @p456 as c5, @p457 as c6, @p458 as c7, @p459 as c8, @p460 as c9, 
            @p461 as c10 union all
    select @rowguid43 as rowguid, @setbm43 as setbm, @metadata_type43 as metadata_type, @lineage_old43 as lineage_old, @p463 as c1, @p464 as c2, @p465 as c3, @p467 as c5, @p468 as c6, @p469 as c7, @p470 as c8, @p471 as c9, 
            @p472 as c10 union all
    select @rowguid44 as rowguid, @setbm44 as setbm, @metadata_type44 as metadata_type, @lineage_old44 as lineage_old, @p474 as c1, @p475 as c2, @p476 as c3, @p478 as c5, @p479 as c6, @p480 as c7, @p481 as c8, @p482 as c9, 
            @p483 as c10
 union all
    select @rowguid45 as rowguid, @setbm45 as setbm, @metadata_type45 as metadata_type, @lineage_old45 as lineage_old, @p485 as c1, @p486 as c2, @p487 as c3, @p489 as c5, @p490 as c6, @p491 as c7, @p492 as c8, @p493 as c9, 
            @p494 as c10 union all
    select @rowguid46 as rowguid, @setbm46 as setbm, @metadata_type46 as metadata_type, @lineage_old46 as lineage_old, @p496 as c1, @p497 as c2, @p498 as c3, @p500 as c5, @p501 as c6, @p502 as c7, @p503 as c8, @p504 as c9, 
            @p505 as c10 union all
    select @rowguid47 as rowguid, @setbm47 as setbm, @metadata_type47 as metadata_type, @lineage_old47 as lineage_old, @p507 as c1, @p508 as c2, @p509 as c3, @p511 as c5, @p512 as c6, @p513 as c7, @p514 as c8, @p515 as c9, 
            @p516 as c10 union all
    select @rowguid48 as rowguid, @setbm48 as setbm, @metadata_type48 as metadata_type, @lineage_old48 as lineage_old, @p518 as c1, @p519 as c2, @p520 as c3, @p522 as c5, @p523 as c6, @p524 as c7, @p525 as c8, @p526 as c9, 
            @p527 as c10 union all
    select @rowguid49 as rowguid, @setbm49 as setbm, @metadata_type49 as metadata_type, @lineage_old49 as lineage_old, @p529 as c1, @p530 as c2, @p531 as c3, @p533 as c5, @p534 as c6, @p535 as c7, @p536 as c8, @p537 as c9, 
            @p538 as c10 union all
    select @rowguid50 as rowguid, @setbm50 as setbm, @metadata_type50 as metadata_type, @lineage_old50 as lineage_old, @p540 as c1, @p541 as c2, @p542 as c3, @p544 as c5, @p545 as c6, @p546 as c7, @p547 as c8, @p548 as c9, 
            @p549 as c10 union all
    select @rowguid51 as rowguid, @setbm51 as setbm, @metadata_type51 as metadata_type, @lineage_old51 as lineage_old, @p551 as c1, @p552 as c2, @p553 as c3, @p555 as c5, @p556 as c6, @p557 as c7, @p558 as c8, @p559 as c9, 
            @p560 as c10 union all
    select @rowguid52 as rowguid, @setbm52 as setbm, @metadata_type52 as metadata_type, @lineage_old52 as lineage_old, @p562 as c1, @p563 as c2, @p564 as c3, @p566 as c5, @p567 as c6, @p568 as c7, @p569 as c8, @p570 as c9, 
            @p571 as c10 union all
    select @rowguid53 as rowguid, @setbm53 as setbm, @metadata_type53 as metadata_type, @lineage_old53 as lineage_old, @p573 as c1, @p574 as c2, @p575 as c3, @p577 as c5, @p578 as c6, @p579 as c7, @p580 as c8, @p581 as c9, 
            @p582 as c10 union all
    select @rowguid54 as rowguid, @setbm54 as setbm, @metadata_type54 as metadata_type, @lineage_old54 as lineage_old, @p584 as c1, @p585 as c2, @p586 as c3, @p588 as c5, @p589 as c6, @p590 as c7, @p591 as c8, @p592 as c9, 
            @p593 as c10 union all
    select @rowguid55 as rowguid, @setbm55 as setbm, @metadata_type55 as metadata_type, @lineage_old55 as lineage_old, @p595 as c1, @p596 as c2, @p597 as c3, @p599 as c5, @p600 as c6, @p601 as c7, @p602 as c8, @p603 as c9, 
            @p604 as c10 union all
    select @rowguid56 as rowguid, @setbm56 as setbm, @metadata_type56 as metadata_type, @lineage_old56 as lineage_old, @p606 as c1
, @p607 as c2
, @p608 as c3
, @p610 as c5
, @p611 as c6
, @p612 as c7
, @p613 as c8
, @p614 as c9
, 
            @p615 as c10
) as rows
    inner join [dbo].[HoaDon] t with (rowlock) on rows.rowguid = t.[rowguid]
        and rows.rowguid is not null
    left outer join dbo.MSmerge_contents cont with (rowlock) on rows.rowguid = cont.rowguid 
    and cont.tablenick = 57128000
    where  ((rows.metadata_type = 2 and cont.rowguid is not NULL and cont.lineage = rows.lineage_old) or
           (rows.metadata_type = 3 and cont.rowguid is NULL))
           and rows.rowguid is not null
    
    select @rowcount = @@rowcount, @error = @@error

    select @rows_updated = @rowcount
    if (@rows_updated <> @rows_tobe_updated) or (@error <> 0)
    begin
        raiserror(20695, 16, -1, @rows_updated, @rows_tobe_updated, 'HoaDon')
        set @errcode= 3
        goto Failure
    end

    update dbo.MSmerge_contents with (rowlock)
    set generation = rows.generation,
        lineage = rows.lineage_new,
        colv1 = rows.colv
    from (

    select @rowguid1 as rowguid, @generation1 as generation, @lineage_new1 as lineage_new, @colv1 as colv union all
    select @rowguid2 as rowguid, @generation2 as generation, @lineage_new2 as lineage_new, @colv2 as colv union all
    select @rowguid3 as rowguid, @generation3 as generation, @lineage_new3 as lineage_new, @colv3 as colv union all
    select @rowguid4 as rowguid, @generation4 as generation, @lineage_new4 as lineage_new, @colv4 as colv union all
    select @rowguid5 as rowguid, @generation5 as generation, @lineage_new5 as lineage_new, @colv5 as colv union all
    select @rowguid6 as rowguid, @generation6 as generation, @lineage_new6 as lineage_new, @colv6 as colv union all
    select @rowguid7 as rowguid, @generation7 as generation, @lineage_new7 as lineage_new, @colv7 as colv union all
    select @rowguid8 as rowguid, @generation8 as generation, @lineage_new8 as lineage_new, @colv8 as colv union all
    select @rowguid9 as rowguid, @generation9 as generation, @lineage_new9 as lineage_new, @colv9 as colv union all
    select @rowguid10 as rowguid, @generation10 as generation, @lineage_new10 as lineage_new, @colv10 as colv union all
    select @rowguid11 as rowguid, @generation11 as generation, @lineage_new11 as lineage_new, @colv11 as colv union all
    select @rowguid12 as rowguid, @generation12 as generation, @lineage_new12 as lineage_new, @colv12 as colv union all
    select @rowguid13 as rowguid, @generation13 as generation, @lineage_new13 as lineage_new, @colv13 as colv union all
    select @rowguid14 as rowguid, @generation14 as generation, @lineage_new14 as lineage_new, @colv14 as colv union all
    select @rowguid15 as rowguid, @generation15 as generation, @lineage_new15 as lineage_new, @colv15 as colv union all
    select @rowguid16 as rowguid, @generation16 as generation, @lineage_new16 as lineage_new, @colv16 as colv union all
    select @rowguid17 as rowguid, @generation17 as generation, @lineage_new17 as lineage_new, @colv17 as colv union all
    select @rowguid18 as rowguid, @generation18 as generation, @lineage_new18 as lineage_new, @colv18 as colv union all
    select @rowguid19 as rowguid, @generation19 as generation, @lineage_new19 as lineage_new, @colv19 as colv union all
    select @rowguid20 as rowguid, @generation20 as generation, @lineage_new20 as lineage_new, @colv20 as colv union all
    select @rowguid21 as rowguid, @generation21 as generation, @lineage_new21 as lineage_new, @colv21 as colv union all
    select @rowguid22 as rowguid, @generation22 as generation, @lineage_new22 as lineage_new, @colv22 as colv union all
    select @rowguid23 as rowguid, @generation23 as generation, @lineage_new23 as lineage_new, @colv23 as colv union all
    select @rowguid24 as rowguid, @generation24 as generation, @lineage_new24 as lineage_new, @colv24 as colv union all
    select @rowguid25 as rowguid, @generation25 as generation, @lineage_new25 as lineage_new, @colv25 as colv union all
    select @rowguid26 as rowguid, @generation26 as generation, @lineage_new26 as lineage_new, @colv26 as colv union all
    select @rowguid27 as rowguid, @generation27 as generation, @lineage_new27 as lineage_new, @colv27 as colv union all
    select @rowguid28 as rowguid, @generation28 as generation, @lineage_new28 as lineage_new, @colv28 as colv union all
    select @rowguid29 as rowguid, @generation29 as generation, @lineage_new29 as lineage_new, @colv29 as colv union all
    select @rowguid30 as rowguid, @generation30 as generation, @lineage_new30 as lineage_new, @colv30 as colv union all
    select @rowguid31 as rowguid, @generation31 as generation, @lineage_new31 as lineage_new, @colv31 as colv union all
    select @rowguid32 as rowguid, @generation32 as generation, @lineage_new32 as lineage_new, @colv32 as colv
 union all
    select @rowguid33 as rowguid, @generation33 as generation, @lineage_new33 as lineage_new, @colv33 as colv union all
    select @rowguid34 as rowguid, @generation34 as generation, @lineage_new34 as lineage_new, @colv34 as colv union all
    select @rowguid35 as rowguid, @generation35 as generation, @lineage_new35 as lineage_new, @colv35 as colv union all
    select @rowguid36 as rowguid, @generation36 as generation, @lineage_new36 as lineage_new, @colv36 as colv union all
    select @rowguid37 as rowguid, @generation37 as generation, @lineage_new37 as lineage_new, @colv37 as colv union all
    select @rowguid38 as rowguid, @generation38 as generation, @lineage_new38 as lineage_new, @colv38 as colv union all
    select @rowguid39 as rowguid, @generation39 as generation, @lineage_new39 as lineage_new, @colv39 as colv union all
    select @rowguid40 as rowguid, @generation40 as generation, @lineage_new40 as lineage_new, @colv40 as colv union all
    select @rowguid41 as rowguid, @generation41 as generation, @lineage_new41 as lineage_new, @colv41 as colv union all
    select @rowguid42 as rowguid, @generation42 as generation, @lineage_new42 as lineage_new, @colv42 as colv union all
    select @rowguid43 as rowguid, @generation43 as generation, @lineage_new43 as lineage_new, @colv43 as colv union all
    select @rowguid44 as rowguid, @generation44 as generation, @lineage_new44 as lineage_new, @colv44 as colv union all
    select @rowguid45 as rowguid, @generation45 as generation, @lineage_new45 as lineage_new, @colv45 as colv union all
    select @rowguid46 as rowguid, @generation46 as generation, @lineage_new46 as lineage_new, @colv46 as colv union all
    select @rowguid47 as rowguid, @generation47 as generation, @lineage_new47 as lineage_new, @colv47 as colv union all
    select @rowguid48 as rowguid, @generation48 as generation, @lineage_new48 as lineage_new, @colv48 as colv union all
    select @rowguid49 as rowguid, @generation49 as generation, @lineage_new49 as lineage_new, @colv49 as colv union all
    select @rowguid50 as rowguid, @generation50 as generation, @lineage_new50 as lineage_new, @colv50 as colv union all
    select @rowguid51 as rowguid, @generation51 as generation, @lineage_new51 as lineage_new, @colv51 as colv union all
    select @rowguid52 as rowguid, @generation52 as generation, @lineage_new52 as lineage_new, @colv52 as colv union all
    select @rowguid53 as rowguid, @generation53 as generation, @lineage_new53 as lineage_new, @colv53 as colv union all
    select @rowguid54 as rowguid, @generation54 as generation, @lineage_new54 as lineage_new, @colv54 as colv union all
    select @rowguid55 as rowguid, @generation55 as generation, @lineage_new55 as lineage_new, @colv55 as colv union all
    select @rowguid56 as rowguid, @generation56 as generation, @lineage_new56 as lineage_new, @colv56 as colv

    ) as rows
    inner join dbo.MSmerge_contents cont with (rowlock) 
    on cont.rowguid = rows.rowguid and cont.tablenick = 57128000
    and rows.rowguid is not NULL 
    and rows.lineage_new is not NULL
    option (force order, loop join)
    select @cont_rows_updated = @@rowcount, @error = @@error
    if @error<>0
    begin
        set @errcode= 3
        goto Failure
    end

    if @cont_rows_updated <> @rows_tobe_updated
    begin

        insert into dbo.MSmerge_contents with (rowlock)
        (tablenick, rowguid, lineage, colv1, generation)
        select 57128000, rows.rowguid, rows.lineage_new, rows.colv, rows.generation
        from (

    select @rowguid1 as rowguid, @generation1 as generation, @lineage_new1 as lineage_new, @colv1 as colv union all
    select @rowguid2 as rowguid, @generation2 as generation, @lineage_new2 as lineage_new, @colv2 as colv union all
    select @rowguid3 as rowguid, @generation3 as generation, @lineage_new3 as lineage_new, @colv3 as colv union all
    select @rowguid4 as rowguid, @generation4 as generation, @lineage_new4 as lineage_new, @colv4 as colv union all
    select @rowguid5 as rowguid, @generation5 as generation, @lineage_new5 as lineage_new, @colv5 as colv union all
    select @rowguid6 as rowguid, @generation6 as generation, @lineage_new6 as lineage_new, @colv6 as colv union all
    select @rowguid7 as rowguid, @generation7 as generation, @lineage_new7 as lineage_new, @colv7 as colv union all
    select @rowguid8 as rowguid, @generation8 as generation, @lineage_new8 as lineage_new, @colv8 as colv union all
    select @rowguid9 as rowguid, @generation9 as generation, @lineage_new9 as lineage_new, @colv9 as colv union all
    select @rowguid10 as rowguid, @generation10 as generation, @lineage_new10 as lineage_new, @colv10 as colv union all
    select @rowguid11 as rowguid, @generation11 as generation, @lineage_new11 as lineage_new, @colv11 as colv union all
    select @rowguid12 as rowguid, @generation12 as generation, @lineage_new12 as lineage_new, @colv12 as colv union all
    select @rowguid13 as rowguid, @generation13 as generation, @lineage_new13 as lineage_new, @colv13 as colv union all
    select @rowguid14 as rowguid, @generation14 as generation, @lineage_new14 as lineage_new, @colv14 as colv union all
    select @rowguid15 as rowguid, @generation15 as generation, @lineage_new15 as lineage_new, @colv15 as colv union all
    select @rowguid16 as rowguid, @generation16 as generation, @lineage_new16 as lineage_new, @colv16 as colv union all
    select @rowguid17 as rowguid, @generation17 as generation, @lineage_new17 as lineage_new, @colv17 as colv union all
    select @rowguid18 as rowguid, @generation18 as generation, @lineage_new18 as lineage_new, @colv18 as colv union all
    select @rowguid19 as rowguid, @generation19 as generation, @lineage_new19 as lineage_new, @colv19 as colv union all
    select @rowguid20 as rowguid, @generation20 as generation, @lineage_new20 as lineage_new, @colv20 as colv union all
    select @rowguid21 as rowguid, @generation21 as generation, @lineage_new21 as lineage_new, @colv21 as colv union all
    select @rowguid22 as rowguid, @generation22 as generation, @lineage_new22 as lineage_new, @colv22 as colv union all
    select @rowguid23 as rowguid, @generation23 as generation, @lineage_new23 as lineage_new, @colv23 as colv union all
    select @rowguid24 as rowguid, @generation24 as generation, @lineage_new24 as lineage_new, @colv24 as colv union all
    select @rowguid25 as rowguid, @generation25 as generation, @lineage_new25 as lineage_new, @colv25 as colv union all
    select @rowguid26 as rowguid, @generation26 as generation, @lineage_new26 as lineage_new, @colv26 as colv union all
    select @rowguid27 as rowguid, @generation27 as generation, @lineage_new27 as lineage_new, @colv27 as colv union all
    select @rowguid28 as rowguid, @generation28 as generation, @lineage_new28 as lineage_new, @colv28 as colv union all
    select @rowguid29 as rowguid, @generation29 as generation, @lineage_new29 as lineage_new, @colv29 as colv union all
    select @rowguid30 as rowguid, @generation30 as generation, @lineage_new30 as lineage_new, @colv30 as colv union all
    select @rowguid31 as rowguid, @generation31 as generation, @lineage_new31 as lineage_new, @colv31 as colv union all
    select @rowguid32 as rowguid, @generation32 as generation, @lineage_new32 as lineage_new, @colv32 as colv
 union all
    select @rowguid33 as rowguid, @generation33 as generation, @lineage_new33 as lineage_new, @colv33 as colv union all
    select @rowguid34 as rowguid, @generation34 as generation, @lineage_new34 as lineage_new, @colv34 as colv union all
    select @rowguid35 as rowguid, @generation35 as generation, @lineage_new35 as lineage_new, @colv35 as colv union all
    select @rowguid36 as rowguid, @generation36 as generation, @lineage_new36 as lineage_new, @colv36 as colv union all
    select @rowguid37 as rowguid, @generation37 as generation, @lineage_new37 as lineage_new, @colv37 as colv union all
    select @rowguid38 as rowguid, @generation38 as generation, @lineage_new38 as lineage_new, @colv38 as colv union all
    select @rowguid39 as rowguid, @generation39 as generation, @lineage_new39 as lineage_new, @colv39 as colv union all
    select @rowguid40 as rowguid, @generation40 as generation, @lineage_new40 as lineage_new, @colv40 as colv union all
    select @rowguid41 as rowguid, @generation41 as generation, @lineage_new41 as lineage_new, @colv41 as colv union all
    select @rowguid42 as rowguid, @generation42 as generation, @lineage_new42 as lineage_new, @colv42 as colv union all
    select @rowguid43 as rowguid, @generation43 as generation, @lineage_new43 as lineage_new, @colv43 as colv union all
    select @rowguid44 as rowguid, @generation44 as generation, @lineage_new44 as lineage_new, @colv44 as colv union all
    select @rowguid45 as rowguid, @generation45 as generation, @lineage_new45 as lineage_new, @colv45 as colv union all
    select @rowguid46 as rowguid, @generation46 as generation, @lineage_new46 as lineage_new, @colv46 as colv union all
    select @rowguid47 as rowguid, @generation47 as generation, @lineage_new47 as lineage_new, @colv47 as colv union all
    select @rowguid48 as rowguid, @generation48 as generation, @lineage_new48 as lineage_new, @colv48 as colv union all
    select @rowguid49 as rowguid, @generation49 as generation, @lineage_new49 as lineage_new, @colv49 as colv union all
    select @rowguid50 as rowguid, @generation50 as generation, @lineage_new50 as lineage_new, @colv50 as colv union all
    select @rowguid51 as rowguid, @generation51 as generation, @lineage_new51 as lineage_new, @colv51 as colv union all
    select @rowguid52 as rowguid, @generation52 as generation, @lineage_new52 as lineage_new, @colv52 as colv union all
    select @rowguid53 as rowguid, @generation53 as generation, @lineage_new53 as lineage_new, @colv53 as colv union all
    select @rowguid54 as rowguid, @generation54 as generation, @lineage_new54 as lineage_new, @colv54 as colv union all
    select @rowguid55 as rowguid, @generation55 as generation, @lineage_new55 as lineage_new, @colv55 as colv union all
    select @rowguid56 as rowguid, @generation56 as generation, @lineage_new56 as lineage_new, @colv56 as colv

        ) as rows
        left outer join dbo.MSmerge_contents cont with (rowlock) 
        on cont.rowguid = rows.rowguid and cont.tablenick = 57128000
        and rows.rowguid is not NULL
        and rows.lineage_new is not NULL
        where cont.rowguid is NULL
        and rows.rowguid is not NULL
        and rows.lineage_new is not NULL
        
        if @@error<>0
        begin
            set @errcode= 3
            goto Failure
        end
    end

    exec @retcode = sys.sp_MSdeletemetadataactionrequest 'AB1F05CE-CE24-415B-8771-7EDE0EFE1D98', 57128000, 
        @rowguid1, 
        @rowguid2, 
        @rowguid3, 
        @rowguid4, 
        @rowguid5, 
        @rowguid6, 
        @rowguid7, 
        @rowguid8, 
        @rowguid9, 
        @rowguid10, 
        @rowguid11, 
        @rowguid12, 
        @rowguid13, 
        @rowguid14, 
        @rowguid15, 
        @rowguid16, 
        @rowguid17, 
        @rowguid18, 
        @rowguid19, 
        @rowguid20, 
        @rowguid21, 
        @rowguid22, 
        @rowguid23, 
        @rowguid24, 
        @rowguid25, 
        @rowguid26, 
        @rowguid27, 
        @rowguid28, 
        @rowguid29, 
        @rowguid30, 
        @rowguid31, 
        @rowguid32, 
        @rowguid33, 
        @rowguid34, 
        @rowguid35, 
        @rowguid36, 
        @rowguid37, 
        @rowguid38, 
        @rowguid39, 
        @rowguid40, 
        @rowguid41, 
        @rowguid42, 
        @rowguid43, 
        @rowguid44, 
        @rowguid45, 
        @rowguid46, 
        @rowguid47, 
        @rowguid48, 
        @rowguid49, 
        @rowguid50, 
        @rowguid51, 
        @rowguid52, 
        @rowguid53, 
        @rowguid54, 
        @rowguid55, 
        @rowguid56
    if @retcode<>0 or @@error<>0
        goto Failure
    

    commit tran
    return 1

Failure:
    rollback tran batchupdateproc
    commit tran
    return 0
end


go

update dbo.sysmergepartitioninfo 
    set column_list = 't.*', 
        column_list_blob = 't.*'
    where artid = '343D2BD2-1205-418A-8290-8C7DE8FA4CF1' and pubid = 'AB1F05CE-CE24-415B-8771-7EDE0EFE1D98'

go
SET ANSI_NULLS ON SET QUOTED_IDENTIFIER ON

go

    create procedure dbo.[MSmerge_sel_sp_343D2BD21205418AAB1F05CECE24415B] (
        @maxschemaguidforarticle uniqueidentifier,
        @type int output, 
        @rowguid uniqueidentifier=NULL,
        @enumentirerowmetadata bit= 1,
        @blob_cols_at_the_end bit=0,
        @logical_record_parent_rowguid uniqueidentifier = '00000000-0000-0000-0000-000000000000',
        @metadata_type tinyint = 0,
        @lineage_old varbinary(311) = NULL,
        @rowcount int = NULL output
        ) 
    as
    begin
        declare @retcode    int
        
        set nocount on
            
        if ({ fn ISPALUSER('AB1F05CE-CE24-415B-8771-7EDE0EFE1D98') } <> 1)
        begin       
            RAISERROR (14126, 11, -1)
            return (1)
        end 

    if @type = 1
        begin
            select 
t.*
          from [dbo].[HoaDon] t where rowguidcol = @rowguid
        if @@ERROR<>0 return(1)
    end 
    else if @type < 4 
        begin
            -- case one: no blob gen optimization
            if @blob_cols_at_the_end=0
            begin
                select 
                c.tablenick, 
                c.rowguid, 
                c.generation,
                case @enumentirerowmetadata
                    when 0 then null
                    else c.lineage
                end as lineage,
                case @enumentirerowmetadata
                    when 0 then null
                    else c.colv1
                end as colv1,
                
t.*

                from #cont c , [dbo].[HoaDon] t with (rowlock)
                where t.rowguidcol = c.rowguid
                order by t.rowguidcol 
                
            if @@ERROR<>0 return(1)
            end
  
            -- case two: blob gen optimization
            else 
            begin
                select 
                c.tablenick, 
                c.rowguid, 
                c.generation,
                case @enumentirerowmetadata
                    when 0 then null
                    else c.lineage
                end as lineage,
                case @enumentirerowmetadata
                    when 0 then null
                    else c.colv1
                end as colv1,
t.*

                from #cont c,[dbo].[HoaDon] t with (rowlock)
              where t.rowguidcol = c.rowguid
                 order by t.rowguidcol 
                 
            if @@ERROR<>0 return(1)
            end
        end
   else if @type = 4
    begin
        set @type = 0
        if exists (select * from [dbo].[HoaDon] where rowguidcol = @rowguid)
            set @type = 3
        if @@ERROR<>0 return(1)
    end

    else if @type = 5
    begin
         
        delete [dbo].[HoaDon] where rowguidcol = @rowguid
        if @@ERROR<>0 return(1)

        delete from dbo.MSmerge_metadataaction_request
            where tablenick=57128000 and rowguid=@rowguid
    end 

    else if @type = 6 -- sp_MSenumcolumns
    begin
        select 
t.*
         from [dbo].[HoaDon] t where 1=2
        if @@ERROR<>0 return(1)
    end

    else if @type = 7 -- sp_MSlocktable
    begin
        select 1 from [dbo].[HoaDon] with (tablock holdlock) where 1 = 2
        if @@ERROR<>0 return(1)
    end

    else if @type = 8 -- put update lock
    begin
        if not exists (select * from [dbo].[HoaDon] with (UPDLOCK HOLDLOCK) where rowguidcol = @rowguid)
        begin
            RAISERROR(20031 , 16, -1)
            return(1)
        end
    end
    else if @type = 9
    begin
        declare @oldmaxversion int, @replnick binary(6)
                , @cur_article_rowcount int, @column_tracking int
                        
        select @replnick = 0xd5e45bedbd38

        select top 1 @oldmaxversion = maxversion_at_cleanup,
                     @column_tracking = column_tracking
        from dbo.sysmergearticles 
        where nickname = 57128000
        
        select @cur_article_rowcount = count(*) from #rows 
        where tablenick = 57128000
            
        update dbo.MSmerge_contents 
        set lineage = { fn UPDATELINEAGE(lineage, @replnick, @oldmaxversion+1) }
        where tablenick = 57128000
        and rowguid in (select rowguid from #rows where tablenick = 57128000) 

        if @@rowcount <> @cur_article_rowcount
        begin
            declare @lineage varbinary(311), @colv1 varbinary(1)
                    , @cur_rowguid uniqueidentifier, @prev_rowguid uniqueidentifier
            set @lineage = { fn UPDATELINEAGE(0x0, @replnick, @oldmaxversion+1) }
            if @column_tracking <> 0
                set @colv1 = 0xFF
            else
                set @colv1 = NULL
                
            select top 1 @cur_rowguid = rowguid from #rows
            where tablenick = 57128000
            order by rowguid
            
            while @cur_rowguid is not null
            begin
                if not exists (select * from dbo.MSmerge_contents 
                                where tablenick = 57128000
                                and rowguid = @cur_rowguid)
                begin
                    begin tran 
                    save tran insert_contents_row 

                    if exists (select * from [dbo].[HoaDon]with (holdlock) where rowguidcol = @cur_rowguid)
                    begin
                        exec @retcode = sys.sp_MSevaluate_change_membership_for_row @tablenick = 57128000, @rowguid = @cur_rowguid
                        if @retcode <> 0 or @@error <> 0
                        begin
                            rollback tran insert_contents_row
                            return 1
                        end
                        insert into dbo.MSmerge_contents (rowguid, tablenick, generation, lineage, colv1, logical_record_parent_rowguid)
                            values (@cur_rowguid, 57128000, 0, @lineage, @colv1, @logical_record_parent_rowguid)
                    end
                    commit tran
                end
                
                select @prev_rowguid = @cur_rowguid
                select @cur_rowguid = NULL
                
                select top 1 @cur_rowguid = rowguid from #rows
                where tablenick = 57128000
                and rowguid > @prev_rowguid
                order by rowguid
            end
        end 

        select 
            r.tablenick, 
            r.rowguid, 
            mc.generation,
            case @enumentirerowmetadata
                when 0 then null
                else mc.lineage
            end,
            case @enumentirerowmetadata
                when 0 then null
                else mc.colv1
            end,
            
t.*
         from #rows r left outer join [dbo].[HoaDon] t on r.rowguid = t.rowguidcol and r.tablenick = 57128000
                 left outer join dbo.MSmerge_contents mc on
                 mc.tablenick = 57128000 and mc.rowguid = t.rowguidcol
                 where r.tablenick = 57128000
         order by r.idx
         
        if @@ERROR<>0 return(1)
    end 

        else if @type = 10  
        begin
            select 
                c.tablenick, 
                c.rowguid, 
                c.generation,
                case @enumentirerowmetadata
                    when 0 then null
                    else c.lineage
                end,
                case @enumentirerowmetadata
                    when 0 then null
                    else c.colv1
                end,
                null,
                
t.*
         from #cont c,[dbo].[HoaDon] t with (rowlock) where
                      t.rowguidcol = c.rowguid
             order by t.rowguidcol 
                        
            if @@ERROR<>0 return(1)
        end

    else if @type = 11
    begin
         
        -- we will do a delete with metadata match
        if @metadata_type = 0
        begin
            delete from [dbo].[HoaDon] where [rowguid] = @rowguid
            select @rowcount = @@rowcount
            if @rowcount <> 1
            begin
                RAISERROR(20031 , 16, -1)
                return(1)
            end
        end
        else
        begin
            if @metadata_type = 3
                delete [dbo].[HoaDon] from [dbo].[HoaDon] t
                    where t.[rowguid] = @rowguid and 
                        not exists (select 1 from dbo.MSmerge_contents c with (rowlock) where
                                                c.rowguid = @rowguid and
                                                c.tablenick = 57128000)
            else if @metadata_type = 5 or @metadata_type = 6
                delete [dbo].[HoaDon] from [dbo].[HoaDon] t
                    where t.[rowguid] = @rowguid and 
                         not exists (select 1 from dbo.MSmerge_contents c with (rowlock) where
                                                c.rowguid = @rowguid and
                                                c.tablenick = 57128000 and
                                                c.lineage <> @lineage_old)
                                                
            else
                delete [dbo].[HoaDon] from [dbo].[HoaDon] t
                    where t.[rowguid] = @rowguid and 
                         exists (select 1 from dbo.MSmerge_contents c with (rowlock) where
                                                c.rowguid = @rowguid and
                                                c.tablenick = 57128000 and
                                                c.lineage = @lineage_old)
            select @rowcount = @@rowcount
            if @rowcount <> 1 
            begin
                if not exists (select * from [dbo].[HoaDon] where [rowguid] = @rowguid)
                begin
                    RAISERROR(20031 , 16, -1)
                    return(1)
                end
            end
        end
        if @@ERROR<>0 
        begin
            delete from dbo.MSmerge_metadataaction_request
                where tablenick=57128000 and rowguid=@rowguid

            return(1)
        end        
    end

    else if @type = 12
    begin 
        -- this type indicates metadata type selection
        declare @maxversion int
        declare @error int
        
        select @maxversion= maxversion_at_cleanup from dbo.sysmergearticles 
            where nickname = 57128000 and pubid = 'AB1F05CE-CE24-415B-8771-7EDE0EFE1D98'
        if @error <> 0 
            return 1
        select case when (cont.generation is NULL and tomb.generation is null) 
                    then 0 
                    else isnull(cont.generation, tomb.generation) 
               end as generation, 
               case when t.[rowguid] is null 
                    then (case when tomb.rowguid is NULL then 0 else tomb.type end) 
                    else (case when cont.rowguid is null then 3 else 2 end) 
               end as type,
               case when tomb.rowguid is null 
                    then cont.lineage 
                    else tomb.lineage
               end as lineage, 
               cont.colv1 as colv, 
               @maxversion as maxversion
        from
        (select @rowguid as rowguid) as rows 
        left outer join [dbo].[HoaDon] t with (rowlock) 
        on t.[rowguid] = rows.rowguid
        and rows.rowguid is not null
        left outer join dbo.MSmerge_contents cont with (rowlock) 
        on cont.rowguid = rows.rowguid and cont.tablenick = 57128000
        left outer join dbo.MSmerge_tombstone tomb with (rowlock) 
        on tomb.rowguid = rows.rowguid and tomb.tablenick = 57128000
        where rows.rowguid is not null
        
        select @error = @@error
        if @error <> 0 
        begin
            --raiserror(@error, 16, -1)
            return 1
        end
    end

    return(0)
end


go

create procedure dbo.[MSmerge_sel_sp_343D2BD21205418AAB1F05CECE24415B_metadata]
( 
    @rowguid1 uniqueidentifier,
    @rowguid2 uniqueidentifier = NULL,
    @rowguid3 uniqueidentifier = NULL,
    @rowguid4 uniqueidentifier = NULL,
    @rowguid5 uniqueidentifier = NULL,
    @rowguid6 uniqueidentifier = NULL,
    @rowguid7 uniqueidentifier = NULL,
    @rowguid8 uniqueidentifier = NULL,
    @rowguid9 uniqueidentifier = NULL,
    @rowguid10 uniqueidentifier = NULL,
    @rowguid11 uniqueidentifier = NULL,
    @rowguid12 uniqueidentifier = NULL,
    @rowguid13 uniqueidentifier = NULL,
    @rowguid14 uniqueidentifier = NULL,
    @rowguid15 uniqueidentifier = NULL,
    @rowguid16 uniqueidentifier = NULL,
    @rowguid17 uniqueidentifier = NULL,
    @rowguid18 uniqueidentifier = NULL,
    @rowguid19 uniqueidentifier = NULL,
    @rowguid20 uniqueidentifier = NULL,
    @rowguid21 uniqueidentifier = NULL,
    @rowguid22 uniqueidentifier = NULL,
    @rowguid23 uniqueidentifier = NULL,
    @rowguid24 uniqueidentifier = NULL,
    @rowguid25 uniqueidentifier = NULL,
    @rowguid26 uniqueidentifier = NULL,
    @rowguid27 uniqueidentifier = NULL,
    @rowguid28 uniqueidentifier = NULL,
    @rowguid29 uniqueidentifier = NULL,
    @rowguid30 uniqueidentifier = NULL,
    @rowguid31 uniqueidentifier = NULL,
    @rowguid32 uniqueidentifier = NULL,
    @rowguid33 uniqueidentifier = NULL,
    @rowguid34 uniqueidentifier = NULL,
    @rowguid35 uniqueidentifier = NULL,
    @rowguid36 uniqueidentifier = NULL,
    @rowguid37 uniqueidentifier = NULL,
    @rowguid38 uniqueidentifier = NULL,
    @rowguid39 uniqueidentifier = NULL,
    @rowguid40 uniqueidentifier = NULL,
    @rowguid41 uniqueidentifier = NULL,
    @rowguid42 uniqueidentifier = NULL,
    @rowguid43 uniqueidentifier = NULL,
    @rowguid44 uniqueidentifier = NULL,
    @rowguid45 uniqueidentifier = NULL,
    @rowguid46 uniqueidentifier = NULL,
    @rowguid47 uniqueidentifier = NULL,
    @rowguid48 uniqueidentifier = NULL,
    @rowguid49 uniqueidentifier = NULL,
    @rowguid50 uniqueidentifier = NULL,

    @rowguid51 uniqueidentifier = NULL,
    @rowguid52 uniqueidentifier = NULL,
    @rowguid53 uniqueidentifier = NULL,
    @rowguid54 uniqueidentifier = NULL,
    @rowguid55 uniqueidentifier = NULL,
    @rowguid56 uniqueidentifier = NULL,
    @rowguid57 uniqueidentifier = NULL,
    @rowguid58 uniqueidentifier = NULL,
    @rowguid59 uniqueidentifier = NULL,
    @rowguid60 uniqueidentifier = NULL,
    @rowguid61 uniqueidentifier = NULL,
    @rowguid62 uniqueidentifier = NULL,
    @rowguid63 uniqueidentifier = NULL,
    @rowguid64 uniqueidentifier = NULL,
    @rowguid65 uniqueidentifier = NULL,
    @rowguid66 uniqueidentifier = NULL,
    @rowguid67 uniqueidentifier = NULL,
    @rowguid68 uniqueidentifier = NULL,
    @rowguid69 uniqueidentifier = NULL,
    @rowguid70 uniqueidentifier = NULL,
    @rowguid71 uniqueidentifier = NULL,
    @rowguid72 uniqueidentifier = NULL,
    @rowguid73 uniqueidentifier = NULL,
    @rowguid74 uniqueidentifier = NULL,
    @rowguid75 uniqueidentifier = NULL,
    @rowguid76 uniqueidentifier = NULL,
    @rowguid77 uniqueidentifier = NULL,
    @rowguid78 uniqueidentifier = NULL,
    @rowguid79 uniqueidentifier = NULL,
    @rowguid80 uniqueidentifier = NULL,
    @rowguid81 uniqueidentifier = NULL,
    @rowguid82 uniqueidentifier = NULL,
    @rowguid83 uniqueidentifier = NULL,
    @rowguid84 uniqueidentifier = NULL,
    @rowguid85 uniqueidentifier = NULL,
    @rowguid86 uniqueidentifier = NULL,
    @rowguid87 uniqueidentifier = NULL,
    @rowguid88 uniqueidentifier = NULL,
    @rowguid89 uniqueidentifier = NULL,
    @rowguid90 uniqueidentifier = NULL,
    @rowguid91 uniqueidentifier = NULL,
    @rowguid92 uniqueidentifier = NULL,
    @rowguid93 uniqueidentifier = NULL,
    @rowguid94 uniqueidentifier = NULL,
    @rowguid95 uniqueidentifier = NULL,
    @rowguid96 uniqueidentifier = NULL,
    @rowguid97 uniqueidentifier = NULL,
    @rowguid98 uniqueidentifier = NULL,
    @rowguid99 uniqueidentifier = NULL,
    @rowguid100 uniqueidentifier = NULL
) 

as
begin
    declare @retcode    int
    declare @maxversion int
    set nocount on
        
    if ({ fn ISPALUSER('AB1F05CE-CE24-415B-8771-7EDE0EFE1D98') } <> 1)
    begin       
        RAISERROR (14126, 11, -1)
        return (1)
    end
    
    select @maxversion= maxversion_at_cleanup from dbo.sysmergearticles 
        where nickname = 57128000 and pubid = 'AB1F05CE-CE24-415B-8771-7EDE0EFE1D98'


        select case when (cont.generation is NULL and tomb.generation is null) then 0 else isnull(cont.generation, tomb.generation) end as generation, 
               case when t.[rowguid] is null then (case when tomb.rowguid is NULL then 0 else tomb.type end) else (case when cont.rowguid is null then 3 else 2 end) end as type,
               case when tomb.rowguid is null then cont.lineage else tomb.lineage end as lineage,  
               cont.colv1 as colv,
               @maxversion as maxversion,
               rows.rowguid as rowguid
    

        from
        ( 
        select @rowguid1 as rowguid, 1 as sortcol union all
        select @rowguid2 as rowguid, 2 as sortcol union all
        select @rowguid3 as rowguid, 3 as sortcol union all
        select @rowguid4 as rowguid, 4 as sortcol union all
        select @rowguid5 as rowguid, 5 as sortcol union all
        select @rowguid6 as rowguid, 6 as sortcol union all
        select @rowguid7 as rowguid, 7 as sortcol union all
        select @rowguid8 as rowguid, 8 as sortcol union all
        select @rowguid9 as rowguid, 9 as sortcol union all
        select @rowguid10 as rowguid, 10 as sortcol union all
        select @rowguid11 as rowguid, 11 as sortcol union all
        select @rowguid12 as rowguid, 12 as sortcol union all
        select @rowguid13 as rowguid, 13 as sortcol union all
        select @rowguid14 as rowguid, 14 as sortcol union all
        select @rowguid15 as rowguid, 15 as sortcol union all
        select @rowguid16 as rowguid, 16 as sortcol union all
        select @rowguid17 as rowguid, 17 as sortcol union all
        select @rowguid18 as rowguid, 18 as sortcol union all
        select @rowguid19 as rowguid, 19 as sortcol union all
        select @rowguid20 as rowguid, 20 as sortcol union all
        select @rowguid21 as rowguid, 21 as sortcol union all
        select @rowguid22 as rowguid, 22 as sortcol union all
        select @rowguid23 as rowguid, 23 as sortcol union all
        select @rowguid24 as rowguid, 24 as sortcol union all
        select @rowguid25 as rowguid, 25 as sortcol union all
        select @rowguid26 as rowguid, 26 as sortcol union all
        select @rowguid27 as rowguid, 27 as sortcol union all
        select @rowguid28 as rowguid, 28 as sortcol union all
        select @rowguid29 as rowguid, 29 as sortcol union all
        select @rowguid30 as rowguid, 30 as sortcol union all
        select @rowguid31 as rowguid, 31 as sortcol union all

        select @rowguid32 as rowguid, 32 as sortcol union all
        select @rowguid33 as rowguid, 33 as sortcol union all
        select @rowguid34 as rowguid, 34 as sortcol union all
        select @rowguid35 as rowguid, 35 as sortcol union all
        select @rowguid36 as rowguid, 36 as sortcol union all
        select @rowguid37 as rowguid, 37 as sortcol union all
        select @rowguid38 as rowguid, 38 as sortcol union all
        select @rowguid39 as rowguid, 39 as sortcol union all
        select @rowguid40 as rowguid, 40 as sortcol union all
        select @rowguid41 as rowguid, 41 as sortcol union all
        select @rowguid42 as rowguid, 42 as sortcol union all
        select @rowguid43 as rowguid, 43 as sortcol union all
        select @rowguid44 as rowguid, 44 as sortcol union all
        select @rowguid45 as rowguid, 45 as sortcol union all
        select @rowguid46 as rowguid, 46 as sortcol union all
        select @rowguid47 as rowguid, 47 as sortcol union all
        select @rowguid48 as rowguid, 48 as sortcol union all
        select @rowguid49 as rowguid, 49 as sortcol union all
        select @rowguid50 as rowguid, 50 as sortcol union all
        select @rowguid51 as rowguid, 51 as sortcol union all
        select @rowguid52 as rowguid, 52 as sortcol union all
        select @rowguid53 as rowguid, 53 as sortcol union all
        select @rowguid54 as rowguid, 54 as sortcol union all
        select @rowguid55 as rowguid, 55 as sortcol union all
        select @rowguid56 as rowguid, 56 as sortcol union all
        select @rowguid57 as rowguid, 57 as sortcol union all
        select @rowguid58 as rowguid, 58 as sortcol union all
        select @rowguid59 as rowguid, 59 as sortcol union all
        select @rowguid60 as rowguid, 60 as sortcol union all
        select @rowguid61 as rowguid, 61 as sortcol union all
        select @rowguid62 as rowguid, 62 as sortcol union all
 
        select @rowguid63 as rowguid, 63 as sortcol union all
        select @rowguid64 as rowguid, 64 as sortcol union all
        select @rowguid65 as rowguid, 65 as sortcol union all
        select @rowguid66 as rowguid, 66 as sortcol union all
        select @rowguid67 as rowguid, 67 as sortcol union all
        select @rowguid68 as rowguid, 68 as sortcol union all
        select @rowguid69 as rowguid, 69 as sortcol union all
        select @rowguid70 as rowguid, 70 as sortcol union all
        select @rowguid71 as rowguid, 71 as sortcol union all
        select @rowguid72 as rowguid, 72 as sortcol union all
        select @rowguid73 as rowguid, 73 as sortcol union all
        select @rowguid74 as rowguid, 74 as sortcol union all
        select @rowguid75 as rowguid, 75 as sortcol union all
        select @rowguid76 as rowguid, 76 as sortcol union all
        select @rowguid77 as rowguid, 77 as sortcol union all
        select @rowguid78 as rowguid, 78 as sortcol union all
        select @rowguid79 as rowguid, 79 as sortcol union all
        select @rowguid80 as rowguid, 80 as sortcol union all
        select @rowguid81 as rowguid, 81 as sortcol union all
        select @rowguid82 as rowguid, 82 as sortcol union all
        select @rowguid83 as rowguid, 83 as sortcol union all
        select @rowguid84 as rowguid, 84 as sortcol union all
        select @rowguid85 as rowguid, 85 as sortcol union all
        select @rowguid86 as rowguid, 86 as sortcol union all
        select @rowguid87 as rowguid, 87 as sortcol union all
        select @rowguid88 as rowguid, 88 as sortcol union all
        select @rowguid89 as rowguid, 89 as sortcol union all
        select @rowguid90 as rowguid, 90 as sortcol union all
        select @rowguid91 as rowguid, 91 as sortcol union all
        select @rowguid92 as rowguid, 92 as sortcol union all
        select @rowguid93 as rowguid, 93 as sortcol union all
 
        select @rowguid94 as rowguid, 94 as sortcol union all
        select @rowguid95 as rowguid, 95 as sortcol union all
        select @rowguid96 as rowguid, 96 as sortcol union all
        select @rowguid97 as rowguid, 97 as sortcol union all
        select @rowguid98 as rowguid, 98 as sortcol union all
        select @rowguid99 as rowguid, 99 as sortcol union all
        select @rowguid100 as rowguid, 100 as sortcol
        ) as rows 

        left outer join [dbo].[HoaDon] t with (rowlock) 
        on t.[rowguid] = rows.rowguid
        and rows.rowguid is not null
        left outer join dbo.MSmerge_contents cont with (rowlock) 
        on cont.rowguid = rows.rowguid and cont.tablenick = 57128000
        left outer join dbo.MSmerge_tombstone tomb with (rowlock) 
        on tomb.rowguid = rows.rowguid and tomb.tablenick = 57128000
        where rows.rowguid is not null
        order by rows.sortcol
                
        if @@error <> 0 
            return 1
    end
    

go
Create procedure dbo.[MSmerge_cft_sp_343D2BD21205418AAB1F05CECE24415B] ( 
@p1 nvarchar(30), 
        @p2 nvarchar(30), 
        @p3 nvarchar(30), 
        @p4 nvarchar(30), 
        @p5 nvarchar(30), 
        @p6 nvarchar(100), 
        @p7 int, 
        @p8 money, 
        @p9 money, 
        @p10 datetime, 
        @p11 uniqueidentifier, 
        @p12  nvarchar(255) 
, @conflict_type int,  @reason_code int,  @reason_text nvarchar(720)
, @pubid uniqueidentifier, @create_time datetime = NULL
, @tablenick int = 0, @source_id uniqueidentifier = NULL, @check_conflicttable_existence bit = 0 
) as
declare @retcode int
-- security check
exec @retcode = sys.sp_MSrepl_PAL_rolecheck @objid = 1185439297, @pubid = 'AB1F05CE-CE24-415B-8771-7EDE0EFE1D98'
if @@error <> 0 or @retcode <> 0 return 1 

if 1 = @check_conflicttable_existence
begin
    if 1185439297 is null return 0
end


    if @source_id is NULL 
        select @source_id = subid from dbo.sysmergesubscriptions 
            where lower(@p12) = LOWER(subscriber_server) + '.' + LOWER(db_name) 

    if @source_id is NULL select @source_id = newid() 
  
    set @create_time=getdate()

  if exists (select * from MSmerge_conflicts_info info inner join [dbo].[MSmerge_conflict_MYPHAM_CNLA_HoaDon] ct 
    on ct.rowguidcol=info.rowguid and 
       ct.origin_datasource_id = info.origin_datasource_id
     where info.rowguid = @p11 and info.origin_datasource = @p12 and info.tablenick = @tablenick)
    begin
        update [dbo].[MSmerge_conflict_MYPHAM_CNLA_HoaDon] with (rowlock) set 
[MaHD] = @p1
,
        [MaKH] = @p2
,
        [MaSP] = @p3
,
        [MaCN] = @p4
,
        [MaNV] = @p5
,
        [TenSP] = @p6
,
        [SoLuong] = @p7
,
        [GiaBan] = @p8
,
        [TongTien] = @p9
,
        [NgayLap] = @p10
 from [dbo].[MSmerge_conflict_MYPHAM_CNLA_HoaDon] ct inner join MSmerge_conflicts_info info 
        on ct.rowguidcol=info.rowguid and 
           ct.origin_datasource_id = info.origin_datasource_id
 where info.rowguid = @p11 and info.origin_datasource = @p12 and info.tablenick = @tablenick


    end
    else
    begin
        insert into [dbo].[MSmerge_conflict_MYPHAM_CNLA_HoaDon] (
[MaHD]
,
        [MaKH]
,
        [MaSP]
,
        [MaCN]
,
        [MaNV]
,
        [TenSP]
,
        [SoLuong]
,
        [GiaBan]
,
        [TongTien]
,
        [NgayLap]
,
        [rowguid]
,
        [origin_datasource_id]
) values (

@p1
,
        @p2
,
        @p3
,
        @p4
,
        @p5
,
        @p6
,
        @p7
,
        @p8
,
        @p9
,
        @p10
,
        @p11
,
         @source_id 
)

    end

    
    if exists (select * from MSmerge_conflicts_info info where tablenick=@tablenick and rowguid=@p11 and info.origin_datasource= @p12 and info.conflict_type not in (4,7,8,12))
    begin
        update MSmerge_conflicts_info with (rowlock) 
            set conflict_type=@conflict_type, 
                reason_code=@reason_code,
                reason_text=@reason_text,
                pubid=@pubid,
                MSrepl_create_time=@create_time
            where tablenick=@tablenick and rowguid=@p11 and origin_datasource= @p12
            and conflict_type not in (4,7,8,12)
    end
    else    
    begin
    
        insert MSmerge_conflicts_info with (rowlock) 
            values(@tablenick, @p11, @p12, @conflict_type, @reason_code, @reason_text,  @pubid, @create_time, @source_id)
    end

        declare @error    int
        set @error= @reason_code

    declare @REPOLEExtErrorDupKey            int
    declare @REPOLEExtErrorDupUniqueIndex    int

    set @REPOLEExtErrorDupKey= 2627
    set @REPOLEExtErrorDupUniqueIndex= 2601
    
    if @error in (@REPOLEExtErrorDupUniqueIndex, @REPOLEExtErrorDupKey)
    begin
        update mc
            set mc.generation= 0
            from dbo.MSmerge_contents mc join [dbo].[HoaDon] t on mc.rowguid=t.rowguidcol
            where
                mc.tablenick = 57128000 and
                (

                        (t.[MaHD]=@p1 and t.[MaSP]=@p3)

                        )
            end

go

update dbo.sysmergearticles 
    set insert_proc = 'MSmerge_ins_sp_343D2BD21205418AAB1F05CECE24415B',
        select_proc = 'MSmerge_sel_sp_343D2BD21205418AAB1F05CECE24415B',
        metadata_select_proc = 'MSmerge_sel_sp_343D2BD21205418AAB1F05CECE24415B_metadata',
        update_proc = 'MSmerge_upd_sp_343D2BD21205418AAB1F05CECE24415B',
        ins_conflict_proc = 'MSmerge_cft_sp_343D2BD21205418AAB1F05CECE24415B',
        delete_proc = 'MSmerge_del_sp_343D2BD21205418AAB1F05CECE24415B'
    where artid = '343D2BD2-1205-418A-8290-8C7DE8FA4CF1' and pubid = 'AB1F05CE-CE24-415B-8771-7EDE0EFE1D98'

go

	if object_id('sp_MSpostapplyscript_forsubscriberprocs','P') is not NULL
		exec sys.sp_MSpostapplyscript_forsubscriberprocs @procsuffix = '343D2BD21205418AAB1F05CECE24415B'

go
