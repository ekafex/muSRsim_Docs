# musrSim ROOT Output Variables

musrSim writes its simulation output to a ROOT file, by default:

```text
data/musr_RUNNUMBER.root
````

The main event-by-event data are stored in the ROOT tree:

```text
t1
```

In addition, the ROOT file may contain run-level vectors/histograms such as `geantParametersD`,
`hGeantParameters`, and optional debugging histograms.


## 1. General conventions

### Default units

| Quantity          | Default unit     |
| ----------------- | ---------------- |
| Length / position | mm               |
| Time              | μs, sometimes ns |
| Energy            | MeV              |
| Momentum          | MeV/c            |
| Magnetic field    | tesla            |
| Electric field    | kV/mm            |
| Angle             | degree           |

### Undefined values

Values such as:

```text
-999
-1000
```

usually mean that the variable was not defined for that event.

Example: if `muTargetTime = -1000`, the muon did not enter the `Target`/`target` volume, so no target-entry time exists.

### Controlling ROOT output

Variables can be suppressed or enabled with:

```text
/musr/command rootOutput variableName off
/musr/command rootOutput variableName on
```

Notes:

* `save` volume variables are stored automatically if a `save...` volume is used.
* `nFieldNomVal` and `fieldNomVal[]` are controlled together with the keyword `fieldNomVal`.
* Field-integral variables are **off by default** and must be explicitly enabled.


# 2. Event identification and weighting

| Variable          |     Type | Meaning                                                                                                        |
| ----------------- | -------: | -------------------------------------------------------------------------------------------------------------- |
| `runID`           |    Int_t | Run number.                                                                                                    |
| `eventID`         |    Int_t | Event number.                                                                                                  |
| `timeToNextEvent` | Double_t | Time difference to the next event in a continuous beam facility, in μs. Generated from `/gun/meanarrivaltime`. |
| `weight`          | Double_t | Event weight. Used when event reweighting is enabled.                                                          |

Use `weight` when filling histograms if `/musr/command logicalVolumeToBeReweighted ...` was used.


# 3. Field at muon decay

| Variable           |     Type | Meaning                                                           |
| ------------------ | -------: | ----------------------------------------------------------------- |
| `BFieldAtDecay_Bx` | Double_t | Magnetic field x-component at muon decay position/time, in tesla. |
| `BFieldAtDecay_By` | Double_t | Magnetic field y-component at muon decay position/time, in tesla. |
| `BFieldAtDecay_Bz` | Double_t | Magnetic field z-component at muon decay position/time, in tesla. |
| `BFieldAtDecay_B3` | Double_t | Electric field x-component at muon decay position/time, in kV/mm. |
| `BFieldAtDecay_B4` | Double_t | Electric field y-component at muon decay position/time, in kV/mm. |
| `BFieldAtDecay_B5` | Double_t | Electric field z-component at muon decay position/time, in kV/mm. |

Despite the name `BFieldAtDecay`, the last three components correspond to the electric field.


# 4. Initial muon variables

These describe the generated primary muon.

| Variable                              |     Type | Meaning                                          |
| ------------------------------------- | -------: | ------------------------------------------------ |
| `muIniTime`                           | Double_t | Time when the initial muon was generated, in μs. |
| `muIniPosX`, `muIniPosY`, `muIniPosZ` | Double_t | Initial muon position, in mm.                    |
| `muIniMomX`, `muIniMomY`, `muIniMomZ` | Double_t | Initial muon momentum, in MeV/c.                 |
| `muIniPolX`, `muIniPolY`, `muIniPolZ` | Double_t | Initial muon polarization vector components.     |

These variables correspond to the muon after generation by `/gun/*` or TURTLE input.


# 5. Muon decay / stopping variables

| Variable                                    |     Type | Meaning                                                     |
| ------------------------------------------- | -------: | ----------------------------------------------------------- |
| `muDecayDetID`                              |    Int_t | ID number of the volume where the muon stopped and decayed. |
| `muDecayTime`                               | Double_t | Muon decay time, in μs.                                     |
| `muDecayPosX`, `muDecayPosY`, `muDecayPosZ` | Double_t | Muon stopping/decay position, in mm.                        |
| `muDecayPolX`, `muDecayPolY`, `muDecayPolZ` | Double_t | Muon polarization at stopping/decay.                        |

`muDecayDetID` uses the `idNumber` assigned in the `/musr/command construct ... idNumber` geometry command.


# 6. Target-entry variables

These variables are filled when the muon first enters a volume named `Target` or `target`.

| Variable                                       |     Type | Meaning                                              |
| ---------------------------------------------- | -------: | ---------------------------------------------------- |
| `muTargetTime`                                 | Double_t | Time when the muon entered the target/sample, in μs. |
| `muTargetPolX`, `muTargetPolY`, `muTargetPolZ` | Double_t | Muon polarization at target entry.                   |
| `muTargetMomX`, `muTargetMomY`, `muTargetMomZ` | Double_t | Muon momentum at target entry.                       |

The target is usually the sample. If the muon misses the target, these variables are undefined.


# 7. M0, M1, M2 muon-counter variables

These variables are filled when the muon first enters special volumes named `M0`, `M1`, or `M2`
(case-insensitive according to the manual examples).

## M0

| Variable                           |     Type | Meaning                                 |
| ---------------------------------- | -------: | --------------------------------------- |
| `muM0Time`                         | Double_t | Time when the muon entered `M0`, in μs. |
| `muM0PolX`, `muM0PolY`, `muM0PolZ` | Double_t | Muon polarization at entry into `M0`.   |

## M1

| Variable                           |     Type | Meaning                                 |
| ---------------------------------- | -------: | --------------------------------------- |
| `muM1Time`                         | Double_t | Time when the muon entered `M1`, in μs. |
| `muM1PolX`, `muM1PolY`, `muM1PolZ` | Double_t | Muon polarization at entry into `M1`.   |

## M2

| Variable                           |     Type | Meaning                                 |
| ---------------------------------- | -------: | --------------------------------------- |
| `muM2Time`                         | Double_t | Time when the muon entered `M2`, in μs. |
| `muM2PolX`, `muM2PolY`, `muM2PolZ` | Double_t | Muon polarization at entry into `M2`.   |

The manual notes that `muM0Time` is usually not the best quantity for timing analysis; use detector-hit timing such as `det_time_start[]` instead.


# 8. Decay positron initial momentum

| Variable                                 |     Type | Meaning                                           |
| ---------------------------------------- | -------: | ------------------------------------------------- |
| `posIniMomX`, `posIniMomY`, `posIniMomZ` | Double_t | Initial momentum of the decay positron, in MeV/c. |

These variables are useful for checking the emitted positron direction and energy after muon decay.

---

# 9. Nominal field values

| Variable                    |           Type | Meaning                                                                                 |
| --------------------------- | -------------: | --------------------------------------------------------------------------------------- |
| `nFieldNomVal`              |          Int_t | Number of elementary fields contributing to the global field.                           |
| `fieldNomVal[nFieldNomVal]` | Double_t array | Nominal values of the elementary fields. Usually constant, but may vary event by event. |

These variables are controlled together using:

```text
/musr/command rootOutput fieldNomVal off
/musr/command rootOutput fieldNomVal on
```


# 10. Field-integral variables

These variables are usually **not written by default**. They must be enabled explicitly.

| Variable      |     Type | Meaning                                        | Unit    |
| ------------- | -------: | ---------------------------------------------- | ------- |
| `BxIntegral`  | Double_t | Integral of `Bx` along the muon path.          | tesla·m |
| `ByIntegral`  | Double_t | Integral of `By` along the muon path.          | tesla·m |
| `BzIntegral`  | Double_t | Integral of `Bz` along the muon path.          | tesla·m |
| `BzIntegral1` | Double_t | Integral of `Bz dz` from initial z to decay z. | tesla·m |
| `BzIntegral2` | Double_t | Muon path length integral `∫ ds`.              | mm      |
| `BzIntegral3` | Double_t | Longitudinal distance integral `∫ dz`.         | mm      |

To enable, use commands such as:

```text
/musr/command rootOutput fieldIntegralBx on
/musr/command rootOutput fieldIntegralBy on
/musr/command rootOutput fieldIntegralBz on
```

For accurate field integrals, the manual recommends forcing small Geant4 step sizes, for example by setting a small `SetLargestAcceptableStep`.


# 11. Optical photon count

| Variable   |  Type | Meaning                                                 |
| ---------- | ----: | ------------------------------------------------------- |
| `nOptPhot` | Int_t | Total number of optical photons generated in the event. |

This is relevant only when optical photon simulation is enabled.


# 12. Detector-hit variables: `det_*`

Detector-hit variables describe energy deposits in sensitive volumes, usually scintillators defined with:

```text
sensitiveClass = musr/ScintSD
```

The number of detector hits in an event is:

| Variable |  Type | Meaning                               |
| -------- | ----: | ------------------------------------- |
| `det_n`  | Int_t | Number of detector hits in the event. |

A single event may contain several hits. The same detector may also appear more than once if separated hits occur.

## Basic detector-hit quantities

| Variable                                       |           Type | Meaning                                                                                                                                   |
| ---------------------------------------------- | -------------: | ----------------------------------------------------------------------------------------------------------------------------------------- |
| `det_ID[det_n]`                                |    Int_t array | ID number of the detector where the hit occurred.                                                                                         |
| `det_edep[det_n]`                              | Double_t array | Total deposited energy in the hit, in MeV.                                                                                                |
| `det_edep_el[det_n]`                           | Double_t array | Deposited energy due to electron-based interactions, in MeV.                                                                              |
| `det_edep_pos[det_n]`                          | Double_t array | Deposited energy due to positron-based interactions, in MeV.                                                                              |
| `det_edep_gam[det_n]`                          | Double_t array | Deposited energy due to photon/gamma-based interactions, in MeV.                                                                          |
| `det_edep_mup[det_n]`                          | Double_t array | Deposited energy due to muon-based interactions, in MeV.                                                                                  |
| `det_nsteps[det_n]`                            |    Int_t array | Number of Geant4 steps summed into this hit.                                                                                              |
| `det_length[det_n]`                            | Double_t array | Total trajectory length of particles contributing to the hit, in mm.                                                                      |
| `det_time_start[det_n]`                        | Double_t array | Time of the first energy deposit in the hit, in μs.                                                                                       |
| `det_time_end[det_n]`                          | Double_t array | Time of the last energy deposit in the hit, in μs.                                                                                        |
| `det_x[det_n]`, `det_y[det_n]`, `det_z[det_n]` | Double_t array | Coordinates of the first step of the hit, usually in mm.                                                                                  |
| `det_kine[det_n]`                              | Double_t array | Kinetic energy of the first particle contributing to the hit, in MeV. The manual warns that interpretation may require checking the code. |

Important note: hits are not necessarily sorted by detector ID. In the manual example, hits are ordered by deposited energy, so `det_time_start[0] - det_time_start[1]` can give both positive and negative time-of-flight peaks depending on which detector has the larger deposited energy.


# 13. Detector-hit vertex variables: `det_Vrtx*`

The `det_Vrtx*` variables describe the particle responsible for the first-in-time energy deposit belonging to the hit.

| Variable                                                   |           Type | Meaning                                                                                                                                         |
| ---------------------------------------------------------- | -------------: | ----------------------------------------------------------------------------------------------------------------------------------------------- |
| `det_VrtxKine[det_n]`                                      | Double_t array | Kinetic energy of the first particle belonging to the hit.                                                                                      |
| `det_VrtxX[det_n]`, `det_VrtxY[det_n]`, `det_VrtxZ[det_n]` | Double_t array | Vertex position where that particle was created, in mm.                                                                                         |
| `det_VrtxVolID[det_n]`                                     |    Int_t array | ID of the volume where the vertex was created.                                                                                                  |
| `det_VrtxProcID[det_n]`                                    |    Int_t array | ID of the physics process that created the vertex.                                                                                              |
| `det_VrtxTrackID[det_n]`                                   |    Int_t array | Track ID of the first particle contributing to the hit. If negative, more than one track contributed; the absolute value is the first track ID. |
| `det_VrtxParticleID[det_n]`                                |    Int_t array | Particle ID of the first particle contributing to the hit.                                                                                      |

Common particle IDs:

| Particle |   ID |
| -------- | ---: |
| μ⁺       |  -13 |
| μ⁻       |  +13 |
| electron |   11 |
| positron |  -11 |
| gamma    |   22 |
| proton   | 2212 |
| neutron  | 2112 |
| π⁻       | -211 |
| π⁺       |  211 |


# 14. Detector-hit ancestry variables: `det_Vvv*`

The `det_Vvv*` variables are similar to `det_Vrtx*`, but they try to identify the ancestor particle that entered or caused the hit from outside the sensitive volume.

If the first particle contributing to the hit was created inside the same logical volume where the hit occurred, musrSim follows its mother track backward until it finds a particle created outside that volume.

Purpose:

```text
det_Vrtx*  → first particle directly contributing to the hit
det_Vvv*   → likely outside ancestor that caused the hit
```

This is useful when secondary particles are created inside the detector and one wants to know what original particle caused the detector response.

The manual text is truncated/incomplete at this point, so for the exact full list of `det_Vvv*` branch names, check the ROOT tree with:

```cpp
t1->Print()
```

or inspect the musrSim source code.


# 15. Optical photon signal variables: `odet_*`

These variables are relevant when optical photon simulation and optical photon signal analysis are enabled.

The number of optical photon signals is:

| Variable |  Type | Meaning                                        |
| -------- | ----: | ---------------------------------------------- |
| `odet_n` | Int_t | Number of optical photon signals in the event. |

There may be several optical photon signals per detector. Ideally, `odet_n` may correspond to `det_n`, but the two are treated independently and do not have to match exactly.

| Variable                  |           Type | Meaning                                                                                                                  |
| ------------------------- | -------------: | ------------------------------------------------------------------------------------------------------------------------ |
| `odet_ID[odet_n]`         |    Int_t array | ID number of the detector where the optical photon signal occurred. Assigned to the volume into which the photon enters. |
| `odet_nPhot[odet_n]`      |    Int_t array | Number of detected photons in the optical photon signal.                                                                 |
| `odet_timeFirst[odet_n]`  | Double_t array | Time of the first detected photon.                                                                                       |
| `odet_timeSecond[odet_n]` | Double_t array | Time of the second detected photon.                                                                                      |
| `odet_timeThird[odet_n]`  | Double_t array | Time of the third detected photon.                                                                                       |
| `odet_timeLast[odet_n]`   | Double_t array | Time of the last detected photon.                                                                                        |
| `odet_timeA[odet_n]`      | Double_t array | Time when photon number `OPSA_fracA × odet_nPhot[i]` was detected.                                                       |
| `odet_timeB[odet_n]`      | Double_t array | Time when photon number `OPSA_fracB × odet_nPhot[i]` was detected.                                                       |
| `odet_timeC[odet_n]`      | Double_t array | Time when the signal shape crosses threshold `OPSA_C_threshold`.                                                         |
| `odet_timeD[odet_n]`      | Double_t array | Time when the normalized signal shape crosses threshold `OPSA_D_threshold`.                                              |
| `odet_timeCFD[odet_n]`    | Double_t array | Time determined by the constant fraction discriminator.                                                                  |
| `odet_timeMean[odet_n]`   | Double_t array | Mean arrival time of photons calculated from the OPSA histogram.                                                         |

The `OPSA_fracA`, `OPSA_fracB`, `OPSA_C_threshold`, and `OPSA_D_threshold` parameters are set through `/musr/command OPSA photonFractions`.


# 16. Save-volume variables: `save_*`

A `save` volume is any volume whose name starts with:

```text
save
```

These volumes are used to record particle position, momentum, polarization, and energy at selected locations, even if no energy is deposited there. Therefore, a `save` volume can be made of vacuum.

The number of save-volume crossings is:

| Variable |  Type | Meaning                                             |
| -------- | ----: | --------------------------------------------------- |
| `save_n` | Int_t | Number of `save` volumes hit/crossed in this event. |

| Variable                                                      |           Type | Meaning                                                |
| ------------------------------------------------------------- | -------------: | ------------------------------------------------------ |
| `save_detID[save_n]`                                          |    Int_t array | ID number of the save volume.                          |
| `save_particleID[save_n]`                                     |    Int_t array | Particle ID of the particle entering the save volume.  |
| `save_time[save_n]`                                           | Double_t array | Time when the particle entered the save volume, in μs. |
| `save_x[save_n]`, `save_y[save_n]`, `save_z[save_n]`          | Double_t array | Position at entry into the save volume, in mm.         |
| `save_px[save_n]`, `save_py[save_n]`, `save_pz[save_n]`       | Double_t array | Momentum at entry into the save volume, in MeV/c.      |
| `save_polx[save_n]`, `save_poly[save_n]`, `save_polz[save_n]` | Double_t array | Polarization at entry into the save volume.            |
| `save_ke[save_n]`                                             | Double_t array | Kinetic energy at entry into the save volume, in MeV.  |

Common particle IDs:

| Particle |   ID |
| -------- | ---: |
| μ⁺       |  -13 |
| μ⁻       |  +13 |
| electron |   11 |
| positron |  -11 |
| gamma    |   22 |
| proton   | 2212 |
| neutron  | 2112 |
| π⁻       | -211 |
| π⁺       |  211 |


# 17. Other ROOT objects in the file

Besides the event tree `t1`, musrSim stores additional ROOT objects.

| Object             | Meaning                                                                                                                                              |
| ------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------- |
| `t1`               | Main event-by-event ROOT tree.                                                                                                                       |
| `geantParametersD` | Vector containing run-level information such as run number and number of generated events.                                                           |
| `hGeantParameters` | Histogram containing similar run-level information to `geantParametersD`. Useful when merging ROOT files with `hadd`, because histograms are summed. |
| Other histograms   | Optional debugging histograms, usually not needed for normal analysis.                                                                               |


# 18. Minimal ROOT inspection commands

Open a musrSim output file:

```cpp
TFile* f = new TFile("data/musr_101.root");
f->ls();
t1->Print();
```

Draw deposited energy in detector ID 10:

```cpp
t1->Draw("det_edep", "det_ID==10");
```

Draw deposited energy in detector ID 11:

```cpp
t1->Draw("det_edep", "det_ID==11");
```

Draw time difference between the first two stored hits:

```cpp
t1->Draw("det_time_start[0]-det_time_start[1]");
```

Be careful: `det_time_start[0]` and `det_time_start[1]` do not necessarily correspond to fixed detector IDs unless you explicitly select or process the corresponding `det_ID[]`.


# 19. Practical interpretation guide

## Most important variables for basic μSR detector studies

| Goal                        | Useful variables                                        |
| --------------------------- | ------------------------------------------------------- |
| Initial beam check          | `muIniPos*`, `muIniMom*`, `muIniPol*`                   |
| Muon stopping distribution  | `muDecayPos*`, `muDecayDetID`                           |
| Muon decay time             | `muDecayTime`                                           |
| Muon polarization at decay  | `muDecayPol*`                                           |
| Sample entry                | `muTargetTime`, `muTargetMom*`, `muTargetPol*`          |
| Detector hit energy         | `det_ID[]`, `det_edep[]`                                |
| Detector hit timing         | `det_time_start[]`, `det_time_end[]`                    |
| Particle causing hit        | `det_VrtxParticleID[]`, `det_VrtxTrackID[]`, `det_Vvv*` |
| Optical photon timing       | `odet_timeFirst[]`, `odet_timeCFD[]`, `odet_timeMean[]` |
| Diagnostic particle monitor | `save_*`                                                |

## Most useful branch groups

| Branch group              | Use                                                           |
| ------------------------- | ------------------------------------------------------------- |
| `muIni*`                  | Generated muon state.                                         |
| `muDecay*`                | Muon stopping and decay state.                                |
| `muTarget*`               | Muon state at sample entry.                                   |
| `muM0*`, `muM1*`, `muM2*` | Muon crossing special trigger-like volumes.                   |
| `det_*`                   | Sensitive-detector energy deposits and timing.                |
| `det_Vrtx*`               | Particle directly responsible for the hit.                    |
| `det_Vvv*`                | Ancestor particle likely responsible for the hit.             |
| `odet_*`                  | Optical photon signal information.                            |
| `save_*`                  | Diagnostic crossing information in special `save...` volumes. |


# 20. Common warnings

1. `det_n` is the number of hits, not the number of detectors.
2. A detector may appear more than once in `det_ID[]`.
3. Hits may combine energy deposits from several particles.
4. `det_edep[]` is summed over Geant4 steps belonging to the hit.
5. `det_time_start[]` is usually the most useful detector timing variable.
6. `muM0Time` etc. are special muon-entry times, not necessarily experimental detector times.
7. `save_*` variables are diagnostic and are filled by crossing special `save...` volumes.
8. Undefined values such as `-999` or `-1000` mean the corresponding physical event did not happen or could not be assigned.
9. Field-integral variables are off by default.
10. Always inspect the actual ROOT tree with `t1->Print()` because exact branch naming may depend on the musrSim version.


