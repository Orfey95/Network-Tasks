1) Использовать результаты Task-3 и Task-4.
2) Создать 3 сети. Выбрать такие адреса сети, которые позволили бы разместить:
- в первой сети, не боле 6 хостов;
- во второй сети, не более 24 хостов;
- в третьей сети, не более 50 хостов.

Адреса сети выбрать так чтобы количество записей маршрутизации было минимальным.
```
Net1: 172.16.2.96/29
Net2: 172.16.2.67/27
Net3: 172.16.2.0/26
```
Сеть имеет следующую топологию:<br>
net 1: подсоединена к сети net3 (отдельный роутер R13 хост с двумя интерфейсами);<br>
net 2: подсоединена к сети net3 (отдельный роутер R23 хост с двумя интерфейсами);<br>
net 3: имеет nat доступ к сети epam;<br>
net-dmz: имеет выход в inet (сеть EPAM) через сеть net 3 (отдельный роутер Rdmz3 хост с
двумя интерфейсами).

![Logo](images/topology.png)

3) Настроить:
- один DNS и DHCP;
- настроить nat для доступа в интернет из локальной сети;
- настроить роутинг.
```
NAT Server:  172.16.2.1
DHCP Server: 172.16.2.2
DNS Server:  172.16.2.3
```
4) Настроить на одном из хостов в сетях net1 и net2 сервер nginx. На сервере nginx развернуть
сайт (одна страница, ваше резюме). На DNS настроить Round robin DNS.
```
vagrant@EPUAKHAWO13DT3:~$ ping nginx -c 1 | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}" | head -n 1
172.16.2.66
vagrant@EPUAKHAWO13DT3:~$ ping nginx -c 1 | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}" | head -n 1
172.16.2.99
vagrant@EPUAKHAWO13DT3:~$ ping nginx -c 1 | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}" | head -n 1
172.16.2.66
vagrant@EPUAKHAWO13DT3:~$ ping nginx -c 1 | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}" | head -n 1
172.16.2.99
vagrant@EPUAKHAWO13DT3:~$ ping nginx -c 1 | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}" | head -n 1
172.16.2.66
vagrant@EPUAKHAWO13DT3:~$ ping nginx -c 1 | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}" | head -n 1
172.16.2.66
```
5) Настроить автоматическую регистрацию DHCP клиентов в DNS сервере.
```
vagrant@EPUAKHAWO13DT3:~$ cat /var/lib/bind/forward.bind
$ORIGIN .
$TTL 86400      ; 1 day
frolov                  IN SOA  DNS.frolov. root.DNS.frolov. (
                                2014110751 ; serial
                                604800     ; refresh (1 week)
                                86400      ; retry (1 day)
                                2419200    ; expire (4 weeks)
                                604800     ; minimum (1 week)
                                )
                        NS      DNS.frolov.
                        A       172.16.2.3
$ORIGIN frolov.
DHCP                    A       172.16.2.2
DNS                     A       172.16.2.3
$TTL 300        ; 5 minutes
EPUAKHAWO13DT12         A       172.16.2.102
                        TXT     "008134311960cd14b5e0484e44facdad4d"
EPUAKHAWO13DT13         A       172.16.2.13
                        TXT     "31febc311e6f7923be8264c0a781358458"
EPUAKHAWO13DT22         A       172.16.2.68
                        TXT     "006a368f7750b4d455ea3aa7bf19bd3c73"
EPUAKHAWO13DT23         A       172.16.2.23
                        TXT     "00476175d29aac97026caefc027089b38f"
$TTL 86400      ; 1 day
NAT                     A       172.16.2.1
nginx                   A       172.16.2.66
                        A       172.16.2.99
```
