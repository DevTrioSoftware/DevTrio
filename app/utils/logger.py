import logging
import os

log_dir = "logs"
os.makedirs(log_dir, exist_ok=True)

logger = logging.getLogger("route-service")
logger.setLevel(logging.DEBUG)

# Formatter
formatter = logging.Formatter('%(asctime)s [%(threadName)s] %(levelname)s %(name)s - %(message)s')

# Handlers
info_handler = logging.FileHandler(f"{log_dir}/info.log")
info_handler.setLevel(logging.INFO)
info_handler.setFormatter(formatter)

error_handler = logging.FileHandler(f"{log_dir}/error.log")
error_handler.setLevel(logging.ERROR)
error_handler.setFormatter(formatter)

debug_handler = logging.FileHandler(f"{log_dir}/debug.log")
debug_handler.setLevel(logging.DEBUG)
debug_handler.setFormatter(formatter)

console_handler = logging.StreamHandler()
console_handler.setLevel(logging.INFO)
console_handler.setFormatter(formatter)

# Add handlers
logger.addHandler(info_handler)
logger.addHandler(error_handler)
logger.addHandler(debug_handler)
logger.addHandler(console_handler)
