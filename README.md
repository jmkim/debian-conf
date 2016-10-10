Network interfaces
===

Overview
---

We have only one machine which has only one NIC. We also have 5 virtual
machines, named VM1, VM2, VM3, VM4, and VM5.


VM1 and VM2 need public IP address. VM3, VM4, VM5, VM6 do not need
public IP address, but need both an Internet connection and a local area
network.


Here is a graphical model.


Graphical model
---

            +=================+
            |                 |
            |  Another Host   |
            |                 |
            +=================+
                     ^
                     .
                     .
                     .
             +----------------+
    +========|     Bridge     |=========+
    |        +----------------+         |           +---+
    |         ^     ^       ^           |           |   | : Logical network interface
    |  +=====+ +=====+  +-----------+   |           +---+
    |  | VM1 | | VM2 |  |    NAT    |   |
    |  +=====+ +=====+  +-----------+   |           +===+
    |                   ^   ^   ^   ^   |           |   | : Public IP assigned host
    |                VM3  VM4  VM5  VM6 |           +===+
    |                                   |
    |               Host                |     (No border) : Private IP assigned host
    |                                   |
    +===================================+


Network interfaces table
---

|           | Assigned IP address   | Public IP address     | Route to Internet             | Local area network member     |
| ---       | ---                   | ---                   | ---                           | ---                           |
| Host      | 210.125.112.52        | 210.125.112.52        | Bridge - Internet             | 210.125.112.0/24              |
| VM1       | 210.125.112.234       | 210.125.112.234       | Bridge - Internet             | 210.125.112.0/24              |
| VM2       | 210.125.112.235       | 210.125.112.235       | Bridge - Internet             | 210.125.112.0/24              |
| VM3       | 192.168.83.2          | 210.125.112.52        | NAT - Bridge - Internet       | 192.168.83.0/24               |
| VM4       | 192.168.83.11         | 210.125.112.52        | NAT - Bridge - Internet       | 192.168.83.0/24               |
| VM5       | 192.168.83.21         | 210.125.112.52        | NAT - Bridge - Internet       | 192.168.83.0/24               |
| VM6       | 192.168.83.22         | 210.125.112.52        | NAT - Bridge - Internet       | 192.168.83.0/24               |


Name server resource records table
---

| IP address        | MAC address           | Hostname                      |
| ---               | ---                   | ---                           |
| 121.174.208.24    | 68:f7:28:1b:f0:71     |                               |
| 121.174.208.192   | 70:8b:cd:80:1b:21     | haruka.harukasan.org          |
| 121.174.208.208   | 64:e5:99:22:41:71     | kotori.harukasan.org          |
| 121.174.208.210   | 26:bb:af:2f:a6:16     | ns1.harukasan.org             |
| 121.174.208.211   | ba:ea:40:9c:3b:5d     | ns2.harukasan.org             |
| 121.174.208.214   | 06:7e:ec:f8:77:98     |                               |
| 121.174.208.215   | d6:5a:6f:80:fb:62     |                               |
| 121.174.208.239   | 62:5d:e0:48:a0:1a     | u20001.uid.harukasan.org      |
| 121.174.208.240   | b2:b6:30:5c:48:26     | u20002.uid.harukasan.org      |
| 121.174.208.249   | 76:78:dc:55:f0:11     |                               |
| 121.174.208.250   | e2:80:b1:27:2a:a8     |                               |
| 121.174.208.251   | 9e:72:c0:ca:67:8a     |                               |
| 121.174.209.2     | e2:94:26:da:47:92     |                               |
| 121.174.209.6     | 56:76:b7:56:8c:79     |                               |
| 121.174.209.8     | 9e:3f:7c:fd:09:ba     |                               |
