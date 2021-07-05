# IT_Junior_task01

This Docker image was created as a test task by Vasily Borodin. 

### Programs

The image contains the following programs:

 - biobambam2 suite, containing tools for processing BAM files including
 - samtools suite for interacting with high-throughput sequencing data, along with HTSlib library
 - libdeflate, a heavily optimised library for fast compression and decompression

### Commands

Building:
`docker build -t ITJtask`

Running interactively:
`docker run -it ITJtask`

Running interactively from root user:
`docker run -u 0 -it ITJtask`
