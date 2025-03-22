# Tiny Encryption Algorithm (TEA) in Verilog

This repository contains the implementation of the Tiny Encryption Algorithm (TEA) as part of the "Hardware and Embedded Security" course at the University of Pisa for the academic year 2023/2024. The project was developed by **Nicola Lepore** and **Francesco Copelli** during the Master’s program in Cybersecurity.

---

## Overview

The Tiny Encryption Algorithm (TEA) is a lightweight block cipher designed to encrypt 64-bit data blocks using a 128-bit key. This project features:

- **High-Level Modeling:** An abstract model to validate the algorithm’s logic before hardware implementation.
- **RTL Design:** A modular Verilog implementation featuring a pipelined single-iteration round (`tea_round` module), with clear separation of submodules (upper and lower rounds) and control via a Finite-State Machine (FSM).
- **Functional Verification:** Comprehensive SystemVerilog testbenches and Python scripts for generating test vectors, ensuring accurate encryption results.
- **FPGA Implementation:** Synthesis and implementation on a Cyclone V FPGA (device 5CGXFC9D6F27C7) with detailed performance metrics (latency and throughput) and minimal resource utilization.

---

## Project Structure

```
├── docs/                # Detailed project documentation and analysis (PDF, figures, reports)
├── rtl/                 # Verilog source files for the TEA encryption engine and submodules
├── tb/                  # SystemVerilog testbenches for functional verification (ModelSim compatible)
├── scripts/             # Python scripts for generating test vectors and validating encryption results
├── fpga/                # FPGA synthesis files and Quartus Prime project files
└── README.md            # This file
```

---

## Features

- **Efficient Encryption:** Implements 32 rounds of TEA using a straightforward Feistel structure.
- **Modular Design:** Clean separation of logic into submodules (upper_round, lower_round) with a dedicated FSM for control.
- **Robust Verification:** Includes both simulation testbenches and Python-based test vector generation for functional verification.
- **FPGA Ready:** Successfully synthesized on Cyclone V FPGA with excellent resource utilization and verified performance metrics:
  - **Latency:** ~420 ns per encryption operation
  - **Throughput:** ~152 Mbps

---

## Getting Started

### Prerequisites

- **Verilog Simulation:** ModelSim (or any compatible Verilog simulator)
- **FPGA Synthesis:** Intel Quartus Prime (Version 23.1 or later recommended)
- **Python:** Python 3.x (for test vector generation and verification)
- **Hardware:** Cyclone V FPGA (optional, for hardware deployment)

### Running Simulations

1. Navigate to the `tb/` directory.
2. Compile and run the testbench using ModelSim:
   ```bash
   vsim -c -do "run -all; quit" tb_tea_functional
   ```

### FPGA Synthesis

1. Open the Quartus Prime project located in the `fpga/` directory.
2. Compile the design and review the resource utilization and timing reports.
3. Program the Cyclone V FPGA with the generated bitstream.

---

## Functional Verification

The project includes:
- **SystemVerilog Testbenches:** For validating encryption functionality under various scenarios.
- **Python Scripts:** To generate random plaintexts, keys, and expected ciphertexts, ensuring consistent functional behavior.
- Detailed documentation of verification procedures and results can be found in the `docs/` folder.

---

## FPGA Implementation Results

- **Latency:** Approximately 420 ns per encryption cycle.
- **Throughput:** Approximately 152 Mbps.
- **Resource Utilization:** Minimal usage of FPGA resources, with negligible block memory and DSP blocks consumed.

---

## License

This project is licensed under the [MIT License](LICENSE).

---

## Acknowledgements

- **University of Pisa** for the academic framework and support.
- **Hardware and Embedded Security Course** instructors and peers for their invaluable guidance.
- Special thanks to **Nicola Lepore** and **Francesco Copelli** for their contributions to the project.
