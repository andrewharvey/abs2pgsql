#!/bin/sh

# we need this to prepend to file references where those files are in the same
# directory as this script
cwd=`dirname $0`

sql_template=$cwd/quantile-classification-staging.sql
cp $cwd/quantile-classification-template.sql $sql_template

num_classes=$1
classify_column=$2
structure=$3
classify_stat_table=$4

sed -i "s/\$classify_column/$classify_column/g" $sql_template
sed -i "s/\$num_classes/$num_classes/g" $sql_template
sed -i "s/\$classify_geom_table/asgs_2011.${structure}_pyramid/g" $sql_template
sed -i "s/\$classify_stat_table/${classify_stat_table}_${structure}/g" $sql_template

mkdir -p classifications/quantile
psql --no-align --field-separator=',' -f $sql_template | head  --lines=-1 > classifications/quantile/${classify_stat_table}_${structure}.csv
rm $sql_template
