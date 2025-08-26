import matplotlib.pyplot as plt
import numpy as np
import seaborn as sns # type: ignore

# --- Fungsi Validasi ---
def validate_input_number(prompt, min_value=None, max_value=None):
    while True:
        try:
            value = float(input(prompt))
            if min_value is not None and value < min_value:
                print(f"Nilai harus lebih besar dari atau sama dengan {min_value}.")
                continue
            if max_value is not None and value > max_value:
                print(f"Nilai harus lebih kecil dari atau sama dengan {max_value}.")
                continue
            return value
        except ValueError:
            print("Input tidak valid. Mohon masukkan angka.")

def get_valid_resistor_value(prompt, min_value=0.1, max_value=10000):
    return validate_input_number(prompt, min_value, max_value)

# --- Fungsi Perhitungan EKG ---
def calculate_bipolar_leads(VRa, VLa, VLL):
    LeadI = VLa - VRa
    LeadII = VLL - VRa
    LeadIII = VLL - VLa
    
    if abs((LeadI + LeadIII) - LeadII) > 1e-9:
        print("Peringatan: Hukum Einthoven tidak terpenuhi (I + III != II).")
    
    return LeadI, LeadII, LeadIII

def calculate_augmented_leads(VRa, VLa, VLL, method='Goldberger'):
    if method == 'Goldberger':
        aVR = VRa - (VLa + VLL) / 2
        aVL = VLa - (VRa + VLL) / 2
        aVF = VLL - (VRa + VLa) / 2
    elif method == 'WCT':
        V_WCT = (VRa + VLa + VLL) / 3
        aVR = VRa - V_WCT
        aVL = VLa - V_WCT
        aVF = VLL - V_WCT
    else:
        raise ValueError("Metode tidak valid. Pilih 'Goldberger' atau 'WCT'.")
        
    return aVR, aVL, aVF

def calculate_voltage_central_terminal(V_RA, V_LA, V_LL, R5, R6, R9):
    if R5 == R6 and R6 == R9:
        print("Kondisi: R5, R6, dan R9 memiliki nilai yang sama. Menggunakan WCT standar.")
        V_WCT = (V_RA + V_LA + V_LL) / 3
    else:
        print("Kondisi: R5, R6, dan R9 memiliki nilai yang berbeda. Menghitung pembagi tegangan.")
        V_RA_LA = V_LA + (R6 / (R5 + R6)) * (V_RA - V_LA)
        V_LA_LL = V_LL + (R9 / (R5 + R9)) * (V_LA - V_LL)
        V_RA_LL = V_LL + (R9 / (R6 + R9)) * (V_RA - V_LL)
        
        V_WCT = (V_RA_LA + V_LA_LL + V_RA_LL) / 3
        print(f"  V_RA_LA = {V_RA_LA:.2f}V, V_LA_LL = {V_LA_LL:.2f}V, V_RA_LL = {V_RA_LL:.2f}V")
        
    print(f"Tegangan Wilson Central Terminal (V_WCT) = {V_WCT:.2f} V")
    return V_WCT

# --- Fungsi Visualisasi Gabungan ---
def visualize_ekg_vectors_and_values(LeadI, LeadII, LeadIII, aVR, aVL, aVF):
    fig, axes = plt.subplots(nrows=1, ncols=3, figsize=(18, 6))
    plt.suptitle('Analisis Vektor EKG Sadapan Ekstremitas', fontsize=16)

    # Subplot 1: Einthoven's Triangle
    ax1 = axes[0]
    RA = np.array([0, 0])
    LA = np.array([-1, np.sqrt(3)])
    LL = np.array([1, np.sqrt(3)])
    ax1.plot([RA[0], LA[0], LL[0], RA[0]], [RA[1], LA[1], LL[1], RA[1]], 'k-', lw=2)
    center = np.mean([RA, LA, LL], axis=0)
    ax1.quiver(center[0], center[1], (LA - RA)[0], (LA - RA)[1], angles='xy', scale_units='xy', scale=1.5, color='r', label='Lead I', lw=2)
    ax1.quiver(center[0], center[1], (LL - RA)[0], (LL - RA)[1], angles='xy', scale_units='xy', scale=1.5, color='g', label='Lead II', lw=2)
    ax1.quiver(center[0], center[1], (LL - LA)[0], (LL - LA)[1], angles='xy', scale_units='xy', scale=1.5, color='b', label='Lead III', lw=2)
    ax1.text(LA[0], LA[1] + 0.1, 'LA', ha='center')
    ax1.text(RA[0], RA[1] - 0.1, 'RA', ha='center')
    ax1.text(LL[0], LL[1] + 0.1, 'LL', ha='center')
    ax1.set_aspect('equal')
    ax1.set_title("Segitiga Einthoven")
    ax1.legend()
    ax1.grid(True)
    ax1.set_xlim(-2, 2)
    ax1.set_ylim(-1, 3)

    # Subplot 2: Vektor Jantung (Mean QRS Vector)
    ax2 = axes[1]
    angle_I = np.deg2rad(0)
    angle_II = np.deg2rad(60)
    x_I = LeadI * np.cos(angle_I)
    y_I = LeadI * np.sin(angle_I)
    x_II = LeadII * np.cos(angle_II)
    y_II = LeadII * np.sin(angle_II)
    x_total = x_I + x_II
    y_total = y_I + y_II
    magnitude = np.sqrt(x_total**2 + y_total**2)
    angle = np.rad2deg(np.arctan2(y_total, x_total))

    ax2.axhline(y=0, color='k', linestyle='-')
    ax2.axvline(x=0, color='k', linestyle='-')
    ax2.quiver(0, 0, x_I, y_I, angles='xy', scale_units='xy', scale=1, color='r', label='Lead I', width=0.005)
    ax2.quiver(0, 0, x_II, y_II, angles='xy', scale_units='xy', scale=1, color='g', label='Lead II', width=0.005)
    ax2.quiver(0, 0, x_total, y_total, angles='xy', scale_units='xy', scale=1, color='b', label='Vektor Jantung', width=0.008)
    ax2.set_aspect('equal')
    ax2.set_title("Arah Listrik Jantung")
    ax2.set_xlabel("Sumbu Horizontal (0°)")
    ax2.set_ylabel("Sumbu Vertikal (90°)")
    ax2.legend()
    ax2.grid(True)
    ax2.text(0.1, 0.9, f"Sudut: {angle:.2f}°", transform=ax2.transAxes, fontsize=12)
    ax2.text(0.1, 0.85, f"Magnitudo: {magnitude:.2f}", transform=ax2.transAxes, fontsize=12)
    ax2.set_xlim(-2, 2)
    ax2.set_ylim(-1.5, 2.5)

    # Subplot 3: Bar Plot Tegangan
    ax3 = axes[2]
    leads_values = [LeadI, LeadII, LeadIII, aVR, aVL, aVF]
    leads_labels = ['I', 'II', 'III', 'aVR', 'aVL', 'aVF']
    sns.barplot(x=leads_labels, y=leads_values, palette='viridis', ax=ax3)
    ax3.set_title('Nilai Tegangan Sadapan Ekstremitas')
    ax3.set_ylabel('Tegangan (V)')
    ax3.set_xlabel('Sadapan')

    plt.tight_layout(rect=[0, 0.03, 1, 0.95])
    plt.show()

# --- Program Utama ---
if __name__ == "__main__":
    print("Masukkan nilai untuk setiap resistor (Ohm):")
    resistors = {}
    for i in range(1, 10):
        resistors[f"R{i}"] = get_valid_resistor_value(f"Masukkan nilai resistor R{i} (Ohm): ")
    
    print("\nMasukkan nilai tegangan untuk setiap elektroda (Volt):")
    VRa = validate_input_number("Masukkan tegangan Lengan Kanan (V_RA) dalam Volt: ")
    VLa = validate_input_number("Masukkan tegangan Lengan Kiri (V_LA) dalam Volt: ")
    VLL = validate_input_number("Masukkan tegangan Kaki Kiri (V_LL) dalam Volt: ")
    
    print("\n--- Hasil Perhitungan ---")
    
    LeadI, LeadII, LeadIII = calculate_bipolar_leads(VRa, VLa, VLL)
    print(f"Sadapan I (VLa - VRa) = {LeadI:.2f}V")
    print(f"Sadapan II (VLL - VRa) = {LeadII:.2f}V")
    print(f"Sadapan III (VLL - VLa) = {LeadIII:.2f}V")

    V_WCT = calculate_voltage_central_terminal(
        VRa, VLa, VLL, 
        resistors['R5'], resistors['R6'], resistors['R9']
    )
    aVR_wct, aVL_wct, aVF_wct = calculate_augmented_leads(VRa, VLa, VLL, method='WCT')
    
    print("\nSadapan Augmented (menggunakan WCT):")
    print(f"  aVR = {aVR_wct:.2f}V")
    print(f"  aVL = {aVL_wct:.2f}V")
    print(f"  aVF = {aVF_wct:.2f}V")
    
    visualize_ekg_vectors_and_values(LeadI, LeadII, LeadIII, aVR_wct, aVL_wct, aVF_wct)