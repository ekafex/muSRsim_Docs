# Materials reference for musrSim

## How to read the “Call in musrSim macro” column

For a construct line in a musrSim steering/macro file, the material field should contain the **exact material name string**. Examples:

```txt
... Mylar ...
... Air1mbar ...
... G4_Si ...
... G4_Al ...
```

Not:

```txt
... Si ...
... Al ...
```

unless your code explicitly defined a material with that exact name, which this uploaded `musrDetectorConstruction.cc` does not do for bare element symbols.  ([geant4-userdoc.web.cern.ch][1])

---

## 1. Geant4 simple materials (elements) usable from musrSim

These come from the Geant4 NIST material database. For the simple-element entries in the appendix, the usable material names are `G4_H`, `G4_He`, `G4_Si`, etc. The density values below are the reference values shown in the Geant4 appendix. ([geant4-userdoc.web.cern.ch][1])

| Z    | Element      | Material Call | Comments                                |
| ---- | ------------ | ------------- | --------------------------------------- |
| 1    | Hydrogen     | G4_H          | $\rho\approx 8.3748e-05 \,{\rm g/cm^3}$ |
| 2    | Helium       | G4_He         | $\rho\approx 1.66322e-04\,{\rm g/cm^3}$ |
| 3    | Lithium      | G4_Li         | $\rho\approx 0.534\,{\rm g/cm^3}$       |
| 4    | Beryllium    | G4_Be         | $\rho\approx 1.848\,{\rm g/cm^3}$       |
| 5    | Boron        | G4_B          | $\rho\approx 2.37\,{\rm g/cm^3}$        |
| 6    | Carbon       | G4_C          | $\rho\approx 2.0\,{\rm g/cm^3}$         |
| 7    | Nitrogen     | G4_N          | $\rho\approx 0.0011652\,{\rm g/cm^3}$   |
| 8    | Oxygen       | G4_O          | $\rho\approx 0.00133151\,{\rm g/cm^3}$  |
| 9    | Fluorine     | G4_F          | $\rho\approx 0.00158029\,{\rm g/cm^3}$  |
| 10   | Neon         | G4_Ne         | $\rho\approx 8.38505e-04\,{\rm g/cm^3}$ |
| 11   | Sodium       | G4_Na         | $\rho\approx 0.971\,{\rm g/cm^3}$       |
| 12   | Magnesium    | G4_Mg         | $\rho\approx 1.74\,{\rm g/cm^3}$        |
| 13   | Aluminium    | G4_Al         | $\rho\approx 2.699\,{\rm g/cm^3}$       |
| 14   | Silicon      | G4_Si         | $\rho\approx 2.33\,{\rm g/cm^3}$        |
| 15   | Phosphorus   | G4_P          | $\rho\approx 2.2\,{\rm g/cm^3}$         |
| 16   | Sulfur       | G4_S          | $\rho\approx 2.0\,{\rm g/cm^3}$         |
| 17   | Chlorine     | G4_Cl         | $\rho\approx 0.00299473\,{\rm g/cm^3}$  |
| 18   | Argon        | G4_Ar         | $\rho\approx 0.00166201\,{\rm g/cm^3}$  |
| 19   | Potassium    | G4_K          | $\rho\approx 0.862\,{\rm g/cm^3}$       |
| 20   | Calcium      | G4_Ca         | $\rho\approx 1.55\,{\rm g/cm^3}$        |
| 21   | Scandium     | G4_Sc         | $\rho\approx 2.989\,{\rm g/cm^3}$       |
| 22   | Titanium     | G4_Ti         | $\rho\approx 4.54\,{\rm g/cm^3}$        |
| 23   | Vanadium     | G4_V          | $\rho\approx 6.11\,{\rm g/cm^3}$        |
| 24   | Chromium     | G4_Cr         | $\rho\approx 7.18\,{\rm g/cm^3}$        |
| 25   | Manganese    | G4_Mn         | $\rho\approx 7.44\,{\rm g/cm^3}$        |
| 26   | Iron         | G4_Fe         | $\rho\approx 7.874\,{\rm g/cm^3}$       |
| 27   | Cobalt       | G4_Co         | $\rho\approx 8.9\,{\rm g/cm^3}$         |
| 28   | Nickel       | G4_Ni         | $\rho\approx 8.902\,{\rm g/cm^3}$       |
| 29   | Copper       | G4_Cu         | $\rho\approx 8.96\,{\rm g/cm^3}$        |
| 30   | Zinc         | G4_Zn         | $\rho\approx 7.133\,{\rm g/cm^3}$       |
| 31   | Gallium      | G4_Ga         | $\rho\approx 5.904\,{\rm g/cm^3}$       |
| 32   | Germanium    | G4_Ge         | $\rho\approx 5.323\,{\rm g/cm^3}$       |
| 33   | Arsenic      | G4_As         | $\rho\approx 5.73\,{\rm g/cm^3}$        |
| 34   | Selenium     | G4_Se         | $\rho\approx 4.5\,{\rm g/cm^3}$         |
| 35   | Bromine      | G4_Br         | $\rho\approx 0.0070721\,{\rm g/cm^3}$   |
| 36   | Krypton      | G4_Kr         | $\rho\approx 0.00347832\,{\rm g/cm^3}$  |
| 37   | Rubidium     | G4_Rb         | $\rho\approx 1.532\,{\rm g/cm^3}$       |
| 38   | Strontium    | G4_Sr         | $\rho\approx 2.54\,{\rm g/cm^3}$        |
| 39   | Yttrium      | G4_Y          | $\rho\approx 4.469\,{\rm g/cm^3}$       |
| 40   | Zirconium    | G4_Zr         | $\rho\approx 6.506\,{\rm g/cm^3}$       |
| 41   | Niobium      | G4_Nb         | $\rho\approx 8.57\,{\rm g/cm^3}$        |
| 42   | Molybdenum   | G4_Mo         | $\rho\approx 10.22\,{\rm g/cm^3}$       |
| 43   | Technetium   | G4_Tc         | $\rho\approx 11.5\,{\rm g/cm^3}$        |
| 44   | Ruthenium    | G4_Ru         | $\rho\approx 12.41\,{\rm g/cm^3}$       |
| 45   | Rhodium      | G4_Rh         | $\rho\approx 12.41\,{\rm g/cm^3}$       |
| 46   | Palladium    | G4_Pd         | $\rho\approx 12.02\,{\rm g/cm^3}$       |
| 47   | Silver       | G4_Ag         | $\rho\approx 10.5\,{\rm g/cm^3}$        |
| 48   | Cadmium      | G4_Cd         | $\rho\approx 8.65\,{\rm g/cm^3}$        |
| 49   | Indium       | G4_In         | $\rho\approx 7.31\,{\rm g/cm^3}$        |
| 50   | Tin          | G4_Sn         | $\rho\approx 7.31\,{\rm g/cm^3}$        |
| 51   | Antimony     | G4_Sb         | $\rho\approx 6.691\,{\rm g/cm^3}$       |
| 52   | Tellurium    | G4_Te         | $\rho\approx 6.24\,{\rm g/cm^3}$        |
| 53   | Iodine       | G4_I          | $\rho\approx 4.93\,{\rm g/cm^3}$        |
| 54   | Xenon        | G4_Xe         | $\rho\approx 0.00548536\,{\rm g/cm^3}$  |
| 55   | Caesium      | G4_Cs         | $\rho\approx 1.873\,{\rm g/cm^3}$       |
| 56   | Barium       | G4_Ba         | $\rho\approx 3.5\,{\rm g/cm^3}$         |
| 57   | Lanthanum    | G4_La         | $\rho\approx 6.154\,{\rm g/cm^3}$       |
| 58   | Cerium       | G4_Ce         | $\rho\approx 6.657\,{\rm g/cm^3}$       |
| 59   | Praseodymium | G4_Pr         | $\rho\approx 6.71\,{\rm g/cm^3}$        |
| 60   | Neodymium    | G4_Nd         | $\rho\approx 6.9\,{\rm g/cm^3}$         |
| 61   | Promethium   | G4_Pm         | $\rho\approx 7.22\,{\rm g/cm^3}$        |
| 62   | Samarium     | G4_Sm         | $\rho\approx 7.46\,{\rm g/cm^3}$        |
| 63   | Europium     | G4_Eu         | $\rho\approx 5.243\,{\rm g/cm^3}$       |
| 64   | Gadolinium   | G4_Gd         | $\rho\approx 7.9004\,{\rm g/cm^3}$      |
| 65   | Terbium      | G4_Tb         | $\rho\approx 8.229\,{\rm g/cm^3}$       |
| 66   | Dysprosium   | G4_Dy         | $\rho\approx 8.55\,{\rm g/cm^3}$        |
| 67   | Holmium      | G4_Ho         | $\rho\approx 8.795\,{\rm g/cm^3}$       |
| 68   | Erbium       | G4_Er         | $\rho\approx 9.066\,{\rm g/cm^3}$       |
| 69   | Thulium      | G4_Tm         | $\rho\approx 9.321\,{\rm g/cm^3}$       |
| 70   | Ytterbium    | G4_Yb         | $\rho\approx 6.73\,{\rm g/cm^3}$        |
| 71   | Lutetium     | G4_Lu         | $\rho\approx 9.84\,{\rm g/cm^3}$        |
| 72   | Hafnium      | G4_Hf         | $\rho\approx 13.31\,{\rm g/cm^3}$       |
| 73   | Tantalum     | G4_Ta         | $\rho\approx 16.654\,{\rm g/cm^3}$      |
| 74   | Tungsten     | G4_W          | $\rho\approx 19.3\,{\rm g/cm^3}$        |
| 75   | Rhenium      | G4_Re         | $\rho\approx 21.02\,{\rm g/cm^3}$       |
| 76   | Osmium       | G4_Os         | $\rho\approx 22.57\,{\rm g/cm^3}$       |
| 77   | Iridium      | G4_Ir         | $\rho\approx 22.42\,{\rm g/cm^3}$       |
| 78   | Platinum     | G4_Pt         | $\rho\approx 21.45\,{\rm g/cm^3}$       |
| 79   | Gold         | G4_Au         | $\rho\approx 19.32\,{\rm g/cm^3}$       |
| 80   | Mercury      | G4_Hg         | $\rho\approx 13.546\,{\rm g/cm^3}$      |
| 81   | Thallium     | G4_Tl         | $\rho\approx 11.72\,{\rm g/cm^3}$       |
| 82   | Lead         | G4_Pb         | $\rho\approx 11.35\,{\rm g/cm^3}$       |
| 83   | Bismuth      | G4_Bi         | $\rho\approx 9.747\,{\rm g/cm^3}$       |
| 84   | Polonium     | G4_Po         | $\rho\approx 9.32\,{\rm g/cm^3}$        |
| 85   | Astatine     | G4_At         | $\rho\approx 9.32\,{\rm g/cm^3}$        |
| 86   | Radon        | G4_Rn         | $\rho\approx 0.00900662\,{\rm g/cm^3}$  |
| 87   | Francium     | G4_Fr         | $\rho\approx 1.0\,{\rm g/cm^3}$         |
| 88   | Radium       | G4_Ra         | $\rho\approx 5.0\,{\rm g/cm^3}$         |
| 89   | Actinium     | G4_Ac         | $\rho\approx 10.07\,{\rm g/cm^3}$       |
| 90   | Thorium      | G4_Th         | $\rho\approx 11.72\,{\rm g/cm^3}$       |
| 91   | Protactinium | G4_Pa         | $\rho\approx 15.37\,{\rm g/cm^3}$       |
| 92   | Uranium      | G4_U          | $\rho\approx 18.95\,{\rm g/cm^3}$       |


---

## 2. Custom materials explicitly defined in the uploaded musrSim `musrDetectorConstruction.cc`

These are directly created with `new G4Material("...")` in your uploaded file, so these exact strings are the ones to use in the musrSim macro.

| Material         | Comments                                                     |
| ---------------- | ------------------------------------------------------------ |
| MgO              | $\rho= 3.60\,{\rm g/cm^3}$; magnesium oxide                  |
| SiO2             | $\rho = 2.533\,{\rm g/cm^3}$; quartz                         |
| Si3N4            | $\rho = 3.2\,{\rm g/cm^3}$; silicon nitride                  |
| Al2O3            | $\rho = 3.985\,{\rm g/cm^3}$; aluminum oxide; comment says sapphire |
| K2O              | $\rho = 2.350\,{\rm g/cm^3}$; potassium oxide                |
| B2O3             | $\rho = 2.550\,{\rm g/cm^3}$; boron oxide                    |
| Scintillator     | $\rho = 1.032\,{\rm g/cm^3}$; composition C9H10              |
| Mylar            | $\rho = 1.397\,{\rm g/cm^3}$; composition C10H8O4            |
| Brass            | $\rho = 8.40\,{\rm g/cm^3}$; 70% Cu + 30% Zn by mass         |
| Steel            | $\rho = 7.93\,{\rm g/cm^3}$; 71% Fe + 18% Cr + 11% Ni by mass |
| Macor            | $\rho = 2.52\,{\rm g/cm^3}$; MCP detector ceramic; built from SiO2, MgO, Al2O3, K2O, B2O3 |
| MCPglass         | $\rho = 2.0\,{\rm g/cm^3}$; lead-rich multi-channel-plate glass |
| Air              | $\rho = 1.290 \,{\rm mg/cm^3}$; 70% N + 30% O by mass        |
| Air1mbar         | $\rho = 1.290e-3 \,{\rm mg/cm^3}$; nominal 1 mbar air model  |
| AirE1mbar        | $\rho = 1.290e-4 \,{\rm mg/cm^3}$; effectively 10^-1 mbar relative to Air1mbar scaling |
| AirE2mbar        | $\rho = 1.290e-5 \,{\rm mg/cm^3}$; effectively 10^-2 mbar scaling |
| AirE3mbar        | $\rho = 1.290e-6 \,{\rm mg/cm^3}$; effectively 10^-3 mbar scaling |
| AirE4mbar        | $\rho = 1.290e-7 \,{\rm mg/cm^3}$; effectively 10^-4 mbar scaling |
| AirE5mbar        | $\rho = 1.290e-8 \,{\rm mg/cm^3}$; effectively 10^-5 mbar scaling |
| AirE6mbar        | $\rho = 1.290e-9 \,{\rm mg/cm^3}$; effectively 10^-6 mbar scaling |
| Vacuum           | $\rho =$ universe_mean_density; T = 2.73 K; P = 3e-18 Pa     |
| ArgonGas         | $\rho = 1e-11 \,{\rm mg/cm^3}$; very dilute argon model      |
| HeliumGas5mbar   | $\rho = 8.8132e-7\,{\rm g/cm^3}$; nominal 5 mbar He          |
| HeliumGas6mbar   | $\rho = 1.057584e-6\,{\rm g/cm^3}$; nominal 6 mbar He        |
| HeliumGas7mbar   | $\rho = 1.233848e-6\,{\rm g/cm^3}$; nominal 7 mbar He        |
| HeliumGas8mbar   | $\rho = 1.410112e-6\,{\rm g/cm^3}$; nominal 8 mbar He        |
| HeliumGas9mbar   | $\rho = 1.586376e-6\,{\rm g/cm^3}$; nominal 9 mbar He        |
| HeliumGas10mbar  | $\rho = 1.76264e-6\,{\rm g/cm^3}$; nominal 10 mbar He        |
| HeliumGas11mbar  | $\rho = 1.938904e-6\,{\rm g/cm^3}$; nominal 11 mbar He       |
| HeliumGas12mbar  | $\rho = 2.115168e-6\,{\rm g/cm^3}$; nominal 12 mbar He       |
| HeliumGas13mbar  | $\rho = 2.291432e-6\,{\rm g/cm^3}$; nominal 13 mbar He       |
| HeliumGas14mbar  | $\rho = 2.467696e-6\,{\rm g/cm^3}$; nominal 14 mbar He       |
| HeliumGas15mbar  | $\rho = 2.64396e-6\,{\rm g/cm^3}$; nominal 15 mbar He        |
| HeliumGas20mbar  | $\rho = 3.52528e-6\,{\rm g/cm^3}$; nominal 20 mbar He        |
| HeliumGas30mbar  | $\rho = 5.28792e-6\,{\rm g/cm^3}$; nominal 30 mbar He        |
| HeliumGas40mbar  | $\rho = 7.05056e-6\,{\rm g/cm^3}$; nominal 40 mbar He        |
| HeliumGas50mbar  | $\rho = 8.81320e-6\,{\rm g/cm^3}$; nominal 50 mbar He        |
| HeliumGas60mbar  | $\rho = 1.057584e-5\,{\rm g/cm^3}$; nominal 60 mbar He       |
| HeliumGas70mbar  | $\rho = 1.233848e-5\,{\rm g/cm^3}$; nominal 70 mbar He       |
| HeliumGas80mbar  | $\rho = 1.410112e-5\,{\rm g/cm^3}$; nominal 80 mbar He       |
| HeliumGas90mbar  | $\rho = 1.586376e-5\,{\rm g/cm^3}$; nominal 90 mbar He       |
| HeliumGas100mbar | $\rho = 1.762640e-5\,{\rm g/cm^3}$; nominal 100 mbar He      |
| HeliumGasSat4K   | $\rho = 0.016891\,{\rm g/cm^3}$; saturated He vapor near 4.2 K |
| HeliumGas5mbar4K | $\rho = 0.016891 × 5/1013\,{\rm g/cm^3}$; typical cold exchange gas at 4.2 K and 5 mbar |
| HeliumGas2mbar4K | $\rho = 0.016891 × 2/1013\,{\rm g/cm^3}$; cold exchange gas at 4.2 K and 2 mbar |

---

## Practical rule

Use this mental rule:

* **NIST/Geant4 built-in element-like material** → call it by `G4_*`, for example `G4_Si`
* **musrSim custom material from detector construction** → call it by the exact custom name, for example `Mylar`, `Air1mbar`, `HeliumGas5mbar`, `Vacuum`  ([geant4-userdoc.web.cern.ch][1])

If you want, next I can turn this into a clean `Materials.md` file with the tables already formatted for your documentation repo.



[1]: https://geant4-userdoc.web.cern.ch/UsersGuides/ForApplicationDeveloper/html/Appendix/materialNames.html "Geant4 Material Database — Book For Application Developers  11.4
 documentation"

