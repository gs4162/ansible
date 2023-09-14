graph TD;

  subgraph Device
    sensor[IoT Device]
  end

  subgraph MQTTBroker
    MQTT
  end

  subgraph KafkaCluster
    Kafka[Kafka]
    Zookeeper[ZooKeeper]
    KafkaConnect[Kafka Connect]
    ksqlDB[ksqlDB]
    Kafka --> Zookeeper
    Kafka --> KafkaConnect
    KafkaConnect --> ksqlDB
  end
  
  subgraph Database
    MariaDB[MariaDB]
  end
  
  subgraph SupersetCluster
    Superset[Superset Apache]
  end

  subgraph PythonApp
    PyScript[Python Script]
  end

  sensor -->|IoT Data to MQTT| MQTT
  MQTT -->|Subscribe| PyScript

  PyScript -->|To Kafka| Kafka
  ksqlDB -->|Processed Data| KafkaConnect
  KafkaConnect -->|To Database| MariaDB
  MariaDB -->|To Superset| Superset
