begin transaction;

do $migration$
declare _statement text;
begin
    raise notice 'running migrations';

    if exists (select * from information_schema.tables where table_schema = 'public' and table_name = 'meta') then
        if exists (select * from meta where version in ('1.5', '1.4.1')) then
            raise notice 'upgrading from 1.5 to 1.6';

            if not exists (select * from config_metadata where key = 'executor.wrp-send-retries-no') then
                _statement := $str$
                INSERT INTO config_metadata VALUES ('executor.wrp-send-retries-no', 'Number of wrapper retries to connect to executor when TCP error', 'int', true, 8);
                $str$;
                raise notice '%', _statement;
                execute _statement;
            end if;
            if not exists (select * from config where key = 'executor.wrp-send-retries-no' and site_id is null) then
                _statement := $str$
                INSERT INTO config(key, site_id, value, last_updated) VALUES ('executor.wrp-send-retries-no', NULL, '3600', '2015-06-03 17:03:39.541136+03');
                $str$;
                raise notice '%', _statement;
                execute _statement;
            end if;

            if not exists (select * from config_metadata where key = 'executor.wrp-timeout-between-retries') then
                _statement := $str$
                INSERT INTO config_metadata VALUES ('executor.wrp-timeout-between-retries', 'Timeout between wrapper retries to executor when TCP error', 'int', true, 8);
                $str$;
                raise notice '%', _statement;
                execute _statement;
            end if;
            if not exists (select * from config where key = 'executor.wrp-timeout-between-retries' and site_id is null) then
                _statement := $str$
                INSERT INTO config(key, site_id, value, last_updated) VALUES ('executor.wrp-timeout-between-retries', NULL, '1000', '2015-06-03 17:03:39.541136+03');
                $str$;
                raise notice '%', _statement;
                execute _statement;
            end if;

            if not exists (select * from config_metadata where key = 'executor.wrp-executes-local') then
                _statement := $str$
                INSERT INTO config_metadata VALUES ('executor.wrp-executes-local', 'Execution of wrappers are only local', 'int', true, 8);
                $str$;
                raise notice '%', _statement;
                execute _statement;
            end if;
            if not exists (select * from config where key = 'executor.wrp-executes-local' and site_id is null) then
                _statement := $str$
                INSERT INTO config(key, site_id, value, last_updated) VALUES ('executor.wrp-executes-local', NULL, '1', '2015-06-03 17:03:39.541136+03');
                $str$;
                raise notice '%', _statement;
                execute _statement;
            end if;

            if not exists (select * from config_metadata where key = 'processor.l3b.lai.laibandscfgfile') then
                _statement := $str$
                INSERT INTO config_metadata VALUES ('processor.l3b.lai.laibandscfgfile', 'Configuration of the bands to be used for LAI', 'file', false, 4);
                $str$;
                raise notice '%', _statement;
                execute _statement;
            end if;
            if not exists (select * from config where key = 'processor.l3b.lai.laibandscfgfile' and site_id is null) then
                _statement := $str$
                INSERT INTO config(key, site_id, value, last_updated) VALUES ('processor.l3b.lai.laibandscfgfile', NULL, '/usr/share/sen2agri/Lai_Bands_Cfgs.cfg', '2016-02-16 11:54:47.223904+02');
                $str$;
                raise notice '%', _statement;
                execute _statement;
            end if;

            if not exists (select * from config_metadata where key = 'executor.module.path.lai-end-of-job') then
                _statement := $str$
                INSERT INTO config_metadata VALUES ('executor.module.path.lai-end-of-job', 'End of LAI monodate job', 'file', true, 8);
                $str$;
                raise notice '%', _statement;
                execute _statement;
            end if;
            if not exists (select * from config where key = 'executor.module.path.lai-end-of-job' and site_id is null) then
                _statement := $str$
                INSERT INTO config(key, site_id, value, last_updated) VALUES ('executor.module.path.lai-end-of-job', NULL, 'true', '2016-01-12 14:56:57.501918+02');
                $str$;
                raise notice '%', _statement;
                execute _statement;
            end if;

            if exists (select * from config where key = 'processor.l3a.half_synthesis' and site_id is null) then
                _statement := $str$
                UPDATE config SET VALUE = 25 where key = 'processor.l3a.half_synthesis' and site_id is null;
                $str$;
                raise notice '%', _statement;
                execute _statement;
            end if;

            _statement := $str$
            UPDATE config_metadata SET is_advanced = false where key IN (
                'processor.l3a.weight.aot.minweight',
                'processor.l3a.weight.aot.maxweight',
                'processor.l3a.weight.cloud.coarseresolution',
                'general.scratch-path',
                'general.scratch-path.l3a',
                'general.scratch-path.l3b_lai', 'general.scratch-path.l3e_pheno',
                'general.scratch-path.l4a',
                'general.scratch-path.l4b', 'monitor-agent.disk-path',
                'processor.l3a.weight.aot.maxaot', 'processor.l3a.weight.cloud.sigmasmall',
                'processor.l3a.weight.cloud.sigmalarge',
                'processor.l3a.weight.total.weightdatemin',
                'processor.l3b.lai.localwnd.bwr',
                'processor.l3a.bandsmapping',
                'processor.l3a.preproc.scatcoeffs_10m',
                'processor.l3a.preproc.scatcoeffs_20m',
                'processor.l3a.lut_path',
                'processor.l4a.lut_path',
                'processor.l4b.lut_path',
                'processor.l3b.lai.localwnd.fwr',
                'processor.l3b.lai.modelsfolder',
                'processor.l3b.lai.lut_path',
                'processor.l3b.lai.global_bv_samples_file',
                'processor.l3b.generate_models',
                'processor.l3b.mono_date_lai',
                'processor.l3b.reprocess',
                'processor.l3b.fitted',
                'processor.l3b.production_interval',
                'processor.l3b.reproc_production_interval',
                'site.upload-path',
                'processor.l3b.lai.rsrcfgfile',
                'processor.l3a.synth_date_sched_offset',
                'processor.l3a.half_synthesis',
                'processor.l3a.generate_20m_s2_resolution',
                'processor.l4a.reference_data_dir',
                'processor.l4a.mission',
                'processor.l4a.temporal_resampling_mode',
                'processor.l4a.random_seed',
                'processor.l4a.window',
                'processor.l4a.smoothing-lambda',
                'processor.l4a.nbcomp',
                'processor.l4a.segmentation-spatial-radius',
                'processor.l4a.range-radius',
                'processor.l4a.segmentation-minsize',
                'processor.l4a.erode-radius',
                'processor.l4a.mahalanobis-alpha',
                'processor.l4a.min-area',
                'processor.l4a.classifier.field',
                'processor.l4a.classifier.rf.nbtrees',
                'processor.l4a.classifier.rf.max',
                'processor.l4a.classifier.rf.min',
                'processor.l4a.sample-ratio',
                'processor.l4a.training-samples-number',
                'processor.l4a.classifier.svm.k',
                'processor.l4a.classifier.svm.opt',
                'processor.l4a.reference-map',
                'processor.l4a.classifier',
                'executor.processor.l3a.keep_job_folders',
                'executor.processor.l3b.keep_job_folders',
                'executor.processor.l3e.keep_job_folders',
                'executor.processor.l4a.keep_job_folders',
                'executor.processor.l4b.keep_job_folders',
                'processor.l3a.sched_wait_proc_inputs',
                'processor.l3b.sched_wait_proc_inputs',
                'processor.l3e.sched_wait_proc_inputs',
                'processor.l4a.sched_wait_proc_inputs',
                'processor.l4b.sched_wait_proc_inputs');
            $str$;
            raise notice '%', _statement;
            execute _statement;


            if exists (select * from config_metadata where key = 'processor.l4a.reference_data_dir') then
                _statement := $str$
                UPDATE config_metadata SET type = 'directory' where key = 'processor.l4a.reference_data_dir';
                $str$;
                raise notice '%', _statement;
                execute _statement;
            end if;

            if exists (select * from config_metadata where key = 'processor.l3b.lai.modelsfolder') then
                _statement := $str$
                UPDATE config_metadata SET type = 'directory' where key = 'processor.l3b.lai.modelsfolder';
                $str$;
                raise notice '%', _statement;
                execute _statement;
            end if;

            raise notice 'applying 6dcf61d719759725c24af10079c19ce71f76fe09';
            _statement := $str$create table if not exists season(
                id smallserial not null primary key,
                site_id smallserial not null,
                name text not null,
                start_date date not null,
                end_date date not null,
                mid_date date not null,
                enabled boolean not null,
                unique (site_id, name)
            );$str$;
            raise notice '%', _statement;
            execute _statement;

            _statement := 'alter table scheduled_task add column season_id smallint null;';
            raise notice '%', _statement;
            begin
                execute _statement;
            exception
                when duplicate_column then
            end;

            _statement = 'DROP FUNCTION IF EXISTS sp_get_scheduled_tasks()';
            raise notice '%', _statement;
            execute _statement;

            _statement := $str$CREATE OR REPLACE FUNCTION sp_get_scheduled_tasks()
                RETURNS TABLE (
                    id scheduled_task.id%TYPE,
                    name scheduled_task.name%TYPE,

                    processor_id scheduled_task.processor_id%TYPE,
                    site_id scheduled_task.site_id%TYPE,
                    season_id scheduled_task.season_id%TYPE,
                    processor_params scheduled_task.processor_params%TYPE,

                    repeat_type scheduled_task.repeat_type%TYPE,
                    repeat_after_days scheduled_task.repeat_after_days%TYPE,
                    repeat_on_month_day scheduled_task.repeat_on_month_day%TYPE,
                    retry_seconds scheduled_task.retry_seconds%TYPE,

                    priority scheduled_task.priority%TYPE,

                    first_run_time scheduled_task.first_run_time%TYPE,

                    status_id scheduled_task_status.id%TYPE,
                    next_schedule scheduled_task_status.next_schedule%TYPE,
                    last_scheduled_run scheduled_task_status.last_scheduled_run%TYPE,
                    last_run_timestamp scheduled_task_status.last_run_timestamp%TYPE,
                    last_retry_timestamp scheduled_task_status.last_retry_timestamp%TYPE,
                    estimated_next_run_time scheduled_task_status.estimated_next_run_time%TYPE

                )
                AS $$
                BEGIN
                    RETURN QUERY
                        SELECT scheduled_task.id,
                            scheduled_task.name,
                            scheduled_task.processor_id,
                            scheduled_task.site_id,
                            scheduled_task.season_id,
                            scheduled_task.processor_params,
                            scheduled_task.repeat_type,
                            scheduled_task.repeat_after_days,
                            scheduled_task.repeat_on_month_day,
                            scheduled_task.retry_seconds,
                            scheduled_task.priority,
                            scheduled_task.first_run_time,
                            scheduled_task_status.id,
                            scheduled_task_status.next_schedule,
                            scheduled_task_status.last_scheduled_run,
                            scheduled_task_status.last_run_timestamp,
                            scheduled_task_status.last_retry_timestamp,
                            scheduled_task_status.estimated_next_run_time
                        FROM scheduled_task
                        INNER JOIN scheduled_task_status ON scheduled_task.id = scheduled_task_status.task_id
                        INNER JOIN site on site.id = scheduled_task.site_id
                        WHERE site.enabled;
                END
                $$
                LANGUAGE plpgsql
                STABLE;
                $str$;
            raise notice '%', _statement;
            execute _statement;

            _statement := 'DROP FUNCTION IF EXISTS sp_insert_scheduled_task(character varying, integer, integer, smallint, smallint, smallint, character varying, integer, smallint, json);';
            raise notice '%', _statement;
            execute _statement;

            _statement := $str$
                CREATE OR REPLACE FUNCTION sp_insert_scheduled_task(
                    _name character varying,
                    _processor_id integer,
                    _site_id integer,
                    _season_id integer,
                    _repeat_type smallint,
                    _repeat_after_days smallint,
                    _repeat_on_month_day smallint,
                    _first_run_time character varying,
                    _retry_seconds  integer,
                    _priority smallint,
                    _processor_params json)
                RETURNS integer AS
                $BODY$
                DECLARE _return_id int;
                BEGIN

                    INSERT INTO scheduled_task(
                        name,
                        processor_id,
                        site_id,
                        season_id,
                        repeat_type,
                        repeat_after_days,
                        repeat_on_month_day,
                        first_run_time,
                        retry_seconds,
                        priority,
                        processor_params)
                    VALUES (
                        _name,
                        _processor_id,
                        _site_id,
                        _season_id,
                        _repeat_type,
                        _repeat_after_days,
                        _repeat_on_month_day,
                        _first_run_time,
                        _retry_seconds,
                        _priority,
                        _processor_params
                    ) RETURNING id INTO _return_id;

                    INSERT INTO scheduled_task_status(
                        task_id,
                        next_schedule,
                        last_scheduled_run,
                        last_run_timestamp,
                        last_retry_timestamp,
                        estimated_next_run_time)
                    VALUES (
                        _return_id,
                        _first_run_time,
                        '0',
                        '0',
                        '0',
                        '0'
                    );

                    RETURN _return_id;

                END;
                $BODY$
                LANGUAGE plpgsql VOLATILE;
            $str$;
            raise notice '%', _statement;
            execute _statement;

            _statement := $str$
                create or replace function sp_delete_season(
                    _season_id season.id%type
                )
                returns void as
                $$
                begin
                    delete from scheduled_task_status
                    using scheduled_task
                    where scheduled_task_status.season_id = _season_id;

                    delete from scheduled_task
                    where season_id = _season_id;

                    delete from season
                    where id = _season_id;

                    if not found then
                        raise exception 'Invalid season % for site %', _name, _site_id;
                    end if;
                end;
                $$
                    language plpgsql volatile;
            $str$;
            raise notice '%', _statement;
            execute _statement;

            _statement := 'DROP FUNCTION IF EXISTS sp_get_dashboard_processor_scheduled_task(smallint);';
            raise notice '%', _statement;
            execute _statement;

            _statement := $str$
                CREATE OR REPLACE FUNCTION sp_get_dashboard_processor_scheduled_task(IN _processor_id smallint)
                RETURNS TABLE(
                    id smallint,
                    name character varying,
                    site_name character varying,
                    season_name text,
                    repeat_type smallint,
                    first_run_time character varying,
                    repeat_after_days smallint,
                    repeat_on_month_day smallint,
                    processor_params character varying) AS
                $BODY$
                BEGIN
                RETURN QUERY
                    SELECT st.id,
                            st.name,
                            site.name,
                            season.name,
                            st.repeat_type,
                            st.first_run_time,
                            st.repeat_after_days,
                            st.repeat_on_month_day,
                            st.processor_params
                        FROM scheduled_task AS st
                        INNER JOIN site on site.id = st.site_id
                        LEFT OUTER JOIN season ON season.id = st.season_id
                        WHERE st.processor_id = _processor_id
                        ORDER BY st.id;


                END
                $BODY$
                LANGUAGE plpgsql
            $str$;
            raise notice '%', _statement;
            execute _statement;

            _statement := 'DROP FUNCTION IF EXISTS sp_get_dashboard_sites_seasons(smallint);';
            raise notice '%', _statement;
            execute _statement;

            _statement := $str$
                create or replace function sp_get_site_seasons(
                    _site_id site.id%type
                )
                returns table (
                    id season.id%type,
                    site_id season.site_id%type,
                    name season.name%type,
                    start_date season.start_date%type,
                    end_date season.end_date%type,
                    mid_date season.mid_date%type,
                    enabled season.enabled%type
                ) as
                $$
                begin
                    if _site_id is null then
                        return query
                            select
                                season.id,
                                season.site_id,
                                season.name,
                                season.start_date,
                                season.end_date,
                                season.mid_date,
                                season.enabled
                            from season
                            order by season.site_id, season.start_date;
                    else
                        return query
                            select
                                season.id,
                                season.site_id,
                                season.name,
                                season.start_date,
                                season.end_date,
                                season.mid_date,
                                season.enabled
                            from season
                            where season.site_id = _site_id
                            order by season.start_date;
                    end if;
                end;
                $$
                    language plpgsql stable;
            $str$;
            raise notice '%', _statement;
            execute _statement;

            _statement := $str$
                create or replace function sp_insert_default_scheduled_tasks(
                    _season_id season.id%type,
                    _processor_id processor.id%type default null
                )
                returns void as
                $$
                declare _site_id site.id%type;
                declare _site_name site.short_name%type;
                declare _season_name season.name%type;
                declare _start_date season.start_date%type;
                declare _mid_date season.start_date%type;
                begin
                    select site.short_name
                    into _site_name
                    from season
                    inner join site on site.id = season.site_id
                    where season.id = _season_id;

                    select site_id,
                        name,
                        start_date,
                        mid_date
                    into _site_id,
                        _season_name,
                        _start_date,
                        _mid_date
                    from season
                    where id = _season_id;

                    if _processor_id is null or _processor_id = 2 then
                        perform sp_insert_scheduled_task(
                                    _site_name || '_' || _season_name || '_L3A' :: character varying,
                                    2,
                                    _site_id :: int,
                                    _season_id :: int,
                                    2::smallint,
                                    0::smallint,
                                    31::smallint,
                                    cast((select date_trunc('month', _start_date) + interval '1 month' - interval '1 day') as character varying),
                                    60,
                                    1 :: smallint,
                                    '{}' :: json);
                    end if;

                    if _processor_id is null or _processor_id = 3 then
                        perform sp_insert_scheduled_task(
                                    _site_name || '_' || _season_name || '_L3B' :: character varying,
                                    3,
                                    _site_id :: int,
                                    _season_id :: int,
                                    1::smallint,
                                    10::smallint,
                                    0::smallint,
                                    cast((_start_date + 10) as character varying),
                                    60,
                                    1 :: smallint,
                                    '{"general_params":{"product_type":"L3B"}}' :: json);
                    end if;

                    if _processor_id is null or _processor_id = 5 then
                        perform sp_insert_scheduled_task(
                                    _site_name || '_' || _season_name || '_L4A' :: character varying,
                                    5,
                                    _site_id :: int,
                                    _season_id :: int,
                                    2::smallint,
                                    0::smallint,
                                    31::smallint,
                                    cast(_mid_date as character varying),
                                    60,
                                    1 :: smallint,
                                    '{}' :: json);
                    end if;

                    if _processor_id is null or _processor_id = 6 then
                        perform sp_insert_scheduled_task(
                                    _site_name || '_' || _season_name || '_L4B' :: character varying,
                                    6,
                                    _site_id :: int,
                                    _season_id :: int,
                                    2::smallint,
                                    0::smallint,
                                    31::smallint,
                                    cast(_mid_date as character varying),
                                    60,
                                    1 :: smallint,
                                    '{}' :: json);
                    end if;
                end;
                $$
                    language plpgsql volatile;
            $str$;
            raise notice '%', _statement;
            execute _statement;

            _statement := $str$
                create or replace function sp_insert_season(
                    _site_id season.site_id%type,
                    _name season.name%type,
                    _start_date season.start_date%type,
                    _end_date season.end_date%type,
                    _mid_date season.mid_date%type,
                    _enabled season.enabled%type
                )
                returns season.id%type as
                $$
                declare _season_id season.id%type;
                begin
                    insert into season(
                        site_id,
                        name,
                        start_date,
                        end_date,
                        mid_date,
                        enabled
                    ) values (
                        _site_id,
                        _name,
                        _start_date,
                        _end_date,
                        _mid_date,
                        _enabled
                    )
                    returning season.id
                    into _season_id;

                    return _season_id;
                end;
                $$
                    language plpgsql volatile;
            $str$;
            raise notice '%', _statement;
            execute _statement;

            _statement := $str$
                create or replace function sp_update_season(
                    _id season.id%type,
                    _site_id season.site_id%type,
                    _name season.name%type,
                    _start_date season.start_date%type,
                    _end_date season.end_date%type,
                    _mid_date season.mid_date%type,
                    _enabled season.enabled%type
                )
                returns void as
                $$
                begin
                    update season
                    set site_id = coalesce(_site_id, site_id),
                        name = coalesce(_name, name),
                        start_date = coalesce(_start_date, start_date),
                        end_date = coalesce(_end_date, end_date),
                        mid_date = coalesce(_mid_date, mid_date),
                        enabled = coalesce(_enabled, enabled)
                    where id = _id;

                    if not found then
                        raise exception 'Invalid season % for site %', _name, _site_id;
                    end if;
                end;
                $$
                    language plpgsql volatile;
            $str$;
            raise notice '%', _statement;
            execute _statement;

            _statement := 'create index ix_season_site_id on season(site_id);';
            raise notice '%', _statement;
            begin
                execute _statement;
            exception when duplicate_table then
            end;

            _statement := 'delete from scheduled_task_status where task_id not in (select id from scheduled_task);';
            raise notice '%', _statement;
            execute _statement;

            _statement := 'alter table scheduled_task add constraint fk_scheduled_task_season foreign key(season_id) references season(id) on delete cascade;';
            raise notice '%', _statement;
            begin
                execute _statement;
            exception when duplicate_object then
            end;

            _statement := 'alter table scheduled_task_status add constraint fk_scheduled_task_status_scheduled_task foreign key(task_id) references scheduled_task(id) on delete cascade;';
            raise notice '%', _statement;
            begin
                execute _statement;
            exception when duplicate_object then
            end;

            _statement := 'alter table season add constraint fk_season_site foreign key(site_id) references site(id);';
            raise notice '%', _statement;
            begin
                execute _statement;
            exception when duplicate_object then
            end;

            do $$
            declare _site_id smallint;
            declare _summer_start text;
            declare _summer_end text;
            declare _winter_start text;
            declare _winter_end text;
            declare _season_start date;
            declare _season_end date;
            declare _season_mid date;
            declare _summer_season_id smallint;
            declare _winter_season_id smallint;
            declare _target_season_id smallint;
            begin
                for _site_id in
                    select id from site
                loop
                    raise notice '%', _site_id;

                    if exists(select * from season where season.site_id = _site_id) then
                        continue;
                    end if;

                    _summer_start := substr((select value from config where config.site_id = _site_id and key = 'downloader.summer-season.start') || '2016', 1, 8);
                    _summer_end := substr((select value from config where config.site_id = _site_id and key = 'downloader.summer-season.end') || '2016', 1, 8);
                    _winter_start := substr((select value from config where config.site_id = _site_id and key = 'downloader.winter-season.start') || '2016', 1, 8);
                    _winter_end := substr((select value from config where config.site_id = _site_id and key = 'downloader.winter-season.end') || '2016', 1, 8);
                    raise notice '% % % %', _summer_start, _summer_end, _winter_start, _winter_end;

                    _summer_season_id := null;
                    if _summer_start is not null and _summer_end is not null then
                        _season_start := to_date(_summer_start, 'MMDDYYYY');
                        _season_end := to_date(_summer_end, 'MMDDYYYY');
                        _season_mid := _season_start + (_season_end - _season_start) / 2;

                        _summer_season_id := (select sp_insert_season(_site_id, 'Summer', _season_start, _season_end, _season_mid, true));
                    end if;

                    _winter_season_id := null;
                    if _winter_start is not null and _winter_end is not null then
                        _season_start := to_date(_winter_start, 'MMDDYYYY');
                        _season_end := to_date(_winter_end, 'MMDDYYYY');
                        _season_mid := _season_start + (_season_end - _season_start) / 2;

                        _winter_season_id := (select sp_insert_season(_site_id, 'Winter', _season_start, _season_end, _season_mid, true));
                    end if;

                    _target_season_id := null;
                    if _summer_season_id is not null and _winter_season_id is null then
                        _target_season_id := _summer_season_id;
                    elsif _summer_season_id is null and _winter_season_id is not null then
                        _target_season_id := _winter_season_id;
                    end if;

                    if _target_season_id is not null then
                        update scheduled_task
                        set season_id = _target_season_id
                        where site_id = _site_id
                        and (name like '%\_L3A' or
                            name like '%\_L3B' or
                            name like '%\_L4A' or
                            name like '%\_L4B');
                    else
                        delete from scheduled_task
                        where site_id = _site_id
                        and (name like '%\_L3A' or
                            name like '%\_L3B' or
                            name like '%\_L4A' or
                            name like '%\_L4B');

                        if _summer_season_id is not null then
                            perform sp_insert_default_scheduled_tasks(_summer_season_id);
                        end if;
                        if _winter_season_id is not null then
                            perform sp_insert_default_scheduled_tasks(_winter_season_id);
                        end if;
                    end if;
                end loop;

                if not exists(select * from scheduled_task where season_id is null) then
                    raise notice 'alter table scheduled_task alter column season_id set not null;';

                    alter table scheduled_task alter column season_id set not null;
                end if;
            end;
            $$;

            raise notice 'applying b41f35a27979297d6a6a279280f6551e00c625d8';
            _statement := $str$
                create or replace function sp_get_job_output(
                    _job_id job.id%type
                ) returns table (
                    step_name step.name%type,
                    command text,
                    stdout_text step_resource_log.stdout_text%type,
                    stderr_text step_resource_log.stderr_text%type,
                    exit_code step.exit_code%type
                ) as
                $$
                begin
                    return query
                        select step.name,
                            array_to_string(array_prepend(config.value :: text, array(select json_array_elements_text(json_extract_path(step.parameters, 'arguments')))), ' ') as command,
                            step_resource_log.stdout_text,
                            step_resource_log.stderr_text,
                            step.exit_code
                        from task
                        inner join step on step.task_id = task.id
                        left outer join step_resource_log on step_resource_log.step_name = step.name and step_resource_log.task_id = task.id
                        left outer join config on config.site_id is null and config.key = 'executor.module.path.' || task.module_short_name
                        where task.job_id = _job_id
                        order by step.submit_timestamp;
                end;
                $$
                    language plpgsql stable;
            $str$;
            raise notice '%', _statement;
            execute _statement;

            raise notice 'applying 557e5a8594689c5c6c3e4b2c98d134ade818c749';
            _statement = 'DROP FUNCTION IF EXISTS sp_dashboard_add_site(character varying, character varying, character varying, character varying, character varying, character varying, boolean);';
            raise notice '%', _statement;
            execute _statement;

            _statement := $str$
                CREATE OR REPLACE FUNCTION sp_dashboard_add_site(
                    _name character varying,
                    _geog character varying,
                    _enabled boolean)
                RETURNS smallint AS
                $BODY$
                DECLARE _short_name character varying;
                DECLARE return_id smallint;
                BEGIN

                    _short_name := lower(_name);
                    _short_name := regexp_replace(_short_name, '\W+', '_', 'g');
                    _short_name := regexp_replace(_short_name, '_+', '_', 'g');
                    _short_name := regexp_replace(_short_name, '^_', '');
                    _short_name := regexp_replace(_short_name, '_$', '');

                    INSERT INTO site (name, short_name, geog, enabled)
                        VALUES (_name, _short_name, ST_Multi(ST_Force2D(ST_GeometryFromText(_geog))) :: geography, _enabled)
                    RETURNING id INTO return_id;

                    RETURN return_id;
                END;
                $BODY$
                LANGUAGE plpgsql VOLATILE;
            $str$;
            raise notice '%', _statement;
            execute _statement;

            _statement = 'DROP FUNCTION IF EXISTS sp_dashboard_update_site(smallint, character varying, character varying, character varying, character varying, character varying, character varying, boolean)';
            raise notice '%', _statement;
            execute _statement;

            _statement := $str$
                CREATE OR REPLACE FUNCTION sp_dashboard_update_site(
                    _id smallint,
                    _short_name character varying,
                    _geog character varying,
                    _enabled boolean)
                RETURNS void AS
                $BODY$
                BEGIN

                IF NULLIF(_short_name, '') IS NOT NULL THEN
                    UPDATE site
                    SET short_name = _short_name
                    WHERE id = _id;
                END IF;

                IF _enabled IS NOT NULL THEN
                    UPDATE site
                    SET enabled = _enabled
                    WHERE id = _id;
                END IF;

                IF NULLIF(_geog, '') IS NOT NULL THEN
                    UPDATE site
                    SET geog = ST_Multi(ST_Force2D(ST_GeometryFromText(_geog)))
                    WHERE id = _id;
                END IF;

                END;
                $BODY$
                LANGUAGE plpgsql;
            $str$;
            raise notice '%', _statement;
            execute _statement;

            _statement = 'DROP FUNCTION IF EXISTS sp_get_sites(_siteid smallint);';
            raise notice '%', _statement;
            execute _statement;

            _statement := $str$
                CREATE OR REPLACE FUNCTION sp_get_sites(IN _site_id smallint DEFAULT NULL::smallint)
                RETURNS TABLE(id smallint, name character varying, short_name character varying, enabled boolean) AS
                $BODY$
                BEGIN
                RETURN QUERY
                        SELECT site.id,
                            site.name,
                            site.short_name,
                            site.enabled
                        FROM site
                        WHERE _site_id IS NULL OR site.id = _site_id
                        ORDER BY site.name;
                END
                $BODY$
                LANGUAGE plpgsql;
            $str$;
            raise notice '%', _statement;
            execute _statement;

            _statement := $str$
                create or replace function sp_insert_default_scheduled_tasks(
                    _season_id season.id%type,
                    _processor_id processor.id%type default null
                )
                returns void as
                $$
                declare _site_id site.id%type;
                declare _site_name site.short_name%type;
                declare _season_name season.name%type;
                declare _start_date season.start_date%type;
                declare _mid_date season.start_date%type;
                begin
                    select site.short_name
                    into _site_name
                    from season
                    inner join site on site.id = season.site_id
                    where season.id = _season_id;

                    if not found then
                        raise exception 'Invalid season id %', _season_id;
                    end if;

                    select site_id,
                        name,
                        start_date,
                        mid_date
                    into _site_id,
                        _season_name,
                        _start_date,
                        _mid_date
                    from season
                    where id = _season_id;

                    if _processor_id is null or _processor_id = 2 then
                        perform sp_insert_scheduled_task(
                                    _site_name || '_' || _season_name || '_L3A' :: character varying,
                                    2,
                                    _site_id :: int,
                                    _season_id :: int,
                                    2::smallint,
                                    0::smallint,
                                    31::smallint,
                                    cast((select date_trunc('month', _start_date) + interval '1 month' - interval '1 day') as character varying),
                                    60,
                                    1 :: smallint,
                                    '{}' :: json);
                    end if;

                    if _processor_id is null or _processor_id = 3 then
                        perform sp_insert_scheduled_task(
                                    _site_name || '_' || _season_name || '_L3B' :: character varying,
                                    3,
                                    _site_id :: int,
                                    _season_id :: int,
                                    1::smallint,
                                    10::smallint,
                                    0::smallint,
                                    cast((_start_date + 10) as character varying),
                                    60,
                                    1 :: smallint,
                                    '{"general_params":{"product_type":"L3B"}}' :: json);
                    end if;

                    if _processor_id is null or _processor_id = 5 then
                        perform sp_insert_scheduled_task(
                                    _site_name || '_' || _season_name || '_L4A' :: character varying,
                                    5,
                                    _site_id :: int,
                                    _season_id :: int,
                                    2::smallint,
                                    0::smallint,
                                    31::smallint,
                                    cast(_mid_date as character varying),
                                    60,
                                    1 :: smallint,
                                    '{}' :: json);
                    end if;

                    if _processor_id is null or _processor_id = 6 then
                        perform sp_insert_scheduled_task(
                                    _site_name || '_' || _season_name || '_L4B' :: character varying,
                                    6,
                                    _site_id :: int,
                                    _season_id :: int,
                                    2::smallint,
                                    0::smallint,
                                    31::smallint,
                                    cast(_mid_date as character varying),
                                    60,
                                    1 :: smallint,
                                    '{}' :: json);
                    end if;

                    if _processor_id is not null and _processor_id not in (2, 3, 5, 6) then
                        raise exception 'No default jobs defined for processor id %', _processor_id;
                    end if;

                end;
                $$
                    language plpgsql volatile;
            $str$;
            raise notice '%', _statement;
            execute _statement;

            raise notice 'applying 9c43cfbf7ad569e76e97e275cd1c2ead0e43605f';
            _statement := $str$
                create or replace function sp_get_season_scheduled_processors(
                    _season_id season.id%type
                )
                returns table (
                    processor_id processor.id%type,
                    processor_name processor.name%type,
                    processor_short_name processor.short_name%type
                ) as
                $$
                begin
                    return query
                        select
                            processor.id,
                            processor.name,
                            processor.short_name
                        from processor
                        where exists(select *
                                    from scheduled_task
                                    where scheduled_task.season_id = _season_id
                                    and scheduled_task.processor_id = processor.id)
                        order by processor.short_name;
                end;
                $$
                    language plpgsql stable;
            $str$;
            raise notice '%', _statement;
            execute _statement;

            _statement := $str$
                CREATE OR REPLACE FUNCTION sp_get_products_by_inserted_time(
                    IN site_id smallint DEFAULT NULL::smallint,
                    IN product_type_id smallint DEFAULT NULL::smallint,
                    IN start_time timestamp with time zone DEFAULT NULL::timestamp with time zone,
                    IN end_time timestamp with time zone DEFAULT NULL::timestamp with time zone)
                  RETURNS TABLE("ProductId" integer, "Product" character varying, "ProductType" character varying, "ProductTypeId" smallint, "Processor" character varying,
                                "ProcessorId" smallint, "Site" character varying, "SiteId" smallint, full_path character varying,
                                quicklook_image character varying, footprint polygon, created_timestamp timestamp with time zone, inserted_timestamp timestamp with time zone) AS
                $BODY$
                DECLARE q text;
                BEGIN
                    q := $sql$
                    WITH site_names(id, name, row) AS (
                            select id, name, row_number() over (order by name)
                            from site
                        ),
                        product_type_names(id, name, row) AS (
                            select id, name, row_number() over (order by name)
                            from product_type
                        )
                        SELECT P.id AS ProductId,
                            P.name AS Product,
                            PT.name AS ProductType,
                            P.product_type_id AS ProductTypeId,
                            PR.name AS Processor,
                            P.processor_id AS ProcessorId,
                            S.name AS Site,
                            P.site_id AS SiteId,
                            P.full_path,
                            P.quicklook_image,
                            P.footprint,
                            P.created_timestamp,
                            P.inserted_timestamp
                        FROM product P
                            JOIN product_type_names PT ON P.product_type_id = PT.id
                            JOIN processor PR ON P.processor_id = PR.id
                            JOIN site_names S ON P.site_id = S.id
                        WHERE TRUE$sql$;

                    IF NULLIF($1, -1) IS NOT NULL THEN
                        q := q || $sql$
                            AND P.site_id = $1$sql$;
                    END IF;
                    IF NULLIF($2, -1) IS NOT NULL THEN
                        q := q || $sql$
                            AND P.product_type_id = $2$sql$;
                    END IF;
                    IF $3 IS NOT NULL THEN
                        q := q || $sql$
                            AND P.inserted_timestamp >= $3$sql$;
                    END IF;
                    IF $4 IS NOT NULL THEN
                        q := q || $sql$
                            AND P.inserted_timestamp <= $4$sql$;
                    END IF;
                    q := q || $SQL$
                        ORDER BY S.row, PT.row, P.name;$SQL$;

                    RETURN QUERY
                        EXECUTE q
                        USING $1, $2, $3, $4;
                END
                $BODY$
                  LANGUAGE plpgsql STABLE;
            $str$;
            raise notice '%', _statement;
            execute _statement;

            raise notice 'applying b86e74775959e41ea3ec3b2b89bb166d4564f539';
            _statement := 'DROP FUNCTION IF EXISTS sp_get_dashboard_products(smallint, smallint);';
            raise notice '%', _statement;
            execute _statement;

            _statement := $str$
                CREATE OR REPLACE FUNCTION sp_get_dashboard_products(
                    _site_id smallint DEFAULT NULL::smallint,
                    _processor_id smallint DEFAULT NULL::smallint)
                RETURNS TABLE (
                    json json
                ) AS
                $BODY$
                DECLARE q text;
                BEGIN
                    q := $sql$
                        WITH site_names(id, name, geog, row) AS (
                                select id, name, st_astext(geog), row_number() over (order by name)
                                from site
                            ),
                            product_type_names(id, name, description, row) AS (
                                select id, name, description, row_number() over (order by description)
                                from product_type
                            ),
                            data(id, satellite_id, product,product_type,product_type_description,processor,site,full_path,quicklook_image,footprint,created_timestamp, site_coord) AS (
                            SELECT
                                P.id,
                                P.satellite_id,
                                P.name,
                                PT.name,
                                PT.description,
                                PR.name,
                                S.name,
                                P.full_path,
                                P.quicklook_image,
                                P.footprint,
                                P.created_timestamp,
                                S.geog
                            FROM product P
                                JOIN product_type_names PT ON P.product_type_id = PT.id
                                JOIN processor PR ON P.processor_id = PR.id
                                JOIN site_names S ON P.site_id = S.id
                            WHERE TRUE -- COALESCE(P.is_archived, FALSE) = FALSE
                    $sql$;
                    IF $1 IS NOT NULL THEN
                        q := q || $sql$
                                AND P.site_id = $1
                                AND EXISTS (
                                    SELECT * FROM season WHERE season.site_id = $1 AND P.created_timestamp BETWEEN season.start_date AND season.end_date
                                )
                        $sql$;
                    END IF;
                    IF $2 IS NOT NULL THEN
                        q := q || $sql$
                                AND P.product_type_id = $2
                        $sql$;
                    END IF;

                    q := q || $sql$
                            ORDER BY S.row, PT.row, P.name
                        )
                --         select * from data;
                        SELECT array_to_json(array_agg(row_to_json(data)), true) FROM data;
                    $sql$;

                --     raise notice '%', q;

                    RETURN QUERY
                    EXECUTE q
                    USING _site_id, _processor_id;
                END
                $BODY$
                LANGUAGE plpgsql STABLE
                COST 100;
                ALTER FUNCTION sp_get_dashboard_products(smallint, smallint)
                OWNER TO admin;
            $str$;
            raise notice '%', _statement;
            execute _statement;

            raise notice 'applying ab1ac800a88bd6e7ff9357b7e837232013330224';
            _statement := $str$
                CREATE OR REPLACE FUNCTION sp_downloader_get_sites()
                RETURNS TABLE (
                    id site.id%TYPE,
                    name site.name%TYPE,
                    short_name site.short_name%TYPE,
                    geog text[]
                )
                AS $$
                BEGIN
                    RETURN QUERY
                        SELECT site.id,
                            site.name,
                            site.short_name,
                            (SELECT array_agg(ST_AsText(ST_MakeValid(ST_SnapToGrid(polys.geog, 0.001))))
                                FROM (
                                    SELECT (ST_Dump(site.geog :: geometry)).geom AS geog
                                ) polys)
                        FROM site
                    WHERE site.enabled;
                END
                $$
                LANGUAGE plpgsql STABLE;
            $str$;
            raise notice '%', _statement;
            execute _statement;

            raise notice 'applying 9855e500f18feeca8f0bcaad5d33058a174bc99a';
            _statement := 'DROP FUNCTION IF EXISTS sp_dashboard_update_site(smallint, character varying, character varying, boolean);';
            raise notice '%', _statement;
            execute _statement;

            _statement := $str$
                CREATE OR REPLACE FUNCTION sp_dashboard_update_site(
                    _id smallint,
                    _enabled boolean)
                RETURNS void AS
                $BODY$
                BEGIN

                IF _enabled IS NOT NULL THEN
                    UPDATE site
                    SET enabled = _enabled AND EXISTS(
                                    SELECT *
                                    FROM season
                                    WHERE season.site_id = _id AND season.enabled)
                    WHERE id = _id;
                END IF;

                END;
                $BODY$
                LANGUAGE plpgsql;
            $str$;
            raise notice '%', _statement;
            execute _statement;

            raise notice 'applying 8dd70afcd17541ebe858845c7b2ee9356931ebd7';
            _statement := $str$
                CREATE OR REPLACE FUNCTION sp_get_job_history_custom_page(
                    IN _siteid smallint DEFAULT NULL::smallint,
                    IN _page integer DEFAULT 1,
                    IN _rows_per_page integer DEFAULT 20)
                RETURNS TABLE(id integer, end_timestamp timestamp with time zone, processor character varying, site character varying, status character varying, start_type character varying) AS
                $BODY$
                BEGIN
                    RETURN QUERY
                        SELECT J.id, J.end_timestamp, P.name, S.name, AST.name, ST.name
                        FROM job J
                            JOIN processor P ON J.processor_id = P.id
                            JOIN site S ON J.site_id = S.id
                            JOIN job_start_type ST ON J.start_type_id = ST.id
                            JOIN activity_status AST ON J.status_id = AST.id
                        WHERE   $1 IS NULL OR site_id = _siteid
                    ORDER BY J.submit_timestamp DESC
                    OFFSET ($2 - 1) * _rows_per_page LIMIT _rows_per_page;
                END
                $BODY$
                LANGUAGE plpgsql STABLE
                COST 100
                ROWS 1000;
                ALTER FUNCTION sp_get_job_history_custom_page(smallint, integer, integer)
                OWNER TO admin;
            $str$;
            raise notice '%', _statement;
            execute _statement;

            raise notice 'applying 4e10d7162e51bc0ebdf7788670ce0d579d076376';
            _statement := $str$
                create or replace function sp_split_site(
                    _site_id site.id%type
                )
                returns void
                as
                $$
                declare _name site.name%type;
                declare _short_name site.short_name%type;
                declare _geog site.geog%type;
                declare _enabled site.enabled%type;
                declare _tile_id text;
                declare _satellite_id satellite.id%type;
                declare _new_site_id site.id%type;
                begin
                    select name,
                        short_name,
                        geog,
                        enabled
                    into _name,
                        _short_name,
                        _geog,
                        _enabled
                    from site
                    where site.id = _site_id;

                    if not found then
                        raise exception 'Could not find site id %', _site_id;
                    end if;

                    for _tile_id,
                        _satellite_id
                    in
                        select tile_id, 1
                        from sp_get_site_tiles(_site_id, 1)
                        union all
                        select tile_id, 2
                        from sp_get_site_tiles(_site_id, 2)
                    loop
                        insert into site(name,
                                        short_name,
                                        geog,
                                        enabled)
                        values (
                            _name || '_' || _tile_id,
                            _short_name || '_' || lower(_tile_id),
                            _geog,
                            _enabled
                        )
                        returning id
                        into _new_site_id;

                        insert into site_tiles(site_id,
                                            satellite_id,
                                            tiles)
                        values (
                            _new_site_id,
                            _satellite_id,
                            array[_tile_id]
                        );

                        insert into season(site_id,
                                        name,
                                        start_date,
                                        end_date,
                                        mid_date,
                                        enabled)
                        select _new_site_id,
                            name,
                            start_date,
                            end_date,
                            mid_date,
                            enabled
                        from season
                        where season.site_id = _site_id;
                    end loop;
                end;
                $$
                    language plpgsql volatile;
            $str$;
            raise notice '%', _statement;
            execute _statement;

            _statement := 'update meta set version = ''1.6'';';
            raise notice '%', _statement;
            execute _statement;
        end if;
    end if;

    raise notice 'complete';
end;
$migration$;

commit;
