# Assembly Temperature Projects

## Overview

This repository contains two x86 Assembly language projects developed for **CS271 (Computer Architecture and Assembly Language)**. Both programs utilize the **Irvine32 library** and demonstrate file handling, string manipulation, and array processing in Assembly.

***

## Files Included

### **1. Proj5_landryza.asm**

**Title:** Chaotic Temperature Statistics  
**Description:**  
Generates random temperature readings for a specified number of days and readings per day. It calculates daily highs and lows, computes average high and low temperatures, and displays all results in a structured format.

**Key Features:**

*   Random temperature generation within a defined range.
*   Calculation of daily high and low temperatures.
*   Calculation of average high and low across all days.
*   Displays temperature arrays and summary statistics.

**Constants:**

*   `DAYS_MEASURED` – Number of days to simulate.
*   `TEMPS_PER_DAY` – Number of readings per day.
*   `MIN_TEMP` and `MAX_TEMP` – Temperature range.

***

### **2. Proj6_landryza.asm**

**Title:** Temperature Error Corrector  
**Description:**  
Reads a file containing a comma-delimited list of temperatures, reverses their order, and prints the corrected sequence.

**Key Features:**

*   File input and validation.
*   Parsing ASCII-formatted temperature values into an integer array.
*   Displays temperatures in reverse order.

**Constants:**

*   `TEMPS_PER_DAY` – Number of temperatures expected.
*   `DELIMITER` – Character used to separate values (`,`).
*   `MAX_FILE_SIZE` – Maximum size of input file.

***

## Requirements

*   **Assembler:** MASM (Microsoft Macro Assembler)
*   **Library:** Irvine32.inc
*   **Platform:** Windows (32-bit environment)

***

## How to Run

1.  Ensure MASM and Irvine32 library are installed and configured.
2.  Assemble and link the desired `.asm` file:
    ```bash
    ml /c /coff Proj5_landryza.asm
    link /subsystem:console Proj5_landryza.obj Irvine32.lib
    ```
3.  Run the executable:
    ```bash
    Proj5_landryza.exe
    ```
4.  For **Proj6**, place the input file in the same directory as the executable and follow the on-screen prompts.

***

## Author

**Zachary Landry**  
CS271 Section 400  
Oregon State University
