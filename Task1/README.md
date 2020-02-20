## 2.1.a.Анализ сетевых интерфейсов
1) Исследовать сетевые настройки на вашем компьютере. Выполнить проверку относительно 
всех доступных сетевых интерфейсов в системе. (ipconfig / ifconfig / ip).
```
vagrant@task1:~$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: enp0s3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 4444 qdisc fq_codel state UP group default qlen 1000
    link/ether 02:57:a3:c3:eb:b7 brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 brd 10.0.2.255 scope global dynamic enp0s3
       valid_lft 86298sec preferred_lft 86298sec
    inet6 fe80::57:a3ff:fec3:ebb7/64 scope link
       valid_lft forever preferred_lft forever
3: enp0s8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 5555 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:99:fc:18 brd ff:ff:ff:ff:ff:ff
    inet 10.23.26.135/22 brd 10.23.27.255 scope global dynamic enp0s8
       valid_lft 259118sec preferred_lft 259118sec
    inet6 fe80::a00:27ff:fe99:fc18/64 scope link
       valid_lft forever preferred_lft forever
```
2) Проверить качество связи (на домены ukr.net, ya.ru, 8.8.8.8), объяснить показатели. (ping).
ukr.net
```
vagrant@task1:~$ ping -c 5 ukr.net
PING ukr.net (212.42.76.252) 56(84) bytes of data.
64 bytes from srv252.fwdcdn.com (212.42.76.252): icmp_seq=1 ttl=53 time=38.8 ms
64 bytes from srv252.fwdcdn.com (212.42.76.252): icmp_seq=2 ttl=53 time=38.8 ms
64 bytes from srv252.fwdcdn.com (212.42.76.252): icmp_seq=3 ttl=53 time=38.9 ms
64 bytes from srv252.fwdcdn.com (212.42.76.252): icmp_seq=4 ttl=53 time=38.2 ms
64 bytes from srv252.fwdcdn.com (212.42.76.252): icmp_seq=5 ttl=53 time=38.9 ms
--- ukr.net ping statistics ---
5 packets transmitted, 5 received, 0% packet loss, time 4056ms
rtt min/avg/max/mdev = 38.254/38.789/38.993/0.299 ms
```
ya.ru
```
vagrant@task1:~$ ping -c 5 ya.ru
PING ya.ru (87.250.250.242) 56(84) bytes of data.
64 bytes from ya.ru (87.250.250.242): icmp_seq=2 ttl=51 time=21.5 ms
64 bytes from ya.ru (87.250.250.242): icmp_seq=3 ttl=51 time=21.3 ms
64 bytes from ya.ru (87.250.250.242): icmp_seq=4 ttl=51 time=21.5 ms
64 bytes from ya.ru (87.250.250.242): icmp_seq=5 ttl=51 time=21.5 ms
--- ya.ru ping statistics ---
5 packets transmitted, 4 received, 20% packet loss, time 4117ms
rtt min/avg/max/mdev = 21.390/21.508/21.565/0.162 ms
```
8.8.8.8
```
vagrant@task1:~$ ping -c 5 8.8.8.8
PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
64 bytes from 8.8.8.8: icmp_seq=1 ttl=49 time=28.9 ms
64 bytes from 8.8.8.8: icmp_seq=2 ttl=49 time=30.8 ms
64 bytes from 8.8.8.8: icmp_seq=3 ttl=49 time=24.7 ms
64 bytes from 8.8.8.8: icmp_seq=4 ttl=49 time=27.9 ms
64 bytes from 8.8.8.8: icmp_seq=5 ttl=49 time=27.3 ms
--- 8.8.8.8 ping statistics ---
5 packets transmitted, 5 received, 0% packet loss, time 4027ms
rtt min/avg/max/mdev = 24.703/27.962/30.819/2.008 ms
```
3) Изучение MTU:
- получить значения MTU локальных интерфейсов;
```
vagrant@task1:~$ ip a | grep -E "^[1-9]*:" | cut -d' ' -f 2,4,5
lo: mtu 65536
enp0s3: mtu 1500
enp0s8: mtu 1500
```
- изменить  значение  MTU  локальных  интерфейсов.  Определить  допустимые значения MTU. Как это отразится на канале связи? 
```
vagrant@task1:~$ sudo ip link set mtu 4444 dev enp0s3
vagrant@task1:~$ sudo ip link set mtu 5555 dev enp0s8
vagrant@task1:~$ ip a | grep -E "^[1-9]*:" | cut -d' ' -f 2,4,5
lo: mtu 65536
enp0s3: mtu 4444
enp0s8: mtu 5555
```
- включите режим Jumbo Frame. Промоделировать преимущества и недостатки;
```
vagrant@task1:~$ sudo ip link set mtu 9999 dev enp0s3
vagrant@task1:~$ sudo ip link set mtu 16000 dev enp0s8
vagrant@task1:~$ ip a | grep -E "^[1-9]*:" | cut -d' ' -f 2,4,5
lo: mtu 65536
enp0s3: mtu 9999
enp0s8: mtu 16000
```
- Объединиться в команды по 3 студента. Два члена команды на своих VM изменяют MTU  и  
не  сообщают  его  третьему  участнику.  Третий  член  команды  должен вычислить MTU канала связи. (Описать процесс вычисления). 
Все члены команды должны написать свой скрипт для поиска MTU и выполнить поиск MTU;
- измените длину очереди передачи и промоделируйте ее работу после изменений. Сделайте несколько изменений
4) Изучение MAC.
- Найти все доступные MAC-адреса в вашей сети (хосты коллег, ресурсов). 
- Используйте команды arp и ip. 
- Реализовать систему автоматического обнаружения изменений в локальной сети. 
## 2.1.b.Администрирование
1.Выполнить статическую настройку интерфейса. 
a.Установить временный статический IP-адрес. 
```
vagrant@task1:~$ sudo ip address add 10.23.23.121/22 dev enp0s8
vagrant@task1:~$ ip a show enp0s8
3: enp0s8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:99:fc:18 brd ff:ff:ff:ff:ff:ff
    inet 10.23.26.135/22 brd 10.23.27.255 scope global dynamic enp0s8
       valid_lft 258543sec preferred_lft 258543sec
    inet 10.23.23.121/22 scope global enp0s8
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe99:fc18/64 scope link
       valid_lft forever preferred_lft forever
```
b.Установить перманентный статический IP-адрес. 
c.Установить статический IP-адрес с минимально допустимой маской для сети с количеством компьютеров 2^(<последнее число вашего ID-пропуска>). 
d.Способы изменения MAC-адреса в операционных системах. Установить локально администрируемый MAC-адрес. 
e.Проверить выполненное с помощью команды ip and ipconfig (ifconfig). 
