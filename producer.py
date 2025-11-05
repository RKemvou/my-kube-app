import os
import time
import redis

redis_host = os.getenv('REDIS_HOST', 'localhost')
redis_port = int(os.getenv('REDIS_PORT', 6379))
topic = os.getenv('TOPIC_NAME', 'test-topic')

r = redis.Redis(host=redis_host, port=redis_port)

while True:
    msg = f"Hello from producer at {time.time()}"
    r.publish(topic, msg)
    print(f"Published: {msg}")
    time.sleep(5)

