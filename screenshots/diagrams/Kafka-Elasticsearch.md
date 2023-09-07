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

  subgraph KafkaCluster
    Kafka[Kafka]
    Zookeeper[ZooKeeper]
    Kafka --> Zookeeper
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

  sensor -->|MQTT Publish| MQTT
  MQTT -->|MQTT Subscribe| PyScript
  PyScript -->|SQL INSERT| MariaDB
  PyScript -->|Kafka Produce| Kafka
  Kafka -->|Data Pipeline| Elasticsearch
  Elasticsearch -->|Data Visualization| Kibana
