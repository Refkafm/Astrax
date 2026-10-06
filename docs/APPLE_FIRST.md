# Apple terlebih dahulu — 5 Oktober 2026

Arahan pemilik produk menggantikan prioritas Android-first pada baseline PRD. Target tahap ini adalah iPhone/iOS dengan Flutter, bukan rewrite SwiftUI atau aplikasi macOS. Android tetap ada tetapi pengembangan capture Android ditunda.

## Implementasi

- Runner iOS, Xcode project/workspace, AppDelegate/SceneDelegate dan konfigurasi Flutter dibuat dari Flutter 3.47.0.
- Deployment target iOS 15.0 sesuai scaffold; iPad tersedia secara teknis tetapi validasi utama iPhone.
- Nama tampilan sementara “Catatan keuangan”, lokalisasi Indonesia, light theme sesuai DESIGN.md.
- Ketiga build configuration menggunakan `Runner/Runner.entitlements` untuk akses Keychain.
- Kunci ledger: `unlocked_this_device`, `synchronizable: false`. Tidak meminta Face ID atau mengklaim app lock.
- Sebelum membuka ledger, method channel native menyiapkan Application Support: exclude backup dan complete-until-first-user-authentication file protection. Kegagalan diteruskan ke layar pemulihan, bukan diabaikan.
- Akun, ledger, budget, tagihan dan SAFE memakai domain Flutter yang sama. Tidak ada data dummy produksi.
- Menu capture tidak muncul pada Transaksi/Pengaturan iOS. Rute capture jika dibuka langsung menjelaskan pencatatan manual; tidak meminta Notification Access Android.

## Menjalankan di Mac

Pemeriksaan perangkat terbaru: Xcode 27.0 (27A266a) sudah aktif, CocoaPods tersedia, dan iPhone fisik terdeteksi pada iOS 26.6.2. Percobaan `flutter run` berhenti karena belum tersedia sertifikat development signing. Konfigurasi Apple ID/Personal Team diperlukan sebelum aplikasi dapat dipasang. Pemeriksaan kompilasi tanpa signing dilakukan terpisah.

Pengujian memakai **iPhone fisik milik pengguna**, tanpa emulator/simulator. Xcode lengkap dan iOS SDK tetap diperlukan untuk mengompilasi serta menandatangani aplikasi; runtime simulator tidak perlu dipasang untuk alur ini.

1. Pasang Xcode lengkap, buka dan selesaikan komponen awal yang dibutuhkan untuk perangkat iOS.
2. Pilih Xcode di Settings → Locations → Command Line Tools. Alternatif terminal setelah instalasi:

```sh
sudo xcode-select -s /Applications/Xcode.app/Contents/Developer
sudo xcodebuild -runFirstLaunch
flutter doctor -v
```

3. Sambungkan iPhone ke Mac lewat USB, buka kunci perangkat dan pilih **Trust This Computer**.
4. Aktifkan **Settings → Privacy & Security → Developer Mode** pada iPhone, lalu ikuti restart/konfirmasi. Jika opsi belum muncul, hubungkan ke Xcode terlebih dahulu.
5. Buka workspace:

```sh
open ios/Runner.xcworkspace
```

6. Pada target **Runner → Signing & Capabilities**, pilih Apple ID/Personal Team milik pengguna dan aktifkan **Automatically manage signing**. Bundle `id.local.catatanUang` masih placeholder; ubah ke identifier unik milik pengguna jika provisioning memerlukannya. Signing development untuk test perangkat tidak perlu menunggu branding/App Store final.
7. Pilih iPhone sebagai tujuan Run di Xcode, atau jalankan:

```sh
flutter pub get
flutter devices
flutter run -d <id-iphone>
```

Jika iPhone meminta kepercayaan sertifikat developer, ikuti Settings → General → VPN & Device Management. Apple ID/Personal Team dapat digunakan untuk pengujian pribadi; distribusi App Store merupakan alur terpisah.

Belum ada Apple Team, provisioning profile, atau identitas perangkat yang dikonfigurasi otomatis dalam repository. Tidak ada upload App Store/TestFlight pada langkah pengujian ini.

Panduan resmi: [Flutter iOS setup](https://docs.flutter.dev/platform-integration/ios/setup).

## Verifikasi dan batasnya

Hasil terbaru: `flutter analyze` tanpa temuan dan 32 pengujian lulus. Sintaks Swift serta plist/project lolos pemeriksaan.

`flutter analyze` dan `flutter test` memeriksa kode Dart, ledger/enkripsi host, channel contract/fail-closed dan layout widget. `test/widgets/layout_test.dart` memakai TargetPlatform.iOS pada lebar 320–680 serta landscape, skala teks 100%/200%; preview `docs/previews/home-ios.png` adalah render widget sintetis, bukan screenshot simulator.

Tanpa Xcode lengkap, Swift belum dapat ditautkan dengan Flutter/UIKit, belum ada `.app`/IPA, dan berikut belum diverifikasi di iPhone: SQLCipher native assets, Keychain persisten, backup exclusion, lifecycle/lock, VoiceOver, keyboard serta safe-area perangkat nyata.

## Urutan pekerjaan

1. Build langsung ke iPhone fisik; uji relaunch/persistence, key failure, backup policy dan UI.
2. Selesaikan gap manual MVP: account/category lifecycle, filter/histori, recurring editor, CSV, app lock, pengingat iOS dan hapus semua data.
3. Validasi privacy manifest seluruh plugin, App Privacy, encryption declarations, signing dan TestFlight setelah scope manual siap.
4. Setelah Apple stabil, kembali ke M0 capture Android: Kotlin listener/queue, corpus terverifikasi, Pigeon, Inbox dan lifecycle OEM.

Capture dua sumber bank/e-wallet bukan persyaratan rilis iOS. Formula keuangan dan persyaratan integritas/privacy tetap wajib; pengalihan platform tidak berarti seluruh MVP sudah selesai.

## Hasil percobaan perangkat terbaru

- Build perangkat tanpa signing berhasil: `flutter build ios --debug --no-codesign` menghasilkan `build/ios/iphoneos/Runner.app`. Ini memverifikasi kompilasi iOS, bukan instalasi atau perilaku runtime.
- Development Team kini sudah dipilih di Xcode.
- Percobaan `flutter run` berikutnya gagal saat Xcode menulis build manifest/attachments: `No space left on device`. Ruang bebas saat pemeriksaan terakhir sekitar 602 MiB. Pembersihan artefak proyek sebelumnya memungkinkan build unsigned, tetapi belum mencukupi untuk build/install berikutnya.
- Aplikasi belum terpasang/berjalan melalui sesi ini. Kosongkan beberapa GB ruang Mac (disarankan sedikitnya 5 GB untuk percobaan berikutnya), lalu ulangi build ke iPhone. Signing/provisioning masih harus dikonfirmasi berhasil setelah hambatan storage terselesaikan.

## Status instalasi iPhone

Bundle bertanda tangan dari `build/ios/Debug-iphoneos/Runner.app` berhasil dipasang langsung memakai `devicectl`, menghindari salinan tambahan Flutter yang sempat gagal karena disk penuh. Setelah pengguna mempercayai profil developer, `devicectl device process launch` berhasil dan proses Runner terdeteksi aktif. Koneksi debugger Flutter serta tampilan onboarding/database belum terkonfirmasi; keberhasilan launch proses bukan bukti seluruh alur aplikasi sudah lulus.

## Pengujian dari Home Screen

Pengujian pertama menunjukkan pesan Flutter bahwa aplikasi debug tidak boleh diluncurkan langsung dari Home Screen tanpa tooling/debugger. Karena itu pengujian mandiri pengguna memakai **release build dengan development signing**, bukan distribusi App Store.

```sh
flutter build ios --release
# Instalasi dan launch dilakukan ke iPhone yang dipilih melalui devicectl.
```

Build debug tetap dipakai untuk hot reload melalui `flutter run`; jangan memasang debug lalu meluncurkannya langsung menggunakan devicectl/Home Screen untuk menyimpulkan startup Flutter berhasil. Proses Runner aktif saja belum membuktikan Dart engine atau database siap.

## Uji release pada iPhone — 6 Oktober 2026

`flutter build ios --release` berhasil menghasilkan bundle 21.6 MB. Bundle dipasang dengan `devicectl device install app` dan dibuka dengan `devicectl device process launch`; kedua perintah berhasil. Pengguna mengonfirmasi onboarding tampil dan alur akun Tunai Rp100.000 → budget Rp80.000 → pengeluaran Rp10.000 menghasilkan Saldo tercatat Rp90.000 dan Aman Dipakai Rp70.000.

Ekspor CSV tersedia dari Pengaturan → Data. Pengguna memilih rentang tanggal, membaca peringatan bahwa CSV tidak terenkripsi, lalu memilih tujuan melalui share sheet iOS (termasuk Simpan ke File). File sementara dihapus setelah share sheet selesai; sisa ekspor terputus dibersihkan saat ekspor berikutnya. Perilaku share sheet dan simpan file pada iPhone perlu diuji setelah build baru dipasang.

Tab Transaksi kini dapat menampilkan histori di luar periode berjalan melalui pemilih tanggal, lalu menyaring akun, kategori, tipe, serta mencari merchant/catatan. Daftar dikelompokkan menurut tanggal dengan subtotal pengeluaran bersih. Data masih dibaca dari snapshot penuh; pagination database untuk riwayat besar belum selesai.

Antarmuka tab Transaksi disederhanakan: pencarian, Periode, dan Filter menjadi kontrol utama. Jenis, akun, dan kategori dibuka hanya saat tombol Filter dipilih, dengan jumlah filter aktif pada tombol. Pengujian layout iPhone 320–844 dp pada skala teks 1×/2× dan alur panel filter lulus; build release terbaru berhasil dipasang serta dibuka di iPhone.

Pengelolaan tagihan sekarang memiliki menu pada tagihan belum dibayar untuk mengubah nominal occurrence itu saja atau menonaktifkan jadwal. Saat menonaktifkan, pengguna memilih apakah occurrence mendatang yang sudah dibuat tetap tampil atau dilewati; tagihan terlambat dan selesai tetap ada. Migrasi database v3 mempertahankan data dari v1/v2. Pengingat perangkat dan edit detail template lainnya masih perlu dibuat.

Ringkasan menampilkan lima merchant teratas berdasarkan pengeluaran bersih; refund dikaitkan dengan merchant transaksi asal. Perbandingan pengeluaran memakai jumlah hari yang sama pada periode sebelumnya dan hanya ditampilkan sebagai persentase bila cakupan periode sebelumnya lengkap serta denominator tidak nol.

Ringkasan kini mempunyai filter akun dan kategori dalam satu panel. Chip pilihan aktif dan Reset tampil saat filter digunakan. Semua angka dan pembanding di Ringkasan mengikuti filter; Home dan rumus Aman Dipakai tetap memakai seluruh catatan.
