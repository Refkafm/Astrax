# Status implementasi — diperbarui 5 Oktober 2026

> Prioritas terbaru: **Apple iPhone/iOS lebih dahulu; Android ditunda.** Target iOS dan pengaturan Keychain ditambahkan. Pengujian langsung memakai iPhone fisik pengguna, tanpa simulator. Rencana di bawah yang khusus Android/capture adalah backlog fase Android, bukan gate rilis Apple. Lihat [APPLE_FIRST.md](APPLE_FIRST.md).

## Batas hasil saat ini

Fondasi Flutter iOS-first dengan alur pencatatan manual dan domain budget/tagihan. Ini bukan pernyataan M0–M5 selesai. PRD dan DESIGN memuat addendum prioritas Apple. Tidak ada dukungan capture yang diklaim atau permission notifikasi yang diminta.

## Cakupan dan gap

| Area | Tersedia | Masih perlu dikerjakan |
|---|---|---|
| ONB / SET | Consent lokal, zona profil Indonesia, anchor 1–31, tanpa login | Wizard lengkap tiga langkah, perubahan anchor/zona pada boundary berikutnya, riwayat perubahan |
| ACC | Akun tiga tipe, saldo awal, saldo ledger, adjustment atomik, ubah nama, arsip/aktifkan kembali, hapus akun tanpa referensi | Histori detail lengkap; guard capture saat fase Android |
| TXN | Manual expense/income/transfer/fee/refund/adjustment; validasi waktu dan money; edit, tombstone; command replay; histori lintas periode dengan filter tanggal/akun/kategori/tipe, pencarian merchant/catatan, kelompok tanggal dan subtotal harian | Filter sumber manual/otomatis saat capture Android tersedia; pagination database (saat ini hanya daftar UI bertahap dari snapshot penuh); command receipts untuk delete/link/undo; UI pemulihan 7 hari di luar snackbar |
| CAT | Tabel kategori sistem/kustom, tambah, arsip/aktifkan kembali; tersedia pada transaksi, budget, tagihan dan ringkasan | Pilihan ikon custom, alias merchant dan aturan pengguna |
| BUD | Batas total, alokasi, revision, snapshot konsisten, periode parsial, default periode baru | Histori periode, label budget disalin, notifikasi threshold sekali per revisi/periode |
| SAFE | L/B/E/R/C/K/S/A, overdue reserve, income terjadwal tidak masuk uang tersedia, breakdown defisit terpisah | Kualitas data capture, readiness catch-up besar, layar stale/error lebih lengkap |
| BILL | Template mingguan/bulanan, anchor asli, occurrence unik, actual payment/link/skip, income schedule; ubah nominal satu occurrence unpaid; nonaktifkan template dengan pilihan mempertahankan atau melewati tagihan mendatang (overdue dipertahankan) | Edit atribut template lainnya, alasan skip, pengingat OS, batching catch-up besar |
| ANA | Gross/net/refund/income, kategori dan angka harian; top 5 merchant expense net termasuk refund lintas periode; pembanding periode sebelumnya dengan jumlah hari setara dan gate cakupan penuh; filter akun/kategori hanya pada Ringkasan dengan chip aktif dan reset | Chart, drill-down, penanda cakupan pada tren harian |
| CAP | Halaman status belum tersedia, manual tetap berfungsi | Seluruh Kotlin listener + sanitizer + encrypted durable queue, Pigeon, parser registry, Inbox, HMAC dedup, mapping, consent lifecycle dan support matrix |
| Privasi | Encrypted SQLite3MultipleCiphers mode SQLCipher, random key via secure storage, fail-closed, aturan exclude backup Android; ekspor CSV dengan periode, peringatan plaintext, formula guard, share sheet iOS, hapus file sementara setelah berbagi | Keystore/ABI/device validation, app lock, UI privacy mode, hapus semua data/kunci/cache, diagnostics opt-in dan retention; uji ekspor fisik iPhone |
| UI | Tokens terpusat, reusable components, empat tab, local font, form berlabel dan CTA tetap | ThemeExtension, motion/pressed-shadow polish, status lengkap dan audit TalkBack semua alur |
| Rilis | Android scaffold minSdk26, lockfile, schema v2 | Android SDK/build, release signing, upgrade migration suite, performance 10k records, perangkat OEM, closed pilot dan policy review |

## Verifikasi yang dilakukan

Suite terbaru: 45 pengujian lulus; `flutter analyze` tanpa temuan. Migrasi schema v1/v2→v3 diuji, termasuk mempertahankan jadwal lama. Layout Ringkasan diuji pada lebar 320–844 dan skala teks 1×/2×; alur panel filter akun diuji. Build release iOS dan instalasi pada iPhone fisik sudah berhasil untuk fitur sebelumnya; filter Ringkasan baru perlu uji perangkat setelah pemasangan build berikutnya.

- Formula fixture: L=5 juta, B=4 juta, E=1 juta, R=1 juta, D=20 → S=2 juta, A=100 ribu.
- Pembayaran bill melepas reserve dalam commit yang sama; penghapusan pembayaran membuka occurrence kembali.
- Transfer fee, sepuluh replay command, rollback kegagalan di akhir operasi, refund lintas periode dan batas refund.
- Penyesuaian saldo dihitung dari snapshot database di dalam transaksi; retry tidak membuat adjustment kedua.
- Tanggal 31 kembali ke anchor setelah Februari; partial period; kalender date-only disimpan dan dibaca tanpa offset zona host.
- Strict money parser menolak desimal, negatif, scientific notation dan nominal melebihi batas.
- Enkripsi host: file tidak mempunyai header SQLite plaintext, isi sintetis tidak muncul sebagai plaintext, reopen kunci sama berhasil, kunci salah ditolak.
- Shell Home/navigation: 320×700, 360×800, 390×844, 430×900, 680×900, 844×390 pada skala teks 1 dan 2, reduced-motion aktif. Widget tests memeriksa layout exception; bukan pengganti uji TalkBack atau inspeksi semua layar pada perangkat.
- Form: nominal invalid menampilkan pesan dan tidak mengubah ledger.
- Preview Home 390×844 diperiksa secara visual. Fixture preview tidak menjadi data awal aplikasi.

## Keputusan teknis

1. Drift NativeDatabase berjalan di background isolate. Ledger dan bill mutations memakai transaksi SQL, balances tidak disimpan sebagai field mutable.
2. SQLite3MultipleCiphers melalui hook `sqlite3: source: sqlite3mc`, cipher `sqlcipher`, pemeriksaan runtime wajib di semua build. Keputusan mengikuti [dokumentasi enkripsi Drift](https://drift.simonbinder.eu/platforms/encryption/). Ini belum membuktikan gate kompatibilitas Android atau audit kriptografi.
3. `flutter_secure_storage` menjadi adapter awal kunci perangkat; tidak ada kunci produksi hardcoded. Kunci hilang dengan DB existing tidak memicu reset diam-diam.
4. UI mendapat satu FinanceSnapshot konsisten; rumus tidak disalin ke widget. Saat ini snapshot memuat seluruh ledger sehingga optimasi/query pagination masih diperlukan sebelum target performa 10.000 transaksi.
5. Recurrence direkonsiliasi saat initialize/resume dan interval satu menit saat proses berjalan. Materialisasi sampai akhir periode berikutnya; belum ada background scheduler. Catch-up saat ini belum dibatch.
6. Schema v2 menambahkan status arsip akun dan tabel kategori (nama+tipe). Schema v3 menambahkan status aktif template dan nominal override occurrence. Migrasi v1/v2→v3 diuji menjaga saldo/riwayat. Referensi kategori ledger masih berupa nama immutable; belum mendukung rename kategori. Kategori fallback, Biaya admin, dan Gaji dijaga aktif. Kategori yang digunakan alokasi budget aktif atau jadwal belum boleh diarsipkan. Akun yang dipakai template aktif belum boleh diarsipkan.
7. Edit pembayaran sengaja membuka kembali tagihan dengan disclosure. Undo delete mengembalikan transaksi tetapi tidak otomatis menautkan kembali bill; pengguna dapat memakai aksi Tautkan transaksi.
8. Adjustment tersedia sebagai tindakan akun; koreksi adjustment melalui hapus lalu catat ulang. Fitur edit adjustment tidak ditawarkan.

## Urutan lanjutan

1. Sambil Xcode disiapkan, lanjutkan fitur manual; setelah siap, validasi build/signing dan penyimpanan pada iPhone fisik pengguna. Android SDK ditunda.
2. Selesaikan gap M1/M2: histori/filter, recurring editor, merchant rules, dan idempotensi semua command.
3. M0 capture: pilih bank + e-wallet berdasarkan package dan notifikasi sintetis/didonasi tersanitasi; dokumentasikan corpus, versi aplikasi dan perangkat. Jangan membuat parser high-confidence berdasarkan tebakan format.
4. Implementasikan Kotlin queue dan Pigeon, kemudian Inbox/review, fingerprint dan auto-post guard.
5. CSV/privacy/delete/app lock/reminder, analytics lanjut, accessibility/performance QA dan pilot.

Belum ada APK, pengujian Android fisik, klaim precision parser, atau kesiapan Play Store.
