import redis
import json
import os
from dotenv import load_dotenv

load_dotenv()

REDIS_HOST = os.getenv("REDIS_HOST", "localhost")
REDIS_PORT = int(os.getenv("REDIS_PORT", 6379))

r = redis.Redis(host=REDIS_HOST, port=REDIS_PORT, decode_responses=True)

def save_route(route_id: str, data: dict, ttl_seconds: int = 86400):
    key = f"route:{route_id}"
    r.setex(key, ttl_seconds, json.dumps(data))

def get_route_by_id(route_id: str):
    key = f"route:{route_id}"
    result = r.get(key)
    if result:
        return json.loads(result)
    return None
