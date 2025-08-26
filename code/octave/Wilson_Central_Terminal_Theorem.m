% WCT_Calculator.m
clc; clear; close all;

disp("=== Kalkulator Wilson Central Terminal (WCT) ===");

% --- Fungsi validasi input angka ---
function val = input_number(prompt, min_val, max_val)
  while true
    raw = input(prompt, "s");       % ambil input sebagai string
    if isempty(raw)
      disp(" Input tidak boleh kosong!");
      continue;
    end
    num = str2double(raw);          % konversi ke angka
    if isnan(num)
      disp(" Harus berupa angka valid!");
      continue;
    end
    if num < min_val || num > max_val
      disp([" Nilai harus antara " num2str(min_val) " dan " num2str(max_val) "!"]);
      continue;
    end
    val = num;
    break;
  end
end

% --- Input Tegangan ---
vra = input_number("Masukkan Tegangan Right Arm (VRA) [Volt, e.g. 1.2]: ", -inf, inf);
vla = input_number("Masukkan Tegangan Left Arm (VLA) [Volt, e.g. 1.5]: ", -inf, inf);
vll = input_number("Masukkan Tegangan Left Leg (VLL) [Volt, e.g. 0.8]: ", -inf, inf);

% --- Input Resistor (harus positif) ---
resistor = zeros(1,9);
for i = 1:9
    resistor(i) = input_number(sprintf("Masukkan nilai Resistor R%d (Ohm, e.g. 100): ", i), 0, inf);
end

R1=resistor(1); R2=resistor(2); R3=resistor(3); R4=resistor(4);
R5=resistor(5); R6=resistor(6); R7=resistor(7); R8=resistor(8); R9=resistor(9);

% --- Perhitungan step-by-step ---
% Perhitungan pembagi tegangan antara setiap pasangan elektroda
V_ra_la = vra - (R1 / (R1 + R2)) * (vra - vla);
V_la_ll = vla - (R3 / (R3 + R4)) * (vla - vll);
V_ra_ll = vra - (R7 / (R7 + R8)) * (vra - vll);

% --- Perhitungan WCT ---
% WCT dihitung dengan merata-ratakan tegangan dari ketiga titik tengah
WCT_via_dividers = (V_ra_la / R5 + V_la_ll / R6 + V_ra_ll / R9) / (1/R5 + 1/R6 + 1/R9);
WCT_standard = (vra + vla + vll) / 3;

if (R5 == R6 && R6 == R9)
    WCT = WCT_standard;
    mode = 'WCT Standar (R5=R6=R9)';
else
    WCT = WCT_via_dividers;
    mode = 'Rangkaian Pembagi Tegangan (R5,R6,R9 berbeda)';
end

% --- Sadapan Bipolar (Einthoven Leads) ---
Lead_I = vla - vra;
Lead_II = vll - vra;
Lead_III = vll - vla;
% Validasi Hukum Einthoven
einthoven_valid = abs((Lead_I + Lead_III) - Lead_II) < 1e-6;

% --- Sadapan Unipolar (Augmented Leads) ---
aVR = vra - WCT;
aVL = vla - WCT;
aVF = vll - WCT;

% --- Output ---
disp("=== HASIL PERHITUNGAN ===");
fprintf("Tegangan di titik tengah:\n");
fprintf("  V(RA-LA): %.4f V\n", V_ra_la);
fprintf("  V(LA-LL): %.4f V\n", V_la_ll);
fprintf("  V(RA-LL): %.4f V\n", V_ra_ll);
fprintf("\n");

fprintf("Tegangan Wilson Central Terminal (WCT): %.4f V\n", WCT);
fprintf("Mode Perhitungan: %s\n", mode);

fprintf("\n--- Sadapan Bipolar (Einthoven Leads) ---\n");
fprintf("Lead I   : %.4f V\n", Lead_I);
fprintf("Lead II  : %.4f V\n", Lead_II);
fprintf("Lead III : %.4f V\n", Lead_III);
if einthoven_valid
    disp("Hukum Einthoven: Valid (I + III = II)");
else
    disp("Hukum Einthoven: Tidak Valid");
end

fprintf("\n--- Sadapan Unipolar (Augmented Leads) ---\n");
fprintf("aVR = %.4f V\n", aVR);
fprintf("aVL = %.4f V\n", aVL);
fprintf("aVF = %.4f V\n", aVF);