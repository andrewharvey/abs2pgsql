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
      $classify_stat_table
  ) single_class
GROUP BY class
ORDER BY class;
