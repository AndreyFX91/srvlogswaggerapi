drop procedure if exists get_logs_by_ids;
delimiter $$
create procedure get_logs_by_ids(i_log_ids text)
main_sql:
  begin
    set @v_ddl_statement=
      concat(' select l.log_id,',
            ' l.log_date,',
            ' h.hostname host,',
            ' l.severity,',
            ' l.facility,',
            ' l.message,',
            ' l.program,',
            ' l.hash',
       ' from logs l',
       ' join hosts h on l.host_id = h.host_id ',
       ' where l.log_id in (',i_log_ids, ')',
       ' order by l.log_date desc');

    prepare v_stmt from @v_ddl_statement;
    execute v_stmt;
    deallocate prepare v_stmt;
  end
$$
delimiter ;
call save_routine_information('get_logs_by_ids',
                              concat_ws(',',
                                        'log_id int',
                                        'log_date datetime',
                                        'host varchar',
                                        'severity int',
                                        'facility int',
                                        'message varchar',
                                        'program varchar',
                                        'hash varchar'
                                       )
                             );