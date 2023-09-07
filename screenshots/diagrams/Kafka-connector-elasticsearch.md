graph TD;

  subgraph Device
    sensor[IoT Device]
  end

  subgraph MQTTBroker
    MQTT
  end

  subgraph MariaDBContainer
    MariaDB[MariaDB]
    DBApp[Optional DB Application]
    MariaDB -->|DB Query| DBApp
  end

  subgraph KafkaCluster
    Kafka[Kafka]
    Zookeeper[ZooKeeper]
    KafkaConnect[Kafka Connect with Elasticsearch Connector]
    Kafka --> Zookeeper
    Kafka -->|Stream to Connect| KafkaConnect
  end
  
  subgraph ElasticsearchCluster
    Elasticsearch[Elasticsearch]
  end
  
  subgraph KibanaDashboard
    Kibana[Kibana]
  end

  subgraph PythonApp
    PyScript[Python Script]
  end

  sensor -->|IoT Data to MQTT| MQTT
  MQTT -->|Subscribe| PyScript
  PyScript -->|SQL to MariaDB| MariaDB
  PyScript -->|To Kafka| Kafka
  KafkaConnect -->|To Elasticsearch| Elasticsearch
  Elasticsearch -->|Visualization| Kibana
