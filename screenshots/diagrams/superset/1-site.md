graph TD;

  subgraph Devices
    device1[IoT Device site 1]
  end

  subgraph MQTTBroker
    MQTT[MQTT Broker]
  end

  subgraph Site1
    PyScript1[Python Script 1]
    MongoDB1[MongoDB 1]
    Superset1[Superset 1]
  end

  device1 -->|MQTT Publish| MQTT
  MQTT -->|MQTT Subscribe to site1| PyScript1
  PyScript1 --> MongoDB1
  MongoDB1 --> Superset1
