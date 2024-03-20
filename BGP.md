##BGP
========================
*������� loopback ��� ��������*
R1(config)#int loopback 0
R1(config-if)#ip address 100.0.0.1 255.255.255.255
*������ ������� ������� � ���, ��� ��� ������ � ��� ������� ����� ���������, ����� ������������� ������, ��� ����� ���� ���� � �������� loopback � ������� �������������*
R1(config)#ip route 100.0.0.0 255.255.254.0 Null 0
=================================
*R1*
R1(config)#router bgp 64500
*��������� �������*
R1(config-router)#neighbor 101.0.0.1 remote-as 64501
>�������� ���� ����������
R1(config-router)#network 100.0.0.0 mask 255.255.254.0

*R2*
R2(config)#router bgp 64501
>�������� ���� ����������
network 101.0.0.0 mask 255.255.240.0
*��������� �������*
neighbor 101.0.0.2 remote-as 64500
neighbor 101.0.0.6 remote-as 64502
neighbor 101.0.0.10 remote-as 64503
*�������� ������� �� ��������� � ��������� ������*
neighbor 102.0.0.2 default-originate 
neighbor 102.0.0.2 prefix-list DEFAULT out

*��������� ��� ������ ��� 102.0.0.2 (������ � �������� ����)*
ip prefix-list DEFAULT seq 5 permit 0.0.0.0/0
====================================
#��������
sh ip bgp
#������� ���������
clear ip bgp 64501
============================================
#��������� ������������� ��� ����������
router bgp 64500
no synchronization
bgp log-neighbor-changes
network 100.0.0.0 mask 255.255.254.0
neighbor 101.0.0.1 remote-as 64501
*��������� ��� �������� ����� ��� �������*
* neighbor 101.0.0.1 prefix-list LAN out *
neighbor 102.0.0.1 remote-as 64502
*neighbor 102.0.0.1 prefix-list LAN out *

no auto-summary
!
ip route 100.0.0.0 255.255.254.0 Null0
!
*ip prefix-list LAN permit 100.0.0.0/23*
============================================
##Prefix-lists cisco
��������� �������:
ip prefix-list {list-name} [seq {value}] {deny|permit} 
{network/length} [ge {value}] [le {value}]
list-name � �������� ������. ��� ��. ������ �����������, ��� name_in ��� name_out. ��� ������������ ��� �� �������� ��� ��������� �������� ����� ����������� (��, �������, �� ������ ����� ����� �� ����������).
seq � ���������� ����� ������� (��� � ACL), ����� ����� ���� ����������� � ����.
deny/permit � ���������� ��������� ����� ������� ��� ���
network/length � ��������� ��� ��� ������, �����, 192.168.14.0/24.
� ��� ������, ��������, ������� � �������� ��� ��� ���������: ge � le. ��� � ��� ��������� NAT (��� � �� �������), ��� �������� "greater or equal" � "less or equal".
�� ���� �� ������ ������ �� ������ ���� ���������� �������, �� � �� ��������.
��������, ����� ������
ip prefix-list NetDay permit 10.0.0.0/8 ge 10 le 16
����� ��������, ��� ����� ������� ��������� ��������.
10.0.0.0/10, 10.0.0.0/11, 10.0.0.0/12, 10.0.0.0/13, 10.0.0.0/14, 10.0.0.0/15, 10.0.0.0/16
=====================================================================================
������ �� �������� ��������� ����� ���� 120.0.0.0/24 ����� ��������� ������� ����������, 
� ��� ��������� ��������. ������ 0.0.0.0/0 le 32 �������� ����� ������� � ����� ������ ����� (������� ��� ������ 32 (0-32)).
ip prefix-list TEST_PL_IN seq 5 deny 120.0.0.0/24
ip prefix-list TEST_PL_IN seq 10 permit 0.0.0.0/0 le 32

router bgp 64500
neighbor 102.0.0.1 prefix-list TEST_PL_IN in

=============================================
##Prefix-lists cisco
��� ���� �����:
������� ��� ����+�����.
������� ���������� ���������, � �������� ��� ������������� ��� ���� ����, ���� � ��� ��� �� ���������/��������� �� ������ �������� ������� � ���������� ���� � �������. 
� ������� � ��������� ��������� �������� ���������� ���������.
==================
������-1:
ip prefix-list TEST seq 10 permit 10.0.0.0/23 ge 24 le 24
����� � ������� ����� ��������� ������ �������� 10.0.0.0/24 � 10.0.1.0/24, ��������� �������� ����� ���������. ���������� "�� ������": 
ip prefix-list - ������� �������-���� 
TEST           - ��� ������� �����
seq 10         - ����� ������������������ � �����, ���� ��
                 ������� �� ��-��������� ����� 5, ����� ������ 
                 ���� �������� �� ����, �.�. ����� ���� ������.
permit         - ���������
10.0.0.0/23    - ������ 23 ���� ���� 10.0.0.0 ��������� �.�.
                 ���� �������� ����� �� ���������  
                 10.0.0.0 - 10.0.1.255  
ge 24 le 24    - ����� ������ ���� ������(ge) 24 � ������(le) 24
==================
������-2:
ip prefix-list DISTR permit 1.2.3.0/24 le 32 
�����: ��������� ������ 24 ���� ���� 1.2.3.0 ��� ������ ���������, ����� ������ ���� ������(le) 32. �.�. ����������� �������� ����� ������� ����� ���� ��� 24 � ������� ����� �� ������(ge), �� ��-��������� �� ����� ����� ������������� �����, � ������ ������ 24. ����� ������� ����� ����� � ��������� �� 24 - 32. ��� ���� 1.2.3.0 � ����� ������ �� 24 �� 32 �����������. 
� ������ ������ ����� ������� ����������� ����������� access-list:
access-list 1 permit 1.2.3.0 0.0.0.255 
==================
������-3:
ip prefix-list OUT permit 0.0.0.0/0 le 32
� ������ ������ ��������� ������ 0 ���(��� ������ ����� ���������), � ��������� ����� ����� ������(le) 32 � ������(ge) 0.
���������� ������:
access-list 1 permit any
==================
������-4:
ip prefix-list TEST permit 0.0.0.0/1 ge 24 le 24
������ ��� ������ ��������� 0 
�.�. ������ ����� ����� ��������� � ���������:
     ��   00000000 =   0
     ��   01111111 = 127
��������� ���� ��������� ����� ��������.
ge 24 le 24 - ������� ��� ��� ����� ������ ���� �� ������ � �� ������ 24, ������� ������� ����� ������ ���� ������ ����� 24�. 
� ����� �������� ������ ����� ������� �������� ������ prefix-list:
0.0.0.0/24  - 127.255.255.0/24
==================
������-5:
ip prefix-list DEFAULT permit 0.0.0.0/0
������� ��-��������� ��� ������� �� ���� 0.0.0.0 � ������ 0.0.0.0. �������������, ���� ������� ���� ��������� ������ ������� ��-���������. 
����������� access-list:
access-list 1 permit 0.0.0.0 0.0.0.0
==================
������-6:
ip prefix-list LIST permit 10.10.10.0/24 ge 28 
����� ��������� ����� ���������:
10.10.10.0/28     10.10.10.0/29    10.10.10.0 /30    
10.10.10.16/28    10.10.10.8/29    10.10.10.4 /30
...               ...              ....
10.10.10.240/28   10.10.10.248/29  10.10.10.252 /30   

10.10.10.0/31     10.10.10.1/32     
10.10.10.2/31     10.10.10.2/32     
...               ...
10.10.10.254/31   10.10.10.255/32

#RouteMAP
=======================
��������� ������� ���������:
route-map {map_name} {permit|deny} {seq}
[match {expression}]
[set {expression}]

map_name � ��� �����
permit/deny � ��������� ��� ��� ����������� ������, ����������� ��� ������� route-map
seq � ����� ������� � route-map
match � ������� ���������� ������� ��� ������ �������.



