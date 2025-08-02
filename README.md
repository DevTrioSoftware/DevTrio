# TranswiseAI - Akıllı Lojistik Planlama ve Takip Sistemi

TranswiseAI, akıllı lojistik planlama ve takip için geliştirilmiş modern bir Flutter uygulamasıdır.

## 📱 Özellikler

- **Kullanıcı Yönetimi**: Kayıt, giriş ve profil yönetimi
- **Kargo Takibi**: Gerçek zamanlı kargo takip sistemi  
- **Şoför Paneli**: Onaylanmış şoförler için özel rota yönetimi
- **Google Maps Entegrasyonu**: Harita üzerinde rota görüntüleme
- **Admin Paneli**: Şoför başvurularını yönetme
- **Responsive Tasarım**: Tüm cihazlarda optimize çalışma

## 🚀 Kurulum

### 1. Proje Klonlama
```bash
git clone https://github.com/YOUR-USERNAME/transwise_ai.git
cd transwise_ai
```

### 2. Bağımlılıkları Yükleme
```bash
flutter pub get
```

### 3. Google Maps API Key Kurulumu

#### Google Cloud Console'da API Key Alma:
1. [Google Cloud Console](https://console.cloud.google.com/) 'a gidin
2. Yeni proje oluşturun veya mevcut projeyi seçin
3. **APIs & Services → Library** bölümünden şu API'leri etkinleştirin:
   - Maps SDK for Android
   - Maps SDK for iOS
   - Geocoding API (opsiyonel)
   - Places API (opsiyonel)
4. **APIs & Services → Credentials** → **+ CREATE CREDENTIALS** → **API key**
5. API key'i kopyalayın ve güvenlik kısıtlamalarını yapın

#### API Key'i Projeye Ekleme:

**Android için:**
`android/app/src/main/AndroidManifest.xml` dosyasında:
```xml
<meta-data 
    android:name="com.google.android.geo.API_KEY"
    android:value="YOUR_GOOGLE_MAPS_API_KEY_HERE" />
```
`YOUR_GOOGLE_MAPS_API_KEY_HERE` kısmını kendi API key'iniz ile değiştirin.

**iOS için:**
`ios/Runner/AppDelegate.swift` dosyasında:
```swift
GMSServices.provideAPIKey("YOUR_GOOGLE_MAPS_API_KEY_HERE")
```
`YOUR_GOOGLE_MAPS_API_KEY_HERE` kısmını kendi API key'iniz ile değiştirin.

### 4. Uygulamayı Çalıştırma
```bash
flutter run
```

## 🏗️ Proje Yapısı

```
lib/
├── core/
│   ├── constants/        # Sabitler (renkler, stringler)
│   ├── models/          # Veri modelleri
│   └── services/        # Servis sınıfları
├── features/
│   ├── auth/           # Kimlik doğrulama
│   ├── admin/          # Admin paneli
│   ├── driver/         # Şoför özellikleri
│   ├── cargo/          # Kargo yönetimi
│   ├── home/           # Ana sayfa
│   ├── profile/        # Profil yönetimi
│   └── tracking/       # Takip sistemi
├── shared/
│   ├── navigation/     # Routing
│   └── widgets/        # Ortak widget'lar
└── main.dart           # Ana uygulama
```

## 📱 Kullanım

### Test Hesapları

**Normal Kullanıcı:**
- Email: `test@test.com`
- Şifre: `123456`

**Admin:**
- Email: `admin@admin.com`
- Şifre: `admin123`

### Ana Özellikler

1. **Şoför Başvurusu**: Ana sayfadan şoförlük için başvuru yapın
2. **Rota Yönetimi**: Onaylanmış şoförler harita üzerinde rotaları görebilir
3. **Kargo Takibi**: Kargo gönderimi ve takip işlemleri
4. **Admin Paneli**: Şoför başvurularını onaylama/reddetme

## 🛠️ Teknolojiler

- **Flutter 3.24+**
- **Provider** (State Management)
- **GoRouter** (Navigation)
- **Google Maps Flutter**
- **Material Design 3**

## 📋 Gereksinimler

- Flutter SDK 3.24.1 veya üstü
- Dart 3.8.1 veya üstü
- Android API 21+ / iOS 12.0+
- Google Maps API Key
