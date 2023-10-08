graph TD;

  subgraph Site1
    device1[IoT Device site 1]
  end

  subgraph Site2
    device2[IoT Device site 2]
  end

  subgraph Site3
    device3[IoT Device site 3]
  end
  
  subgraph Site4
    device4[IoT Device site 4]
  end

  subgraph Cloud
    HiveMQ[HiveMQ MQTT Broker]
  end

  subgraph OnPremStack1
    PyScript1[Python Script 1]
    MongoDB1[MongoDB 1]
    Superset1[Superset 1]
  end

  subgraph OnPremStack2
    PyScript2[Python Script 2]
    MongoDB2[MongoDB 2]
    Superset2[Superset 2]
  end

  subgraph OnPremStack3
    PyScript3[Python Script 3]
    MongoDB3[MongoDB 3]
    Superset3[Superset 3]
  end
  
  subgraph OnPremStack4
    PyScript4[Python Script 4]
    MongoDB4[MongoDB 4]
    Superset4[Superset 4]
  end
  
  subgraph Overheads
    Nginx[Nginx Reverse Proxy]
  end

  AccessPoint["Access Point (User/Client)"]
  
  subgraph TailscaleNetwork
    Tailscale[Tailscale]
  end

  EngineerLaptop[Engineer's Laptop]

  device1 -->|MQTT Publish| HiveMQ
  HiveMQ -->|MQTT Subscribe to site1| PyScript1
  PyScript1 --> MongoDB1
  MongoDB1 --> Superset1
  Superset1 --> Nginx
  
  device2 -->|MQTT Publish| HiveMQ
  HiveMQ -->|MQTT Subscribe to site2| PyScript2
  PyScript2 --> MongoDB2
  MongoDB2 --> Superset2
  Superset2 --> Nginx
  
  device3 -->|MQTT Publish| HiveMQ
  HiveMQ -->|MQTT Subscribe to site3| PyScript3
  PyScript3 --> MongoDB3
  MongoDB3 --> Superset3
  Superset3 --> Nginx

  device4 -->|MQTT Publish| HiveMQ
  HiveMQ -->|MQTT Subscribe to site4| PyScript4
  PyScript4 --> MongoDB4
  MongoDB4 --> Superset4
  Superset4 --> Nginx

  Nginx --> Cloudflare
  AccessPoint -->|HTTP/HTTPS Access| Cloudflare
  
  EngineerLaptop --> Tailscale
  Tailscale --> device1
  Tailscale --> device2
  Tailscale --> device3
  Tailscale --> device4
