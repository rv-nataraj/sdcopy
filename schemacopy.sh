totalarg=$#
if [ $totalarg -eq 3 ]
then
	echo "source databae"
        file=$1
        i=1;
        while read line; do
                lengt=${#line}
                echo "$line"
                sc[$i]="$line"
                i=$((i+1))
        done <$file

	echo "destination database"
	file=$2
        i=1;
        while read line; do
                lengt=${#line}
                echo "$line"
                dc[$i]="$line"
                i=$((i+1))
        done <$file
	mydumper --host=${sc[1]} --port=${sc[2]} --user=${sc[3]} --password=${sc[4]} --outputdir=tmpsch --no-data
	myloader  --host=${dc[1]} --port=${dc[2]} --user=${dc[3]} --password=${dc[4]} --directory=tmpsch --overwrite-tables
	rm -r tmpsch
	echo "Database Operations...."
	file=$3
        i=1;
        while read line; do
                lengt=${#line}
                echo "$line - $lengt"
                tn[$i]="$line"
		echo ${tn[i]}
		mydumper --host=${sc[1]} --port=${sc[2]} --user=${sc[3]} --password=${sc[4]} --outputdir=tmp --tables-list=${tn[i]}
		myloader  --host=${dc[1]} --port=${dc[2]} --user=${dc[3]} --password=${dc[4]} --directory=tmp --overwrite-tables
		#rm tmp/*.sql
		i=$((i+1))
        done <$file
else
	echo "<source db> <destination db> <dbtables.config>"
fi

