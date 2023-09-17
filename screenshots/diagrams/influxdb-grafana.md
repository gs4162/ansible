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

  sensor -->|MQTT Publish| MQTT
  MQTT -->|MQTT Subscribe| PyScript
  PyScript -->|Data Insert| InfluxDB

  InfluxDB -->|Data Source| Grafana
