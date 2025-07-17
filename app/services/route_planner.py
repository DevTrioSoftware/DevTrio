import uuid
from app.services.route_service import get_route
from app.models.route_model import RouteResponse
from app.utils.logger import logger
from app.services.redis_client import save_route

def plan_route(pickup_address: str, delivery_address: str, waypoints: list[str] = None) -> RouteResponse:
    logger.info(f"Yeni rota planlama: {pickup_address} -> {delivery_address} | Waypoints: {waypoints}")

    route_data = get_route(pickup_address, delivery_address, waypoints)
    route_id = str(uuid.uuid4())

    response = RouteResponse(
        routeId=route_id,
        rotalar=route_data["rotalar"]
    )

    # Redis'e kaydet
    save_route(route_id, response.dict())
    logger.info(f"Rota kaydedildi: route:{route_id}")

    return response
