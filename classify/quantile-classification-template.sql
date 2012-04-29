SELECT
  ntile as class,
  min(classify_column) AS min,
  max(classify_column) AS max
FROM
  (
    SELECT
      $classify_column as classify_column,
      ntile($num_classes) OVER (ORDER BY ($classify_column)) AS ntile
    FROM
      (
        SELECT stat.*, geom.area
        FROM $classify_stat_table stat
        NATURAL JOIN $classify_geom_table geom
      ) stats_with_area
  ) single_class
GROUP BY class
ORDER BY class;
