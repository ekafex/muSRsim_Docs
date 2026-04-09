# List of muSR category commnads

1. **Geometry / Detector Construction**

   * volumes, materials, rotations, regions
   * (`/musr/command construct`, `rotation`, `arrayDef`, `region`) 

2. **Fields (Electric & Magnetic)**

   * uniform, mapped, quadrupoles, field parameters
   * (`/musr/command globalfield ...`) 

3. **Physics Processes**

   * particle processes, custom μSR processes
   * (`/musr/command process ...`) 

4. **Primary Beam / Source Definition**

   * particle type, vertex, momentum, polarization, TURTLE, GPS
   * (`/gun/*`, `/gps/*`) 

5. **Optical Photon Simulation (optional)**

   * materials, surfaces, photon tracking, OPSA
   * (`G4OpticalPhotons`, material tables, OPSA) 

6. **Run Control & Simulation Parameters**

   * number of events, runtime limits, filters, killing particles
   * (`/run/beamOn`, `/musr/command ...`) 

7. **Output Configuration (ROOT)**

   * output directory, variable selection, weighting
   * (`/musr/command rootOutput ...`) 

8. **Analysis-related / Derived Quantities**

   * field integrals, detector hit structure, saved variables
   * (ROOT tree definitions) 


