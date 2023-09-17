graph TD;

  subgraph Device
    sensor1[IoT Device 1]
    sensor2[IoT Device 2]
    sensor3[IoT Device 3]
  end

  subgraph MQTTBroker
    MQTT[MQTT Broker]
  end

  subgraph KafkaCluster
    Kafka[Kafka Data Streaming]
  end

  subgraph DruidCluster
    Druid[Apache Druid]
  end

  subgraph RedashApp
    Redash[Redash App]
  end

  subgraph Clients
    client1[Client User 1]
    client2[Client User 2]
    client3[Client User 3]
  end

  sensor1 -->|MQTT Publish| MQTT
  sensor2 -->|MQTT Publish| MQTT
  sensor3 -->|MQTT Publish| MQTT

  MQTT -->|Stream to Kafka| Kafka

  Kafka -->|Data Stream| Druid

  Druid -->|Data Source| Redash

  Redash --> client1
  Redash --> client2
  Redash --> client3
