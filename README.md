# Eksperiment_Simulation_WCT_Theorem
# WCT ECG Project

Proyek perhitungan dan simulasi **Wilson Central Terminal (WCT)** untuk sistem ECG.

## Struktur Repo
- `schematic/` : Skema rangkaian WCT (gambar, KiCad, dsb.)
- `octave/` : Kode perhitungan WCT dengan GNU Octave.
- `ltspice/` : Simulasi rangkaian WCT dengan LTSpice.
- `docs/` : Dokumentasi tambahan.

## Tujuan
- Validasi teori **Wilson Central Terminal**.
- Simulasi rangkaian divider resistor.
- Implementasi perhitungan di Octave dan LTSpice.

## Hasil Perhitungan

### 1. Rumus Pembagi Tegangan
Rumus pembagi tegangan yang digunakan untuk setiap node:

\[
V_{RA\_LA} = V_{LA} + \left( \frac{R_2}{R_1 + R_2} \right)(V_{RA} - V_{LA})
\]

\[
V_{LA\_LL} = V_{LL} + \left( \frac{R_4}{R_3 + R_4} \right)(V_{LA} - V_{LL})
\]

\[
V_{RA\_LL} = V_{LL} + \left( \frac{R_8}{R_7 + R_8} \right)(V_{RA} - V_{LL})
\]

### 2. Perhitungan WCT (Simetris)
Jika resistansi \(R_5 = R_6 = R_9\), maka tegangan **Wilson Central Terminal (WCT)** dihitung sebagai:

\[
V_{WCT} = \frac{V_{RA\_LA} + V_{LA\_LL} + V_{RA\_LL}}{3}
\]

### 3. Lead Augmentasi (Metode Goldberger)
Menggunakan metode Goldberger:

\[
aVR = V_{RA} - \frac{V_{LA} + V_{LL}}{2}
\]

\[
aVL = V_{LA} - \frac{V_{RA} + V_{LL}}{2}
\]

\[
aVF = V_{LL} - \frac{V_{RA} + V_{LA}}{2}
\]

### 4. Lead dalam Mode WCT
Jika menggunakan **Wilson Central Terminal** sebagai referensi:

\[
V_{WCT} = \frac{V_{RA} + V_{LA} + V_{LL}}{3}
\]

\[
aVR = V_{RA} - V_{WCT}
\]

\[
aVL = V_{LA} - V_{WCT}
\]

\[
aVF = V_{LL} - V_{WCT}
\]

---

## Contoh Perhitungan Numerik (Simetris)

Misalkan diberikan kondisi:
- \(R_1 = R_2 = R_3 = R_4 = R_7 = R_8 = 10 \,k\Omega\)  
- \(V_{RA} = 1.2 \,V\), \(V_{LA} = 0.8 \,V\), \(V_{LL} = 0.5 \,V\)

### Step 1: Tegangan Divider
- \(V_{RA\_LA} = 1.0 \,V\)  
- \(V_{LA\_LL} = 0.65 \,V\)  
- \(V_{RA\_LL} = 0.85 \,V\)  

### Step 2: Wilson Central Terminal
\[
V_{WCT} = 0.833 \,V
\]

### Step 3: Lead Goldberger
- \(aVR = 0.55 \,V\)  
- \(aVL = -0.05 \,V\)  
- \(aVF = -0.50 \,V\)  

### Step 4: Lead Mode WCT
- \(aVR = 0.367 \,V\)  
- \(aVL = -0.033 \,V\)  
- \(aVF = -0.333 \,V\)  

---

## Tabel Perbandingan (Simetris)

| Lead  | Metode Goldberger | Metode WCT |
|-------|-------------------|------------|
| aVR   | 0.55 V            | 0.367 V    |
| aVL   | -0.05 V           | -0.033 V   |
| aVF   | -0.50 V           | -0.333 V   |

---

## Kasus Resistor Tidak Simetris

Jika resistor tidak identik (misalnya \(R_5 \neq R_6 \neq R_9\)), maka rumus WCT menjadi:

\[
V_{WCT} = \frac{\frac{V_{RA}}{R_5} + \frac{V_{LA}}{R_6} + \frac{V_{LL}}{R_9}}{\frac{1}{R_5} + \frac{1}{R_6} + \frac{1}{R_9}}
\]

👉 Artinya, WCT berubah menjadi **pembagi tegangan berbobot (weighted average)**, di mana node yang resistornya lebih kecil akan lebih dominan mempengaruhi nilai WCT.

### Contoh Kasus
- \(R_5 = 10k\Omega\), \(R_6 = 20k\Omega\), \(R_9 = 30k\Omega\)  
- \(V_{RA} = 1.2V\), \(V_{LA} = 0.8V\), \(V_{LL} = 0.5V\)

\[
V_{WCT} = \frac{\frac{1.2}{10} + \frac{0.8}{20} + \frac{0.5}{30}}{\frac{1}{10} + \frac{1}{20} + \frac{1}{30}}
= \frac{0.12 + 0.04 + 0.0167}{0.1 + 0.05 + 0.0333}
= \frac{0.1767}{0.1833} \approx 0.964 \,V
\]

📌 Terlihat bahwa WCT **bergeser** lebih dekat ke \(V_{RA}\) karena resistor \(R_5\) paling kecil sehingga lebih dominan.

---

✍️ **Catatan Penting:**  
- WCT **ideal** hanya valid jika resistansi identik.  
- Jika tidak simetris, hasil WCT bias → potensi interpretasi lead ECG bisa melenceng.  
- Pada praktik klinis, desain hardware harus memastikan kesimetrian resistor agar perhitungan lead konsisten.
