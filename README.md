# Design and Analysis of a Dual-Band Microstrip Patch Antenna for 2.4/5 GHz

![MATLAB](https://img.shields.io/badge/MATLAB-R2024b-orange)
![Antenna Toolbox](https://img.shields.io/badge/MATLAB-Antenna%20Toolbox-blue)
![Status](https://img.shields.io/badge/Status-In%20Progress-yellow)
![Domain](https://img.shields.io/badge/Domain-RF%20%7C%20Microwave%20%7C%20Antenna%20Design-green)

## 📌 Project Overview

This project focuses on the **design, simulation, optimization, and performance analysis of a dual-band microstrip patch antenna operating at 2.4 GHz and 5 GHz** using MATLAB and the Antenna Toolbox.

The antenna is designed using an **E-notched microstrip patch structure** to obtain two operating bands from a single compact antenna geometry.

The project investigates antenna parameters such as:

- Resonant frequency
- Return loss (S11)
- VSWR
- Input impedance
- Bandwidth
- Radiation pattern
- Gain
- Directivity
- Radiation efficiency

The complete design process is performed computationally in MATLAB, including antenna modeling, parameter optimization, electromagnetic analysis, and performance evaluation.

---

## 🎯 Objectives

The main objectives of this project are:

1. Design a microstrip patch antenna for the 2.4 GHz frequency band.
2. Introduce an E-notched structure to obtain dual-band operation.
3. Obtain a second resonance near 5 GHz.
4. Optimize the feed position for improved impedance matching.
5. Optimize the notch dimensions for dual-band operation.
6. Analyze S11 and VSWR over the required frequency range.
7. Calculate input impedance at the target frequencies.
8. Analyze radiation characteristics at 2.4 GHz and 5 GHz.
9. Determine gain, directivity, and radiation efficiency.
10. Develop a complete MATLAB-based antenna simulation workflow.

---

## 📡 Target Specifications

| Parameter | Specification |
|---|---|
| Lower operating frequency | 2.4 GHz |
| Upper operating frequency | 5.0 GHz |
| Antenna type | Microstrip Patch Antenna |
| Structure | E-Notched Patch |
| Substrate | FR-4 |
| Relative permittivity | 4.3 |
| Substrate thickness | 1.6 mm |
| Loss tangent | 0.02 |
| Reference impedance | 50 Ω |
| Initial ground size | 50 × 50 mm |
| Simulation software | MATLAB R2024b |
| Toolbox | Antenna Toolbox |

---

## 🧠 Design Methodology

The project follows a systematic antenna-design procedure.

```text
Design Requirements
        ↓
Substrate Selection
        ↓
Patch Dimension Calculation
        ↓
Initial Patch Design
        ↓
Initial S11 Analysis
        ↓
Feed Position Optimization
        ↓
E-Notch Dual-Band Structure
        ↓
2.4 GHz Optimization
        ↓
5 GHz Optimization
        ↓
Simultaneous Dual-Band Optimization
        ↓
S11 / VSWR / Impedance Analysis
        ↓
Radiation Pattern Analysis
        ↓
Gain / Directivity / Efficiency
        ↓
Final MATLAB Simulation
