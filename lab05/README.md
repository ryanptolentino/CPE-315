[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-24ddc0f5d75046c5622901739e7c5dd533143b0c8e959d652212380cedb1ea36.svg)](https://classroom.github.com/a/WKvQuoB3)
# cpe315-lab5
Cache Optimization

## Modify this README.md file to include your names and GitHub info

Jonathan Flores & Ryan Tolentino

To run 

make
./mm 
./mm-col
./mm-unrolled
./mm-col-unrolled



######You may work in pairs on this assignment.
###Purpose
To optimize data cache accesses for the matrix multiply application.

###Measurements
You can measure the number of cache misses and cache references using:
    perf stat -e cache-misses -e cache-references ./mm > myout



