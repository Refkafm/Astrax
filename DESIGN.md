# DESIGN.md — Personal Finance Indonesia-first

> **Perubahan prioritas — 5 Oktober 2026:** atas arahan pemilik produk, implementasi dan validasi rilis pertama ditujukan ke **Apple iPhone/iOS**, kemudian Android. Flutter tetap dipakai. Pernyataan Android-first dan gate capture Android di dokumen baseline di bawah ditunda ke fase Android; bukan gate rilis iOS. iOS menggunakan pencatatan manual dan tidak menjanjikan pembacaan notifikasi aplikasi lain. Formula ledger, budget, tagihan, privasi, dan arah visual tetap berlaku. Detail: [Rencana Apple-first](docs/APPLE_FIRST.md).


**Versi:** 1.0 · **Platform:** Flutter / Android-first  
**Arah desain:** Neo-brutalist yang hangat, ringkas, dan berorientasi angka.  
**Referensi produk:** [bajet.lah](https://bajetlah.my/)  
**Dokumen pasangan:** [PRD MVP](PRD-MVP-Personal-Finance-Indonesia-Flutter.md)

Dokumen ini adalah spesifikasi desain aplikasi mobile untuk developer/Codex. PRD tetap menjadi sumber kebenaran untuk scope dan perhitungan keuangan. Semua warna, ukuran, dan tipografi di bawah adalah keputusan desain produk kita, bukan hasil ekstraksi token resmi bajet.lah.

## 1. Konsep utama

**“Buku uang yang tegas, ringan, dan mudah diperiksa.”**

Bangun aplikasi dengan kesan seperti kartu catatan keuangan di atas kertas krem: garis hitam terlihat jelas, angka menjadi pusat perhatian, warna pastel membantu membedakan informasi, dan bayangan keras memberi kedalaman yang sederhana. Tampilan terasa praktis dan personal, tanpa kepadatan dashboard akuntansi.

Prioritas visual setiap layar: **angka atau tugas utama → konteks → aksi → detail pendukung**. Home menjawab “berapa yang masih bisa dipakai?”, Transaksi menjawab “apa yang tercatat?”, Budget menjawab “batasnya berapa?”, dan Ringkasan menjawab “uangnya ke mana?”.

### Apa yang diambil dari referensi

Observasi berasal dari landing page dan mockup aplikasi yang ditampilkan di [situs bajet.lah](https://bajetlah.my/), bukan pemeriksaan seluruh aplikasi terpasang. Referensi memperlihatkan latar krem dengan grid tipis, tipografi hitam sangat tebal, outline hitam, bayangan offset tanpa blur, kartu membulat, angka besar, dan aksen hijau/pastel.

| Elemen referensi | Adaptasi untuk aplikasi kita |
|---|---|
| Kartu Left to Spend dengan angka dominan | Kartu “Estimasi Aman Dipakai”, IDR penuh, rincian per hari |
| Outline hitam dan bayangan tegas | Dipakai pada kartu utama dan CTA; daftar menggunakan divider lebih ringan |
| Krem, mint, kuning, coral | Palet hangat dengan warna status yang jelas |
| Hierarki kartu utama + kartu kecil | Satu hero, dua summary cards, lalu daftar vertikal |
| Grid seperti kertas | Dekorasi opsional onboarding; tidak di belakang daftar transaksi |
| Akun dan ringkasan kategori | Akun lokal, kategori Indonesia, transaksi QRIS/tunai/top-up |
| Headline marketing sangat besar | Disederhanakan menjadi judul pendek dan angka besar yang responsif |

Logo, nama, maskot, dan copy bajet.lah tidak dipakai sebagai identitas produk. Nama final aplikasi belum ditentukan; gunakan placeholder “Nama aplikasi” hanya pada onboarding, bukan menciptakan brand final.

## 2. Prinsip desain

1. **Satu fokus per layar.** Hero Home adalah Aman Dipakai; total saldo adalah informasi sekunder.
2. **Angka harus terbaca utuh.** Hindari ellipsis atau pemotongan angka finansial penting.
3. **Karakter kuat, konten tenang.** Outline/bayangan memberi identitas; tidak semua baris diberi kartu berat.
4. **Status dapat dijelaskan.** Otomatis, perlu diperiksa, dan manual dibedakan lewat label, bukan warna saja.
5. **Input cepat.** Form hanya menunjukkan field penting, dengan rincian opsional setelahnya.
6. **Jujur terhadap data lokal.** “Saldo tercatat”, “Estimasi”, dan “Belum diperiksa” hadir saat relevan.
7. **Nyaman disentuh.** Semua target utama minimal 48×48 dp; ikon visual boleh lebih kecil.

## 3. Design tokens

### 3.1 Warna light theme

Light theme adalah baseline MVP. Dark theme tidak perlu diimplementasikan pada fase ini; jangan membalik warna otomatis tanpa spesifikasi dan pemeriksaan kontras.

| Token | Hex | Pemakaian |
|---|---|---|
| `canvas` | `#FFF9E8` | Latar seluruh aplikasi, krem hangat |
| `surface` | `#FFFFFF` | Form, daftar, bottom sheet |
| `surfaceSubtle` | `#F4F0E5` | Track progress, disabled surface |
| `ink` | `#171916` | Teks utama, outline, ikon |
| `inkSecondary` | `#555A51` | Label sekunder, metadata |
| `lineSubtle` | `#D8D9D0` | Divider dekoratif; bukan outline kontrol |
| `primary` | `#55B98A` | Tombol utama, indikator terpilih |
| `mint` | `#E2F2DF` | Hero Aman Dipakai normal |
| `butter` | `#F6DF83` | Highlight budget/tagihan |
| `coral` | `#F0B0A4` | Kartu perhatian nonkritis |
| `lilac` | `#E4DDF6` | Transfer/visualisasi netral tambahan |
| `successInk` | `#21633F` | Teks pemasukan/sukses |
| `warningInk` | `#705000` | Teks perlu perhatian |
| `dangerInk` | `#A12B27` | Error, overdue, overspend |
| `dangerSurface` | `#FCE5E1` | Latar pesan error |
| `scrim` | `#171916` / 48% | Lapisan di belakang modal |

Aturan pasangan: teks `ink` pada semua pastel dan `primary`; teks putih hanya pada permukaan `ink`/`dangerInk`. Jangan menaruh teks putih kecil pada hijau primary. Warna kategori selalu disertai nama dan ikon. Warna merchant/bank tidak mengganti arti status.

### 3.2 Tipografi

Gunakan **Plus Jakarta Sans** sebagai pilihan font produk, dibundel lokal dengan lisensi yang sesuai agar bekerja offline. Ini bukan klaim font yang digunakan bajet.lah. Fallback: sans-serif platform.

| Token | Ukuran / weight / line height | Penggunaan |
|---|---|---|
| `amountHero` | 40 sp / 800 / 1.12 | Angka Aman Dipakai |
| `amountLarge` | 28 sp / 800 / 1.2 | Saldo detail, nominal input |
| `screenTitle` | 24 sp / 800 / 1.25 | Judul halaman |
| `sectionTitle` | 18 sp / 700 / 1.3 | Judul bagian |
| `body` | 16 sp / 500 / 1.5 | Isi, nama transaksi |
| `bodyStrong` | 16 sp / 700 / 1.4 | Nilai baris dan CTA |
| `label` | 14 sp / 600 / 1.4 | Label field, keterangan |
| `caption` | 12 sp / 600 / 1.4 | Metadata pendek, tidak untuk instruksi penting |

Gunakan tabular figures pada nominal jika font mendukung. Huruf kapital hanya untuk eyebrow singkat seperti “BUDGET PERIODE INI”. Body dan tombol memakai sentence case. Maksimal tiga tingkatan ukuran dalam satu kartu.

### 3.3 Spacing, outline, radius, shadow

| Kelompok | Nilai |
|---|---|
| Spacing | 4, 8, 12, 16, 20, 24, 32 dp |
| Page gutter | 20 dp; layar <360 dp memakai 16 dp |
| Jarak antar-section | 24 dp; antar-kartu 16 dp; antar-baris form 16 dp |
| Card padding | 20 dp; compact card 16 dp |
| Radius | Hero 24 dp; card 18 dp; button/input 12 dp; chip 10 dp |
| Outline | Hero/CTA 2.5 dp `ink`; card/input 2 dp; divider 1 dp |
| Shadow kuat | Offset (4,4), blur 0, spread 0, warna `ink` |
| Shadow ringan | Offset (2,2), blur 0, spread 0, warna `ink` |
| Icon | 24 dp default, 20 dp inline, 32 dp empty-state |

Bayangan kuat hanya pada hero dan CTA utama. Sisakan ruang offset agar tidak terpotong. Jangan memakai gradient, glass blur, glow, atau elevasi Material bawaan yang menghasilkan soft shadow.

## 4. Layout dan navigation

Empat tab mengikuti PRD: **Home · Transaksi · Budget · Ringkasan**. Semua ikon outline dari satu keluarga, misalnya Material Symbols Rounded outline. Active tab memakai tile mint dengan outline dan teks bold; inactive menggunakan ikon/teks `inkSecondary`. Label selalu terlihat.

Accounts/Akun dan Bills/Tagihan diakses dari section Home. Settings melalui ikon roda gigi di kanan app bar. Capture Inbox dapat dibuka dari Home dan Transaksi.

- App bar: tinggi minimum 64 dp di luar status bar, title kiri, maksimal dua aksi kanan.
- Bottom navigation: minimum 72 dp + safe-area bawah. Saat font besar, tinggi berkembang mengikuti label.
- Tombol `+ Catat`: extended floating button hijau di Home/Transaksi, kanan bawah, 16 dp di atas navigasi. Sediakan padding konten agar item terakhir tidak tertutup.
- Tap `+ Catat` membuka pilihan Pengeluaran, Pemasukan, Transfer; default form berikutnya mengingat tipe terakhir hanya jika tidak membingungkan.
- Tab mempertahankan posisi scroll. Back dari detail kembali ke tab/filter sebelumnya.
- Form panjang memakai full-screen route. Bottom sheet untuk selector sederhana, filter, dan ringkasan formula.
- Bottom sheet: surface putih, sudut atas 24 dp, outline atas 2 dp, drag handle + tombol tutup. Pengoperasian tidak boleh bergantung pada swipe.

### Adaptasi ukuran

Baseline desain 390×844 logical pixels; verifikasi lebar 320, 360, 390, 430, dan 600+ dp. Layout tidak mengunci tinggi layar.

Pada layar kecil atau text scale tinggi, dua summary cards menjadi satu kolom. Nominal hero boleh turun dari 40 ke 32 sp pada skala default; pada skala aksesibilitas biarkan blok berkembang dan pindahkan label “Rp” ke baris terpisah bila perlu. Jangan memakai `FittedBox` untuk mengecilkan semua teks sehingga mengabaikan preferensi pengguna.

Pada tablet, pusatkan konten dengan lebar maksimum 680 dp. Layar lebar bukan alasan menambah fitur/sidebar baru. Keyboard tidak menutupi field aktif atau tombol Simpan.

## 5. Home — layar acuan visual

### Susunan

1. Header: “Home”, periode aktif, Settings.
2. Hero mint “Estimasi Aman Dipakai”.
3. Alert data belum lengkap hanya bila relevan.
4. Dua summary cards: Saldo tercatat dan Tagihan belum dibayar.
5. Akun, maksimal tiga baris + “Lihat semua”.
6. Budget kategori, maksimal tiga baris.
7. Tagihan mendatang, maksimal tiga baris.
8. Transaksi terbaru, maksimal lima baris.

Hero menampilkan angka, allowance per hari, tanggal akhir periode, dan link “Lihat perhitungan”. Jangan menambahkan persentase remaining ke hero tanpa label denominator yang jelas; progress budget ditempatkan pada section Budget.

### Wireframe

```text
┌───────────────────────────────────┐
│ Home                         [⚙]  │
│ 1–31 Oktober 2026                  │
│                                   │
│ ╭─────────────────────────────╮   │
│ │ ESTIMASI AMAN DIPAKAI        │   │
│ │ Rp2.000.000                 │   │
│ │ Rp100.000 per hari          │   │
│ │ Sampai 31 Oktober           │   │
│ │ Lihat perhitungan       →   │   │
│ ╰─────────────────────────────╯▌  │
│                                   │
│ [2 catatan perlu diperiksa →]      │
│                                   │
│ ╭──────────────╮ ╭──────────────╮ │
│ │ Saldo        │ │ Tagihan      │ │
│ │ tercatat     │ │ belum dibayar│ │
│ │ Rp5.000.000  │ │ Rp1.000.000  │ │
│ ╰──────────────╯ ╰──────────────╯ │
│                                   │
│ Akun                   Lihat semua│
│ [bank] BCA             Rp3.800.000 │
│ [wallet] GoPay           Rp700.000 │
│ [cash] Tunai             Rp500.000 │
│                                   │
│ Budget                            │
│ Makan & minum                     │
│ ▰▰▰▰▰▰▱▱▱▱     Rp600rb / Rp1jt   │
│                                   │
│ ...konten berikutnya dapat discroll│
│                        [+ Catat]  │
├───────────────────────────────────┤
│ Home   Transaksi  Budget Ringkasan │
└───────────────────────────────────┘
```

Glyph wireframe hanya penanda; implementasi menggunakan ikon vector, bukan emoji atau karakter terminal.

**Fixture angka konsisten:** tanggal 12 Oktober, 20 hari tersisa termasuk hari ini; L=Rp5 juta, B=Rp4 juta, E=Rp1 juta, R=Rp1 juta. Aman Dipakai Rp2 juta dan allowance Rp100 ribu. Data ini ilustrasi, bukan catatan pengguna.

### Hero states

| State | Tampilan |
|---|---|
| Ready | Mint, angka lengkap, timestamp pencatatan di rincian |
| Belum ada akun/budget | Angka `—`, CTA “Tambah akun”/“Atur budget” |
| Data perlu review | Angka tetap sesuai ledger, label “Sementara”, notice kuning dengan jumlah draft |
| Dana habis | Angka Rp0, keterangan batas budget/saldo sesuai domain |
| Defisit | Surface coral/error lembut, jumlah defisit di rincian; tidak mengubah Rp0 menjadi angka negatif hero |
| Loading | Placeholder statis tanpa angka palsu; semantics “Menghitung catatan” |
| Error | `—`, “Angka belum bisa ditampilkan”, tombol coba lagi |

## 6. Rincian Aman Dipakai

Bottom sheet dengan judul “Cara menghitungnya”, nominal hasil, dan breakdown vertikal. Pada font besar atau konten panjang sheet dapat menjadi hampir full-screen.

```text
Saldo tercatat                  Rp5.000.000
Tagihan belum dibayar          −Rp1.000.000
Ruang dari saldo                Rp4.000.000

Budget periode ini              Rp4.000.000
Pengeluaran bersih             −Rp1.000.000
Tagihan belum dibayar          −Rp1.000.000
Ruang dari budget               Rp2.000.000

Estimasi Aman Dipakai           Rp2.000.000
Nilai yang lebih kecil dari dua ruang di atas.
20 hari tersisa → Rp100.000 per hari
```

Tambahkan copy: “Berdasarkan transaksi yang sudah tercatat. Pemasukan yang belum diterima tidak dihitung.” Jika ada pending capture, beri link langsung ke Inbox. Formula tidak dibuat ulang di widget; UI menerima read model dari domain PRD.

## 7. Spesifikasi layar lainnya

### 7.1 Transaksi

Header judul + search; periode dan filter berbentuk chips. Banner review kuning berada di atas daftar bila pending >0. Kelompokkan berdasarkan tanggal dengan subtotal expense net harian berlabel jelas.

Baris minimum 72 dp: icon tile 40 dp kiri; merchant/label 16 sp semibold; kategori · akun 14 sp; nominal kanan 16 sp bold; sumber “Otomatis” sebagai badge kecil bila relevan. Nama panjang wrap maksimal dua baris sebelum detail, tetapi nominal tidak di-ellipsis. Pada ruang sempit nominal pindah ke baris berikutnya.

Pengeluaran memakai `−Rp35.000` berwarna ink; pemasukan `+Rp5.000.000` successInk; transfer label “Transfer” + arah akun dengan tinta netral; refund `+Rp…` dengan label “Refund”. Jangan memberi semua expense warna merah seolah error.

Tap membuka detail, sumber capture, dan aksi edit/hapus. Hapus melalui overflow + dialog; swipe tidak menjadi satu-satunya akses. Search kosong menampilkan “Tidak ada transaksi yang cocok” + Reset filter.

### 7.2 Tambah/edit transaksi

Full-screen dengan back, judul tipe, segmented control tiga tipe bila membuat baru. Area nominal besar di atas surface krem; form putih di bawahnya dengan outline sederhana.

Urutan: nominal → akun → kategori → tanggal/waktu → merchant opsional → catatan opsional. Transfer mengganti kategori dengan Akun asal/Akun tujuan dan field biaya opsional. Form refund/adjustment hanya dari alur PRD yang terkait.

Tombol Simpan hijau, full width, tinggi minimum 52 dp, tetap di atas keyboard/safe area. Label field persisten. Error tepat di bawah field; nilai pengguna tidak hilang ketika save gagal. Nominal awal kosong, bukan transaksi Rp0 yang tampak valid. Setelah sukses kembali ke konteks semula dan tampil “Transaksi tersimpan”.

### 7.3 Accounts/Akun

Total “Saldo tercatat” di atas, daftar akun putih ber-outline. Tiap row: icon bank/wallet/cash, nama, tipe, saldo. Sediakan + Tambah akun. Detail berisi saldo besar, histori, dan tombol “Sesuaikan saldo” dalam overflow/section tindakan.

Nama BCA/GoPay/DANA boleh berupa teks + ikon generik; jangan membuat logo tiruan. Label “Pilih sumber notifikasi” berada dalam pengaturan capture, bukan tombol “Hubungkan bank”. Saldo negatif memakai icon peringatan + “Periksa catatan akun”.

### 7.4 Budget

Kartu utama butter: Batas total, Terpakai, Sisa aktual. Progress 12 dp dengan outline 1.5 dp, fill hijau normal. Reserve tagihan di baris terpisah bertuliskan “Disiapkan untuk tagihan”, tidak ditambahkan lagi sebagai actual expense.

Daftar kategori: icon tile, label, actual/limit, bar, persentase. Pada 80% tampil “Mendekati batas”; pada ≥100% “Melebihi Rp…” dengan dangerInk. Grafik boleh mencapai maksimum 100% secara visual, angka actual tetap utuh.

Alokasi belum diatur menampilkan “Belum dialokasikan”, bukan “Dana ekstra”. Tombol “Edit budget” secondary. Histori periode selesai read-only sesuai PRD.

### 7.5 Bills/Tagihan

Header “Tagihan”, tabs/filter “Belum dibayar”, “Selesai”, serta akses jadwal pemasukan dengan label terpisah. Daftar berkelompok “Terlambat”, “Minggu ini”, “Berikutnya”.

Row: tile tanggal 48 dp kiri, nama + akun, nominal kanan, badge status. Overdue menggunakan dangerInk dan teks “Terlambat 2 hari”. Hindari warna merah untuk seluruh tagihan yang belum jatuh tempo.

Detail menawarkan **“Catat pembayaran”** dan “Tautkan transaksi”; jangan memakai “Bayar sekarang” karena aplikasi tidak memindahkan uang. Catat pembayaran membuka form actual amount/date/account. Jadwal pemasukan memakai “Catat penerimaan”.

### 7.6 Capture Inbox

Judul “Periksa catatan”, helper “Periksa sebelum masuk ke transaksi”. Satu kartu per kandidat: nominal, merchant, sumber, akun usulan, kategori, alasan review.

- Default tombol “Konfirmasi” hijau; secondary “Edit”. “Abaikan” di overflow/detail.
- Akun/nominal ambigu tidak bisa dikonfirmasi sebelum field wajib diselesaikan.
- Kemungkinan duplikat: panel perbandingan kandidat dan transaksi existing; aksi “Tautkan ke transaksi” atau “Catat sebagai transaksi baru”.
- Kemungkinan top-up: tampil asal/tujuan dan CTA “Periksa transfer”.
- Tidak ada bulk confirm pada MVP; ketepatan lebih penting daripada jumlah kartu selesai.
- Banner izin off mengarahkan ke Pengaturan; tidak menghalangi review draft yang sudah ada.
- Metadata raw notification tidak ditampilkan; tampilkan field tersanitasi dan sumber sesuai PRD.

### 7.7 Ringkasan/basic analytics

Periode di atas, summary income/expense net, kemudian bar chart pengeluaran harian dan daftar kategori. Kartu grafik putih, outline 2 dp, tanpa shadow berat. Tiga hingga lima kategori utama cukup di viewport; sisanya via “Lihat semua”.

Utamakan horizontal bar + nilai untuk kategori, karena refund dapat membuat net negatif. Sediakan titik nol, label rupiah, dan pilihan daftar angka. Warna kategori stabil antarlayar. Perbandingan menulis rentang “1–12 Okt dibanding 1–12 Sep”; jangan membandingkan periode penuh dengan periode berjalan tanpa penjelasan.

Empty chart bukan data dummy. Copy: “Ringkasan muncul setelah kamu mencatat transaksi.” CTA “Catat transaksi”.

### 7.8 Onboarding dan izin

Maksimal tiga langkah inti: akun/saldo awal → periode/budget → capture opsional. Header progress sederhana “Langkah 1 dari 3”, ilustrasi opsional berupa bentuk kartu lokal, bukan maskot wajib.

Layar izin capture berisi satu ilustrasi alur notifikasi → catatan, penjelasan data lokal dan keterbatasan, tombol “Buka pengaturan Android”, serta “Lanjutkan manual” yang jelas. Izin reminder diminta saat pengguna mengaktifkan pengingat, terpisah dari capture.

Saat kembali dari Settings, tampilkan status izin nyata; jangan mengganti toggle menjadi ON sebelum status OS diketahui. Tidak ada countdown, forced consent, atau claim semua transaksi akan tertangkap.

### 7.9 Pengaturan

Kelompokkan: Catatan & kategori; Capture & pengingat; Privasi; Data; Tentang. Row surface putih dengan divider, tanpa membuat semua item menjadi kartu bayangan. Hapus semua data dipisah di bagian bawah, dangerInk, dialog konfirmasi eksplisit. Status “Data tersimpan di perangkat ini” memberi penjelasan kehilangan data saat uninstall, mengikuti PRD.

## 8. Komponen reusable Flutter

| Komponen | Contract/variants |
|---|---|
| `OutlinedSurface` | tone, radius, border, shadow none/small/strong; bukan selalu clickable |
| `MoneyText` | integer IDR, sign mode, size role, privacy hidden state, semantics; tidak memotong angka |
| `SafeToSpendCard` | ready/missing/provisional/zero/error/loading; onOpenBreakdown |
| `SummaryTile` | label, money, optional status; adaptif satu/dua kolom |
| `TransactionRow` | merchant, account, category, amount, type, source, onOpen |
| `CategoryProgressRow` | actual, limit, reserved optional; semantic state dan label overspend |
| `BillRow` | dueDate, name, amount, status, onOpen |
| `CaptureReviewCard` | candidate fields, reason, allowed actions |
| `StatusBanner` | info/warning/error, title, body, action; icon+teks |
| `PrimaryButton` | idle/pressed/loading/disabled; shadow kuat default |
| `AmountField` | formatter IDR, controller, validation, accessible label |
| `EmptyState` | simple vector, title, description, satu CTA opsional |
| `PeriodSelector` | range label, previous/next, partial-period badge |

Semua komponen menerima data dari controller/read model; tidak menghitung ulang ledger, reserve, atau saldo. Tokens dipusatkan pada `ThemeExtension`, `ColorScheme`, dan `TextTheme`. Set Material `surfaceTintColor` transparan pada komponen custom agar fill pastel tidak berubah akibat elevation overlay.

Gunakan `SafeArea`, `LayoutBuilder`, dan scroll layout sesuai constraints. Gunakan `Semantics` untuk nominal dan status. Kelola focus/keyboard serta dispose controller. Pusatkan formatter IDR; jangan menyusun string uang berbeda di tiap widget.

## 9. Interaction dan motion

- Press feedback 100–140 ms, transisi sheet 220–280 ms, pergantian state 160–200 ms.
- Tombol boleh mengurangi shadow dari offset 4 ke 2 saat ditekan; bounds/tap target tetap stabil.
- Angka saldo berubah langsung setelah commit; tidak perlu count-up yang menunda pembacaan nominal.
- Hindari bounce, confetti, marquee, dan auto-carousel dalam aplikasi keuangan.
- Reduced motion meniadakan transform/slide dekoratif; status tetap jelas tanpa animasi.
- Snackbar success 3–4 detik, tidak menutupi tombol utama. Error penting tetap terlihat di konteks layar.
- Back pada form berubah meminta “Buang perubahan?” dengan pilihan kembali mengedit. Save gagal tidak meninggalkan layar.

## 10. Microcopy Indonesia

| Konteks | Copy |
|---|---|
| Capture belum aktif | “Catat lebih cepat dari notifikasi yang didukung.” |
| Data belum lengkap | “Ada 2 catatan yang belum diperiksa. Estimasi bisa berubah.” |
| Tidak ada transaksi | “Mulai dari satu transaksi.” |
| Budget kosong | “Tentukan batas belanja periode ini.” |
| Tidak ada tagihan | “Tambahkan tagihan agar dananya ikut disisihkan.” |
| Gagal simpan | “Transaksi belum tersimpan. Coba lagi.” |
| Parsing tidak pasti | “Nominal belum bisa dikenali. Isi secara manual.” |
| Saldo tidak sesuai | “Saldo ini berasal dari catatanmu. Sesuaikan jika berbeda.” |
| Success bill | “Pembayaran tercatat.” |

Nada ramah dan singkat, tanpa menghakimi kebiasaan belanja. Gunakan “kamu” secara konsisten pada helper text; label navigasi tetap netral. Hindari janji “100% akurat”, “terhubung ke semua bank”, “pasti aman”, dan “otomatis tanpa pernah perlu diperiksa”.

## 11. Accessibility dan visual QA

- Target sentuh ≥48 dp; jarak antartarget minimal 8 dp bila memungkinkan.
- Teks normal contrast ≥4.5:1; ikon bermakna/batas kontrol ≥3:1. Divider dekoratif tidak menjadi satu-satunya tanda area input.
- Font scaling 200%: nominal utuh, tombol masih terjangkau, hero/summary cards dapat tumbuh.
- TalkBack membaca nominal sebagai rupiah, source/status, selected tab, error, dan tujuan tombol.
- Ikon dekoratif di samping teks tidak dibaca dua kali. Tombol icon-only punya label eksplisit.
- Chart punya alternatif daftar. Progress memberi semantics actual/limit, bukan warna saja.
- Focus mengikuti urutan visual; setelah invalid submit arahkan ke field error pertama.
- Bottom navigation, FAB, bottom sheet dan keyboard tidak menutupi konten atau system gestures.
- Jika implementasi dark theme ditambahkan nanti, buat token mapping dan validasi terpisah.

## 12. Acceptance checklist desain

Checklist ini untuk implementasi berikutnya; belum merupakan klaim bahwa aplikasi/prototipe sudah dibuat dan diuji.

- [ ] Latar krem, outline ink, pastel, dan hard shadow konsisten di semua layar.
- [ ] Kartu Aman Dipakai menjadi fokus Home; total saldo tidak menggantikannya.
- [ ] Angka contoh cocok dengan formula PRD, termasuk pembayaran tagihan dan refund.
- [ ] Empat tab sesuai PRD; Accounts/Bills tersedia melalui Home.
- [ ] Tidak ada Goals, Debt/PayLater, Shared Expense, AI Assistant, forecasting, Financial Health, atau Net Worth dalam MVP.
- [ ] Semua tombol memiliki pressed/loading/disabled state.
- [ ] Capture permission dan reminder permission dibedakan dalam alur dan copy.
- [ ] Transaksi ambigu/duplikat punya review UI yang dapat dikoreksi.
- [ ] State kosong/error tidak menampilkan nominal nol yang menyesatkan.
- [ ] Tidak ada logo tiruan, emoji struktural, glass blur, gradient, atau chart dekoratif.
- [ ] Layout diperiksa pada 320–430 dp, landscape, 600+ dp, dan text scale 200%.
- [ ] TalkBack, reduced motion, kontras, safe area, dan keyboard behavior lolos pemeriksaan.

## 13. Brief implementasi untuk developer/Codex

> Implementasikan UI Flutter sesuai PRD MVP dan DESIGN.md ini. Gunakan konsep neo-brutalist hangat yang terinspirasi mockup bajet.lah: canvas krem, outline hitam tebal, hard shadow kecil, sudut membulat, aksen mint/butter/coral, dan angka IDR yang dominan. Mulai dari tokens serta komponen reusable, lalu Home sebagai layar acuan, Transaksi dan form, Budget, Accounts, Bills, Capture Inbox, Ringkasan, serta onboarding/settings. Pertahankan empat tab dan seluruh batas scope PRD. Pisahkan contoh data preview dari data produksi. Jangan menghitung saldo atau Aman Dipakai di widget. Implementasikan empty/error/loading/review states sejak awal. Sesuaikan layout dengan text scaling dan safe area; jangan mengorbankan keterbacaan nominal demi ukuran kartu tetap.

**Urutan visual:** tokens → hero/card/button/row → Home → form + daftar → Budget/Bills → Inbox → Ringkasan → onboarding/settings → QA.

**Batas referensi:** bentuk dan komposisi diinspirasi situs publik; ukuran, font, tokens, alur review, copy Indonesia, dan rincian layar adalah rancangan untuk produk ini. Dokumen ini adalah design specification Markdown, bukan file Figma atau screenshot aplikasi final.
