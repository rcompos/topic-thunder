import paho.mqtt.client as mqtt

#Connection success callback
def on_connect(client, userdata, flags, rc):
    print('Connected with result code '+str(rc))
    client.subscribe('testtopic')

# Message receiving callback
def on_message(client, userdata, msg):
    print(msg.topic+" "+str(msg.payload))

client = mqtt.Client()

# Specify callback function
client.on_connect = on_connect
client.on_message = on_message

# Establish a connection
# client.connect('broker.emqx.io', 1883, 60)
client.connect('10.10.23.70', 1883, 60)

# Publish a message
# client.publish('emqtt',payload='Hello World',qos=0)
client.publish('testtopic',payload='Hello World',qos=0)
client.publish('testtopic/hellos',payload='Greetings',qos=0)
client.publish('raw-car-messages',payload='log/hello',qos=0)

client.loop_forever()
