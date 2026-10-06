# PRD MVP — Personal Finance Indonesia-first

> **Perubahan prioritas — 5 Oktober 2026:** atas arahan pemilik produk, implementasi dan validasi rilis pertama ditujukan ke **Apple iPhone/iOS**, kemudian Android. Flutter tetap dipakai. Pernyataan Android-first dan gate capture Android di dokumen baseline di bawah ditunda ke fase Android; bukan gate rilis iOS. iOS menggunakan pencatatan manual dan tidak menjanjikan pembacaan notifikasi aplikasi lain. Formula ledger, budget, tagihan, privasi, dan arah visual tetap berlaku. Detail: [Rencana Apple-first](docs/APPLE_FIRST.md).


**Versi:** 1.0 · **Tanggal:** 4 Oktober 2026 · **Status:** baseline implementasi, dengan gate validasi capture pada M0.  
**Platform rilis MVP:** Android, aplikasi Flutter + integrasi native Kotlin.  
**Bahasa/mata uang:** Bahasa Indonesia, IDR. Nama produk belum ditentukan.  
**Pembaca:** product owner, designer, Flutter/Android developer, QA, dan Codex.

## 1. Ringkasan dan keputusan produk

Aplikasi membantu pengguna Indonesia mencatat uang masuk/keluar dari bank, e-wallet, dan tunai, mengatur budget, serta mengetahui estimasi uang yang masih dapat dipakai sampai akhir periode. Pencatatan manual selalu tersedia; capture notifikasi mengurangi pekerjaan manual pada sumber Android yang kompatibel.

Inspirasi dari pembahasan bajet.lah adalah kesederhanaan expense tracking, kategorisasi, budget, dan daily allowance. Dokumen ini menetapkan rancangan produk baru, bukan klaim bahwa semua fitur atau integrasi tersebut tersedia pada produk referensi.

| Keputusan | Ketentuan MVP |
|---|---|
| Distribusi | Android-first; minSdk usulan 26, dikunci setelah kompatibilitas Flutter/dependensi diverifikasi M0; target SDK mengikuti persyaratan Play saat rilis |
| Framework | Flutter stable, Dart; Kotlin untuk notification listener dan durable capture queue |
| Data | Local-first, single-device, tanpa login, backend, sinkronisasi bank, atau cloud sync |
| Capture | Opt-in, hanya notifikasi baru dari package/template yang sudah diverifikasi; izin akses bukan koneksi rekening |
| Posting otomatis | Default OFF; pengguna boleh mengaktifkan per sumber setelah mapping akun; hanya kandidat berkeyakinan tinggi |
| Kategori pintar | Aturan lokal deterministik, alias merchant, dan aturan pilihan pengguna; tanpa LLM |
| Saldo | Saldo pembukuan dari saldo awal + transaksi, bukan saldo rekening real-time |
| Budget | Satu batas total per periode; alokasi kategori opsional; semua pengeluaran aktual dan tagihan termasuk batas total |
| Aman Dipakai | Estimasi konservatif dari uang tercatat, batas budget, dan kewajiban; bukan jaminan saldo bank atau prediksi pendapatan |
| Tagihan | Recurring expense/income sebagai jadwal; jatuh tempo tidak otomatis berarti transaksi terjadi |
| Ekspor | CSV atas tindakan pengguna; impor/restore dan backup terenkripsi belum masuk MVP |
| Telemetri | Event lokal dengan skema terbatas; tidak dikirim otomatis; ekspor diagnostik opsional dan eksplisit |

Semua requirement di dokumen ini wajib MVP kecuali ditandai **opsional**, **roadmap**, atau **di luar scope**. Nomor requirement menjadi referensi tiket implementasi dan acceptance test.

## 2. Product vision, pengguna, dan masalah

### Product vision

Membantu pengguna menjawab “uangku dipakai untuk apa dan berapa yang masih masuk akal dipakai sampai akhir periode?” dalam kurang dari satu menit, dengan catatan yang dapat diperiksa dan dikoreksi.

### Target user

| Segmen | Situasi | Kebutuhan utama |
|---|---|---|
| Utama: pekerja bergaji 22–40 tahun | Gajian bulanan, beberapa bank/e-wallet, pembayaran QRIS, tagihan rutin | Batas belanja sampai gajian tanpa mencatat semuanya satu per satu |
| Sekunder: freelancer | Pemasukan tidak tetap, biaya rumah tangga dan kerja bercampur | Melihat uang yang benar-benar sudah diterima; menghindari asumsi pendapatan masa depan |
| Sekunder: mahasiswa/first-jobber | Uang saku atau gaji terbatas, banyak transaksi kecil/tunai | Input cepat, kategori lokal, budget sederhana |

Pengguna tidak harus memberi akses notifikasi. MVP tidak ditujukan untuk pembukuan usaha, investasi, akuntansi pajak, atau pengelolaan kredit.

### Problem statements

1. Transaksi tersebar antara tunai, bank, dan e-wallet sehingga catatan tidak lengkap.
2. Pencatatan manual repetitif membuat pengguna berhenti sebelum mendapat manfaat.
3. Saldo terlihat cukup, tetapi sebagian diperlukan untuk kos, listrik, internet, dan langganan.
4. Top-up dan transfer mudah dihitung dua kali sebagai pengeluaran.
5. Pengguna sulit mempercayai hasil otomatis bila sumber, kategori, dan cara memperbaikinya tidak jelas.
6. Format notifikasi berubah dan tidak semua pembayaran menghasilkan notifikasi yang bisa dibaca.

### Jobs to be done

- Setelah membayar, saya ingin transaksi tercatat atau siap dikonfirmasi dengan sedikit tindakan.
- Sebelum berbelanja, saya ingin melihat ruang belanja berdasarkan catatan yang tersedia.
- Saat mendekati gajian, saya ingin tahu tagihan mana yang masih harus disisihkan.
- Saat angka salah, saya ingin melihat penyebab dan memperbaikinya tanpa merusak riwayat.

## 3. Goals, non-goals, dan ukuran keberhasilan

### Goals

| ID | Sasaran | Target validasi awal, bukan klaim hasil |
|---|---|---|
| G01 | Time to first value | ≥80% peserta usability dapat membuat akun, transaksi, budget, dan membaca Aman Dipakai ≤5 menit |
| G02 | Pencatatan cepat | Median input pengeluaran manual ≤20 detik setelah onboarding |
| G03 | Keterpercayaan capture | Precision kandidat high-confidence ≥99% pada corpus holdout; salah nominal/arah/akun = gagal gate |
| G04 | Cakupan realistis | Recall ≥90% hanya pada template yang dinyatakan didukung; cakupan di luar template dilaporkan terpisah |
| G05 | Konsistensi | Tidak ada transaksi ganda atau perubahan saldo parsial pada seluruh skenario crash/retry teruji |
| G06 | Kegunaan berulang | Target pilot: ≥40% pengguna teraktivasi memakai aplikasi pada minggu ke-2; evaluasi dengan peserta yang menyetujui pengukuran |

Aktivasi = minimal satu akun, satu transaksi tersimpan, satu budget aktif, dan layar rincian Aman Dipakai pernah dibuka. Pengukuran pilot melalui event lokal yang diekspor sukarela; tidak tersedia dashboard server untuk seluruh populasi.

### Non-goals dan larangan scope

- **Goals/tabungan tujuan, Debt/PayLater, Shared Expense, AI Assistant, forecasting lanjutan, Financial Health, dan Net Worth tidak masuk MVP.**
- Tidak ada akun kartu kredit, limit kredit, cicilan, saldo pinjaman, penilaian kesehatan finansial, atau agregasi aset/liabilitas.
- Tidak ada login bank, OTP harvesting, scraping mobile banking, akses SMS langsung, Accessibility Service, atau open banking.
- Tidak ada OCR struk, multi-currency, transfer uang, pembayaran tagihan, split transaksi, investasi, fitur keluarga, atau sinkronisasi antarperangkat.
- Pengeluaran pembayaran kredit yang pengguna catat manual boleh menjadi pengeluaran umum; tidak menghasilkan fitur pengelolaan utang.
- iOS bukan target penerimaan rilis MVP. Port berikutnya memakai fitur manual; jangan menjanjikan parity capture notifikasi lintas aplikasi.

## 4. Information architecture

Empat tab utama menjaga navigasi sederhana; Accounts dan Bills memiliki halaman khusus yang dapat diakses dari Home.

```text
Onboarding
 ├─ Penjelasan data lokal dan keterbatasan saldo
 ├─ Tambah akun + saldo awal
 ├─ Pilih awal periode + budget total
 └─ Capture opsional → penjelasan → pengaturan Android → mapping sumber

Navigasi utama
 ├─ Home
 │   ├─ Aman Dipakai → rincian formula + kualitas data
 │   ├─ Total saldo tercatat → Accounts → detail akun
 │   ├─ Tagihan mendatang → Bills → detail occurrence/template
 │   ├─ Ringkasan budget
 │   └─ Capture perlu review → Capture Inbox
 ├─ Transaksi
 │   ├─ Riwayat + filter/search
 │   ├─ Detail/edit transaksi
 │   └─ Capture Inbox
 ├─ Budget
 │   ├─ Total periode + kategori
 │   └─ Edit periode berikutnya / lihat histori
 └─ Ringkasan
     ├─ Pemasukan/pengeluaran bersih
     ├─ Breakdown kategori + merchant
     └─ Tren harian + perbandingan periode

Aksi global “+” → pengeluaran / pemasukan / transfer
Pengaturan → kategori, capture & izin, pengingat, app lock,
             privasi, ekspor CSV, hapus semua data, versi aplikasi
```

Istilah UI: “Akun” = sumber uang, bukan akun login. “Hubungkan bank” dilarang dipakai untuk mapping notifikasi; gunakan “Pilih sumber notifikasi”.

## 5. User flows utama

| Flow | Langkah normal | Cabang/hasil |
|---|---|---|
| F01 Onboarding | Baca penjelasan → buat akun → saldo awal saat ini → awal periode → budget → Home | Semua langkah selain consent dasar dapat dilewati; metrik yang belum siap menampilkan CTA, bukan angka palsu |
| F02 Pengeluaran manual | Tap + → nominal → akun → kategori yang disarankan → simpan | Merchant/catatan opsional; validasi inline; sukses memperbarui saldo, budget, Home, dan Ringkasan |
| F03 Capture setup | Disclosure → setuju → buka Notification Access → kembali → pilih sumber → mapping akun | Ditolak/dicabut: manual tetap berfungsi; tampil status aktual |
| F04 Capture review | Notifikasi baru → queue → parse → Inbox → koreksi/konfirmasi | Unsupported/ambigu tidak diposting; discard tidak mengubah saldo |
| F05 Auto-post | Opt-in per sumber → notifikasi high-confidence → transaksi + label Otomatis | Snackbar/feed memberi akses koreksi; kemungkinan duplikat/transfer/pendapatan tetap review |
| F06 Transfer/top-up | Pilih asal dan tujuan → nominal + biaya opsional → simpan atomik | Principal bukan expense; biaya menjadi expense terpisah yang terhubung |
| F07 Budget | Buka Budget → batas total → alokasi kategori → simpan | Alokasi melebihi total ditolak; revisi periode aktif ditandai |
| F08 Bills | Buat jadwal → occurrence jatuh tempo → tandai dibayar atau tautkan transaksi | Tidak otomatis mendebit saldo; pencocokan capture hanya saran |
| F09 Koreksi saldo | Detail akun → sesuaikan saldo → masukkan saldo yang diketahui + alasan | Sistem membuat adjustment selisih; tidak masuk income/expense/budget |
| F10 Akhir periode | App dibuka/tanggal berubah → buat periode baru + occurrence secara idempotent | Carry-over budget tidak ada; tagihan belum dibayar tetap dicadangkan |
| F11 Cabut akses | Pengaturan capture → hentikan capture → petunjuk cabut akses Android | Listener membuang event berikutnya; pending draft boleh ditinjau/dihapus |

## 6. Functional requirements

### 6.1 Onboarding dan pengaturan

- **ONB-01:** Tanpa registrasi. Nama panggilan opsional, default tidak diperlukan.
- **ONB-02:** Input IDR integer dengan format `Rp1.250.000`; locale `id_ID`. Keyboard nominal; copy/paste dengan pemisah ribuan dinormalisasi ketat.
- **ONB-03:** Awal periode default tanggal 1, dapat dipilih 1–31 mengikuti siklus gajian. Tanggal ini hanya batas periode, tidak membuat pemasukan otomatis.
- **ONB-04:** Zona waktu profil disarankan dari perangkat dan dikonfirmasi: Asia/Jakarta, Asia/Makassar, atau Asia/Jayapura. Zona profil tidak berubah diam-diam saat bepergian.
- **ONB-05:** Saldo awal diberi timestamp. UI menjelaskan saldo adalah pembukuan lokal dan bisa berbeda dari bank.
- **SET-01:** Perubahan siklus berlaku pada batas periode berikutnya; jangan menulis ulang histori. Bila diperlukan buat periode transisi pendek, tanpa gap atau overlap, dengan budget yang diminta ulang, bukan diprorata diam-diam.

### 6.2 Accounts

- **ACC-01:** Tipe `bank`, `e_wallet`, `cash`; contoh label BCA, BRI, Mandiri, BNI, Jago, GoPay, OVO, DANA, ShopeePay, Tunai. Label bukan janji capture didukung.
- **ACC-02:** Field wajib nama dan saldo awal; warna/icon opsional. Tidak meminta nomor rekening lengkap, kredensial, PIN, atau OTP.
- **ACC-03:** Saldo dihitung dari saldo awal dan ledger; saldo tidak boleh diedit langsung tanpa adjustment.
- **ACC-04:** Saldo awal nonnegatif. Saldo hasil transaksi boleh negatif agar mismatch tidak disembunyikan, tetapi beri peringatan “Periksa catatan akun”. Tidak menafsirkan nilai negatif sebagai utang.
- **ACC-05:** Semua akun aktif adalah sumber saldo likuid Aman Dipakai. Tidak ada toggle pengecualian akun dalam MVP agar scope budget konsisten.
- **ACC-06:** Akun hanya boleh diarsipkan bila saldo nol, tidak punya pending capture, mapping aktif, atau tagihan unpaid yang menggunakannya. Riwayat tetap ada. Penghapusan hanya untuk akun tanpa transaksi/referensi.
- **ACC-07:** Detail akun berisi saldo, saldo awal, riwayat, tanggal penyesuaian terakhir, dan sumber capture yang dipetakan.
- **ACC-08:** Transaksi sebelum `opening_at` akun ditolak, termasuk capture terlambat. Untuk mulai di tengah bulan, histori sebelum saldo awal tidak ditebak.

### 6.3 Transaksi manual dan ledger

- **TXN-01:** Jenis `expense`, `income`, `transfer`, `refund`, `adjustment`. Form normal hanya menonjolkan tiga jenis pertama; refund dari detail expense, adjustment dari akun.
- **TXN-02:** Wajib nominal positif, akun, waktu kejadian, serta kategori untuk expense/income; “Belum dikategorikan” adalah kategori valid. Merchant/catatan opsional.
- **TXN-03:** Nominal berupa integer rupiah 64-bit, batas input produk Rp999.999.999.999 per transaksi; tidak memakai floating-point. Pecahan rupiah dari parser tidak dibulatkan diam-diam; masuk review.
- **TXN-04:** Transaksi aktual tidak boleh bertanggal masa depan. Untuk rencana masa depan gunakan Bills/recurring.
- **TXN-05:** Transfer harus memiliki dua akun berbeda, principal sama, satu waktu. Top-up bank→e-wallet dan tarik tunai bank→cash adalah transfer. Biaya top-up/admin menjadi expense `Biaya admin` terpisah dalam commit yang sama.
- **TXN-06:** Refund wajib menunjuk expense asal, boleh parsial dan kembali ke akun berbeda; total refund tidak melebihi nominal asal. Refund mengurangi expense pada tanggal refund, bukan menulis ulang periode asal. Refund lintas periode ditampilkan jelas.
- **TXN-07:** Edit/delete memperbarui semua turunan atomik. Delete memakai tombstone untuk undo 7 hari; tidak menghapus fingerprint capture sehingga event replay tidak membuat transaksi kembali.
- **TXN-08:** Expense yang punya refund tidak dapat dihapus atau diturunkan di bawah total refund sampai refund dibatalkan. Perubahan akun/waktu tetap mengikuti saldo awal.
- **TXN-09:** Hapus/edit transaksi yang melunasi bill akan membuka kembali occurrence atau meminta pengguna melepas tautan terlebih dahulu. Satu transaksi hanya melunasi satu occurrence dalam MVP.
- **TXN-10:** Riwayat diurutkan waktu kejadian terbaru, tie-break ID. Filter periode, akun, kategori, tipe, sumber manual/otomatis; search merchant/catatan lokal; pagination untuk daftar panjang.
- **TXN-11:** Simpan ganda akibat double-tap dicegah oleh disabled submit dan `command_id` unik di database. Tidak memakai nominal+waktu sebagai dedup manual karena transaksi identik dapat sah.
- **TXN-12:** Adjustment menyimpan selisih bertanda, alasan, dan waktu; tidak masuk budget atau grafik expense/income. Ada label “Penyesuaian saldo”.

### 6.4 Automatic capture dan Capture Inbox

- **CAP-01:** Integrasi Kotlin `NotificationListenerService`. Notification access dibuka melalui pengaturan sistem dan selalu dapat ditolak.
- **CAP-02:** Pengguna memilih sumber dari katalog package yang telah diverifikasi, lalu mapping ke akun. Satu package yang mencakup beberapa rekening memerlukan discriminator aman dari template atau selalu review; tidak menebak rekening.
- **CAP-03:** Filter package terlebih dahulu di native layer. Buang notifikasi non-allowlist, summary group, promo, OTP, status gagal/pending, dan konten kosong sebelum persist. Tidak membaca seluruh aplikasi lalu menyimpan semuanya.
- **CAP-04:** Kandidat minimal: package, source event key, post time, nominal, arah transaksi, merchant opsional, account mapping, rule ID/version, tier keyakinan, dan alasan review.
- **CAP-05:** Tiga tier deterministik: `high` = template tested + transaksi final/sukses + satu nominal transaksi yang jelas + arah pasti + mapping tunggal; `review` = field bisnis perlu konfirmasi; `reject` = bukan transaksi/format tak dikenal. Tier bukan probabilitas statistik.
- **CAP-06:** Auto-post hanya `expense` high yang bukan indikasi transfer, bukan kemungkinan duplikat, dan bukan kandidat bill/refund yang belum dipastikan. Income, transfer, refund, dan kandidat bill masuk review pada MVP. Kategori tidak diketahui boleh “Belum dikategorikan”.
- **CAP-07:** Default semua kandidat masuk Inbox. Pilihan “Catat otomatis transaksi yang dikenali” per sumber terpisah dari izin OS; riwayat consent lokal disimpan.
- **CAP-08:** Inbox memungkinkan ubah nominal, akun, tanggal, merchant, kategori, tipe; konfirmasi, tautkan ke transaksi existing, atau abaikan. Tampilkan alasan “Akun belum jelas”/“Kemungkinan transfer”, bukan skor tanpa penjelasan.
- **CAP-09:** Jika timestamp transaksi tidak ada, pakai waktu posting dengan label “Waktu notifikasi”. Timestamp absurd/masa depan tidak diposting otomatis.
- **CAP-10:** Tidak backfill histori notifikasi. Pada koneksi ulang boleh memeriksa notifikasi aktif dari sumber pilihan dan setelah consent start, tetapi fingerprint tetap wajib; ini bukan recovery semua event hilang.
- **CAP-11:** Catatan auto-post mempunyai provenance dan editability yang sama dengan manual; edit pengguna tidak ditimpa pembaruan notifikasi.
- **CAP-12:** Status layanan: tidak didukung, belum diaktifkan, aktif, terputus, izin dicabut, sumber belum dipetakan, atau antrean belum diproses. “Aktif” hanya status listener, bukan bukti semua transaksi tertangkap.
- **CAP-13:** Batas queue 1.000 item sanitasi; TTL 7 hari. Saat penuh jangan buang tanpa sinyal: increment counter dan tampilkan “Sebagian notifikasi mungkin belum tercatat”. Draft hasil parsing disimpan sampai pengguna menyelesaikan, dengan reminder kebersihan setelah 30 hari.
- **CAP-14:** Format tak dikenal dibuang tanpa raw text permanen; simpan hanya reason counter. Pengguna diberi fallback “Catat manual”. Tidak mengirim notifikasi finansial ke layanan eksternal untuk meminta parsing.

#### Deduplication dan transfer

1. Event update dengan notification key sama dan hash isi sama: no-op. Key sama tetapi isi berbeda adalah revisi, bukan transaksi kedua secara default.
2. Gunakan HMAC lokal atas reference transaksi yang benar-benar tersedia, dibatasi sumber/akun; jangan menyimpan referensi lengkap. Unique key ini mencegah replay yang pasti.
3. Tanpa reference, simpan fingerprint event key + waktu posting + normalized payload hash; ini mencegah retry event yang sama, bukan memastikan kesamaan ekonomi.
4. Kandidat dengan akun/arah/nominal/merchant sama dalam ±120 detik dari transaksi existing diberi `possible_duplicate`; jangan hapus otomatis karena dua pembelian identik bisa sah.
5. Dua sumber berbeda dengan nominal sama tidak digabung otomatis. Bank→wallet adalah saran transfer yang harus dikonfirmasi. Satu transfer dapat ditautkan ke dua capture events.
6. Jika transaksi manual sudah dicatat, pengguna menautkan kandidat ke transaksi tersebut; tidak menciptakan ledger baru. Jangan mengubah nominal manual diam-diam.
7. Notification key dipakai ulang atau satu notifikasi agregat berisi banyak pembayaran → review/reject sampai template mempunyai event identity yang dapat dibuktikan.

#### Launch support matrix

| Sumber | Status sebelum M0 | Syarat menjadi “Didukung” |
|---|---|---|
| Bank lokal kandidat, mis. BCA/BRI/Mandiri | Belum diverifikasi; bukan komitmen integrasi | Package identity, format debit, versi aplikasi, OS/device, hasil corpus dan uji perangkat dicatat |
| E-wallet kandidat, mis. GoPay/DANA/OVO | Belum diverifikasi | Nominal transaksi dapat dibedakan dari saldo, promo, cashback, dan top-up |
| Tunai | Manual | Tidak memiliki notifikasi pembayaran |
| SMS, WhatsApp, email, browser | Di luar scope capture | Tidak dimasukkan allowlist |

M0 memilih **minimal dua package nyata: satu bank dan satu e-wallet**, berdasarkan bukti, bukan popularitas saja. Jika tidak ada dua yang lolos, fitur capture belum memenuhi definisi MVP dan jadwal/scope harus diputuskan ulang secara eksplisit; jangan mengiklankan dukungan universal. Katalog rilis menyimpan package, template version, jenis transaksi, last verified app version, OS/device yang diuji, dan keterbatasan.

### 6.5 Smart categories

- **CAT-01:** Urutan deterministik: pilihan eksplisit transaksi → aturan merchant pengguna → alias merchant bawaan → aturan kata kunci template → Belum dikategorikan.
- **CAT-02:** Koreksi kategori menawarkan “Gunakan juga untuk merchant ini”; default hanya transaksi saat ini. Tidak diam-diam melatih model atau mengubah histori.
- **CAT-03:** Normalisasi trim/case/punctuation; strip nomor terminal hanya pada pola yang diuji. Merchant raw yang sudah disanitasi dan canonical disimpan terpisah. Sediakan undo aturan.
- **CAT-04:** Merchant agregator ambigu tidak diberi kategori pasti: “Gojek” bisa transport/makanan/top-up; Shopee/Tokopedia tidak cukup untuk mengetahui jenis barang. Gunakan info layanan hanya bila template jelas.
- **CAT-05:** Kategori bawaan dapat diarsipkan, bukan dihapus bila terpakai. Kategori custom: nama, icon, tipe expense/income. Tidak ada hierarki subkategori MVP.
- **CAT-06:** Terapkan aturan baru hanya untuk transaksi berikutnya; bulk recategorization histori di luar scope. Refund mewarisi kategori expense asal dan mengikuti koreksinya.

Seed expense: Makan & minum, Belanja harian, Transportasi, Tempat tinggal, Listrik & air, Internet & pulsa, Kesehatan, Pendidikan, Hiburan & langganan, Belanja pribadi, Keluarga, Donasi, Biaya admin, Lainnya, Belum dikategorikan. Seed income: Gaji, Freelance/usaha, Hadiah, Lainnya.

Contoh alias awal yang tetap bisa dikoreksi: Indomaret/Alfamart → Belanja harian; PLN → Listrik & air; KAI/MRT/TransJakarta → Transportasi; layanan GoFood/GrabFood yang teridentifikasi → Makan & minum. Tidak mengklaim afiliasi merchant.

### 6.6 Budget

- **BUD-01:** Satu budget total `B` per periode, termasuk pengeluaran rutin dan nonrutin. Budget bukan jumlah pemasukan dan tidak bertambah otomatis saat ada income.
- **BUD-02:** Alokasi kategori opsional; jumlah alokasi ≤ B. Selisih ditampilkan sebagai “Belum dialokasikan”, bukan uang tambahan di luar B.
- **BUD-03:** Penggunaan budget = posted expense dikurangi posted refund pada periode tersebut; termasuk transaksi manual dan auto-post, tidak termasuk draft, income, transfer principal, opening balance, adjustment.
- **BUD-04:** Tampilkan aktual, sisa, persen, dan reserve tagihan terpisah. Overspend tidak di-clamp menjadi nol pada rincian; tampilkan nilai kelebihan. Progress visual boleh max 100% dengan label “Melebihi Rp…”.
- **BUD-05:** Warning kategori/total saat mencapai 80% dan 100%, in-app tanpa bergantung izin pengingat. Per threshold satu kali per revisi/periode agar tidak spam.
- **BUD-06:** Edit budget aktif diizinkan dengan konfirmasi dan revision timestamp. Budget periode selesai read-only; transaksi backdate tetap dapat mengubah actual historis.
- **BUD-07:** Periode baru menyalin batas total/alokasi periode sebelumnya sebagai default dengan label “Disalin dari periode lalu”. Tidak rollover sisa atau defisit. Tawarkan review.
- **BUD-08:** Jika onboarding di tengah periode, pengguna memasukkan batas belanja tersisa dari hari mulai sampai boundary berikutnya. Tandai “Periode awal parsial”; jangan menganggap histori sebulan lengkap atau memprorata diam-diam.

### 6.7 Aman Dipakai dan Home

- **HOME-01:** Urutan Home: Aman Dipakai + per hari, warning kualitas data, saldo tercatat, tagihan mendatang, budget ringkas, transaksi terbaru/capture review.
- **HOME-02:** Setiap angka dapat dibuka untuk melihat komponen dan transaksi pembentuknya. Saldo bukan net worth; jangan tampilkan aset investasi atau utang.
- **SAFE-01:** Label lengkap: “Estimasi Aman Dipakai” dan “Berdasarkan catatan sampai [waktu]”. Bila pending capture atau listener terputus tampilkan “Periksa catatan”; tidak menjanjikan data lengkap hanya karena Inbox kosong.
- **SAFE-02:** Pendapatan yang dijadwalkan tetapi belum diterima tidak dihitung. Kenaikan saldo dari income belum tentu menaikkan angka jika sisa budget menjadi batas lebih kecil.
- **SAFE-03:** Jika belum ada akun atau budget: tampil `—` dengan CTA yang sesuai; bukan Rp0. Jika input lengkap tetapi dana habis: Rp0 dengan rincian defisit.
- **SAFE-04:** Rincian formula wajib memakai definisi dan contoh pada Bagian 7. Tidak ada forecast AI atau health score.

### 6.8 Bills dan recurring transactions

- **BILL-01:** Template memiliki nama, arah expense/income, estimasi nominal positif, kategori, akun default, frequency bulanan/mingguan, tanggal pertama, reminder, status aktif. Template bukan ledger transaction.
- **BILL-02:** Generate occurrence terpisah, unik per template+tanggal. Bulanan tanggal 29–31 di-clamp ke hari terakhir bulan, lalu kembali ke anchor asli pada bulan berikutnya.
- **BILL-03:** State occurrence `unpaid`, `paid`, `skipped`. Overdue adalah turunan `unpaid && due_date < today`, bukan state yang menutup kewajiban. Scheduled income memakai UI “Belum diterima/Diterima”.
- **BILL-04:** “Tandai dibayar” meminta nominal aktual, tanggal, akun; membuat expense dan tautan atomik. Alternatif: tautkan expense existing. Tidak ada pembayaran sebagian, satu pembayaran untuk banyak bills, atau debt amortization MVP.
- **BILL-05:** Capture dengan merchant/nominal/tanggal dekat memberi saran tautan (default ±3 hari, nilai sama). Selalu konfirmasi; tidak membuat bill paid hanya karena notifikasi diterima.
- **BILL-06:** Nominal variabel seperti PLN dapat diedit per occurrence; perubahan template hanya memengaruhi occurrence unpaid mendatang yang belum di-override pengguna. Riwayat paid tidak berubah.
- **BILL-07:** Nonaktifkan template menghentikan occurrence masa depan dan meminta keputusan untuk unpaid yang sudah dibuat; tagihan overdue tidak hilang diam-diam. Skip meminta alasan opsional dan melepaskan reserve.
- **BILL-08:** Reminder default sehari sebelum jatuh tempo pukul 09.00 zona profil. Izin reminder terpisah; tanpa izin, daftar tagihan tetap bekerja. Tidak menjanjikan pengiriman tepat menit.
- **BILL-09:** Rekonsiliasi occurrence dijalankan saat startup/resume/perubahan tanggal/template. Materialisasi sampai akhir periode berikutnya; proses dengan batching jika app lama tidak dibuka, indikator loading sebelum SAFE dihitung. Background delivery bukan syarat kebenaran data.
- **BILL-10:** Jadwal income hanya pengingat; tidak meningkatkan saldo/Aman Dipakai sampai confirmed posted income. Tidak ada auto-post karena tanggal gajian tiba.

### 6.9 Basic analytics

- **ANA-01:** Ringkasan periode: total income, expense gross, refund, expense net, dan selisih income−expense net. Adjustment/transfer tidak masuk cash-flow summary ini.
- **ANA-02:** Breakdown kategori dan top 5 merchant memakai expense net; nama kosong dikelompokkan “Tanpa merchant”. Transfer/top-up principal tidak muncul sebagai belanja.
- **ANA-03:** Tren harian memakai hari lokal profil. Hari tanpa transaksi bernilai nol, hari sebelum mulai pencatatan ditandai “Belum ada cakupan”.
- **ANA-04:** Refund lintas periode dapat membuat kategori net negatif; gunakan bar/table, bukan pie/donut yang tidak dapat menggambarkan nilai negatif. Tampilkan gross dan refund di drill-down.
- **ANA-05:** Bandingkan periode aktif hanya sampai jumlah hari berlalu yang sama pada periode sebelumnya, dibatasi panjang periode sebelumnya dan diberi label rentang. Jika denominator nol tampil “Belum ada pembanding”; histori parsial tidak diberi persentase seolah lengkap.
- **ANA-06:** Filter akun dan kategori hanya memengaruhi Ringkasan, bukan formula Home. Tampilkan chip filter dan reset. Semua grafik punya versi daftar numerik.
- **ANA-07:** Insight hanya fakta deterministik, mis. kategori terbesar atau budget terlewati. Tidak ada saran investasi, forecast, financial score, atau AI text.

## 7. Business logic “Aman Dipakai”

### 7.1 Periode dan waktu

Periode berbentuk `[start_date, end_date_exclusive)` dalam zona profil. Awal siklus tanggal 25 menghasilkan periode 25 September–24 Oktober; boundary berikutnya 25 Oktober. Untuk anchor 31, batas bulanan di-clamp ke akhir bulan. Tanggal lokal menggunakan kalender, bukan membagi selisih detik dengan 86.400.

`as_of` adalah saat perhitungan. Semua transaksi aktual harus `occurred_at <= as_of`. Periode awal boleh parsial dari onboarding ke boundary berikutnya. Saat zona profil diubah, minta konfirmasi dan hanya terapkan pada periode baru; histori mempertahankan business date yang sudah dicatat.

### 7.2 Definisi dan formula

| Simbol | Definisi |
|---|---|
| `L` | Jumlah saldo saat ini semua akun aktif: opening + posted ledger sampai as_of; akun arsip wajib saldo nol |
| `B` | Batas budget total periode aktif, termasuk tagihan |
| `E` | Posted expense dikurangi refund di periode aktif, semua akun; dapat negatif bila refund lintas periode |
| `R` | Total estimasi occurrence expense unpaid yang jatuh tempo sebelum akhir periode, **termasuk overdue dari periode sebelumnya**, tanpa menghitung occurrence paid/skipped atau scheduled income |
| `C` | Ruang saldo setelah kewajiban: `L − R` |
| `K` | Ruang budget setelah aktual dan kewajiban: `B − E − R` |
| `S` | Aman Dipakai: `max(0, min(C, K))` |
| `D` | Jumlah hari kalender dari hari ini sampai end_date_exclusive; hari ini termasuk; minimal 1 untuk periode aktif yang valid |
| `A` | Aman Dipakai per hari: `floor(S / D)` rupiah; jangan bulatkan naik |

Defisit saldo `max(0, −C)` dan defisit budget `max(0, −K)` ditampilkan **terpisah**, tidak dijumlahkan karena dapat mewakili masalah yang sama. Nilai negatif L atau reserve melebihi uang tersedia memicu CTA periksa saldo/tagihan.

Tidak ada potongan seluruh sisa alokasi kategori lagi setelah K dihitung: alokasi adalah pembagian B, bukan kewajiban tambahan. Reserve tidak ditambahkan ke expense actual sebelum pembayaran.

### 7.3 Mengapa tagihan tidak dihitung dua kali

Contoh: L=Rp5.000.000, B=Rp4.000.000, E=Rp1.000.000, R=Rp1.000.000, D=20.

```text
C = 5.000.000 − 1.000.000 = 4.000.000
K = 4.000.000 − 1.000.000 − 1.000.000 = 2.000.000
S = min(4.000.000, 2.000.000) = 2.000.000
A = floor(2.000.000 / 20) = 100.000 per hari
```

Bayar bill Rp500.000 pada hari yang sama dan tautkan occurrence dalam satu commit: L menjadi Rp4.500.000, E Rp1.500.000, R Rp500.000. C dan K tetap sama, sehingga S tetap Rp2.000.000. Jika pembayaran hanya dicatat sebagai expense tanpa ditautkan, reserve masih ada; UI meminta review kemungkinan pembayaran bill, tanpa diam-diam menganggap lunas.

### 7.4 Edge cases wajib

| Kondisi | Hasil yang diharapkan |
|---|---|
| Gaji terjadwal besok | L tidak bertambah; S tidak memakai pendapatan masa depan |
| Transfer Rp1 juta bank→wallet | L/E/S tidak berubah; biaya admin saja mengurangi L dan menambah E |
| Refund Rp100 ribu diterima | L naik Rp100 ribu, E turun Rp100 ribu pada periode penerimaan; cek batas refund asal |
| Budget habis, saldo masih besar | S=0 karena K≤0 |
| Saldo kecil, budget masih besar | S dibatasi C |
| Bill overdue dari bulan lalu | Masuk R sampai paid/skipped, walaupun bukan occurrence periode ini |
| Hari terakhir periode | D=1; setelah tengah malam buat periode baru sebelum menghitung |
| Bill dibayar lebih besar dari estimasi | L/E memakai actual; R melepas estimasi occurrence, selisih menurunkan S sebagaimana mestinya |
| Capture draft belum dikonfirmasi | Tidak mengubah L/E/R; badge “Ada transaksi belum diperiksa” dan angka berstatus sementara |
| Tak ada budget | S/A tidak tersedia; saldo masih ditampilkan |
| Awal pencatatan di tengah bulan | Pakai budget sisa yang dimasukkan pengguna; label parsial |
| Hapus transaksi pembayaran bill | Occurrence kembali unpaid dan reserve kembali; lakukan atomik |

Perhitungan memakai satu snapshot transaksi database setelah recurrence catch-up selesai. Jangan gabungkan stream L baru dengan R lama. `SafeToSpendService` merupakan fungsi domain murni atas snapshot, clock, dan kalender periode; seluruh formula harus memiliki unit tests.

## 8. Batas teknis Android, permissions, dan privacy capture

`NotificationListenerService` mengirim callback notifikasi yang dapat diakses OS; layanan ini bukan API transaksi bank. Android membatasi listener pada beberapa konfigurasi, termasuk work profile dan perangkat low-RAM Android Q atau lebih lama. Penanganan callback harus ringan dan meneruskan pekerjaan ke worker native. [Dokumentasi Android NotificationListenerService](https://developer.android.com/reference/android/service/notification/NotificationListenerService).

Android 15 dapat menyamarkan notifikasi yang terdeteksi mengandung OTP bagi listener yang tidak dipercaya. Parser wajib menerima konten hilang/redacted sebagai kondisi normal; jangan mencoba bypass. [Perubahan Android 15](https://developer.android.com/about/versions/15/behavior-changes-all).

| Akses | Tujuan | Kebijakan produk |
|---|---|---|
| Notification Access | Membaca notifikasi sumber yang dipilih | Special access melalui Settings; disclosure in-app sebelum navigasi; opsional |
| `BIND_NOTIFICATION_LISTENER_SERVICE` | Melindungi deklarasi service native | Permission pada deklarasi service sesuai API, bukan dialog runtime biasa |
| `POST_NOTIFICATIONS` | Mengirim pengingat Bills milik aplikasi | Diminta kontekstual saat reminder diaktifkan pada Android yang memerlukannya; tidak memberi akses membaca notifikasi |
| Biometrik/device credential | App lock opsional | Gunakan API OS; tanpa menyimpan template biometrik |
| Boot receiver bila dibutuhkan scheduler | Menjadwalkan ulang reminder setelah reboot | Hanya untuk pengingat; bukan jaminan capture selalu hidup |
| File export | Menyimpan CSV yang diminta pengguna | Gunakan system picker/share sheet; tanpa izin penyimpanan luas |
| SMS, contacts, location, accessibility | Tidak dibutuhkan | Jangan deklarasikan/request |

Android memisahkan runtime permission untuk notifikasi keluar dari akses listener; implementasi dan copy harus membedakannya. [Notification permission Android](https://developer.android.com/develop/ui/compose/notifications/notification-permission).

Disclosure contoh: “Dengan izin Android, aplikasi dapat menerima isi notifikasi. Kami hanya memproses notifikasi dari aplikasi yang Anda pilih untuk menyiapkan catatan transaksi di perangkat ini. Data tidak dikirim ke server. Sebagian notifikasi mungkin tidak terbaca. Anda dapat melanjutkan dengan pencatatan manual.” Tautkan penjelasan data yang disimpan dan cara mencabut izin.

Consent harus didapat sebelum membuka Settings dan sebelum menyimpan event; toggling consent off segera menonaktifkan ingest di aplikasi meskipun izin OS belum dicabut. Setelah reinstall/import masa depan, consent tidak boleh diwariskan diam-diam. Disclosure, consent, dan Data Safety harus sesuai implementasi aktual, mengikuti kebijakan data pengguna Google Play; ini gate pemeriksaan rilis, bukan klaim persetujuan Play. [Google Play User Data](https://support.google.com/googleplay/android-developer/answer/10144311).

Keterbatasan yang wajib ada pada bantuan produk:

- Notifikasi sumber dimatikan, konten disembunyikan, format berubah, work profile dibatasi, OS/OEM memutus layanan, force-stop, atau reboot sebelum unlock dapat membuat transaksi terlewat.
- Listener permission tidak menjamin penerimaan seluruh transaksi. Tidak ada pembacaan histori rekening atau saldo otomatis yang otoritatif.
- Nama merchant, timestamp, saldo, cashback, biaya, dan nominal transaksi dapat ambigu. Jika beberapa nominal ada, parsing harus berdasarkan template field, bukan mengambil angka terbesar/pertama.
- Dukungan OEM diuji pada perangkat fisik. Petunjuk pengaturan baterai hanya saat relevan, bukan meminta pengguna mematikan seluruh proteksi perangkat.
- App lock melindungi UI; setelah perangkat pernah di-unlock, capture background tetap dapat berlangsung sesuai consent. Kondisi sebelum unlock tidak dijamin.

## 9. Arsitektur offline/local-first dan stack Flutter

### 9.1 Batas komponen

```text
Android NotificationListenerService (Kotlin)
  → source allowlist / OTP rejection / sanitization
  → durable native queue di storage privat
  → Pigeon pull + acknowledge saat Flutter tersedia
  → parser rules Dart → capture_events
  → review / posting command → transaksi DB atomik

Flutter UI → Riverpod controller → domain use case → repository
  → Drift + SQLite → reactive read models
  → Home / Accounts / Budget / Bills / Analytics
```

Database lokal adalah sumber kebenaran tunggal. Repository memisahkan UI dari persistence, dengan use case eksplisit untuk operasi keuangan atomik; prinsip ini mengikuti panduan arsitektur dan offline-first Flutter. Tidak diperlukan lapisan sync palsu dalam MVP. [Flutter architecture](https://docs.flutter.dev/app-architecture/guide), [Flutter offline-first](https://docs.flutter.dev/app-architecture/design-patterns/offline-first).

**Keputusan lifecycle:** native listener dapat menerima event saat Flutter engine tidak berjalan. Kotlin menyimpan envelope sanitasi ke durable queue; parser Dart dan auto-post dijalankan saat Flutter tersedia/startup/resume. Dengan demikian capture background tetap dapat mengantre, tetapi angka baru bisa diperbarui setelah aplikasi dibuka. Jangan menjanjikan posting real-time saat app tertutup. Hindari dependency pada `EventChannel` saja karena event bisa hilang tanpa subscriber.

Native queue adalah penyimpanan operasional, bukan ledger kedua: gunakan SQLiteOpenHelper native dengan payload minimal terenkripsi per record, index event ID, dan API ack. Flutter tidak membuka file queue tersebut langsung. Main DB diakses melalui satu writer isolate. Ingest mempunyai urutan: read envelope → commit capture/transaction pada main DB → ack queue. Crash setelah commit sebelum ack menghasilkan replay aman karena unique event ID. Tidak ada distributed transaction yang diasumsikan melintasi dua database.

### 9.2 Stack yang direkomendasikan

| Kebutuhan | Pilihan | Ketentuan |
|---|---|---|
| App | Flutter stable + Dart, Material 3 | Pin versi setelah M0; commit lockfile |
| Native | Kotlin + NotificationListenerService | Plugin internal kecil, tidak bergantung plugin listener tak terawat |
| State/DI | `flutter_riverpod`, Notifier/AsyncNotifier | State derived dari repository streams; tidak menyimpan saldo duplikat di provider |
| Routing | `go_router`, shell tabs | Guard onboarding/app lock; route detail memakai ID lokal |
| Local DB | Drift + SQLite | Foreign keys, transaksi, migration versioned, query reaktif |
| Bridge | Pigeon | Typed pull/ack/status/config API; event channel hanya sinyal “queue tersedia” |
| Model | Dart immutable classes; Freezed opsional | Nilai money integer, enum tegas, serialisasi versioned |
| Format/waktu | `intl`, library timezone | Kalender zona profil, injectable Clock |
| Reminder | `flutter_local_notifications` kandidat | Verifikasi dukungan scheduler Android saat M0; gunakan inexact scheduling, tanpa izin exact alarm |
| UI lock | `local_auth` kandidat | Biometrik/device credential OS; bukan kunci database yang selalu butuh prompt |
| Kunci | Android Keystore melalui adapter teruji | Key tidak hardcoded atau tersimpan di preferences |
| Testing | `flutter_test`, `integration_test`, native instrumentation | Fixtures sintetik/sanitasi, real-device capture tests |

Riverpod dipilih untuk dependency injection, state async, dan pengujian controller; go_router untuk navigasi deklaratif. Keduanya adalah pilihan proyek, bukan satu-satunya cara membangun Flutter. [Riverpod documentation](https://riverpod.dev/docs/introduction/getting_started), [go_router](https://pub.dev/packages/go_router).

Drift memberi relational persistence, reactive queries, dan migration support. SQLite tidak otomatis terenkripsi; enkripsi memerlukan backend/adapter tambahan. Spike M0 harus memilih backend SQLCipher-compatible yang dipelihara dan membuktikan kompatibilitas dengan versi Drift/SQLite, ABI, dan migrasi yang dipakai. Jika gagal, jangan mengeklaim encrypted DB atau meloloskan gate security dengan SQLite plaintext. [Drift](https://drift.simonbinder.eu/), [Drift encryption](https://drift.simonbinder.eu/platforms/encryption/).

### 9.3 Folder structure yang disarankan

```text
lib/
  app/                 # bootstrap, router, theme, dependency wiring
  core/
    money/             # rupiah, parsing input, bounds
    time/              # clock, business date, period calculator
    database/          # Drift tables, DAOs, migrations, encrypted opener
    privacy/           # consent, retention, redaction
    errors/            # typed failures dan safe UI messages
    widgets/           # shared accessible components
  features/
    onboarding/{data,domain,presentation}/
    accounts/{data,domain,presentation}/
    transactions/{data,domain,presentation}/
    capture/{data,domain,presentation}/
    categories/{data,domain,presentation}/
    budget/{data,domain,presentation}/
    bills/{data,domain,presentation}/
    home/{domain,presentation}/
    analytics/{data,domain,presentation}/
    settings/{data,domain,presentation}/
  platform/capture/    # generated Pigeon + adapter
assets/parser_rules/   # versioned registry, bukan fixture data pengguna
pigeons/               # interface definitions
android/.../capture/   # listener, allowlist, sanitizer, queue, key adapter
test/{domain,repository,controllers,widgets,fixtures}/
integration_test/
docs/                  # architecture decisions, support matrix, schema
```

Domain tidak mengimpor Flutter widgets/native APIs. Jangan membuat fitur saling menulis tabel secara langsung; operasi lintas fitur melalui use case dan satu unit of work.

## 10. Core data models dan schema

Semua ID menggunakan UUID/string lokal. Timestamp audit UTC epoch milliseconds; `business_date` ISO lokal disimpan saat posting agar histori stabil. FK `RESTRICT` untuk entitas yang punya histori. Semua enum disimpan sebagai string tervalidasi; nominal IDR integer.

| Tabel | Field inti dan constraints |
|---|---|
| `profile_settings` | singleton ID, locale=id_ID, currency=IDR, profile_timezone, cycle_anchor_day 1..31, onboarding_at, capture_consent_at/version, telemetry_opt_in=false, pending_cycle_change |
| `accounts` | id, name, type(bank/e_wallet/cash), opening_balance_idr≥0, opening_at, archived_at, created_at, updated_at |
| `categories` | id, name, type(expense/income), icon, sort_order, is_system, archived_at; fallback category tidak boleh dihapus |
| `transactions` | id, command_id UNIQUE, type, amount_idr, account_id FK, destination_account_id nullable, category_id nullable, merchant_raw_sanitized, merchant_normalized, note, occurred_at_utc, business_date, timezone_at_posting, source(manual/capture/recurring/adjustment), refund_of_id nullable FK, transfer_parent_id nullable FK, created_at, updated_at, deleted_at |
| `budget_periods` | id, start_date, end_date_exclusive, timezone, total_limit_idr≥0, is_partial, revision, created_at, updated_at; non-overlap via domain transaction |
| `category_budgets` | period_id FK, category_id FK, limit_idr≥0; UNIQUE(period_id,category_id), sum≤period.total via use case |
| `recurring_templates` | id, name, direction, estimated_amount_idr>0, account_id FK, category_id FK, cadence(weekly/monthly), anchor_day/date, starts_on, ends_on nullable, reminder_enabled, active, revision |
| `bill_occurrences` | id, template_id FK, due_date, expected_amount_idr>0, category_id, account_id, state, transaction_id nullable UNIQUE FK, is_user_override, skipped_reason; UNIQUE(template_id,due_date) |
| `capture_sources` | package_name, enabled, auto_post_enabled=false, default_account_id nullable FK, mapping_version, consent_at |
| `capture_account_mappings` | id, package_name FK, discriminator_hmac, account_id FK; UNIQUE(package_name,discriminator_hmac); absent discriminator harus mapping tunggal |
| `capture_events` | id, native_event_id UNIQUE, package_name, notification_key_hmac, payload_hmac, transaction_reference_hmac nullable, posted_at, parser_rule_id/version, status, tier, reason_code, candidate_amount/account/type/merchant/date/category, processed_at |
| `capture_transaction_links` | capture_event_id UNIQUE FK, transaction_id FK; banyak event boleh menunjuk satu transaksi/transfer |
| `merchant_rules` | id, normalized_merchant, category_id FK, origin(user/builtin), rule_version, enabled; user exact-match unique |
| `local_events` | id, event_name, safe_properties_json, occurred_at, schema_version; TTL 30 hari, tanpa financial payload |
| `mutation_receipts` | command_id PRIMARY KEY, entity_id, operation, committed_at; idempotensi command termasuk retry delete/link |

`amount_idr` positif untuk semua tipe kecuali `adjustment` yang signed nonzero. `transfer` mewajibkan destination berbeda; jenis lain melarang destination. Expense/refund memakai kategori expense; income kategori income; transfer/adjustment tanpa kategori. Validasi business invariants melalui domain dan SQL CHECK yang memungkinkan.

### Ledger projection

- Expense: `−amount` pada account.
- Income/refund: `+amount` pada account.
- Transfer: `−amount` asal, `+amount` tujuan dalam satu record/logical operation.
- Adjustment: `+signed amount` pada account.
- Opening balance bukan income dan tidak masuk transaksi analitik.
- Deleted transaction tidak masuk projection. Transfer fee adalah record expense terhubung, bukan bagian principal.

Saldo tidak menjadi field mutable di `accounts`; query/projection menghitungnya. Jika cache ditambahkan untuk performa, cache harus dapat dibangun ulang dan diuji sama dengan ledger.

Index minimum: transactions `(account_id,business_date)`, `(destination_account_id,business_date)`, `(business_date,type,deleted_at)`, `(category_id,business_date)`, refund_of_id; occurrences `(state,due_date)`; capture `(status,posted_at)` dan partial unique untuk reference HMAC yang tersedia dengan namespace sumber/akun; merchant normalized. Gunakan parameterized query, bukan interpolasi search ke SQL.

Native queue mempunyai `event_id`, `envelope_version`, `ciphertext`, `nonce`, `created_at`, `expires_at`; header tidak berisi nominal/merchant. Retention fingerprints capture minimal sepanjang umur ledger agar replay tidak menghidupkan transaksi yang dihapus; saat hapus semua data semua fingerprint ikut hilang. Payload hasil parsing dapat dipurge setelah transaksi dihubungkan; provenance minimal tetap ada.

## 11. Security, privacy, dan lifecycle data

1. **Minimization:** Tidak menyimpan raw notification lengkap. Native sanitizer menolak OTP/promo dan menghapus nomor rekening/telepon/referensi panjang sebelum queue. Sanitizer punya fixture tersendiri; jika tidak bisa disanitasi aman, drop dan minta manual.
2. **Encryption:** Main DB dan payload queue terenkripsi at rest; kunci random dibungkus/dilindungi Keystore. Key untuk background queue tidak meminta biometrik setiap event. App lock adalah kontrol tampilan tambahan, bukan klaim bahwa OS/root tak bisa menyerang.
3. **Backup:** Exclude database, queue, key material, preference sensitif dari backup cloud dan device transfer rules yang relevan; uji OS target. `allowBackup=false` saja bukan verifikasi menyeluruh. [Android backup recommendations](https://developer.android.com/privacy-and-security/risks/backup-best-practices).
4. **Kehilangan perangkat:** Onboarding/settings menyatakan data lokal dapat hilang saat uninstall, reset, atau perangkat hilang. CSV bukan backup yang bisa direstore pada MVP.
5. **Logs:** Jangan log nominal, merchant, catatan, payload, reference, atau nama akun; crash details hanya error code dan stack sanitasi. Fixture CI tidak memakai data pribadi asli.
6. **App lock:** Opsional via credential OS; relock setelah 60 detik background atau segera atas pilihan pengguna. Sembunyikan app-switcher preview/screenshot halaman sensitif pada Android jika privacy mode aktif. Tetap sediakan aksesibilitas.
7. **Reminder:** Lock-screen default “Ada tagihan yang perlu diperiksa”; nominal/nama merchant hanya jika pengguna mengaktifkan detail.
8. **Ekspor CSV:** Pengguna memilih periode dan tujuan, diberi tahu file berisi data finansial tanpa enkripsi. Escape CSV/formula-leading characters (`=`, `+`, `-`, `@`) agar spreadsheet tidak mengeksekusi formula. Bersihkan file sementara setelah berbagi atau ≤24 jam.
9. **Hapus semua:** Konfirmasi eksplisit, stop ingest dan reminder, hapus main DB/queue/cache/keys/exports sementara, reset settings. Beri tautan Settings agar pengguna mencabut Notification Access yang masih diberikan OS. Jangan mulai capture kembali tanpa consent baru.
10. **Build:** Dependency/license scan, tidak ada secret tertanam, release logs minimal, hanya component Android yang memang diperlukan diekspor. Service listener dilindungi permission sistem.
11. **Review rilis:** Tinjau kebijakan privasi, deklarasi Data Safety dan kategori/financial declarations yang berlaku pada build aktual. Tidak menganggap desain ini otomatis memenuhi seluruh kewajiban hukum/distribusi.

## 12. Product analytics events

Bedakan **Ringkasan keuangan pengguna** dari **telemetri pemakaian produk**. MVP menyediakan keduanya lokal; telemetri tidak membawa ledger dan tidak keluar perangkat tanpa ekspor diagnostik yang pengguna pilih.

| Event | Trigger | Allowed properties |
|---|---|---|
| `onboarding_completed` | Selesai/skip onboarding | skipped_steps enum list, duration_bucket |
| `account_created` | Commit akun | account_type; tanpa nama/saldo |
| `transaction_saved` | Commit sekali | type, source, has_category boolean |
| `transaction_corrected` | Edit capture/manual | field_names enum list; tanpa nilai lama/baru |
| `capture_consent_changed` | Toggle in-app | enabled, disclosure_version |
| `capture_access_changed` | Status OS diketahui berubah | state enum |
| `capture_processed` | Parse selesai | parser_rule_id/version, tier, reason_code |
| `capture_reviewed` | Konfirmasi/discard/link | action, corrected_fields enum |
| `capture_duplicate_flagged` | Ditahan sebagai kandidat ganda | detection_method enum |
| `budget_saved` | Commit batas/alokasi | is_first, is_revision |
| `safe_to_spend_viewed` | Buka rincian | readiness(ready/missing_input/provisional); tanpa nilai |
| `bill_occurrence_resolved` | Paid/skipped/linked | action, recurrence_type |
| `analytics_viewed` | Buka Ringkasan | period_type, filter_type |
| `export_completed` | Ekspor berhasil | format(csv/diagnostics), success |
| `local_operation_failed` | Error terklasifikasi | operation_enum, error_code; tanpa exception message mentah |

Event tersimpan setelah transaksi sukses, mempunyai event ID untuk dedup, TTL 30 hari, cap 10.000 events. Tidak mencatat setiap render. Analytics opt-in lokal tidak wajib agar fitur berjalan; default OFF untuk event usage, tetapi error counter teknis minimal tanpa payload boleh disimpan untuk status internal dan tidak diekspor tanpa tindakan pengguna. Clock skew tidak dijadikan ukuran performa; gunakan monotonic timer untuk duration.

## 13. Error, empty, loading, dan accessibility

| Area | Empty | Loading | Error/recovery |
|---|---|---|---|
| Home | “Tambahkan akun/budget untuk menghitung” | Skeleton hanya ketika snapshot belum siap | Snapshot gagal: `—`, pesan coba lagi; jangan menampilkan nol sebagai data |
| Accounts | CTA akun pertama | Progress submit, cegah double tap | Validasi nama/nominal; adjustment jika saldo tidak cocok |
| Transactions | CTA catat pertama; filter kosong punya reset | Pagination footer | Gagal commit mempertahankan form; retry memakai command ID yang sama |
| Capture | “Belum ada transaksi untuk diperiksa” | “Memproses X catatan” saat drain queue | Izin off, format berubah, mapping ambigu, queue overflow punya pesan dan aksi spesifik |
| Budget | CTA set budget | Simpan disabled saat commit | Alokasi > total ditandai di field dan ringkasan |
| Bills | CTA tambah tagihan | Catch-up occurrence terukur | Reminder denied tetap simpan bill; database gagal tidak menandai paid |
| Analytics | “Belum cukup catatan”, bukan grafik contoh | Skeleton chart dengan label | Tidak ada pembanding → teks, bukan persentase tak terhingga |
| Database | N/A | “Menyiapkan data” pada migrasi | Migration failure membuka recovery read-only bila aman; jangan reset DB otomatis |
| Storage/key | N/A | N/A | Disk penuh: hentikan write, pertahankan data lama; key invalid: jelaskan data tidak dapat dibuka, jangan hapus diam-diam |

- Target sentuh minimal 48 logical pixels; TalkBack labels dan focus order jelas, termasuk tombol nominal tersembunyi.
- Text scaling hingga 200% tanpa memotong nominal/CTA; layout dapat scroll.
- Kontras teks normal minimal 4.5:1; error/overspend tidak hanya dibedakan warna.
- Grafik memiliki daftar alternatif, nilai dan periode terbaca screen reader.
- Semua nominal memiliki semantics “rupiah”; nilai negatif dan refund dibedakan secara verbal.
- Reduced motion mengikuti preferensi platform; loading tidak beranimasi berlebihan.
- Field form menyebut error spesifik dan mengarahkan focus ke field pertama yang salah.
- Gunakan bahasa sederhana: “Sisa budget”, “Belum diperiksa”, “Saldo tercatat”; hindari istilah internal parser/tabel di UI.

## 14. Acceptance criteria utama

| ID | Given / When / Then |
|---|---|
| AC01 | Given instalasi baru tanpa internet, when pengguna membuat akun dan expense, then keduanya tersimpan, tetap ada setelah restart, dan semua layar relevan berubah konsisten |
| AC02 | Given akun Rp1.000.000, when expense Rp75.000 diposting, then saldo Rp925.000 dan E bertambah Rp75.000 |
| AC03 | Given dua akun, when transfer Rp100.000 + biaya Rp2.500, then total saldo turun hanya Rp2.500, budget terpakai Rp2.500, dua sisi transfer tidak bisa tersimpan parsial |
| AC04 | Given notifikasi non-allowlist atau OTP, when listener menerima, then tidak ada raw/payload finansial tersimpan atau transaksi dibuat |
| AC05 | Given template high dan auto-post OFF, when notifikasi diterima, then draft masuk Inbox dan saldo tetap |
| AC06 | Given template high expense, mapping tunggal, auto-post ON, when Flutter memproses queue, then satu transaksi berlabel otomatis dibuat; sumber dan rule version dapat ditelusuri |
| AC07 | Given replay/update identik 10 kali termasuk crash sebelum ack, then tepat satu transaksi; tidak ada kehilangan commit |
| AC08 | Given dua transaksi identik yang nyata, when sistem menandai possible duplicate, then pengguna dapat mengonfirmasi keduanya tanpa penghapusan otomatis |
| AC09 | Given bank debit dan wallet credit untuk top-up, when pengguna mengonfirmasi transfer, then satu transfer terhubung ke kedua event dan expense principal nol |
| AC10 | Given contoh angka pada Bagian 7, then S=Rp2.000.000 dan A=Rp100.000; melunasi bill Rp500.000 pada hari sama tidak mengubah S |
| AC11 | Given bill overdue periode lama, then reserve tetap masuk; when skipped/paid, then reserve dilepas tepat sekali |
| AC12 | Given anchor 31, when Februari lalu Maret, then boundary/occurrence ter-clamp pada Februari dan kembali ke 31 Maret; tidak ada duplicate occurrence |
| AC13 | Given notifikasi baru saat engine Flutter tidak hidup setelah perangkat unlock, then event yang diterima listener bertahan di queue dan muncul setelah resume; bila OS tidak mengirim, UI tidak mengklaim capture lengkap |
| AC14 | Given izin capture/reminder ditolak, then seluruh CRUD manual, budget, Bills list, dan analytics tetap berfungsi |
| AC15 | Given expense yang dibayar bill dihapus, then saldo, budget, occurrence, dan reserve berubah dalam satu commit |
| AC16 | Given refund lintas periode, then periode asal tetap actual semula, periode penerimaan menunjukkan refund terpisah dan net yang benar |
| AC17 | Given database versi rilis sebelumnya, when upgrade, then jumlah akun/transaksi, total saldo, dan hubungan bill/refund tetap sama |
| AC18 | Given app lock aktif, when background >60 detik lalu kembali, then data tidak terlihat sebelum unlock; pending ingest tidak menyebabkan kebocoran UI |
| AC19 | Given hapus semua data, then DB, queue, key, reminder, dan cache hilang; izin OS yang tersisa tidak memicu ingest tanpa consent baru |
| AC20 | Given TalkBack dan font 200%, then semua flow P0 dapat diselesaikan, angka dibaca benar, tidak ada CTA utama terpotong |
| AC21 | Given disk penuh/DB error saat save, then tidak ada setengah transaksi, draft pengguna tetap dapat diperbaiki/retry, dan tidak ada angka sukses palsu |
| AC22 | Given schema event telemetry, then ekspor diagnostik tidak mengandung nominal, merchant, nama akun, note, notification text, atau reference |

## 15. Non-functional requirements dan testing strategy

### Performance/reliability targets

Ukur pada satu perangkat Android kelas menengah fisik 4 GB RAM yang disepakati M0, release build, database 10.000 transaksi; laporkan device/OS agar hasil bermakna.

- Cold start ke Home siap dibaca p95 ≤2,5 detik tanpa backlog/migrasi besar; proses backlog memiliki progress dan tidak memblokir navigasi manual.
- Save manual sampai read model konsisten p95 ≤300 ms; capture backlog 100 envelope selesai ≤5 detik tanpa freeze UI.
- Callback listener hanya filter/sanitasi/enqueue ringan; tidak menginisialisasi Flutter, melakukan network, atau query ledger di main thread Android.
- Scroll daftar tetap responsif; profiling frame mengidentifikasi pekerjaan DB/parsing yang harus dipindah ke isolate/worker.
- Tidak ada background polling terus-menerus; scheduler hanya kebutuhan reminder/maintenance yang dibenarkan.
- Crash-free sessions target ≥99,5% pada pilot terukur; jika sampel kecil, laporkan numerator/denominator dan jangan mengklaim statistik populasi.

### Test layers

| Layer | Cakupan wajib |
|---|---|
| Unit domain | Formula SAFE, ledger signs, refunds, transfer fee, constraints nominal, budget sum, period clamp, partial period, timezone, recurring idempotence |
| Parser fixtures | Setiap template: sukses, multi-amount/saldo, pending/failed, promo, OTP/redacted, grouped update, reference missing, locale/whitespace, merchant ambigu |
| Property/invariant | Transfer tanpa fee mempertahankan total saldo; retry idempotent; paid bill tidak double reserve; refund≤expense; tidak ada overlap periode |
| Repository/DB | Rollback failure, foreign keys, duplicate command, concurrent ingest/edit, crash-before-ack, tombstone, migration setiap versi |
| Controller/widget | Validation, loading/error, permission states, budget empty, analytics no comparison, app lock, large text |
| Integration | Onboarding offline→CRUD→budget→Bills→Home; capture→review→link bill; restart; ekspor dan hapus data |
| Android physical | Pixel/reference Android, Samsung One UI, dan minimal satu Xiaomi/OPPO yang tersedia; min supported, Android 13, Android 15, dan versi stabil terbaru yang tersedia saat QA |
| Lifecycle | App foreground/background, engine killed tanpa force-stop, force-stop, reboot, locked/unlocked, listener disconnect/rebind, source notifications disabled |
| Security/privacy | Inspect DB/queue/logs/export/temp/backup; verify encryption/key failure; OTP never persisted; consent revocation race |

Corpus rilis minimum 500 notifikasi sintetik atau didonasikan dengan consent lalu disanitasi: ≥100 positive per package yang didukung; sisanya negatives/duplicates/ambiguities. Pisahkan development dan holdout menurut template variant/skenario untuk menghindari kebocoran evaluasi. Ukur extraction accuracy nominal/arah/akun, auto-post precision, recall supported template, duplicate rate, serta jumlah kasus di luar dukungan. Fixture tidak membuktikan cakupan transaksi dunia nyata; pilot perangkat tetap wajib.

Parser yang gagal gate diturunkan ke review-only/dinonaktifkan, bukan dipaksa high. Bila high-tier corpus terlalu kecil untuk mendukung confidence kualitas, rilis auto-post tetap OFF dan jangan memasarkan precision produksi sebagai terbukti. Capture draft dari dua package yang lolos tetap wajib tersedia.

## 16. MVP milestones dan urutan implementasi

Estimasi **8–10 minggu** untuk dua engineer (Flutter dan Android/full-stack mobile), designer/product part-time, dan QA part-time. Ini asumsi kapasitas, bukan deadline tetap; satu developer memerlukan penjadwalan ulang. Tidak memerlukan backend engineer MVP.

| Milestone | Estimasi | Output dan exit gate |
|---|---|---|
| M0 — feasibility dan keputusan stack | Minggu 1 | Dua sumber nyata diuji; support matrix; durable queue saat engine mati; spike encrypted DB; versi Flutter/dependensi/minSdk dikunci; corpus awal dan risiko dicatat |
| M1 — fondasi pembukuan | Minggu 2–3 | Onboarding, Accounts, categories, manual expense/income/transfer/refund/adjustment, DB migration; AC01–03, AC16 lulus |
| M2 — budget, bills, metrik | Minggu 4–5 | Periode, recurring occurrences, reserve, Aman Dipakai, Home; semua edge case Bagian 7 dan AC10–12/15 lulus |
| M3 — capture | Minggu 6–7 | Listener opt-in, queue, parser registry, Inbox, mapping, dedup, auto-post guard; AC04–09/13–14 lulus |
| M4 — analytics dan hardening | Minggu 8 | Basic analytics, privacy settings, CSV, app lock, accessibility, performance, tests migration/security |
| M5 — closed pilot dan release | Minggu 9–10 | Pilot perangkat, parser holdout, kebijakan/data disclosure, store listing yang jujur, release candidate dan daftar known limitations |

Urutan tiket Codex yang disarankan: money/time primitives → schema/migrations → ledger use cases → Accounts/manual UI → recurring/budget domain → SAFE → Home → native queue/bridge → parser registry → Inbox/dedup → analytics → privacy/export/reminder → integration/release QA. Jangan memulai layar dengan saldo mock permanen lalu menambahkan aturan ledger di akhir.

**Definition of done per tiket:** requirement ID disebut, error/empty state ditangani, data migration bila diperlukan, tes domain/integrasi yang sesuai lulus, tidak ada financial payload dalam log, dan perubahan angka dapat dilacak ke source-of-truth database. Tidak menambahkan fitur roadmap tanpa revisi PRD.

## 17. Release criteria

Rilis publik hanya ketika:

- Semua acceptance criteria P0 di Bagian 14 lulus; tidak ada bug severity kritis/tinggi pada nominal, arah transaksi, akun, duplikasi, data loss, atau privacy.
- Minimal dua package (satu bank/satu e-wallet) memiliki capture yang tervalidasi, katalog dukungan terlihat, dan unsupported behavior memberi fallback manual. Auto-post hanya diaktifkan untuk template yang memenuhi gate.
- Flow manual bekerja sepenuhnya offline dan tanpa kedua izin notifikasi.
- Migration, upgrade install, restart, process death/replay, disk-full, backup exclusion, encryption dan deletion teruji.
- Perhitungan SAFE memiliki fixture expected value, bukan hanya screenshot; keterbatasan catatan parsial terlihat.
- Performance dan accessibility target lulus pada matriks perangkat yang dicatat.
- Privacy policy, disclosure, Data Safety, permission manifest, target SDK, dan store descriptions sudah ditinjau terhadap implementasi final.
- Export CSV diverifikasi, kehilangan data saat uninstall dijelaskan, tidak ada klaim backup/sync yang tidak tersedia.
- Tidak ada Goals, Debt/PayLater, Shared Expense, AI Assistant, forecasting lanjutan, Financial Health, atau Net Worth di navigasi, data entry, maupun metrik MVP.
- Ada mekanisme menonaktifkan parser per sumber di perangkat; hotfix lewat update aplikasi. MVP tanpa backend tidak memiliki remote kill switch, sehingga kemampuan rollback lokal dan jalur distribusi hotfix harus didokumentasikan.

## 18. Risiko, mitigasi, dan keputusan M0

| Risiko | Dampak | Mitigasi/keputusan |
|---|---|---|
| Notifikasi bank tidak tersedia/konten tak lengkap | Capture coverage rendah | Validasi sumber sebelum janji marketing; manual dan review-first |
| Template berubah | Salah posting | Rule version, fail closed, local disable, holdout, hotfix release |
| Salah mapping akun | Saldo salah | Mapping tunggal/discriminator; multi-account ambigu selalu review |
| Uang terlihat lebih banyak karena income rencana | Pengguna salah mengambil keputusan | Tidak pernah memasukkan scheduled income ke L |
| Bill tercatat dua kali | SAFE terlalu rendah | Atomic bill link, suggestion review, provenance jelas |
| OEM menghentikan listener | Missing transactions | Status dan petunjuk, queue untuk event yang diterima, tanpa janji catch-up penuh |
| Data lokal hilang | Hilang histori | Disclosure, CSV; encrypted backup/restore menjadi prioritas pasca-MVP |
| Enkripsi/plugin tidak kompatibel | Build/data migration bermasalah | Spike M0 dan gate blocker, bukan keputusan di akhir proyek |

Keputusan terbuka terbatas untuk M0: nama produk, package sumber yang terbukti mendukung, versi toolchain/backend enkripsi, perangkat benchmark, dan peserta pilot. Formula keuangan, scope, default permission, dan prioritas fitur sudah ditetapkan oleh PRD ini; jangan menunggu keputusan branding untuk implementasi domain.

## 19. Post-MVP roadmap

| Tahap | Kandidat | Syarat sebelum dikerjakan |
|---|---|---|
| 1 — keandalan dan portability | Backup/restore terenkripsi, impor CSV dengan dedup, perluasan parser, iOS manual-first | Ledger dan retention stabil, recovery security design teruji |
| 2 — budgeting lebih fleksibel | Rollover opsional, aturan recurring lebih kaya, multi-budget, bill partial payment | Bukti kebutuhan pengguna, tidak merusak definisi Aman Dipakai |
| 3 — Goals | Tujuan tabungan dan alokasi uang | Reserve goals dipisahkan dan formula direvisi agar tidak double-count |
| 3 — Debt/PayLater | Jadwal cicilan/kewajiban dan akun kredit | Model liabilitas terpisah, kajian regulasi/privasi yang relevan |
| 4 — Shared Expense | Split dan settlement bersama | Identity, sync, consent sharing, konflik multi-device |
| 4 — AI Assistant/forecasting lanjutan | Tanya jawab data, skenario keuangan | Consent data, evaluasi akurasi, cost/privacy design; tidak mengganti deterministic ledger |
| 4 — Financial Health/Net Worth | Ringkasan aset-liabilitas dan indikator | Cakupan data memadai dan definisi terukur; bukan perluasan diam-diam saldo MVP |

Urutan roadmap merupakan kandidat prioritas, bukan komitmen tanggal. Ukur dulu apakah pengguna mempertahankan catatan yang lengkap dan percaya pada angka sebelum menambah fitur.
