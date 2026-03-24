# COAL Project Group 6 - Assembly Language Ciphers

This repository contains the final project for the Computer Organization and Assembly Language (COAL) course by Group 6. The project is an interactive, menu-driven Assembly Language program that implements two distinct encryption/decryption techniques to secure text.

## Features

The program offers a command-line interface with the following options:

1. **Caesar Cipher**
   - **Encrypt:** Secures the input string by shifting characters based on a user-provided numeric key (1-25).
   - **Decrypt:** Reverses the shift using the matching key to retrieve the original text. It includes validation to prevent decryption with an incorrect key.
   
2. **ROT13 Hybrid Cipher**
   - **Encrypt:** Instead of a standard ROT13, this hybrid approach uses bitwise operations. It rotates the character bits left (`ROL`) by 3 positions and then applies an `XOR` operation with `13h` (19 in decimal).
   - **Decrypt:** Reverses the custom encryption logic by first applying the `XOR` operation with `13h` and then rotating bits right (`ROR`) by 3 positions.

## Repository Contents

- `COAL_Project_Group6.asm`: The main Assembly source code.
- `COAL_Project_Group6_Report.docx`: Comprehensive project report explaining the logic and design.
- `COAL_Project_Group6_ppt.pptx`: Presentation slides summarizing the project.
- `COAL_Project_Group6_Video.mp4`: A video demonstration showcasing the program's execution and features.

## Prerequisites

To assemble and run this program, you will need a 16-bit DOS environment. You can achieve this using an emulator like **DOSBox**. You will also need an assembler such as **MASM** (Microsoft Macro Assembler) or **TASM** (Turbo Assembler).

## How to Run

1. Open DOSBox and mount the directory containing your assembler and this project's files.
2. Navigate to the project directory.
3. Assemble the source code:
   - **Using MASM:**
     ```cmd
     masm COAL_Project_Group6.asm;
     link COAL_Project_Group6.obj;
     ```
   - **Using TASM:**
     ```cmd
     tasm COAL_Project_Group6.asm
     tlink COAL_Project_Group6.obj
     ```
4. Run the generated executable:
   ```cmd
   COAL_Project_Group6.exe
   ```
5. Follow the on-screen menu instructions to encrypt or decrypt your text.
