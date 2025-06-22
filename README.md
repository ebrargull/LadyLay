# 🌸 LadyLay – Kadın Sağlığı ve Güvenliği Uygulaması / Women's Health & Safety Companion App

**LadyLay**, kadınların sağlığını ve güvenliğini desteklemek için geliştirilen SwiftUI tabanlı bir mobil uygulamadır. / **LadyLay** is a SwiftUI-based mobile application designed to support women's well-being.  
Uygulama iki ana özellikle kadınlara yardımcı olur: / The app provides two main features:  
1. Regl dönemi takibi için takvim tabanlı bir ekran / A calendar-based menstrual cycle tracker  
2. Güvenli ve güvensiz konumları işaretleyip yaklaşınca bildirim gönderme / Location-based safety alerts

Uygulama **SwiftUI** ve **Firebase** kullanılarak geliştirilmiştir, gizlilik ve kullanıcı deneyimi ön planda tutulmuştur. / Built with **SwiftUI** and **Firebase**, the app prioritizes privacy and user experience.

---

## 🌟 Özellikler / Features

### 🗓️ Regl Takvimi / Menstrual Cycle Tracker
- Regl dönemlerini kolayca ekleyip görüntüleme / Easily log and view menstrual periods  
- Gelecek dönem ve yumurtlama tahminleri / Predict upcoming cycles and fertile windows  
- Etkileşimli takvim arayüzü / Interactive calendar interface

### 🗺️ Güvenli Konum Haritası / Safety Map & Alerts
- Kullanıcılar güvenli veya güvensiz konumları haritada işaretleyebilir / Users can mark safe or unsafe locations  
- Belirlenen güvensiz konumlara yaklaşıldığında bildirim gönderilir / Real-time alerts when approaching unsafe areas  
- Kadınların günlük hayatta daha güvende hissetmesini amaçlar / Aims to enhance women's safety in everyday life

### 🎨 Kişiselleştirme / Personalization
- Açık/Koyu mod ve renk teması seçimi / Light/Dark modes and theme options  
- SwiftUI ile sade ve modern arayüz / Clean and modern UI using SwiftUI  
- Tüm veriler Firebase ile güvenli şekilde saklanır / All data is securely stored using Firebase

### 🔔 Bildirimler / Notifications
- Yakın çevrede güvensiz konum varsa uyarı gönderir / Sends alerts when near unsafe zones  
- Regl dönemi yaklaşırken hatırlatmalar (isteğe bağlı) / Optional cycle reminders

---

## 🛠️ Kullanılan Teknolojiler / Technologies Used

- **SwiftUI** – Deklaratif arayüz tasarımı / Declarative UI framework  
- **Firebase** – Gerçek zamanlı veritabanı ve kimlik doğrulama / Real-time database and authentication  
- **MapKit** – Harita özellikleri için / For interactive map features  
- **Yerel Bildirimler** – Lokasyon bazlı uyarılar için / For location-based notifications  
- **MVVM Mimarisi** – Kod yapısında ayrıştırma / Clean separation of logic and UI

---

## 🔐 Gizlilik ve Güvenlik / Privacy & Security

- Uygulama üçüncü taraf veri paylaşımı yapmaz / No third-party data sharing  
- Konum ve regl verileri Firebase’de güvenli biçimde saklanır / Sensitive data is securely stored in Firebase  
- Konum bilgisi yalnızca cihaz içinde ve anlık bildirimler için kullanılır / Location access is used only locally for alerts

---

## 📷 Ekran Görüntüleri / Screenshots

> `Screenshots/` klasörüne görselleri ekleyin ve aşağıya bağlantılarını yazın. / Upload your screenshots in the `Screenshots/` folder and link them below.

### 🗓️ Takvim Ekranı / Calendar View  
<img src="Screenshots/calendar.png" width="250"/>

### 🗺️ Harita ve Konumlar / Map and Locations  
<img src="Screenshots/map.png" width="250"/>

### ⚙️ Ayarlar ve Tema Seçimi / Settings & Theme Selection  
<img src="Screenshots/settings.png" width="250"/>

---

## 🔧 Nasıl Çalıştırılır / How to Run

```bash
1. Depoyu klonlayın / Clone the repository
2. Xcode ile açın / Open the project in Xcode
3. Firebase yapılandırmasını tamamlayın (GoogleService-Info.plist) / Set up Firebase with GoogleService-Info.plist
4. iOS 16+ simülatör veya cihazda çalıştırın / Run on iOS 16+ simulator or real device
