graph TD;

  subgraph Device
    sensor[IoT Device]
  end

  subgraph MQTTBroker
    MQTT[MQTT Broker]
  end

  subgraph InfluxDBCluster
    InfluxDB[InfluxDB]
  end

  subgraph PythonApp
    PyScript[Python Script]
  end

  subgraph Visualization
    Grafana[Grafana Cloud]
  end

  subgraph IIoTApp
    Ubidots[Ubidots IIoT App]
  end

  sensor -->|MQTT Publish| MQTT
  MQTT -->|MQTT Subscribe| PyScript
  MQTT -->|MQTT Subscribe| Ubidots
  PyScript -->|Data Insert| InfluxDB

  InfluxDB -->|Data Source| Grafana
