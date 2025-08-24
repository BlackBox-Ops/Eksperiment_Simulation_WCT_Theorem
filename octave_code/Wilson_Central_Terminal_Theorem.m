% WCT_Calculator.m
clc; clear; close all;

disp("=== Kalkulator Wilson Central Terminal (WCT) ===");

% --- Fungsi validasi input angka ---
function val = input_number(prompt, allow_decimal=false, must_integer=false)
  while true
    raw = input(prompt, "s");       % ambil input sebagai string
    if isempty(raw)
      disp("❌ Input tidak boleh kosong!");
      continue;
    end
    num = str2double(raw);          % konversi ke angka
    if isnan(num)
      disp("❌ Harus berupa angka valid!");
      continue;
    end
    if ~allow_decimal && mod(num,1)~=0
      disp("❌ Tidak boleh desimal/koma!");
      continue;
    end
    if must_integer && (num<=0 || mod(num,1)~=0)
      disp("❌ Resistor harus bilangan bulat positif!");
      continue;
    end
    val = num;
    break;
  end
end

% --- Input Tegangan (boleh desimal) ---
vra = input_number("Masukkan Tegangan Right Arm (VRA) [boleh koma]: ", true);
vla = input_number("Masukkan Tegangan Left Arm (VLA) [boleh koma]: ", true);
vll = input_number("Masukkan Tegangan Left Leg (VLL) [boleh koma]: ", true);

% --- Input Resistor (harus integer positif) ---
resistor = zeros(1,9);
for i = 1:9
    resistor(i) = input_number(sprintf("Masukkan nilai Resistor R%d (ohm, integer positif): ", i), false, true);
end

R1=resistor(1); R2=resistor(2); R3=resistor(3); R4=resistor(4);
R5=resistor(5); R6=resistor(6); R7=resistor(7); R8=resistor(8); R9=resistor(9);

% --- Perhitungan step by step ---
VraLa = vla + (R2/(R1+R2))*(vra - vla);
VlaLl = vll + (R4/(R3+R4))*(vla - vll);
VraLl = vll + (R8/(R7+R8))*(vra - vll);

if (R5 == R6 && R6 == R9)
    WCT = (VraLa + VlaLl + VraLl) / 3;
    mode = 'Rata-rata (symmetrical)';
else
    num = (VraLa/R5) + (VlaLl/R6) + (VraLl/R9);
    denom = (1/R5) + (1/R6) + (1/R9);
    WCT = num / denom;
    mode = 'Pembagi Tegangan (asymmetrical)';
end

% --- Einthoven Leads ---
Lead_I = vla - vra;
Lead_II = vll - vra;
Lead_III = vll - vla;
valid = abs((Lead_I + Lead_III) - Lead_II) < 1e-3;

% --- Augmented Leads ---
aVR = vra - WCT;
aVL = vla - WCT;
aVF = vll - WCT;

% --- Output ---
disp("=== HASIL PERHITUNGAN ===");
printf("VRa+La (via R1,R2): %.4f V\n", VraLa);
printf("VLa+LL (via R3,R4): %.4f V\n", VlaLl);
printf("VRa+LL (via R7,R8): %.4f V\n", VraLl);
printf("WCT: %.4f V (%s)\n", WCT, mode);

printf("\n--- Einthoven Leads ---\n");
printf("Lead I   = %.4f V\n", Lead_I);
printf("Lead II  = %.4f V\n", Lead_II);
printf("Lead III = %.4f V\n", Lead_III);
if valid
    disp("Validasi Einthoven: ✔ Benar");
else
    disp("Validasi Einthoven: ❌ Salah");
end

printf("\n--- Augmented Leads ---\n");
printf("aVR = %.4f V\n", aVR);
printf("aVL = %.4f V\n", aVL);
printf("aVF = %.4f V\n", aVF);
