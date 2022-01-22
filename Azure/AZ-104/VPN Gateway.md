# What is VPN Gateway

A VPN gateway is **a specific type of virtual network gateway** that is used to send encrypted traffic between an Azure virtual network and an on-premises location over the public network. **Each virtual network can only have one VPN gateway.** You can create multiple connections to the same VPN gateway and all VPN tunnels will share the available gateway bandwidth.

There are 3 types of VPN connections: 

1. Between one VPN gateway and anther VPN gateway: VNet-to-VNet. [All on Azure]
2. Between VPN gateway to on-premises VPN devices: Site-to-Site 
2. Point-to-Site

**Pricing:** hourly compute costs for the virtual network gateway, and the egress data transfer from the virtual network gateway.

# What is a virtual network gateway

A virtual network gateway is composed of two or more VMs that are deployed to a specific subnet you create called the *gateway subnet*. Virtual network gateway VMs contain routing tables and run specific gateway services. 

## Differences between P2S and S2S VPN

Point-to-Site VPN need to connect to the network you want to access manually. If you log-of or restart the workstation it losses connection, and you need to reconnect every time. It's common to use this type of VPN when you are working remotely and need access to company assets. 1-to-many connection.

Site-to-Site is used when you want to connect  two networks and keep the communication up all the time. Many-to-many connection.
