# Circular-FIFO-Buffer
A parameterized synchronous FIFO buffer in Verilog with support for almost full/empty flags and overflow/underflow detection, along with a testbench for simulation.
# Synchronous FIFO Buffer in Verilog

##  Overview
This project implements a parameterized synchronous FIFO (First-In-First-Out) buffer in Verilog, designed for digital systems requiring reliable data buffering between producer and consumer modules. A testbench is also included to simulate and verify the FIFO behavior.

##  Features
- Configurable `DATA_WIDTH` and `DEPTH`
- `full` and `empty` status flags
- `almost_full` and `almost_empty` threshold indicators
- Overflow and underflow error detection
- Clean and modular design
- Ready-to-run Verilog testbench

##  Files
- `fifo.v` – Main FIFO module
- `fifo_tb.v` – Testbench for simulation

##  Parameters
| Parameter            | Description                               | Default |
|---------------------|-------------------------------------------|---------|
| `DATA_WIDTH`        | Width of each data word                   | 16      |
| `DEPTH`             | Number of entries in the FIFO             | 64      |
| `ALMOST_FULL_THRESH`| Threshold for `almost_full` signal        | 56      |
