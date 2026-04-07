# Hardware Design and Implementation of a 3×3 GEMM Accelerator in Verilog

## 📌 Overview

This project presents the hardware design and FPGA implementation of a **3×3 General Matrix-Matrix Multiplication (GEMM) accelerator** using Verilog. The design leverages **Block RAM (BRAM)** for efficient storage and utilizes a **Finite State Machine (FSM)** to control the computation flow.

The system performs matrix multiplication using a **workload-based approach**, where rows and columns are fetched from memory, multiplied element-wise, and accumulated to produce the final output.

---

## 🧠 Architecture Description

* Two separate **BRAMs** are used:

  * **BRAM A** → stores rows of Matrix A
  * **BRAM B** → stores columns of Matrix B

* Each BRAM depth stores:

  * One full row (Matrix A)
  * One full column (Matrix B)

* Computation Flow:

  1. Read one row from BRAM A
  2. Read one column from BRAM B
  3. Perform **element-wise multiplication**
  4. Accumulate results using MAC operations
  5. Store result in output BRAM (Matrix C)

---

## ⚙️ Key Features

* Verilog-based RTL design
* Efficient **BRAM-based memory architecture**
* FSM-controlled computation
* Parallel multiply-accumulate operations
* Output storage in on-chip memory
* Debug and verification using **ILA (Integrated Logic Analyzer)**

---

## 🔄 FSM Control Flow

The design is controlled using a Finite State Machine with the following states:

* `IDLE` → Wait for start signal
* `DELAY` → BRAM access delay handling
* `READ_A` → Load row from BRAM A
* `READ_B_MATRIX_MULT` → Load column & perform multiplication
* `INCREMENT_ADDR_B` → Move across columns
* `INCREMENT_ADDR_A` → Move across rows
* `DONE` → Computation complete

---

## 🧮 Computation Method

For each output element:

* Perform:

  * Element-wise multiplication of row and column vectors
  * Accumulate partial results

* Example:

```text
C[i][j] = A[i][0]*B[0][j] + A[i][1]*B[1][j] + A[i][2]*B[2][j] + A[i][3]*B[3][j]
```

---

## 🛠️ Tools & Platform

* **Xilinx Vivado** → Design & synthesis
* **ILA (Integrated Logic Analyzer)** → Output verification
* FPGA with BRAM support

---

## 🧩 Block Diagram (Processing Logic)
<img width="1643" height="886" alt="pl" src="https://github.com/user-attachments/assets/a4077ba4-e616-416b-b50b-7361cd521bfa" />


---

## 📊 Results (ILA Output)

<img width="1700" height="2200" alt="Image" src="https://github.com/user-attachments/assets/cac75c7f-83a8-4819-8e0c-138fc255e545" />


<img width="1700" height="2200" alt="Image" src="https://github.com/user-attachments/assets/f995c5ef-0462-4b5c-aeeb-8b63c0851e5d" />


## 📌 Conclusion

* Efficient implementation of GEMM using hardware parallelism
* BRAM-based design reduces memory bottlenecks
* FSM ensures structured and scalable computation
---

