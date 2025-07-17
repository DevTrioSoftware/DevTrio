"use client"

import { useState, useEffect, useRef } from "react"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { Input } from "@/components/ui/input"
import { Badge } from "@/components/ui/badge"
import { MapPin, Plus, X, Route, Clock, Navigation, Truck } from "lucide-react"

interface RoutePoint {
  id: string
  address: string
  lat: number
  lng: number
}

interface RouteOption {
  id: string
  name: string
  distance: string
  duration: string
  color: string
  polyline: string
  active: boolean
}

async function fetchBackendRoute(
  pickup: string,
  delivery: string,
  waypoints: string[]
) {
  const params = new URLSearchParams({
    pickup,
    delivery,
  });
  waypoints.forEach(wp => params.append("waypoints", wp));
  const res = await fetch(`http://localhost:8000/plan-route?${params.toString()}`);
  if (!res.ok) throw new Error("API hatası");
  return await res.json();
}

export default function CargoRoutePlanner() {
  const mapRef = useRef<HTMLDivElement>(null)
  const [map, setMap] = useState<google.maps.Map | null>(null)
  const [directionsService, setDirectionsService] = useState<google.maps.DirectionsService | null>(null)
  const [polylines, setPolylines] = useState<google.maps.Polyline[]>([])

  const [startPoint, setStartPoint] = useState<RoutePoint>({
    id: "1",
    address: "İstanbul, Türkiye",
    lat: 41.0082,
    lng: 28.9784,
  })

  const [endPoint, setEndPoint] = useState<RoutePoint>({
    id: "2",
    address: "Ankara, Türkiye",
    lat: 39.9334,
    lng: 32.8597,
  })

  const [waypoints, setWaypoints] = useState<RoutePoint[]>([])
  const [newWaypoint, setNewWaypoint] = useState("")
  const [routes, setRoutes] = useState<RouteOption[]>([])
  const [isCalculating, setIsCalculating] = useState(false)
  const [activeRoute, setActiveRoute] = useState<string>("")

  const [startAddress, setStartAddress] = useState("İstanbul, Türkiye")
  const [endAddress, setEndAddress] = useState("Ankara, Türkiye")
  const [markers, setMarkers] = useState<google.maps.Marker[]>([])

  // Google Maps API key'i fonksiyonun içinde alın
  const GOOGLE_MAPS_API_KEY = process.env.NEXT_PUBLIC_GOOGLE_MAPS_API_KEY as string | undefined;

  // Google Maps yükleme
  useEffect(() => {
    if (!GOOGLE_MAPS_API_KEY) {
      console.log("Google Maps API key not found");
      return;
    }

    const loadGoogleMaps = () => {
      if ((window as any).google) {
        initializeMap();
        return;
      }
      const script = document.createElement("script");
      script.src = `https://maps.googleapis.com/maps/api/js?key=${GOOGLE_MAPS_API_KEY}&libraries=geometry`;
      script.async = true;
      script.defer = true;
      script.onload = initializeMap;
      document.head.appendChild(script);
    };
    loadGoogleMaps();
    // eslint-disable-next-line
  }, [GOOGLE_MAPS_API_KEY]);

  const initializeMap = () => {
    if (!mapRef.current) return

    const mapInstance = new google.maps.Map(mapRef.current, {
      center: { lat: 40.0, lng: 30.0 },
      zoom: 6,
      styles: [
        {
          featureType: "all",
          elementType: "geometry.fill",
          stylers: [{ color: "#f5f5f5" }],
        },
        {
          featureType: "water",
          elementType: "geometry",
          stylers: [{ color: "#c9c9c9" }],
        },
        {
          featureType: "road",
          elementType: "geometry",
          stylers: [{ color: "#ffffff" }],
        },
      ],
    })

    setMap(mapInstance)
    setDirectionsService(new google.maps.DirectionsService())

    // İlk markerları oluştur
    updateMapMarkers(mapInstance)
  }

  const updateMapMarkers = (mapInstance?: google.maps.Map | null) => {
    const m = mapInstance ?? map;
    if (!m) return;

    // Mevcut markerları temizle
    markers.forEach((marker) => marker.setMap(null))

    const newMarkers: google.maps.Marker[] = []

    // Başlangıç marker (yeşil)
    const startMarker = new window.google.maps.Marker({
      position: { lat: startPoint.lat, lng: startPoint.lng },
      map: m,
      title: "Başlangıç",
      icon: {
        path: window.google.maps.SymbolPath.CIRCLE,
        scale: 8,
        fillColor: "#22c55e",
        fillOpacity: 1,
        strokeColor: "#ffffff",
        strokeWeight: 2,
      },
      label: "S", // S = Start
    })
    newMarkers.push(startMarker)

    // Bitiş marker (kırmızı)
    const endMarker = new window.google.maps.Marker({
      position: { lat: endPoint.lat, lng: endPoint.lng },
      map: m,
      title: "Varış",
      icon: {
        path: window.google.maps.SymbolPath.CIRCLE,
        scale: 8,
        fillColor: "#ef4444",
        fillOpacity: 1,
        strokeColor: "#ffffff",
        strokeWeight: 2,
      },
      label: "V", // V = Varış
    })
    newMarkers.push(endMarker)

    // Ara durak markerları (mavi, numaralı)
    waypoints.forEach((waypoint, idx) => {
      const waypointMarker = new window.google.maps.Marker({
        position: { lat: waypoint.lat, lng: waypoint.lng },
        map: m,
        title: waypoint.address,
        icon: {
          path: window.google.maps.SymbolPath.CIRCLE,
          scale: 7,
          fillColor: "#3b82f6",
          fillOpacity: 1,
          strokeColor: "#ffffff",
          strokeWeight: 2,
        },
        label: `${idx + 1}`, // 1, 2, 3...
      })
      newMarkers.push(waypointMarker)
    })

    setMarkers(newMarkers)
  }

  const updateStartPoint = () => {
    // Basit geocoding simülasyonu - gerçek projede Google Geocoding API kullanın
    const turkishCities = [
      { name: "İstanbul", lat: 41.0082, lng: 28.9784 },
      { name: "Ankara", lat: 39.9334, lng: 32.8597 },
      { name: "İzmir", lat: 38.4192, lng: 27.1287 },
      { name: "Bursa", lat: 40.1826, lng: 29.0665 },
      { name: "Antalya", lat: 36.8969, lng: 30.7133 },
    ]

    const city =
      turkishCities.find((c) => startAddress.toLowerCase().includes(c.name.toLowerCase())) || turkishCities[0]

    setStartPoint({
      id: "start",
      address: startAddress,
      lat: city.lat,
      lng: city.lng,
    })

    if (map) {
      updateMapMarkers()
    }
  }

  const updateEndPoint = () => {
    // Basit geocoding simülasyonu - gerçek projede Google Geocoding API kullanın
    const turkishCities = [
      { name: "İstanbul", lat: 41.0082, lng: 28.9784 },
      { name: "Ankara", lat: 39.9334, lng: 32.8597 },
      { name: "İzmir", lat: 38.4192, lng: 27.1287 },
      { name: "Bursa", lat: 40.1826, lng: 29.0665 },
      { name: "Antalya", lat: 36.8969, lng: 30.7133 },
    ]

    const city = turkishCities.find((c) => endAddress.toLowerCase().includes(c.name.toLowerCase())) || turkishCities[1]

    setEndPoint({
      id: "end",
      address: endAddress,
      lat: city.lat,
      lng: city.lng,
    })

    if (map) {
      updateMapMarkers()
    }
  }

  const addWaypoint = () => {
    if (!newWaypoint.trim()) return

    // Basit geocoding simülasyonu - gerçek projede Google Geocoding API kullanın
    const mockCoordinates = [
      { lat: 40.7831, lng: 29.9167 }, // Gebze
      { lat: 40.1553, lng: 29.0611 }, // Bursa
      { lat: 39.7667, lng: 30.5256 }, // Eskişehir
    ]

    const randomCoord = mockCoordinates[Math.floor(Math.random() * mockCoordinates.length)]

    const newPoint: RoutePoint = {
      id: Date.now().toString(),
      address: newWaypoint,
      lat: randomCoord.lat,
      lng: randomCoord.lng,
    }

    setWaypoints([...waypoints, newPoint])
    setNewWaypoint("")

    // Markerları güncelle
    if (map) {
      setTimeout(() => updateMapMarkers(), 100)
    }
  }

  const removeWaypoint = (id: string) => {
    setWaypoints(waypoints.filter((wp) => wp.id !== id))

    // Markerları güncelle
    if (map) {
      setTimeout(() => updateMapMarkers(), 100)
    }
  }

  const calculateRoutes = async () => {
    if (!(window as any).google) {
      console.error("Google Maps henüz yüklenmedi!");
      return;
    }
    setIsCalculating(true);

    // Mevcut polyline'ları temizle
    polylines.forEach((polyline) => polyline.setMap(null));
    setPolylines([]);

    try {
      // 1. Backend API'ye istek at
      const backendResult = await fetchBackendRoute(
        startPoint.address,
        endPoint.address,
        waypoints.map(wp => wp.address)
      );

      // 2. API'den dönen polyline'ı haritada çiz
      if (
        backendResult &&
        backendResult.rotalar &&
        backendResult.rotalar.length > 0
      ) {
        const route = backendResult.rotalar[0];
        // Google Maps polyline'ı decode et
        const decodedPath = window.google.maps.geometry.encoding.decodePath(
          route.polyline
        );
        const polyline = new window.google.maps.Polyline({
          path: decodedPath,
          geodesic: true,
          strokeColor: "#1976d2",
          strokeOpacity: 1.0,
          strokeWeight: 5,
          map: map!,
        });
        setPolylines([polyline]);
        // Haritayı rotaya göre ayarla
        const bounds = new window.google.maps.LatLngBounds();
        decodedPath.forEach((latLng: google.maps.LatLng) => bounds.extend(latLng));
        if (map) {
          map.fitBounds(bounds);
        }
      }
    } catch (error) {
      console.error("Rota hesaplama hatası:", error);
    } finally {
      setIsCalculating(false);
    }
  };

  const animatePolyline = (polyline: google.maps.Polyline, color: string) => {
    let step = 0
    const numSteps = 50
    const timePerStep = 20

    const animate = () => {
      step++
      const opacity = Math.sin((step / numSteps) * Math.PI)
      polyline.setOptions({
        strokeOpacity: 0.3 + opacity * 0.7,
      })

      if (step < numSteps) {
        setTimeout(animate, timePerStep)
      } else {
        polyline.setOptions({ strokeOpacity: 0.8 })
      }
    }

    animate()
  }

  const selectRoute = (routeId: string) => {
    setActiveRoute(routeId)

    // Tüm polyline'ları güncelle
    polylines.forEach((polyline, index) => {
      const isActive = routes[index]?.id === routeId
      polyline.setOptions({
        strokeWeight: isActive ? 4 : 2,
        strokeOpacity: isActive ? 1.0 : 0.6,
        zIndex: isActive ? 1000 : 1,
      })
    })
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100 p-4">
      <div className="max-w-7xl mx-auto">
        {/* Header */}
        <div className="text-center mb-8">
          <div className="flex items-center justify-center gap-3 mb-4">
            <div className="p-3 bg-blue-600 rounded-full">
              <Truck className="w-8 h-8 text-white" />
            </div>
            <h1 className="text-4xl font-bold text-gray-900">Kargo Rota Planlayıcı</h1>
          </div>
          <p className="text-gray-600 text-lg">En optimal kargo rotalarını hesaplayın ve görselleştirin</p>
        </div>

        <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
          {/* Sol Panel - Kontroller */}
          <div className="lg:col-span-1 space-y-6">
            {/* Başlangıç/Bitiş Noktaları */}
            <Card>
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  <MapPin className="w-5 h-5" />
                  Rota Noktaları
                </CardTitle>
              </CardHeader>
              <CardContent className="space-y-4">
                <div>
                  <label className="text-sm font-medium text-gray-700 mb-2 block">Başlangıç Noktası</label>
                  <div className="flex gap-2">
                    <Input
                      placeholder="Başlangıç adresini girin..."
                      value={startAddress}
                      onChange={(e) => setStartAddress(e.target.value)}
                      onKeyPress={(e) => e.key === "Enter" && updateStartPoint()}
                    />
                    <Button onClick={updateStartPoint} size="sm" variant="outline">
                      <MapPin className="w-4 h-4" />
                    </Button>
                  </div>
                  <div className="flex items-center gap-2 mt-2">
                    <div className="w-3 h-3 bg-green-500 rounded-full"></div>
                    <span className="text-sm text-gray-600">{startPoint.address}</span>
                  </div>
                </div>

                <div>
                  <label className="text-sm font-medium text-gray-700 mb-2 block">Varış Noktası</label>
                  <div className="flex gap-2">
                    <Input
                      placeholder="Varış adresini girin..."
                      value={endAddress}
                      onChange={(e) => setEndAddress(e.target.value)}
                      onKeyPress={(e) => e.key === "Enter" && updateEndPoint()}
                    />
                    <Button onClick={updateEndPoint} size="sm" variant="outline">
                      <MapPin className="w-4 h-4" />
                    </Button>
                  </div>
                  <div className="flex items-center gap-2 mt-2">
                    <div className="w-3 h-3 bg-red-500 rounded-full"></div>
                    <span className="text-sm text-gray-600">{endPoint.address}</span>
                  </div>
                </div>
              </CardContent>
            </Card>

            {/* Duraklar */}
            <Card>
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  <Navigation className="w-5 h-5" />
                  Ara Duraklar
                </CardTitle>
              </CardHeader>
              <CardContent className="space-y-4">
                <div className="flex gap-2">
                  <Input
                    placeholder="Durak adresi girin..."
                    value={newWaypoint}
                    onChange={(e) => setNewWaypoint(e.target.value)}
                    onKeyPress={(e) => e.key === "Enter" && addWaypoint()}
                  />
                  <Button onClick={addWaypoint} size="sm">
                    <Plus className="w-4 h-4" />
                  </Button>
                </div>

                <div className="space-y-2">
                  {waypoints.map((waypoint) => (
                    <div key={waypoint.id} className="flex items-center justify-between p-2 bg-gray-50 rounded-lg">
                      <div className="flex items-center gap-2">
                        <div className="w-2 h-2 bg-blue-500 rounded-full"></div>
                        <span className="text-sm">{waypoint.address}</span>
                      </div>
                      <Button variant="ghost" size="sm" onClick={() => removeWaypoint(waypoint.id)}>
                        <X className="w-4 h-4" />
                      </Button>
                    </div>
                  ))}
                </div>
              </CardContent>
            </Card>

            {/* Hesaplama Butonu */}
            <Button onClick={calculateRoutes} disabled={isCalculating || !map} className="w-full h-12 text-lg">
              {isCalculating ? (
                <div className="flex items-center gap-2">
                  <div className="w-4 h-4 border-2 border-white border-t-transparent rounded-full animate-spin"></div>
                  Hesaplanıyor...
                </div>
              ) : (
                <div className="flex items-center gap-2">
                  <Route className="w-5 h-5" />
                  Rotaları Hesapla
                </div>
              )}
            </Button>

            {/* Rota Seçenekleri */}
            {routes.length > 0 && (
              <Card>
                <CardHeader>
                  <CardTitle>Rota Seçenekleri</CardTitle>
                </CardHeader>
                <CardContent className="space-y-3">
                  {routes.map((route) => (
                    <div
                      key={route.id}
                      className={`p-3 rounded-lg border-2 cursor-pointer transition-all duration-200 ${
                        activeRoute === route.id
                          ? "border-blue-500 bg-blue-50"
                          : "border-gray-200 hover:border-gray-300"
                      }`}
                      onClick={() => selectRoute(route.id)}
                    >
                      <div className="flex items-center justify-between mb-2">
                        <div className="flex items-center gap-2">
                          <div className="w-4 h-4 rounded-full" style={{ backgroundColor: route.color }}></div>
                          <span className="font-medium">{route.name}</span>
                        </div>
                        {activeRoute === route.id && <Badge variant="secondary">Aktif</Badge>}
                      </div>
                      <div className="flex justify-between text-sm text-gray-600">
                        <span className="flex items-center gap-1">
                          <Navigation className="w-3 h-3" />
                          {route.distance}
                        </span>
                        <span className="flex items-center gap-1">
                          <Clock className="w-3 h-3" />
                          {route.duration}
                        </span>
                      </div>
                    </div>
                  ))}
                </CardContent>
              </Card>
            )}
          </div>

          {/* Sağ Panel - Harita */}
          <div className="lg:col-span-2">
            <Card className="h-[800px]">
              <CardHeader>
                <CardTitle>Rota Haritası</CardTitle>
                <CardDescription>Hesaplanan rotalar harita üzerinde görüntüleniyor</CardDescription>
              </CardHeader>
              <CardContent className="p-0">
                <div ref={mapRef} className="w-full h-[720px] rounded-b-lg" style={{ minHeight: "720px" }} />
              </CardContent>
            </Card>
          </div>
        </div>
      </div>
    </div>
  )
}
