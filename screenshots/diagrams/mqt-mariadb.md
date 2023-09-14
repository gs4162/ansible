graph TD;

  subgraph Device
    sensor[IoT Device]
  end

  subgraph MQTTBroker
    MQTT
  end

  subgraph MariaDBContainer
    MariaDB[MariaDB]
  end



  subgraph PythonApp
    PyScript[Python Script]
  end

  subgraph Visualization
    Superset[Apache Superset]
  end

  sensor -->|MQTT Publish| MQTT
  MQTT -->|MQTT Subscribe| PyScript
  PyScript -->|SQL INSERT| MariaDB

  MariaDB -->|Data Source| Superset
