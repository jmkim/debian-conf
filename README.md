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
