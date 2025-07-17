"use client";
import { useState } from "react";

export default function RouteForm() {
  const [pickup, setPickup] = useState("");
  const [delivery, setDelivery] = useState("");
  const [waypoints, setWaypoints] = useState<string[]>([""]);
  const [result, setResult] = useState<any>(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState("");

  const handleWaypointChange = (index: number, value: string) => {
    const newWaypoints = [...waypoints];
    newWaypoints[index] = value;
    setWaypoints(newWaypoints);
  };

  const addWaypoint = () => setWaypoints([...waypoints, ""]);
  const removeWaypoint = (index: number) =>
    setWaypoints(waypoints.filter((_, i) => i !== index));

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setError("");
    setResult(null);
    try {
      const params = new URLSearchParams({
        pickup,
        delivery,
      });
      waypoints.filter(w => w.trim()).forEach(w => params.append("waypoints", w));
      const res = await fetch(`http://localhost:8000/plan-route?${params.toString()}`);
      if (!res.ok) throw new Error("API hatası");
      const data = await res.json();
      setResult(data);
    } catch (err: any) {
      setError("Bir hata oluştu: " + err.message);
    } finally {
      setLoading(false);
    }
  };

  return (
    <form
      onSubmit={handleSubmit}
      className="bg-white/80 shadow-xl rounded-2xl p-8 max-w-lg mx-auto flex flex-col gap-6 animate-fade-in"
      style={{ backdropFilter: "blur(8px)" }}
    >
      <h2 className="text-2xl font-bold text-center text-blue-700 mb-2 animate-slide-down">Rota Planla</h2>
      <div className="flex flex-col gap-2">
        <label className="font-medium">Başlangıç Adresi</label>
        <input
          className="input input-bordered w-full transition-all focus:ring-2 focus:ring-blue-400"
          value={pickup}
          onChange={e => setPickup(e.target.value)}
          required
          placeholder="Örn: İstanbul, Türkiye"
        />
      </div>
      <div className="flex flex-col gap-2">
        <label className="font-medium">Varış Adresi</label>
        <input
          className="input input-bordered w-full transition-all focus:ring-2 focus:ring-blue-400"
          value={delivery}
          onChange={e => setDelivery(e.target.value)}
          required
          placeholder="Örn: Ankara, Türkiye"
        />
      </div>
      <div className="flex flex-col gap-2">
        <label className="font-medium">Ara Duraklar (isteğe bağlı)</label>
        {waypoints.map((w, i) => (
          <div key={i} className="flex gap-2 items-center animate-fade-in">
            <input
              className="input input-bordered flex-1"
              value={w}
              onChange={e => handleWaypointChange(i, e.target.value)}
              placeholder={`Ara durak ${i + 1}`}
            />
            <button
              type="button"
              onClick={() => removeWaypoint(i)}
              disabled={waypoints.length === 1}
              className="text-red-500 hover:text-red-700 transition-colors font-bold text-lg"
              title="Sil"
            >
              ×
            </button>
          </div>
        ))}
        <button
          type="button"
          onClick={addWaypoint}
          className="text-blue-600 hover:text-blue-800 transition-colors font-semibold mt-1"
        >
          + Ara Durak Ekle
        </button>
      </div>
      <button
        type="submit"
        className="bg-gradient-to-r from-blue-500 to-indigo-600 text-white py-2 rounded-lg font-bold shadow-lg hover:scale-105 transition-transform duration-200"
        disabled={loading}
      >
        {loading ? (
          <span className="flex items-center justify-center gap-2">
            <span className="animate-spin rounded-full h-5 w-5 border-t-2 border-b-2 border-white"></span>
            Yükleniyor...
          </span>
        ) : (
          "Rota Hesapla"
        )}
      </button>
      {error && <div className="text-red-500 text-center animate-shake">{error}</div>}
      {result && (
        <div className="bg-blue-50 border border-blue-200 rounded-lg p-4 mt-2 animate-fade-in">
          <h3 className="font-bold text-blue-700 mb-2">Sonuç</h3>
          <pre className="text-xs text-gray-700 whitespace-pre-wrap">{JSON.stringify(result, null, 2)}</pre>
        </div>
      )}
    </form>
  );
}
