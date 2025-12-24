# 🛍️ Storely App

**Storely** merupakan aplikasi *mobile commerce* yang dirancang untuk menghadirkan pengalaman belanja daring yang efisien, responsif, dan intuitif. Dibangun di atas ekosistem **Flutter**, aplikasi ini mensimulasikan alur transaksi *e-commerce* secara menyeluruh, mulai dari eksplorasi katalog produk multi-kategori, manajemen keranjang belanja pintar, hingga simulasi pembayaran digital.

Proyek ini dikembangkan sebagai bentuk pemenuhan Tugas Besar untuk mata kuliah **Pemrograman Mobile** di Politeknik Negeri Indramayu.

## 🌟 Fitur Unggulan

Aplikasi ini mengintegrasikan berbagai modul fungsional untuk menunjang pengalaman pengguna:

* **Sistem Autentikasi:** Implementasi registrasi dan login pengguna yang aman, terintegrasi dengan layanan *mock backend* (MockAPI).
* **Katalog Produk Dinamis:** Menampilkan ragam produk (Elektronik, Fashion, Aksesoris) yang diambil secara *real-time* melalui integrasi API publik (FakeStoreAPI).
* **Pencarian & Filterisasi:** Fitur pencarian cerdas yang memudahkan pengguna menelusuri produk berdasarkan kata kunci atau kategori spesifik.
* **Detail Produk Komprehensif:** Visualisasi produk dengan resolusi tinggi, dilengkapi deskripsi mendalam dan ulasan rating.
* **Manajemen Keranjang Belanja:** Fleksibilitas dalam menambah, mengurangi, atau menghapus item, serta kalkulasi subtotal otomatis.
* **Logika Promosi & Voucher:** Penerapan kode diskon (contoh: `DISKON50`, `HEMAT10`, `FREEONGKIR`) untuk simulasi pemotongan harga.
* **Simulasi Checkout:** Antarmuka pembayaran yang lengkap dengan validasi alamat pengiriman dan pemilihan metode bayar.
* **Pelacakan Status Pesanan:** Visualisasi alur pesanan pengguna dari tahap pemrosesan sistem hingga pengiriman selesai.
* **Adaptabilitas Tema (Dark Mode):** Dukungan antarmuka responsif yang menyesuaikan preferensi tema perangkat (Gelap/Terang).
* **Personalisasi Profil:** Modul untuk pengelolaan data diri dan pengaturan aplikasi.

## 🛠️ Arsitektur & Pustaka (Tech Stack)

Aplikasi ini dibangun dengan prinsip *Clean Architecture* menggunakan pustaka-pustaka berikut:

* **Framework:** Flutter SDK
* **Bahasa Pemrograman:** Dart
* **Manajemen State:** `provider` (^6.1.1) - Untuk pengelolaan data aplikasi yang reaktif.
* **Jaringan (Networking):** `dio` (^5.4.0) - Menangani permintaan HTTP dengan konfigurasi interceptor.
* **Navigasi:** `go_router` (^13.0.0) - Manajemen rute berbasis deklaratif.
* **Penyimpanan Lokal:** `shared_preferences` (^2.2.2) - Persistensi data sesi dan preferensi pengguna.
* **Komponen UI:** `google_fonts` (Tipografi), `cached_network_image` (Optimasi gambar), `intl` (Format mata uang).

## ⚙️ Panduan Instalasi (Setup)

Ikuti langkah-langkah berikut untuk menyiapkan lingkungan pengembangan lokal:

1.  **Kloning Repositori**
    Pastikan Git telah terinstal, kemudian unduh kode sumber proyek:
    ```bash
    git clone [https://github.com/username-anda/storely-app.git](https://github.com/username-anda/storely-app.git)
    cd storely-app
    ```

2.  **Instalasi Dependensi**
    Unduh seluruh paket pustaka yang diperlukan oleh proyek:
    ```bash
    flutter pub get
    ```

3.  **Konfigurasi Environment**
    Secara *default*, aplikasi telah terkonfigurasi untuk menggunakan:
    * **Produk API:** `https://fakestoreapi.com` (Publik)
    * **User API:** MockAPI (Telah diatur pada `auth_provider.dart`)

## ▶️ Instruksi Menjalankan (Run)

Pastikan Emulator Android telah berjalan atau perangkat fisik terhubung melalui mode *USB Debugging*.

Jalankan perintah berikut untuk mode pengembangan (*Debug*):
```bash
flutter run

## 📦 Cara Build (Export APK)

Untuk membuat file `.apk` yang bisa diinstall di HP Android:

1.  Jalankan perintah build:
    ```bash
    flutter build apk --release
    ```
2.  File APK akan muncul di:
    `build/app/outputs/flutter-apk/app-release.apk`

## 🔑 Informasi Akun Demo

Anda bisa mendaftar akun baru di aplikasi, atau gunakan akun demo berikut (jika tersedia di MockAPI):
* **Email:** `umam@gmail.com`
* **Password:** `123456`

**Ketua Tim / Developer Utama:**
* **Nama:** Khoirul Umam
* **NIM:** 2405029
* **Kelas:** RPL - 2B
* **Institusi:** Politeknik Negeri Indramayu (Polindra)

* **Nama:** Wulan Aulia
* **NIM:** 2405067
* **Kelas:** RPL - 2B
* **Institusi:** Politeknik Negeri Indramayu (Polindra)

* **Nama:** Nela Farokh Rahmayanti
* **NIM:** 2405007
* **Kelas:** RPL - 2B
* **Institusi:** Politeknik Negeri Indramayu (Polindra)

