# 🛍️ Storely App

**Storely** merupakan aplikasi *mobile commerce* yang dirancang untuk menghadirkan pengalaman belanja daring yang efisien, responsif, dan intuitif. Dibangun di atas ekosistem **Flutter**, aplikasi ini mensimulasikan alur transaksi *e-commerce* secara menyeluruh, mulai dari eksplorasi katalog produk multi-kategori, manajemen keranjang belanja pintar, hingga simulasi pembayaran digital.

Proyek ini kami kembangkan sebagai bentuk pemenuhan **Tugas Besar Mata Kuliah Pemrograman Mobile** di **Politeknik Negeri Indramayu**.

---

## 🌟 Fitur Unggulan

Aplikasi ini mengintegrasikan berbagai modul fungsional untuk menunjang pengalaman pengguna:

- **Sistem Autentikasi**  
  Registrasi dan login pengguna yang terintegrasi dengan *mock backend* (MockAPI)

- **Katalog Produk Dinamis**  
  Produk multi-kategori (Elektronik, Fashion, Aksesoris) dari FakeStoreAPI

- **Pencarian & Filterisasi**  
  Pencarian produk berdasarkan kata kunci dan kategori

- **Detail Produk Komprehensif**  
  Gambar resolusi tinggi, deskripsi produk, harga, dan rating

- **Manajemen Keranjang Belanja**  
  Tambah, kurangi, hapus item dengan perhitungan subtotal otomatis

- **Logika Promosi & Voucher**  
  Simulasi diskon menggunakan kode seperti `DISKON50`, `HEMAT10`, `FREEONGKIR`

- **Simulasi Checkout**  
  Validasi alamat pengiriman dan pemilihan metode pembayaran

- **Pelacakan Status Pesanan**  
  Monitoring status pesanan dari proses hingga selesai

- **Adaptabilitas Tema (Dark Mode)**  
  Antarmuka menyesuaikan tema sistem (gelap/terang)

- **Personalisasi Profil**  
  Pengelolaan data akun dan pengaturan aplikasi

---

## 🛠️ Arsitektur & Tech Stack

Aplikasi ini dibangun menggunakan prinsip **Clean Architecture** dengan teknologi berikut:

- **Framework:** Flutter SDK  
- **Bahasa Pemrograman:** Dart  
- **State Management:** `provider` (^6.1.1)  
- **Networking:** `dio` (^5.4.0)  
- **Navigasi:** `go_router` (^13.0.0)  
- **Local Storage:** `shared_preferences` (^2.2.2)  
- **UI Utilities:** `google_fonts`, `cached_network_image`, `intl`

---

## ⚙️ Panduan Instalasi (Setup)

### 1. Kloning Repository
```bash
git clone https://github.com/username-anda/storely-app.git
cd storely-app

2. Instalasi Dependensi
flutter pub get
3. Konfigurasi Environment
Secara default aplikasi menggunakan:

Produk API: https://fakestoreapi.com

User API: MockAPI (dikonfigurasi pada auth_provider.dart)

▶️ Menjalankan Aplikasi
Pastikan emulator Android aktif atau perangkat fisik terhubung melalui USB Debugging.

flutter run
📦 Build APK (Release)
Untuk menghasilkan file APK:

flutter build apk --release
File akan tersedia di:

build/app/outputs/flutter-apk/app-release.apk
🔑 Akun Demo
Anda dapat mendaftar akun baru, atau menggunakan akun demo berikut:

Email: umam@gmail.com

Password: 123456

👥 Tim Pengembang
Program Studi D4 Rekayasa Perangkat Lunak
Politeknik Negeri Indramayu — Kelas 2B

Nama	NIM	Peran
Khoirul Umam	2405029	Ketua Tim / Lead Developer
Wulan Aulia	2405067	UI/UX Designer & Frontend Developer
Nela Farokh Rahmayanti	2405007	Frontend Developer & Quality Assurance

📄 Penutup
© 2025 Storely App
Dikembangkan untuk keperluan akademik menggunakan Flutter.