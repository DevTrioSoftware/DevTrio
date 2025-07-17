import requests
import os
from dotenv import load_dotenv

load_dotenv(".env")

GOOGLE_MAPS_API_KEY = os.getenv("GOOGLE_MAPS_API_KEY")

def get_route(start: str, end: str, waypoints: list[str] = None):
    url = "https://maps.googleapis.com/maps/api/directions/json"
    params = {
        "origin": start,
        "destination": end,
        "key": GOOGLE_MAPS_API_KEY,
        "language": "tr",
        "alternatives": "true"
    }
    if waypoints and len(waypoints) > 0:
        if len(waypoints) > 1:
            params["waypoints"] = "optimize:true|" + "|".join(waypoints)
        else:
            params["waypoints"] = waypoints[0]
    response = requests.get(url, params=params)
    data = response.json()

    if data["status"] != "OK":
        raise Exception(f"Google Maps API hatası: {data['status']} - {data.get('error_message', '')}")

    routes = []
    for route in data["routes"]:
        leg = route["legs"][0]
        steps = []
        for step in leg["steps"]:
            steps.append({
                "mesafe": step["distance"]["text"],
                "süre": step["duration"]["text"],
                "talimat": step["html_instructions"],
                "polyline": step["polyline"]["points"]
            })

        routes.append({
            "mesafe": leg["distance"]["text"],
            "süre": leg["duration"]["text"],
            "başlangıç": leg["start_address"],
            "varış": leg["end_address"],
            "polyline": route["overview_polyline"]["points"],
            "steps": steps
        })

    return {"rotalar": routes}
