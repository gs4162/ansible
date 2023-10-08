graph TD;

  subgraph Devices
    device1[IoT Device site 1]
    device2[IoT Device site 2]
    device3[IoT Device site 3]
  end

  subgraph MQTTBroker
    MQTT[MQTT Broker]
  end

  subgraph Site1
    PyScript1[Python Script 1]
    MongoDB1[MongoDB 1]
    Superset1[Superset 1]
  end

  subgraph Site2
    PyScript2[Python Script 2]
    MongoDB2[MongoDB 2]
    Superset2[Superset 2]
  end

  subgraph Site3
    PyScript3[Python Script 3]
    MongoDB3[MongoDB 3]
    Superset3[Superset 3]
  end

  device1 -->|MQTT Publish| MQTT
  device2 -->|MQTT Publish| MQTT
  device3 -->|MQTT Publish| MQTT

  MQTT -->|MQTT Subscribe to site1| PyScript1
  PyScript1 --> MongoDB1
  MongoDB1 --> Superset1

  MQTT -->|MQTT Subscribe to site2| PyScript2
  PyScript2 --> MongoDB2
  MongoDB2 --> Superset2

  MQTT -->|MQTT Subscribe to site3| PyScript3
  PyScript3 --> MongoDB3
  MongoDB3 --> Superset3
