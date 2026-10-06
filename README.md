# Catatan keuangan — Flutter iOS terlebih dahulu

Implementasi awal dari [PRD](PRD-MVP-Personal-Finance-Indonesia-Flutter.md) dan [DESIGN.md](DESIGN.md). Nama produk belum diputuskan. **Build pengembangan, bukan MVP yang sudah memenuhi gate rilis.** Tidak ada data dummy yang dimasukkan ke database pengguna.

**Prioritas sekarang: iPhone/iOS, Android setelah Apple.** Target iOS sudah ditambahkan (iOS 15+), konfigurasi Keychain dan penyimpanan lokal disiapkan, serta menu capture Android disembunyikan di iOS. [Panduan Apple-first](docs/APPLE_FIRST.md).

## Yang tersedia

- Onboarding dengan disclosure penyimpanan lokal, zona WIB/WITA/WIT dan tanggal siklus.
- Empat tab: Home, Transaksi, Budget, Ringkasan; halaman Akun, Tagihan dan Pengaturan.
- Akun bank/e-wallet/tunai, saldo awal bertimestamp, ubah nama, arsip/aktifkan kembali, dan hapus akun tanpa riwayat.
- Kategori kustom serta arsip kategori lewat Pengaturan → Kelola kategori; tersedia pada transaksi, budget, tagihan dan ringkasan.
- Expense, income, transfer + biaya atomik, refund terbatas, penyesuaian saldo dengan alasan.
- Edit/hapus transaksi; undo melalui snackbar. Saldo selalu diturunkan dari ledger.
- Budget total/alokasi kategori, periode awal parsial, perhitungan Aman Dipakai dan breakdown.
- Jadwal mingguan/bulanan, occurrence idempotent, pembayaran aktual, tautkan transaksi, lewati occurrence.
- Ringkasan numerik pemasukan, pengeluaran gross/net, refund, kategori dan hari.
- Drift/SQLite terenkripsi, kunci acak disimpan melalui secure storage. Cipher tidak tersedia → gagal tertutup.
- Tema krem/mint/butter, Plus Jakarta Sans dibundel offline beserta lisensi OFL.

[Preview Home iOS](docs/previews/home-ios.png) menggunakan fixture sintetis dari DESIGN.md. Preview dibuat oleh widget test, bukan screenshot APK Android.

## Menjalankan

Toolchain yang digunakan: **Flutter 3.47.0 / Dart 3.13.0**. Dependency hasil resolusi ada di `pubspec.lock`. Android `minSdk=26`; target/compile SDK mengikuti versi Flutter, belum dinyatakan lolos validasi rilis.

```sh
flutter pub get
flutter devices
flutter run -d <id-iphone>
```

Untuk build iOS diperlukan **Xcode lengkap beserta iOS SDK**. Pengujian menggunakan iPhone fisik pengguna; runtime simulator tidak diperlukan. Mesin ini baru memiliki Command Line Tools; `xcodebuild -version` belum bisa berjalan. Percobaan `flutter build ios --simulator --debug --no-codesign` belum menghasilkan aplikasi. Setelah Xcode tersedia, ikuti [panduan Apple](docs/APPLE_FIRST.md).

Folder Android tetap tersedia untuk fase berikutnya. Web dan macOS desktop belum menjadi target aplikasi ini.

## Verifikasi

```sh
flutter analyze
flutter test
```

Regenerasi setelah perubahan schema:

```sh
flutter pub run build_runner build
dart format lib test
```

Widget test menghasilkan `docs/previews/home-ios.png`. Fixture hanya berada di folder `test/` dan tidak dijalankan saat startup produksi.

## Struktur

- `lib/core/domain/finance.dart`: money integer, kalender bisnis, immutable read models, formula SAFE.
- `lib/core/database/`: schema Drift v2, pembukaan encrypted DB, use case transaksi atomik.
- `lib/app/`: bootstrap providers, routing, theme dan lifecycle reconciliation.
- `lib/core/widgets/`: surface, money, progress, empty state dan layout bersama.
- `lib/features/`: layar dan form yang memakai snapshot repository.
- `test/`: domain, repository/enkripsi dan widget tests.
- `docs/IMPLEMENTATION_STATUS.md`: pemetaan pekerjaan yang tersedia dan gap PRD.

Belum ada listener, permission capture, parser bank, server, telemetri atau integrasi bank. Halaman Capture menjelaskan status belum tersedia. Enkripsi host sudah diuji, tetapi ABI Android, Keystore, backup exclusion dan process death masih harus diuji pada perangkat.

Perubahan Apple: native iOS menandai direktori Application Support agar dikecualikan dari backup sebelum database dibuka; kunci memakai Keychain `unlocked_this_device` dan tidak disinkronkan. Efektivitas pada perangkat, signing, dan privacy manifest final tetap perlu validasi Xcode/iPhone.
