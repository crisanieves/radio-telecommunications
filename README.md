# Radio Telecommunications Engineering

App for understanding the theoretical and mathematical intricacies of radio telecommunications engineering. Perform the necessary calculations to **design broadcasting, microwave, and satellite systems** efficiently and intuitively, using a user-friendly and elegant interface.

**eRadio** is an engineering calculation tool designed for telecommunications professionals, students, and researchers. It enables the design, sizing, and analysis of broadcasting systems, point-to-point microwave radio links, and geostationary satellite links.

## Core Features & Modules

### 1. Sistema de Radiodifusión (RADIO)
- **Carrier Frequencies**: Low Shift Frequency (LSF) calculation for Video Carrier (PV = LSF + 1.25 MHz), Color Subcarrier (PC = LSF + 4.83 MHz), and Audio Carrier (PA = LSF + 5.75 MHz).
- **Free Space Path Loss (αEL)**: Path attenuation calculations based on distance and operating frequency.
- **Transmission Line Loss (αCable)**: Total attenuation across coaxial transmission lines including cable length and datasheet attenuation per 100 meters.
- **Distribution Losses (αD)**: Power splitting losses computed as `10 * log10(nTx / nCaras)`.
- **System Gain & Required Panels (N)**: Power level conversions (W to dBm), furthest reception site field strength (PRC), and required panel antenna count calculation (`10^((sGANTX - gantx)/10)`).

### 2. Enlace de Microondas (μONDAS)
- **Link Geometry & Line-of-Sight**: Station heights (masl) and tower heights with radio horizon permittivity evaluation.
- **Barnett-Vigants Fade Margin (FM)**: Climatic factor (B) and topographic factor (A) parameterization for desired link availability (reliability $R \ge 99.9\%$).
- **Thermal Noise & Receiver Threshold (Cmin)**: Boltzmann constant thermal noise floor computation with noise bandwidth and carrier-to-noise ratio ($C/N$).
- **System Gain & Minimum Transmit Power (PTX)**: Exact minimum transmitter power requirement in both dBm and Watts.

### 3. Enlace Satelital (SATÉLITE)
- **Geostationary Orbital Geometry**: Calculation of azimuth, elevation angle, and true slant distance $d$ to the satellite.
- **Coordinate Conversion**: Conversion from Degrees, Minutes, Seconds to decimal format with North/South and East/West hemispheric adjustment.
- **Uplink/Downlink Free Space Losses (LFS)**: High-precision spherical geometry path loss calculations across C-band and Ku-band satellite channels.

## Technical Details

- **Platform & Language**: Android (Kotlin)
- **UI Toolkit**: Jetpack Compose (Material Design 3)
- **Architecture**: MVVM with Clean Math Engine Separation (`RadioMathEngine`)
- **Tooltips & Guidance**: Long-press / tap on any parameter field for engineering hints and unit guidance

---

## 👤 About

Application designed and developed by:

**Cristian Calderón Nieves** — Electronics Engineer.

Electronic hardware systems, radiofrequency and microwave design, embedded architectures, and high-performance mobile engineering applications.

---

## 📜 License 

This project is not a free software at this moment. © 2026 Microcore/Volta Corporation. All rights reserved.