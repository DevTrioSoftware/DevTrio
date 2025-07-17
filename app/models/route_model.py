from pydantic import BaseModel
from typing import List

class Step(BaseModel):
    mesafe: str
    süre: str
    talimat: str
    polyline: str

class Rota(BaseModel):
    mesafe: str
    süre: str
    başlangıç: str
    varış: str
    polyline: str
    steps: List[Step]

class RouteResponse(BaseModel):
    routeId: str
    rotalar: List[Rota]
