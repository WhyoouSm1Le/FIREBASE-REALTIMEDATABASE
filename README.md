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
8. [Menjalankan Aplikasi Di Web (Chrome/EDGE)](#menjalankan-aplikasi-di-web-chromeedge)

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

## 4. Membuat Struktur Data (Path)

### Langkah 9 — Tambah Data Manual

1. Buka tab **Data**.
2. Klik ikon **+** di samping URL database.
3. Isi **Key** dan **Value**, lalu klik **Add**.
4. Ulangi untuk setiap path yang dibutuhkan.

Catatan: **URL database** (contoh: `https://fir-realtimedatabase-7a054-default-rtdb.asia-southeast1.firebasedatabase.app`) akan dipakai pada aplikasi Flutter, jadi salin dan simpan.

![Menambah data manual](docs/images/08-add-data.png)

### Langkah 10 — Hasil Struktur Data

Buat tiga path berikut dengan nilai awal `0`:

| Key | Value | Contoh Kegunaan |
|-----|-------|-----------------|
| `DataSuhu` | `0` | Suhu dari sensor |
| `DataKelembaban` | `0` | Kelembaban udara |
| `DataTanah` | `0` | Kelembaban tanah |

Struktur JSON-nya:

```json
{
  "DataSuhu": 0,
  "DataKelembaban": 0,
  "DataTanah": 0
}
```

![Struktur data akhir](docs/images/09-data-result.png)

**Cara menguji:** klik value pada salah satu path (misalnya `DataSuhu`), ubah angkanya (misalnya menjadi `30`), lalu tekan Enter. Nilai ini nantinya akan langsung berubah di aplikasi Flutter tanpa perlu refresh.

---

## 5. Menghubungkan Flutter ke Firebase

Pada bagian ini project Flutter dihubungkan ke project Firebase yang sudah dibuat, menggunakan **Firebase CLI** dan **FlutterFire CLI**. Semua perintah diketik di **terminal VS Code** (`Ctrl + `` ` ``), kecuali Langkah 11 yang bisa memakai Command Prompt (CMD).

> ⚠️ **Penting:** pastikan **Realtime Database sudah dibuat** (Bagian 2–4) *sebelum* menjalankan `flutterfire configure`. Jika belum, `databaseURL` tidak akan ikut tertulis di file konfigurasi dan harus mengulang proses ini.

### Langkah 11 — Cek Node.js

Firebase CLI membutuhkan **Node.js**. Buka **Command Prompt** (tekan `Win + R`, ketik `cmd`, Enter), lalu jalankan:

```bash
node -v
```

![Cek versi Node.js](docs/images/11-cek-nodejs.png)

- Jika muncul nomor versi (contoh: `v22.21.0`), Node.js sudah terpasang. Lanjut ke Langkah 12.
- Jika muncul pesan `'node' is not recognized as an internal or external command`, Node.js belum terpasang:
  1. Download versi **LTS** di [https://nodejs.org/en/download](https://nodejs.org/en/download).
  2. Jalankan installer dan ikuti langkahnya sampai selesai (biarkan opsi bawaan).
  3. **Tutup lalu buka kembali** CMD/VS Code, kemudian ulangi `node -v`.

### Langkah 12 — Install Firebase CLI

Di terminal project VS Code, jalankan:

```bash
npm install -g firebase-tools
```

![Install Firebase CLI](docs/images/12-install-firebase-tools.png)

Tunggu sampai muncul pesan `changed ... packages`. Peringatan `npm warn deprecated` boleh diabaikan.

### Langkah 13 — Login ke Firebase

Jalankan:

```bash
firebase login
```

Terminal akan menanyakan dua hal (boleh dijawab **No**), lalu membuka browser untuk login.

![Perintah firebase login](docs/images/13-firebase-login.png)

> Jika browser tidak terbuka otomatis, salin URL yang muncul di terminal lalu buka manual di browser.

Di browser:

1. **Pilih akun** Google, gunakan akun yang **sama** dengan yang dipakai membuat project Firebase.

   ![Pilih akun Google](docs/images/14-pilih-akun.png)

2. Klik **Lanjutkan**.

   ![Klik Lanjutkan](docs/images/15-lanjutkan.png)

3. Klik **Izinkan** agar Firebase CLI boleh mengakses akun.

   ![Klik Izinkan](docs/images/16-izinkan.png)

4. Jika muncul tulisan **Firebase CLI Login Successful**, login berhasil. Tab browser boleh ditutup dan kembali ke VS Code.

   ![Login berhasil](docs/images/17-login-sukses.png)

### Langkah 14 — Install FlutterFire CLI

Jalankan:

```bash
dart pub global activate flutterfire_cli
```

> Jika nanti muncul error `flutterfire is not recognized`, tambahkan folder `C:\Users\<nama-user>\AppData\Local\Pub\Cache\bin` ke **Environment Variables → Path**, lalu buka ulang VS Code.

### Langkah 15 — Jalankan `flutterfire configure`

Pastikan posisi terminal berada di **root project Flutter** (satu folder dengan `pubspec.yaml`), lalu jalankan:

```bash
flutterfire configure
```

1. Jika muncul pertanyaan *"You have an existing `firebase.json` file ... reuse the values?"*, pilih **no**. Pertanyaan ini hanya muncul bila project sebelumnya sudah pernah dikonfigurasi.
2. Pilih project Firebase yang tadi dibuat (pada contoh ini: `fir-realtimedatabase-7a054`) dengan **panah atas/bawah**, lalu tekan **Enter**.

![Menjalankan flutterfire configure](docs/images/18-flutterfire-configure.png)

### Langkah 16 — Pilih Platform

Pada pertanyaan *"Which platforms should your configuration support?"*, pilih **web** saja karena aplikasi contoh ini dijalankan di **Chrome/Edge**:

- Gerakkan kursor dengan **panah atas/bawah**.
- Tekan **Spasi** pada `web` sampai muncul tanda centang ✓.
- Tekan **Enter** untuk melanjutkan.

![Memilih platform web](docs/images/19-pilih-platform.png)

> Ingin menjalankan di Android atau platform lain? Ulangi `flutterfire configure` dan centang platform tersebut.

### Langkah 17 — Tambahkan Package `firebase_core`

File yang dihasilkan memakai package `firebase_core`, jadi pastikan sudah terpasang:

```bash
flutter pub add firebase_core
```

### Langkah 18 — Hasil: `firebase_options.dart`

Setelah proses selesai, akan muncul file baru **`firebase_options.dart`** di folder `lib/`.

![File firebase_options.dart](docs/images/20-firebase-options.png)

Isi file (nilai `apiKey`, `appId`, dan `messagingSenderId` pada contoh ini disamarkan, milik kamu akan berbeda):

```dart
// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for android - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'YOUR_API_KEY',
    appId: 'YOUR_APP_ID',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: 'fir-realtimedatabase-7a054',
    authDomain: 'fir-realtimedatabase-7a054.firebaseapp.com',
    databaseURL: 'https://fir-realtimedatabase-7a054-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'fir-realtimedatabase-7a054.firebasestorage.app',
  );
}
```

### Penjelasan Kode `firebase_options.dart`

> File ini **dibuat otomatis** oleh FlutterFire CLI. Jangan diedit manual. Jika ada yang salah atau ingin menambah platform, jalankan ulang `flutterfire configure`.

#### 1. Komentar dan import (baris atas)

```dart
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
```

| Baris | Fungsi |
|-------|--------|
| `// ignore_for_file: type=lint` | Mematikan peringatan *lint* (gaya penulisan) di file ini karena kodenya dibuat mesin. |
| `FirebaseOptions` | Kelas dari `firebase_core` yang menyimpan semua data identitas project Firebase. |
| `kIsWeb` | Bernilai `true` jika aplikasi berjalan di browser. |
| `defaultTargetPlatform` | Memberi tahu platform tempat aplikasi berjalan (Android, iOS, Windows, dan seterusnya). |
| `TargetPlatform` | Daftar nama platform yang dipakai untuk pencocokan di `switch`. |

#### 2. Kelas `DefaultFirebaseOptions`

```dart
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform { ... }
}
```

Kelas ini adalah "pintu masuk" konfigurasi. Bagian yang dipanggil dari `main.dart` adalah **`currentPlatform`**, yang otomatis memilih konfigurasi sesuai platform tempat aplikasi berjalan.

#### 3. Logika pemilihan platform

```dart
if (kIsWeb) {
  return web;
}
switch (defaultTargetPlatform) {
  case TargetPlatform.android:
    throw UnsupportedError(...);
  ...
}
```

- Jika aplikasi berjalan di **web** (`kIsWeb == true`), maka mengembalikan konfigurasi `web`.
- Jika berjalan di platform lain, kode masuk ke `switch`. Karena pada Langkah 16 hanya **web** yang dipilih, platform lain (Android, iOS, macOS, Windows, Linux) akan **melempar `UnsupportedError`** berisi pesan bahwa platform itu belum dikonfigurasi.
- Itu sebabnya aplikasi ini hanya bisa dijalankan di Chrome/Edge. Jika dijalankan di Android, akan muncul error tersebut.

#### 4. Konfigurasi `web`

```dart
static const FirebaseOptions web = FirebaseOptions(
  apiKey: '...',
  appId: '...',
  messagingSenderId: '...',
  projectId: '...',
  authDomain: '...',
  databaseURL: '...',
  storageBucket: '...',
);
```

| Properti | Penjelasan |
|----------|------------|
| `apiKey` | Kunci API untuk mengidentifikasi aplikasi web kamu ke layanan Firebase. |
| `appId` | ID unik aplikasi web yang terdaftar di project Firebase. |
| `messagingSenderId` | ID pengirim untuk Firebase Cloud Messaging (notifikasi). Tidak dipakai di praktik ini, tapi tetap dibuat otomatis. |
| `projectId` | ID unik project Firebase (sama dengan yang tampil saat membuat project). |
| `authDomain` | Domain untuk Firebase Authentication. Belum dipakai selama belum memakai fitur login. |
| `databaseURL` | **Alamat Realtime Database.** Properti inilah yang paling penting di praktik ini, karena aplikasi memakainya untuk membaca/menulis data ke RTDB. |
| `storageBucket` | Lokasi penyimpanan file (Cloud Storage). Tidak dipakai di praktik ini. |

> Untuk praktik ini yang benar-benar dipakai adalah `projectId` dan **`databaseURL`**. Properti lain terisi otomatis dan boleh dibiarkan.

#### 5. Cara file ini dipakai

Nanti di `main.dart`, Firebase diinisialisasi dengan memanggil:

```dart
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

Kode lengkapnya dibahas pada bagian [Membaca Data Realtime di Flutter](#6-membaca-data-realtime-di-flutter).

> ⚠️ **Catatan keamanan**
> `apiKey` pada Firebase Web bukan password, melainkan pengenal project, jadi aman berada di aplikasi. Namun, selama **Security Rules** masih `true` (Langkah 8), siapa pun yang tahu `databaseURL` bisa membaca dan menulis data. Gunakan hanya untuk belajar, dan batasi rules untuk proyek sungguhan.

---

### Troubleshooting Bagian Ini

| Masalah | Penyebab | Solusi |
|---------|----------|--------|
| `'node' is not recognized` | Node.js belum terpasang atau terminal belum di-restart | Install dari [nodejs.org](https://nodejs.org/en/download), lalu buka ulang terminal |
| `npm`/`firebase` ... *running scripts is disabled on this system* | Kebijakan PowerShell memblokir script | Jalankan `Set-ExecutionPolicy -Scope CurrentUser RemoteSigned`, lalu coba lagi |
| `firebase is not recognized` | Folder npm global belum masuk PATH | Tutup dan buka ulang VS Code. Jika masih gagal, cek `npm config get prefix` dan tambahkan ke PATH |
| `flutterfire is not recognized` | Folder Pub Cache belum masuk PATH | Tambahkan `%LOCALAPPDATA%\Pub\Cache\bin` ke PATH |
| Project tidak muncul saat `flutterfire configure` | Login dengan akun Google yang berbeda | Jalankan `firebase logout`, lalu `firebase login` dengan akun yang benar |
| `databaseURL` tidak ada di `firebase_options.dart` | Realtime Database belum dibuat saat configure | Buat RTDB dulu, lalu jalankan ulang `flutterfire configure` |
