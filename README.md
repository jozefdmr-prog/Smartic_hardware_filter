# Smartic_hardware_filter
My frist project SystemVerilog implementation of a SmartNIC pipeline and FIFO buffer.
*************************************************************************************
High-Throughput SmartNIC Data Filter & FIFO Buffer

An efficient, pipelining-based network packet processing core implemented in SystemVerilog. Designed for high-frequency trading (HFT) accelerators and smart network interface cards (SmartNICs).

 Key Features
***3-Stage Hardware Pipeline: Enables processing of network data packets at clock speeds up to 100MHz+ with single-cycle throughput.
***AXI-Stream Inspired Protocol: Implements robust handshaking (`valid`/`ready` signals) to match industry standards.
***FIFO Buffer with Backpressure: Built-in 4-slot ring-buffer queue to prevent packet drops when the host CPU/PCIe bus is busy.
***100% Synthesizable & Verified: Includes a comprehensive SystemVerilog testbench (`smartnic_vstupny_filter_tb.sv`) for waveform simulation.

 Architecture Overview

The design follows a modular, hierarchical architecture structured within a single Top Module (`smartnic_top`):

[Raw Network Data] ──> [ 1. Filter Pipeline ] ──(Internal AXI-Stream)──> [ 2. FIFO Buffer ] ──> [ Output to PC / PCIe ]

1. ***Filter Pipeline: Filters out invalid packets (e.g., zero-payload blocks) and performs a single-cycle hardware data transformation.
2. ***FIFO Buffer: A synchronous First-In, First-Out queue that absorbs data bursts and manages flow control using a `full` / `empty` flag logic.

 Repository Structure
* `/rtl/smartnic_vstupny_filter.sv` - Hardware pipeline architecture.
* `/rtl/smartnic_fifo_buffer.sv` - Synchronous FIFO queue buffer.
* `/rtl/smartnic_top.sv` - Top-level module interconnecting the pipeline and buffer.
* `/bench/smartnic_vstupny_filter_tb.sv` - Verification testbench simulating real-time network bursts.

 Verification & Simulation Results

The core was fully verified using an industry-standard RTL simulator. The testbench simulates a network burst followed by a host-CPU read delay to test the backpressure mechanism.

 Observed behavior:
***Pipeline Latency: 3 clock cycles for the first processed packet to emerge.
***Throughput: Once the pipeline is filled, the core successfully processes 1 byte of data per clock cycle.
***Buffer Safety: When `pcie_ready` drops to 0, the internal FIFO safely stores up to 4 elements before raising the `alarm_preplnenia` flag.

 How to Run

1. Load the files into your favorite simulator (ModelSim, Vivado, or EDA Playgrounds).
2. Run `smartnic_vstupny_filter_tb` to view the digital waveform.
