# TransWiseAI
# Bu dosya bilgilendirme amaçlıdır, npm install ile yüklenir!
next
react
react-dom
tailwindcss
postcss
autoprefixer
lucide-react
@headlessui/react
shadcn-ui
## Kurulum ve Çalıştırma

1. **Sanal Ortam Oluşturun (Önerilir):**
   ```powershell
   python -m venv venv
   .\venv\Scripts\activate
   ```

2. **Gerekli Paketleri Yükleyin:**
   ```powershell
   pip install -r requirements.txt
   ```

3. **Projeyi Başlatın:**
   ```powershell
   uvicorn app.main:app --reload
   ```

4. **API'ye Erişim:**
   - [http://127.0.0.1:8000](http://127.0.0.1:8000)
   - Swagger dokümantasyonu: [http://127.0.0.1:8000/docs](http://127.0.0.1:8000/docs)

## Notlar
- `app` klasörü içinde servisler ve modeller yer almaktadır.
- Hata veya eksik paket durumunda, terminaldeki hata mesajına göre requirements.txt dosyasına ekleme yapabilirsiniz.
