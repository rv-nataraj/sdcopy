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

	echo "Database Operations...."
	file=$3
        i=1;
        while read line; do
                lengt=${#line}
                echo "$line - $lengt"
                tn[$i]="$line"
                i=$((i+1))

		tbarr=($line)
		echo ${tbarr[0]}
		mydumper --host=${sc[1]} --port=${sc[2]} --user=${sc[3]} --password=${sc[4]} --outputdir=tmp --tables-list=${tbarr[0]}
		echo ${tbarr[1]}
		if [ ${tbarr[1]} == "1" ]; then
			echo "include schema"
		else
			echo "deleting schema file"
			rm tmp/${tbarr[0]}-schema.sql
		fi
		if [ ${tbarr[2]} == "1" ]; then
			echo "include table data"
                else
                        echo "deleting table data"
			rm tmp/${tbarr[0]}.sql
                fi
		myloader  --host=${dc[1]} --port=${dc[2]} --user=${dc[3]} --password=${dc[4]} --directory=tmp --overwrite-tables
		rm tmp/*.sql
	        for j in "${tbarr[@]}"
        	do
			
                	echo "$j"
        	done
        done <$file
else
	echo "<source db> <destination db> <dbtables.config>"
fi
