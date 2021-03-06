1) Сконфигурировать DHCP-серверы на DHCP-1 и DHCP-2, DHCP-клиенты на Client-3, Client-4,
Client-5, Client-6, Client-7 в соответствии с требованиями спецификации. Client-X должны быть
CentOS 7.4+, Ubuntu 16/18.04.x LST, Windows Server 16 Core or Windows Server 16 Nano.
```
DHCP-1 - Ubuntu 18.04
DHCP-2 - CentOS 7
Client-3 - CentOS 7
Client-4 - CentOS 7
Client-5 - Ubuntu 18.04
Client-6 - Ubuntu 18.04
Client-7 - CentOS 7
```
2) DHCP-1 и DHCP-2 являются DHCP-серверами, выдающими адреса в сети 172.16.nn.0/24 (default
router – 172.16.nn.254), где nn – помер по списку фамилий за алфавитом. Первый выдает
адреса в диапазоне 10-20, второй 40-50. Client-3,5 динамически получает адрес от DHCP-1,
Clent-4,6 динамически получает адрес от DHCP-2.

![Logo](images/Topology.png)

Client-3
```
[vagrant@EPUAKHAWO13DT18 ~]$ ip a show eth1
3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 50:46:5e:6e:8c:18 brd ff:ff:ff:ff:ff:ff
    inet 172.16.2.11/24 brd 172.16.2.255 scope global noprefixroute dynamic eth1
       valid_lft 561sec preferred_lft 561sec
    inet6 fe80::5246:5eff:fe6e:8c18/64 scope link
       valid_lft forever preferred_lft forever
```
Client-4
```
[vagrant@EPUAKHAWO13DT19 ~]$ ip a show eth1
3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 50:46:5e:6e:8c:19 brd ff:ff:ff:ff:ff:ff
    inet 172.16.2.41/24 brd 172.16.2.255 scope global noprefixroute dynamic eth1
       valid_lft 545sec preferred_lft 545sec
    inet6 fe80::5246:5eff:fe6e:8c19/64 scope link
       valid_lft forever preferred_lft forever
```
Client-5
```
vagrant@EPUAKHAWO13DT20:~$ ip a show enp0s8
3: enp0s8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 50:46:5e:6e:8c:20 brd ff:ff:ff:ff:ff:ff
    inet 172.16.2.13/24 brd 172.16.2.255 scope global dynamic enp0s8
       valid_lft 546sec preferred_lft 546sec
    inet6 fe80::5246:5eff:fe6e:8c20/64 scope link
       valid_lft forever preferred_lft forever
```
Client-6
```
vagrant@EPUAKHAWO13DT21:~$ ip a show enp0s8
3: enp0s8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 50:46:5e:6e:8c:21 brd ff:ff:ff:ff:ff:ff
    inet 172.16.2.43/24 brd 172.16.2.255 scope global dynamic enp0s8
       valid_lft 549sec preferred_lft 549sec
    inet6 fe80::5246:5eff:fe6e:8c21/64 scope link
       valid_lft forever preferred_lft forever
```
Client-7
```
$ vagrant ssh Client-7
[vagrant@EPUAKHAWO13DT22 ~]$ ip a show eth1
3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 50:46:5e:6e:8c:22 brd ff:ff:ff:ff:ff:ff
    inet 172.16.2.15/24 brd 172.16.2.255 scope global noprefixroute dynamic eth1
       valid_lft 520sec preferred_lft 520sec
    inet6 fe80::5246:5eff:fe6e:8c22/64 scope link
       valid_lft forever preferred_lft forever
```
3) \*Обеспечить получение арендуемого IP только от "своего" сервера. Обеспечить разумную
конфигурацию всех необходимых параметров стека TCP/IP даже в том случае, когда сервер не
предоставил необходимых данных.

The situation is when the client could not get the address from the DHCP server.
```
Client-5: Internet Systems Consortium DHCP Client 4.3.5
Client-5: Copyright 2004-2016 Internet Systems Consortium.
Client-5: All rights reserved.
Client-5: For info, please visit https://www.isc.org/software/dhcp/
Client-5: Listening on LPF/enp0s8/50:46:5e:6e:8c:20
Client-5: Sending on   LPF/enp0s8/50:46:5e:6e:8c:20
Client-5: Sending on   Socket/fallback
Client-5: DHCPDISCOVER on enp0s8 to 255.255.255.255 port 67 interval 3 (xid=0xb4eb951e)
Client-5: DHCPDISCOVER on enp0s8 to 255.255.255.255 port 67 interval 8 (xid=0xb4eb951e)
Client-5: No DHCPOFFERS received.
Client-5: Trying recorded lease 172.16.2.75
Client-5: bound: renewal in 58115700 seconds.
```
Result
```
vagrant@EPUAKHAWO13DT20:~$ ip a show enp0s8
3: enp0s8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 50:46:5e:6e:8c:20 brd ff:ff:ff:ff:ff:ff
    inet 172.16.2.75/24 brd 172.16.2.255 scope global enp0s8
       valid_lft forever preferred_lft forever
    inet6 fe80::5246:5eff:fe6e:8c20/64 scope link
       valid_lft forever preferred_lft forever
```
4) Для DHCP-1 и DHCP-2 выдавать сначала динамические адреса, потом фиксированные (по
Ethernet-адресу).
```
Host Client-7 {
hardware ethernet 50:46:5E:6E:8C:22;
fixed-address 172.16.2.88;
}
```
```
[vagrant@EPUAKHAWO13DT22 ~]$ ip a show eth1
3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 50:46:5e:6e:8c:22 brd ff:ff:ff:ff:ff:ff
    inet 172.16.2.88/24 brd 172.16.2.255 scope global noprefixroute dynamic eth1
       valid_lft 552sec preferred_lft 552sec
    inet6 fe80::5246:5eff:fe6e:8c22/64 scope link
       valid_lft forever preferred_lft forever
```
5) Добиться полной коннективности*.

Communication within the network
```
[vagrant@EPUAKHAWO13DT18 ~]$ ping -c 3 172.16.2.13
PING 172.16.2.13 (172.16.2.13) 56(84) bytes of data.
64 bytes from 172.16.2.13: icmp_seq=1 ttl=64 time=0.241 ms
64 bytes from 172.16.2.13: icmp_seq=2 ttl=64 time=0.203 ms
64 bytes from 172.16.2.13: icmp_seq=3 ttl=64 time=0.532 ms

--- 172.16.2.13 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2000ms
rtt min/avg/max/mdev = 0.203/0.325/0.532/0.147 ms
```
Communication from outside the network
```
vagrant@EPUAKHAWO13DT20:~$ ping -c 3 8.8.8.8
PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
64 bytes from 8.8.8.8: icmp_seq=1 ttl=49 time=23.6 ms
64 bytes from 8.8.8.8: icmp_seq=2 ttl=49 time=29.1 ms
64 bytes from 8.8.8.8: icmp_seq=3 ttl=49 time=22.7 ms

--- 8.8.8.8 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2004ms
rtt min/avg/max/mdev = 22.788/25.186/29.138/2.815 ms
```
6) Исследовать. Произвести захват пакетов tcpdump-ом (выполнить захват в файл только
необходимых пакетов):
- Первичное получение IP-адреса;
```
08:57:18.935898 IP 0.0.0.0.68 > 255.255.255.255.67: BOOTP/DHCP, Request from 50:46:5e:6e:8c:20, length 300
08:57:19.937994 IP 172.16.2.100.67 > 172.16.2.16.68: BOOTP/DHCP, Reply, length 300
08:57:19.939095 IP 0.0.0.0.68 > 255.255.255.255.67: BOOTP/DHCP, Request from 50:46:5e:6e:8c:20, length 300
08:57:19.941136 IP 172.16.2.100.67 > 172.16.2.16.68: BOOTP/DHCP, Reply, length 300
08:57:26.284647 IP 172.16.2.13.68 > 172.16.2.100.67: BOOTP/DHCP, Request from 50:46:5e:6e:8c:20, length 297
08:57:26.286747 IP 172.16.2.100.67 > 172.16.2.13.68: BOOTP/DHCP, Reply, length 300
```
- Произвести настройку с маленьким периодом аренды IP-адреса. Проследить процесс
продления аренды;
```
09:15:10.549977 IP 172.16.2.13.68 > 172.16.2.100.67: BOOTP/DHCP, Request from 50:46:5e:6e:8c:20, length 297
09:15:10.552149 IP 172.16.2.100.67 > 172.16.2.13.68: BOOTP/DHCP, Reply, length 300
```
- Выключить DHCP сервер и проследить поведения клиентов.
```
09:16:24.029489 IP 0.0.0.0.68 > 255.255.255.255.67: BOOTP/DHCP, Request from 50:46:5e:6e:8c:20, length 303
09:16:25.735178 IP 0.0.0.0.68 > 255.255.255.255.67: BOOTP/DHCP, Request from 50:46:5e:6e:8c:20, length 303
09:16:27.133261 IP 0.0.0.0.68 > 255.255.255.255.67: BOOTP/DHCP, Request from 50:46:5e:6e:8c:20, length 303
09:16:30.915408 IP 0.0.0.0.68 > 255.255.255.255.67: BOOTP/DHCP, Request from 50:46:5e:6e:8c:20, length 303
```
