# Amazon EC2
- EC2 is one of the most popular of AWS offering

- EC2 = Elastic Compute Cloud = Infrastructure as a Service

- It mainly consists in the capability of:

    - Renting virtual machines (EC2)
    - Storing data on virtual drives (EBS)
    - Distributing load across machines (ELB)

    - Scaling the services using an auto-scaling group (ASG).

# EC2 Sizing & configuration options

- Operating System (OS): Linux, MacOs, Window

- How much compute power & cores (CPU)

- How much random-access memory (RAM)

- How much storage space:
    - Network-attached (EBS & EFS)

    - Hardware (EC2 Instance Store)

- Network card: speed of the card, Public IP Address

- Firewall rules: security group

- Bootstrap script (configure at first launch): EC2 User Data

## EC2 User Data

- It is possible to bootstrap our instances using an EC2 User data script.
- Bootstrapping means launching commands when a machine starts
- That script is only run once at the instance first start

- EC2 user data is used to automate boot tasks such as:

    - Installing updates

    - Installing software

    - Downloading common files from the internet

    - Anything you can think of

- The EC2 User Data Script runs with the root user

