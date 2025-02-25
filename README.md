# cuprj-cli
Caravel User's Project CLI

## Introduction
This repository contains a Python CLI tool for generating Verilog code for a Wishbone system to be used as a user's project for the Caravel chip. The tool uses a YAML file to define the wishbone bus slaves, and it cross-references these with an IP library provided as a JSON file (by default fetched from GitHub). The generated Verilog code includes a bus splitter, external interface connections, IRQ assignments, and a top-level wrapper module.

## Features

- **Generate Verilog Code**: Process a bus configuration YAML file and an IP library JSON file to generate a complete Verilog module for a Wishbone bus.
- **List Slave Types**: Display a list of all available slave types in the IP library.
- **Display IP Information**: Show key details about a specific slave type, including cell count, interrupt support, FIFO usage, and external interfaces. Optionally display the full description with the `--full` flag.
- **Robust Error Handling**: Provides clear error messages and logging to help troubleshoot issues with input files.
- **CLI Commands**: Supports the `generate`, `list`, `info`, and `help` commands.

## Installation

Ensure you have Python 3.9 or later installed. Install the required Python packages using pip:

```bash
pip install pyyaml
```
## CLI Commands

### generate
Generates the Wishbone bus Verilog code using the provided YAML file that describes the peripherals attached to the wishbone bus and the IP library JSON. ALso, this command generates a C header file containing the base addresses for the bus peripherals. The Verilog and Header files are named after the YAML file.

Usage:

```bash
python your_script.py generate <bus_yaml_file> [ip_library_json]
```

- bus_yaml_file: Path to the YAML file defining bus slaves.
- ip_library_json: (Optional) Path or URL to the IP library JSON file. If not provided, the default GitHub URL is used.

### list
Lists all slave types available in the IP library.

Usage:

```bash
python your_script.py list [ip_library_json]
```
- ip_library_json: (Optional) Path or URL to the IP library JSON file. If not provided, the default GitHub URL is used.
### info
Displays basic information about a specified slave type from the IP library. By default, it shows the cell count, whether interrupts are supported, FIFO usage, and external interfaces. Use the --full switch to include the full description.

Usage:

```bash
python your_script.py info <slave_type> [ip_library_json] [--full]
```
- slave_type: The IP name of the slave type.
- ip_library_json: (Optional) Path or URL to the IP library JSON file. If not provided, the default GitHub URL is used.
- `--full`: (Optional) Include the full description of the slave type.

### help
Displays the help message with details of all available commands.

Usage:
```bash
python your_script.py help
```

## Bus YAML File Format

This document describes the structure and content of the YAML file used to define the bus configuration for the Wishbone Bus Generator CLI. The YAML file specifies the list of bus slaves that are attached to the bus. Each slave entry contains key parameters that determine how the slave is connected to the bus, such as its type, base address, I/O pin mappings for external interfaces, and an optional IRQ assignment.

The YAML file should have two top-level keys
- `PIC`: Which indicates whether a second-level Interrupt controller (PIC) should be utilized or not. If set to true up to 10 IRQ lines are available. The first 2 are mapped to the first `user_irq` two lines and the last 8 are mapperd to `user_irq[2]`.
- `slaves`: which contains a list of slave definitions

### YAML Example 1
A user's project with three slaves. For each slave it gives the type, the base address, the IRQ line if any and how the slave is connected to the the I/Os (I/O number, 0-37). If a slave needs a bi-directional I/O, connect the the in, out and oe to the same I/O. If the slave connects to an array of I/Os, just specify the first I/O number.
```yaml
PIC: false
slaves:
  - name: UART0
    type: EF_UART
    base_address: "32'h30000000"
    io_pins:
      rx: 12
      tx: 13
    irq: 0
  - name: UART1
    type: EF_UART
    base_address: "32'h30010000"
    io_pins:
      rx: 14
      tx: 15
    irq: 1
  - name: PORTA
    type: EF_GPIO8
    base_address: "32'h30020000"
    io_pins:
      io_in: 14
      io_out: 14
      io_oe: 14
    irq: 2
```

### YAML Example 2
In this example, the second-level PIC is enabled to use more IRQ lines beyond 3. For this scenario, you need to add the PIC as a slave. 
```yaml
PIC: true
slaves:
  - name: PIC
    type: wb_pic_8
    base_address: "32'h300F0000"
  - name: UART0
    type: EF_UART
    base_address: "32'h30000000"
    io_pins:
      rx: 12
      tx: 13
    irq: 0
  - name: UART1
    type: EF_UART
    base_address: "32'h30010000"
    io_pins:
      rx: 14
      tx: 15
    irq: 3
  - name: UART2
    type: EF_UART
    base_address: "32'h30020000"
    io_pins:
      rx: 16
      tx: 17
    irq: 5
```

## Disclaimer
This project was developed with the help of ChatGPT o3-mini-high model.