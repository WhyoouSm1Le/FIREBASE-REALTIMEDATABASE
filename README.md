# FLUTTER + FIREBASE REALTIME-DATABASE

Aplikasi **Flutter** yang terintegrasi dengan **Firebase Realtime Database (RTDB)**.

## Daftar Isi

1. [Prasyarat](#prasyarat)
2. [Membuat Project Firebase](#1-membuat-project-firebase)
3. [Membuat Realtime Database](#2-membuat-realtime-database)
4. [Mengatur Security Rules](#3-mengatur-security-rules)
5. [Membuat Struktur Data (Path)](#4-membuat-struktur-data-path)
6. [Menghubungkan Flutter ke Firebase](#5-menghubungkan-flutter-ke-firebase)
7. [Membaca Data Realtime di Flutter](#6-membaca-data-realtime-di-flutter)
8. [Menjalankan Aplikasi Di Web (Chrome/EDGE)](#menjalankan-aplikasi-di-web-(chrome/edge))

---

## Prasyarat

- Akun Google
- Flutter SDK terpasang (`flutter doctor` tanpa error)
- Editor (VS Code / Android Studio)
- Koneksi internet

---

## 1. Membuat Project Firebase

### Langkah 1 — Buka Firebase Console

1. Buka [https://firebase.google.com](https://firebase.google.com).
2. Login dengan akun Google, lalu klik **Buka konsol** (pojok kanan atas).

![Halaman utama Firebase](docs/images/01-firebase-home.png)

> Banner "Get $300 to unlock all Firebase features" **tidak perlu diklik**. Praktik ini cukup memakai paket gratis **Spark plan**.

### Langkah 2 — Buat Project Baru

Di halaman konsol, klik **Create a new Firebase project**.

![Halaman konsol Firebase](docs/images/02-firebase-console.png)

### Langkah 3 — Beri Nama Project

1. Isi **Project name**, pada contoh ini: `firebaserealtimedatabase`.
2. Firebase otomatis membuat **Project ID** unik (contoh: `fir-realtimedatabase-7a054`). ID ini bisa berbeda di akun masing-masing.
3. Klik **Continue**, lalu ikuti langkah berikutnya sampai project selesai dibuat. Opsi tambahan seperti Gemini atau Google Analytics tidak wajib untuk praktik ini.

![Memberi nama project](docs/images/03-project-name.png)

Setelah selesai, kamu akan masuk ke halaman **Project Overview** dengan label **Spark plan** (gratis, $0/bulan).

---

## 2. Membuat Realtime Database

### Langkah 4 — Buka Menu Realtime Database

Di sidebar kiri, pilih **Databases and storage** lalu klik **Realtime Database** (di bagian *NoSQL*).

> Jangan tertukar dengan **Firestore**. Keduanya sama-sama NoSQL, tetapi contoh ini memakai **Realtime Database**.

![Menu Databases and storage](docs/images/04-menu-database.png)

### Langkah 5 — Create Database

Klik tombol **Create Database**.

![Halaman awal Realtime Database](docs/images/05-create-database.png)

### Langkah 6 — Pilih Lokasi Database

Pada langkah **Database options**, pilih lokasi server. Untuk pengguna di Indonesia, pilih **Singapore (asia-southeast1)** karena paling dekat sehingga latensinya lebih rendah. Lalu klik **Next**.

![Memilih lokasi database](docs/images/06-database-location.png)

---

## 3. Mengatur Security Rules

### Langkah 7 — Pilih Mode Awal

Pada langkah **Security rules**, ada dua pilihan:

| Mode | Keterangan |
|------|------------|
| **Locked mode** | Semua akses dari client ditolak (`.read` dan `.write` bernilai `false`). Paling aman, tetapi aplikasi belum bisa membaca/menulis. |
| **Test mode** | Akses terbuka sementara. Aturan harus diperbarui dalam 30 hari. |

Pada contoh ini pilih **Start in locked mode**, lalu klik **Enable**. Rules akan diubah manual pada langkah berikutnya.

![Pilihan security rules](docs/images/07-security-rules-mode.png)

### Langkah 8 — Ubah Rules agar Bisa Dibaca/Ditulis (untuk Praktik)

1. Buka tab **Rules**.
2. Ubah isinya menjadi:

```json
{
  "rules": {
    ".read": true,
    ".write": true
  }
}
```

3. Klik **Publish** agar perubahan berlaku.

![Mengubah rules](docs/images/10-rules.png)

> ⚠️ **Peringatan keamanan**
> Rules di atas membuat database **terbuka untuk siapa saja** yang memiliki URL-nya. Gunakan hanya untuk **belajar dan pengujian**. Untuk proyek akhir yang sesungguhnya, tambahkan **Firebase Authentication** dan batasi akses, misalnya:
>
> ```json
> {
>   "rules": {
>     ".read": "auth != null",
>     ".write": "auth != null"
>   }
> }
> ```

---
