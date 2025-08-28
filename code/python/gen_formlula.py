import os
import matplotlib.pyplot as plt

# Direktori tujuan
output_dir = "docs/img"
os.makedirs(output_dir, exist_ok=True)

# List formula LaTeX
formulas = {
    "ra_la": r"$V_{RA\_LA} = V_{LA} + \frac{R_2}{R_1+R_2} \cdot (V_{RA} - V_{LA})$",
    "la_ll": r"$V_{LA\_LL} = V_{LL} + \frac{R_4}{R_3+R_4} \cdot (V_{LA} - V_{LL})$",
    "ra_ll": r"$V_{RA\_LL} = V_{LL} + \frac{R_8}{R_7+R_8} \cdot (V_{RA} - V_{LL})$",
    "wct": r"$V_{WCT} = \frac{V_{RA\_LA} + V_{LA\_LL} + V_{RA\_LL}}{3}$",
    "avr": r"$aVR = V_{RA} - \frac{V_{LA} + V_{LL}}{2}$",
    "avl": r"$aVL = V_{LA} - \frac{V_{RA} + V_{LL}}{2}$",
    "avf": r"$aVF = V_{LL} - \frac{V_{RA} + V_{LA}}{2}$",
    "wct_mode": r"$V_{WCT} = \frac{V_{RA} + V_{LA} + V_{LL}}{3}$",
    "avr_wct": r"$aVR = V_{RA} - V_{WCT}$",
    "avl_wct": r"$aVL = V_{LA} - V_{WCT}$",
    "avf_wct": r"$aVF = V_{LL} - V_{WCT}$",
    "wct_weighted": r"$V_{WCT} = \frac{\frac{V_{RA}}{R_5} + \frac{V_{LA}}{R_6} + \frac{V_{LL}}{R_9}}{\frac{1}{R_5} + \frac{1}{R_6} + \frac{1}{R_9}}$"
}

# Fungsi untuk simpan formula ke SVG
def save_formula(name, formula):
    plt.figure(figsize=(6, 1))
    plt.text(0.5, 0.5, formula, fontsize=18, ha="center", va="center")
    plt.axis("off")
    filepath = os.path.join(output_dir, f"{name}.svg")
    plt.savefig(filepath, bbox_inches="tight", transparent=True)
    plt.close()
    print(f"Saved: {filepath}")

# Generate semua formula
for name, formula in formulas.items():
    save_formula(name, formula)
