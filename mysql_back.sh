#!/bin/bash

#Параметры подключения к MySQL
MYSQL_USER='root' 
MYSQL_PASSWORD='!Ahhjntf0p02u1'
MYSQL_HOST='localhost'
MYSQL_PORT='3306'
BACKUP_DIRECTORY="/var/backup/$(date +%Y%m%d%H%M%S)"

mkdir -pm 777 $BACKUP_DIRECTORY

MYSQL=$"-u $MYSQL_USER -p$MYSQL_PASSWORD -h $MYSQL_HOST -P $MYSQL_PORT"

#Получение списка баз данных
BASES=$(mysql -D mysql --skip-column-names -B $MYSQL -e 'SHOW DATABASES;' 2>/dev/null | egrep -v '_schema|sys|mysql')

echo "stop slave;" | mysql $MYSQL 2>/dev/null
echo "Stop slave"

#Бэкапинг баз 

for BASE in $BASES; do
	TABLES=$(mysql $MYSQL -e "USE $BASE; SHOW TABLES;" 2> /dev/null | awk '{ print $1}' | egrep -v '^Tables')
	mkdir -p $BACKUP_DIRECTORY/$BASE/

	for TABLE in $TABLES; do
		mysqldump $MYSQL --add-drop-table --add-locks --create-options --disable-keys --extended-insert --single-transaction --quick --default-character-set=utf8 --events --routines --triggers --master-data=2 $BASE $TABLE 2> /dev/null | gzip -1 > $BACKUP_DIRECTORY/$BASE/$TABLE.sql.gz
		if [[ -f $BACKUP_DIRECTORY/$BASE/$TABLE.sql.gz ]]; then
			echo "$BACKUP_DIRECTORY/$BASE/$TABLE.sql.gz - backup success!"
		fi
	done
done

echo "start slave;" | mysql $MYSQL 2>/dev/null
echo "Start slave"

echo $BACKUP_DIRECTORY/
ls -l $BACKUP_DIRECTORY/
