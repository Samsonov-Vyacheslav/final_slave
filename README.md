#################### ПРЕДНАСТРОЕНО ####################

1. Для большей части преднастроек можно использовать скрипт 1_pre_slave.sh , в него входит:
- выставление корректных даты и времени (Москва)
- выключение SELinux и Firewalld
- изменение имени системы 
- установка sshpass (на всякий случай)
- настройка сети со статическим IP (192.168.1.42)
- установка GIT

Дополнительно необходимо сделать апдейт пакетов системы (yum update -y) и вручную добавить SSH-ключи.

#################### ПОДГОТОВКА К РАЗВОРАЧИВАНИЮ ПРОЕКТА (SLAVE) ####################

Необходимо:
- перейти в папку /tmp
- склонировать нужный проект из GIT - git clone git@github.com:Samsonov-Vyacheslav/final_slave.git
- выдать права на исполнение скриптов - chmod -R 777 /tmp/final_slave

#################### РАЗВОРАЧИВАНИЕ ПРОЕКТА (SLAVE) ####################		

2. 2_install_mysql_slave.sh - установка MySQL.

3. 3_replication.sh - настройка репликации и добавление бэкап-скрипта в Cron - тут в самом начале будет запрос на номер и позицию бинлога, нужно взять с Master-сервера.
	Проверить репликацию и бэкап базы WordPress можно через 10+ минут (настроено в crontab) перейдя по пути /var/backup - там каждые 10 минут будет создаваться папка с потабличным бэкапом базы WordPress.
