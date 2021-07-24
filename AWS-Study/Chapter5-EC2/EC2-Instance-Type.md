# EC2 Instance Types

- You can use different types of EC2 instances that are optimised for different use cases

- AWS has the following naming convention:

    - Example: m5.2xlarge

        - m: instance class

        - 5: generation (AWS improves them over time)

        - 2xlarge: size within the instance class 

- Check info: ec2instances.info

## General Purpose (T class)

- Great for a diversity of workloads such as web servers or code repositories

- Balance between:

    - Compute
    - Memory
    - Networking

## Compute Optimized (C class)

- Great for compute-intensive tasks that require high performance processors:

    - Batch processing workloads

    - Media transcoding

    - High performance webservers

    - High performance computing (HPC)

    - Scientific modeling & machine learning 

    - Dedicated gaming servers


## Memory Optimized (R, X, High Memory, z1 class)

- Fast performance for workloads that process large data sets in memory

- Use cases:

    - High performance, relational/non-relational databases

    - Distributed web scale cache stores

    - In-memory databases optimized for BI (business intelligence)

    - Applications performing real-time processing of big unstructured data



## Storage Optimized (I, D, H)

- Greate for storage-intensive tasks that require high, sequential read and write access to large data sets on local storage

- Use cases:

    - High frequency online transaction processing (OLTP) systems

    - Relational & NoSQL databases

    - Cache for in-memory databases (for example: Redis)

    - Data warehousing applications

    - Distributed file systems



