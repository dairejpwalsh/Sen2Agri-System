﻿CREATE OR REPLACE FUNCTION sp_get_dashboard_downloader_history(IN _siteid smallint DEFAULT NULL::smallint)
  RETURNS TABLE(id integer, nr_downloads bigint) AS
$BODY$
BEGIN
   RETURN QUERY

	SELECT  1, count(status_id)
		FROM downloader_history
		WHERE status_id  = 1 AND ( site_id = 1)
   UNION
	SELECT  2, count(status_id)
		FROM downloader_history
		WHERE status_id IN (2, 5) AND ( site_id = 1)
   UNION
	SELECT  3, count(status_id)
		FROM downloader_history
		WHERE status_id IN (3, 4) AND ( site_id = 1)
   ORDER BY 1;

END
$BODY$
  LANGUAGE plpgsql
