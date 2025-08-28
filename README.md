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
![RA_LA](docs/img/ra_la.svg)  
![LA_LL](docs/img/la_ll.svg)  
![RA_LL](docs/img/ra_ll.svg)  

### 2. Perhitungan WCT (Simetris)
![WCT Formula](docs/img/wct.svg)  

### 3. Lead Augmentasi (Metode Goldberger)
![aVR Formula](docs/img/avr.svg)  
![aVL Formula](docs/img/avl.svg)  
![aVF Formula](docs/img/avf.svg)  

### 4. Lead dalam Mode WCT
![WCT Formula](docs/img/wct.svg)  
![aVR_WCT](docs/img/avr_wct.svg)  
![aVL_WCT](docs/img/avl_wct.svg)  
![aVF_WCT](docs/img/avf_wct.svg)  

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
- \(V_{WCT} = 0.833 \,V\)  

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

![WCT Weighted](docs/img/wct_weighted.svg)  

👉 Artinya, WCT berubah menjadi **pembagi tegangan berbobot (weighted average)**, di mana node yang resistornya lebih kecil akan lebih dominan mempengaruhi nilai WCT.

### Contoh Kasus
- \(R_5 = 10k\Omega\), \(R_6 = 20k\Omega\), \(R_9 = 30k\Omega\)  
- \(V_{RA} = 1.2V\), \(V_{LA} = 0.8V\), \(V_{LL} = 0.5V\)  

Hasil: \(V_{WCT} \approx 0.964 \,V\) (lebih condong ke RA).  

---

✍️ **Catatan Penting:**  
- WCT **ideal** hanya valid jika resistansi identik.  
- Jika tidak simetris, hasil WCT bias → potensi interpretasi lead ECG bisa melenceng.  
- Pada praktik klinis, desain hardware harus memastikan kesimetrian resistor agar perhitungan lead konsisten.
