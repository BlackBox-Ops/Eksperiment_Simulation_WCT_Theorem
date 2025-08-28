% File: ekg_analysis.m
% WCT_Calculator.m
clc; clear; close all;

disp("=== Kalkulator Wilson Central Terminal (WCT) ===");

% --- Fungsi validasi input angka ---
function val = input_number(prompt, min_val, max_val)
  while true
    raw = input(prompt, "s");
    if isempty(raw)
      disp("Input tidak boleh kosong!");
      continue;
    end
    num = str2double(raw);
    if isnan(num)
      disp("Harus berupa angka valid!");
      continue;
    end
    if num < min_val || num > max_val
      disp(["Nilai harus antara " num2str(min_val) " dan " num2str(max_val) "!"]);
      continue;
    end
    val = num;
    break;
  end
end

% --- Fungsi Perhitungan EKG ---
function [LeadI, LeadII, LeadIII] = calculate_bipolar_leads(VRa, VLa, VLL)
    LeadI = VLa - VRa;
    LeadII = VLL - VRa;
    LeadIII = VLL - VLa;

    if abs((LeadI + LeadIII) - LeadII) > 1e-9
        disp("Peringatan: Hukum Einthoven tidak terpenuhi (I + III != II).");
    end
end

function [aVR, aVL, aVF] = calculate_augmented_leads(VRa, VLa, VLL, method)
    if strcmp(method, 'Goldberger')
        aVR = VRa - (VLa + VLL) / 2;
        aVL = VLa - (VRa + VLL) / 2;
        aVF = VLL - (VRa + VLa) / 2;
    elseif strcmp(method, 'WCT')
        V_WCT = (VRa + VLa + VLL) / 3;
        aVR = VRa - V_WCT;
        aVL = VLa - V_WCT;
        aVF = VLL - V_WCT;
    else
        error('Metode tidak valid. Pilih "Goldberger" atau "WCT".');
    end
end

function V_WCT = calculate_voltage_central_terminal(V_RA, V_LA, V_LL, R5, R6, R9)
    if R5 == R6 && R6 == R9
        disp("Kondisi: R5, R6, dan R9 memiliki nilai yang sama. Menggunakan WCT standar.");
        V_WCT = (V_RA + V_LA + V_LL) / 3;
    else
        disp("Kondisi: R5, R6, dan R9 memiliki nilai yang berbeda. Menghitung pembagi tegangan.");
        V_RA_LA = V_LA + (R6 / (R5 + R6)) * (V_RA - V_LA);
        V_LA_LL = V_LL + (R9 / (R5 + R9)) * (V_LA - V_LL);
        V_RA_LL = V_LL + (R9 / (R6 + R9)) * (V_RA - V_LL);
        V_WCT = (V_RA_LA + V_LA_LL + V_RA_LL) / 3;

        fprintf("  V_RA_LA = %.2f V, V_LA_LL = %.2f V, V_RA_LL = %.2f V\n", V_RA_LA, V_LA_LL, V_RA_LL);
    end
    fprintf("Tegangan Wilson Central Terminal (V_WCT) = %.2f V\n", V_WCT);
end

% --- Program Utama ---
% 1. Input nilai resistor
disp("Masukkan nilai untuk setiap resistor (Ohm):");
resistors = zeros(1, 9);
for i = 1:9
    resistors(i) = input_number(sprintf("Masukkan nilai resistor R%d (Ohm): ", i), 0.1, 10000);
end
R5 = resistors(5);
R6 = resistors(6);
R9 = resistors(9);

% 2. Input tegangan ekstremitas
disp("\nMasukkan nilai tegangan untuk setiap elektroda (Volt):");
VRa = input_number("Masukkan tegangan Lengan Kanan (V_RA) dalam Volt: ", -inf, inf);
VLa = input_number("Masukkan tegangan Lengan Kiri (V_LA) dalam Volt: ", -inf, inf);
VLL = input_number("Masukkan tegangan Kaki Kiri (V_LL) dalam Volt: ", -inf, inf);

% 3. Hasil perhitungan
disp("\n--- Hasil Perhitungan ---");
[LeadI, LeadII, LeadIII] = calculate_bipolar_leads(VRa, VLa, VLL);
fprintf("Sadapan I (VLa - VRa) = %.2f V\n", LeadI);
fprintf("Sadapan II (VLL - VRa) = %.2f V\n", LeadII);
fprintf("Sadapan III (VLL - VLa) = %.2f V\n", LeadIII);

V_WCT = calculate_voltage_central_terminal(VRa, VLa, VLL, R5, R6, R9);
[aVR_wct, aVL_wct, aVF_wct] = calculate_augmented_leads(VRa, VLa, VLL, 'WCT');

disp("\nSadapan Augmented (menggunakan WCT):");
fprintf("  aVR = %.2f V\n", aVR_wct);
fprintf("  aVL = %.2f V\n", aVL_wct);
fprintf("  aVF = %.2f V\n", aVF_wct);

% Untuk contoh, kita bisa juga hitung dengan metode Goldberger
% [aVR_gold, aVL_gold, aVF_gold] = calculate_augmented_leads(VRa, VLa, VLL, 'Goldberger');
