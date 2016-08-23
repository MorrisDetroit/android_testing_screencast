require 'active_record'

module Chrome
  class VinPattern < ActiveRecord::Base
    establish_connection :chrome
    self.table_name = 'chvinusadm.vinpattern'

    def self.get_single_us_vp
      self.connection.execute(
          "SELECT t2.vinpattern,
             CASE WHEN vp2.vinpattern IS NOT NULL THEN 'US' ELSE 'CA' END AS country,
             CASE WHEN vp2.vinpattern IS NOT NULL THEN vp2.year ELSE vp3.year END AS year,
             CASE WHEN vp2.vinpattern IS NOT NULL THEN vp2.vindivisionname ELSE vp3.vindivisionname END AS make,
             CASE WHEN vp2.vinpattern IS NOT NULL THEN vp2.vinmodelname ELSE vp3.vinmodelname END AS model
          FROM (
	              SELECT t.vinpattern
	              FROM (
		                  SELECT vp.vinpattern
		                  FROM chvinus.vinpattern vp
		                  UNION ALL
		                  SELECT vp.vinpattern
		                  FROM chvinca.vinpattern vp
		                  JOIN chvinca.vinpatternstylemapping vpsm ON vpsm.VINPATTERNID=vp.VINPATTERNID
	              ) t
                GROUP BY t.vinpattern
                HAVING COUNT(*) = 1
          ) t2
          LEFT JOIN chvinus.vinpattern vp2 ON vp2.vinpattern=t2.vinpattern
          LEFT JOIN chvinca.vinpattern vp3 ON vp3.vinpattern=t2.vinpattern")
    end

    def self.get_single_can_trim
      #TODO: Implement this
    end

    def self.get_us_can_vp
      self.connection.execute(
          "SELECT t2.vinpattern,
             CASE WHEN vp2.vinpattern IS NOT NULL THEN 'US' ELSE 'CA' END AS country,
             CASE WHEN vp2.vinpattern IS NOT NULL THEN vp2.year ELSE vp3.year END AS year,
             CASE WHEN vp2.vinpattern IS NOT NULL THEN vp2.vindivisionname ELSE vp3.vindivisionname END AS make,
             CASE WHEN vp2.vinpattern IS NOT NULL THEN vp2.vinmodelname ELSE vp3.vinmodelname END AS model
          FROM (
	              SELECT t.vinpattern
	              FROM (
		                  SELECT vp.vinpattern
		                  FROM chvinus.vinpattern vp
		                  UNION ALL
		                  SELECT vp.vinpattern
		                  FROM chvinca.vinpattern vp
		                  JOIN chvinca.vinpatternstylemapping vpsm ON vpsm.VINPATTERNID=vp.VINPATTERNID
	              ) t
                GROUP BY t.vinpattern
                HAVING COUNT(*) = 2
          ) t2
          LEFT JOIN chvinus.vinpattern vp2 ON vp2.vinpattern=t2.vinpattern
          LEFT JOIN chvinca.vinpattern vp3 ON vp3.vinpattern=t2.vinpattern")
    end
  end
end
