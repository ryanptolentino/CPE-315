[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-24ddc0f5d75046c5622901739e7c5dd533143b0c8e959d652212380cedb1ea36.svg)](https://classroom.github.com/a/03ccHBig)
# cpe315-lab6
Parallelization

## Modify this README.md file to include your names and GitHub info

Jonathan Flores & Ryan Tolentino

######You may work in pairs on this assignment.
###Purpose
To measure performance impacts from parallelization techniques

###To Build
make
./mm-simd
./mm-omp

This creates two binaries: mm-omp and mm-simd

###Measurements
You can measure the runtime using:
    perf stat ./mm-omp > myout1
    perf stat ./mm-simd > myout2



