# producer.py
import redis
import time

r = redis.Redis(host='redis-service', port=6379)

while True:
    r.lpush("messages", "Hello from producer!")
    print("✅ Message sent to Redis queue")
    time.sleep(5)

