# Construct command

```text
/musr/command construct solid name dimensions... material x y z motherVolume matrixName sensitiveClass idNumber
```

### What it does

It defines a Geant4 volume in one line: effectively **solid + logical volume + physical placement**. 

### Arguments

* **solid**: shape type. Supported examples include
  `tubs`, `cons`, `box`, `trd`, `sphere`, `para`, `polyconeA`, `polyconeB`, and musrSim-specific ones like `uprofile`, `alcSupportPlate`, `tubsbox`, `tubsboxsegm`, `trd90y`, `cylpart`, `GPDcollimator`. `polyconeA/B` may require arrays defined with `/musr/command arrayDef`.

* **name**: volume name. Internally musrSim creates `sol_name`, `log_name`, `phys_name`. The top mother volume must be named **`World`**. 

* **dimensions...**: shape parameters, following **Geant4 solid conventions**. Important: often these are **half-lengths**, not full lengths. Units are **mm** for lengths and **degrees** for angles. 

* **material**: Geant4/NIST material name such as `G4_Galactic`, `G4_Cu`, `G4_AIR`, `G4_PLASTIC_SC_VINYLTOLUENE`; musrSim also defines some custom ones like `Mylar`, `Brass`, `Steel`, `Macor`, `MCPglass`, `MgO`, `SiO2`, `Al2O3`, `K2O`, `B2O3`. 

* **x y z**: placement coordinates of the volume **inside its mother volume**, so these are in the **local coordinates of the mother**. 

* **motherVolume**: name of the mother logical volume. The mother must be defined first. For the `World` volume, this must be **`no logical volume`**. 

* **matrixName**: rotation matrix name used for placement. Use **`norot`** if no rotation is needed; otherwise define it first with `/musr/command rotation`.

* **sensitiveClass**: detector sensitivity class. Currently the manual says the practical choices are

  * `dead` = passive material
  * `musr/ScintSD` = sensitive scintillator volume 

* **idNumber**: unique integer ID for the volume. Used in output, e.g. muon decay detector ID and hit detector ID. 

### Important practical notes

* **Order matters**: define mother before daughter. 
* **No overlaps** are allowed between volumes, except normal daughter-in-mother containment. 
* Some names have **special behavior** in musrSim: `Target`, `M0`, `M1`, `M2`, names starting with `save`, `kill`, `shield`. 

