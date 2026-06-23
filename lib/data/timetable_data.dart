import 'package:flutter/material.dart';

// ─── Data Models & Content for all 3 Timetables ───────────────────────────

class ScheduleRow {
  final String time;
  final String topic;
  final String activity;
  final bool isBreak;
  const ScheduleRow(this.time, this.topic, this.activity,
      {this.isBreak = false});
}

class QAItem {
  final String question;
  final String answer;
  const QAItem(this.question, this.answer);
}

class DayData {
  final int dayNumber;
  final String title;
  final String subtitle;
  final List<String> tags;
  final List<ScheduleRow> schedule;
  final List<String> covered;
  final String? explanation;
  final String? imageAsset;
  final List<QAItem> qa;
  const DayData({
    required this.dayNumber,
    required this.title,
    required this.subtitle,
    required this.tags,
    required this.schedule,
    required this.covered,
    this.explanation,
    this.imageAsset,
    required this.qa,
  });
}

class TimetableData {
  final String id;
  final String label;
  final String emoji;
  final String subtitle;
  final List<DayData> days;
  const TimetableData({
    required this.id,
    required this.label,
    required this.emoji,
    required this.subtitle,
    required this.days,
  });
}

// ══════════════════════════════════════════════════
//  DEVOPS
// ══════════════════════════════════════════════════
const devopsData = TimetableData(
  id: 'devops',
  label: 'DevOps',
  emoji: '🛠️',
  subtitle: 'Linux · Git · CI/CD · Docker · Kubernetes · Terraform',
  days: [
    DayData(
      dayNumber: 1,
      title: 'DevOps Fundamentals & Linux',
      subtitle: 'DevOps culture, Linux CLI, Shell scripting',
      tags: ['DevOps', 'Linux', 'Shell'],
      explanation: '''
# DevOps Fundamentals & Linux

## 1. What is DevOps?
DevOps is a culture and methodology that bridges the gap between software development (Dev) and IT operations (Ops). By prioritizing communication, automation, and continuous delivery, DevOps teams deploy software faster and more reliably.

## 2. Linux Commands
Most servers and containers run on Linux. Mastering the command line interface (CLI) with tools like `ls`, `cd`, `grep`, and `chmod` is critical for navigating file systems and managing user permissions without a graphical interface.

## 3. Shell Scripting Basics
Shell scripting allows you to write a sequence of Linux commands into a single file (like `script.sh`). This automates repetitive tasks, turning a 50-step manual setup into a single command execution.

## 4. SSH & Cron Jobs
**SSH (Secure Shell)** is a protocol used to securely connect to remote servers over the internet. **Cron jobs** are time-based schedulers in Linux used to run your shell scripts automatically at specific intervals (e.g., every day at midnight).

## Real-World Example
A system administrator uses **SSH** to log into a remote **Linux** server. Instead of manually backing up the database every night, they write a **Shell Script** to do it, and schedule it using a **Cron Job** to execute automatically at 2 AM. This embodies the **DevOps** culture of automation.
''',
      imageAsset: 'assets/images/devops_concept.png',
      schedule: [
        ScheduleRow('9:00 – 10:30', 'What is DevOps?', '📖 Read'),
        ScheduleRow('10:30 – 12:00', 'Linux Commands', '💻 Practice'),
        ScheduleRow('12:00 – 13:00', '🍽️ Lunch Break', '—', isBreak: true),
        ScheduleRow('13:00 – 15:00', 'Shell scripting basics', '✍️ Write scripts'),
        ScheduleRow('15:00 – 17:00', 'SSH & cron jobs', '🔬 Hands-on'),
        ScheduleRow('17:00 – 18:00', 'Revision', '📝 Summarize'),
      ],
      covered: ['Culture', 'Linux CLI', 'Bash', 'Cron'],
      qa: [
        QAItem('What is DevOps?', 'A culture combining Development and Operations to automate and speed up software delivery.'),
        QAItem('How to list hidden files in Linux?', 'Use `ls -a` or `ls -la`.'),
        QAItem('What does chmod 755 mean?', 'Owner can read/write/execute. Others can only read/execute.'),
        QAItem('What is a cron job?', 'A time-based job scheduler in Linux used to run scripts automatically.'),
      ],
    ),
    DayData(
      dayNumber: 2,
      title: 'Version Control (Git/GitHub)',
      subtitle: 'Branching, PRs, GitFlow',
      tags: ['Git', 'GitHub'],
      explanation: '''
# Version Control with Git & GitHub

## 1. Git Basics (Commit, Push, Pull)
Git is a distributed version control system. You save a snapshot of your code locally with a `commit`, send it to a remote server with `push`, and retrieve updates from others using `pull`.

## 2. Branching & Merging
Instead of editing the main codebase directly, developers create **branches** to build features in isolation. Once completed and tested, the branch is **merged** back into the main code.

## 3. GitHub PRs & Issues
GitHub is a cloud platform for hosting Git repositories. An **Issue** tracks bugs or tasks. A **Pull Request (PR)** is a formal request to merge your branch into the main repository, allowing team members to review your code first.

## 4. Rebasing & Stashing
**Rebasing** rewrites commit history to create a clean, linear timeline (unlike merging). **Stashing** lets you temporarily hide uncommitted changes so you can switch branches without losing work.

## Real-World Example
Developer A is fixing a bug (tracked via a **GitHub Issue**). They create a new **branch**, write the code, **commit**, and **push** it. Before it's added to the live game, they open a **Pull Request**. The team reviews it, requests a small change, and once approved, it is **merged** into the main branch.
''',
      imageAsset: 'assets/images/devops_day2.png',
      schedule: [
        ScheduleRow('9:00 – 11:00', 'Git basics (commit, push, pull)', '💻 Practice'),
        ScheduleRow('11:00 – 12:00', 'Branching & Merging', '🔬 Hands-on'),
        ScheduleRow('12:00 – 13:00', '🍽️ Lunch Break', '—', isBreak: true),
        ScheduleRow('13:00 – 15:00', 'GitHub PRs & Issues', '🌐 Explore'),
        ScheduleRow('15:00 – 17:00', 'Rebasing & Stashing', '💻 Practice'),
        ScheduleRow('17:00 – 18:00', 'Revision', '📝 Summarize'),
      ],
      covered: ['Git', 'Branching', 'PRs', 'Merge/Rebase'],
      qa: [
        QAItem('Merge vs Rebase?', 'Merge combines histories. Rebase rewrites history for a clean, linear commit line.'),
        QAItem('What is git stash?', 'It temporarily saves uncommitted changes so you can switch branches safely.'),
        QAItem('What is a Pull Request?', 'A request to review and merge code from one branch into another.'),
        QAItem('How to undo a commit?', 'Use `git reset --soft HEAD~1` to keep changes, or `--hard` to delete them.'),
      ],
    ),
    DayData(
      dayNumber: 3,
      title: 'CI/CD Pipelines',
      subtitle: 'Jenkins & GitHub Actions',
      tags: ['CI/CD', 'Jenkins', 'YAML'],
      explanation: '''
# Continuous Integration & Deployment (CI/CD)

## 1. CI/CD Concepts
**Continuous Integration (CI)** automates building and testing code on every commit. **Continuous Deployment (CD)** automatically releases that verified code to servers. Together, they prevent bugs and speed up releases.

## 2. Jenkins Setup
Jenkins is a wildly popular open-source automation server. You configure a "Jenkinsfile" to define pipeline steps, allowing Jenkins to fetch your code, run tests, and deploy it automatically.

## 3. GitHub Actions YAML
GitHub Actions is a modern CI/CD platform built directly into GitHub. It uses **YAML** files to define workflows that trigger automatically on events (like a code push or PR creation).

## 4. Build Full Pipeline
Building a full pipeline means connecting the Dev phase (writing code) to the Ops phase (running on a server). The pipeline handles everything in between: installing dependencies, running unit tests, and pushing to production.

## Real-World Example
An engineer at Spotify pushes an update for the mobile app. A **GitHub Action** immediately triggers, reading a **YAML** file. The action compiles the app, runs 500 automated tests (**CI**), and upon passing, automatically deploys the update to millions of users seamlessly (**CD**).
''',
      imageAsset: 'assets/images/devops_day3.png',
      schedule: [
        ScheduleRow('9:00 – 11:00', 'CI/CD Concepts', '📖 Study'),
        ScheduleRow('11:00 – 12:00', 'Jenkins Setup', '⚙️ Lab'),
        ScheduleRow('12:00 – 13:00', '🍽️ Lunch Break', '—', isBreak: true),
        ScheduleRow('13:00 – 15:00', 'GitHub Actions YAML', '✍️ Write'),
        ScheduleRow('15:00 – 17:00', 'Build full pipeline', '🚀 Project'),
        ScheduleRow('17:00 – 18:00', 'Revision', '📝 Summarize'),
      ],
      covered: ['Pipelines', 'Jenkins', 'Actions'],
      qa: [
        QAItem('What is CI/CD?', 'Continuous Integration (auto-testing) and Continuous Deployment (auto-releasing).'),
        QAItem('What is a Jenkinsfile?', 'A text file defining your pipeline steps as code.'),
        QAItem('How do GitHub Actions trigger?', 'Via events like `push`, `pull_request`, or a `schedule`.'),
        QAItem('Why use CI/CD?', 'To catch bugs early, automate manual tasks, and deploy faster.'),
      ],
    ),
    DayData(
      dayNumber: 4,
      title: 'Docker & Containers',
      subtitle: 'Images, Dockerfile, Compose',
      tags: ['Docker', 'Compose'],
      explanation: '''
# Containerization with Docker

## 1. Containers vs VMs
Virtual Machines require an entire guest operating system, making them heavy and slow. Containers share the host OS's kernel, making them lightweight, fast, and portable. 

## 2. Docker CLI Basics
Docker is the standard platform for containers. The CLI is used to pull images from the internet (`docker pull`), run them (`docker run`), and manage active containers (`docker ps`, `docker stop`).

## 3. Writing Dockerfiles
A `Dockerfile` is a text document containing all the commands a user could call on the command line to assemble an image. It defines the base OS, dependencies, and how the app starts.

## 4. Docker Compose
Docker Compose is a tool used to define and run multi-container applications. Using a single `docker-compose.yml` file, you can spin up a web server container and a database container simultaneously, automatically linking them together.

## Real-World Example
A developer builds an app on a Mac, but the production server runs Linux, causing the "it works on my machine" bug. The developer writes a **Dockerfile** to package the app and its libraries. They use **Docker Compose** to run both the app and a database locally. Because containers are perfectly portable, that exact same container runs flawlessly on the production server.
''',
      schedule: [
        ScheduleRow('9:00 – 11:00', 'Containers vs VMs', '📖 Study'),
        ScheduleRow('11:00 – 12:00', 'Docker CLI basics', '💻 Practice'),
        ScheduleRow('12:00 – 13:00', '🍽️ Lunch Break', '—', isBreak: true),
        ScheduleRow('13:00 – 15:00', 'Writing Dockerfiles', '✍️ Write'),
        ScheduleRow('15:00 – 17:00', 'Docker Compose', '⚙️ Lab'),
        ScheduleRow('17:00 – 18:00', 'Revision', '📝 Summarize'),
      ],
      covered: ['Containers', 'Images', 'Compose'],
      qa: [
        QAItem('Container vs VM?', 'VMs pack a full OS. Containers share the host OS, making them faster and lighter.'),
        QAItem('What is a Dockerfile?', 'A script of instructions used to build a custom Docker image.'),
        QAItem('What is Docker Compose?', 'A tool to run multi-container applications using a single YAML file.'),
        QAItem('What are Docker volumes?', 'They persist data generated by a container, surviving container restarts.'),
      ],
    ),
    DayData(
      dayNumber: 5,
      title: 'Kubernetes (K8s)',
      subtitle: 'Pods, Services, Deployments',
      tags: ['K8s', 'kubectl'],
      explanation: '''
# Kubernetes Orchestration

## 1. K8s Architecture
Kubernetes (K8s) is an orchestration engine designed to automate the deployment and scaling of thousands of containers across many servers (nodes). It features a Master Node controlling Worker Nodes.

## 2. kubectl commands
`kubectl` is the command-line tool used to communicate with the Kubernetes cluster. You use it to inspect the cluster, read logs, and apply YAML configuration files.

## 3. Pods & Deployments
A **Pod** is the smallest deployable unit in K8s, usually holding one container. A **Deployment** manages these Pods, ensuring the desired number are always running. If a Pod crashes, the Deployment replaces it instantly.

## 4. Services & Ingress
Because Pods are constantly created and destroyed, their IP addresses change constantly. A **Service** provides a stable IP address and load balancing. An **Ingress** acts as a smart router, directing outside internet traffic to the correct internal Services.

## Real-World Example
During a flash sale, an e-commerce website experiences a massive surge in traffic. The **Kubernetes Architecture** detects the CPU load increasing on the web **Pods**. A **Deployment** automatically spins up 50 new Pods to handle the traffic. A **Service** spreads the incoming traffic evenly across all 50 Pods so none of them crash.
''',
      schedule: [
        ScheduleRow('9:00 – 11:00', 'K8s Architecture', '📖 Study'),
        ScheduleRow('11:00 – 12:00', 'kubectl commands', '💻 Practice'),
        ScheduleRow('12:00 – 13:00', '🍽️ Lunch Break', '—', isBreak: true),
        ScheduleRow('13:00 – 15:00', 'Pods & Deployments', '✍️ YAML'),
        ScheduleRow('15:00 – 17:00', 'Services & Ingress', '⚙️ Lab'),
        ScheduleRow('17:00 – 18:00', 'Revision', '📝 Summarize'),
      ],
      covered: ['Pods', 'Deployments', 'Services'],
      qa: [
        QAItem('What is Kubernetes?', 'An orchestration tool to automatically deploy, scale, and manage containers.'),
        QAItem('What is a Pod?', 'The smallest deployable unit in K8s, containing one or more containers.'),
        QAItem('Deployment vs StatefulSet?', 'Deployments are for stateless apps. StatefulSets are for stateful apps like databases.'),
        QAItem('What does a Service do?', 'It provides a stable IP address and load balancing for a set of Pods.'),
      ],
    ),
    DayData(
      dayNumber: 6,
      title: 'Terraform & IaC',
      subtitle: 'Provisioning infrastructure as code',
      tags: ['Terraform', 'IaC'],
      explanation: '''
# Infrastructure as Code (IaC)

## 1. IaC Concepts
**Infrastructure as Code (IaC)** replaces manual clicks in a cloud console with machine-readable definition files. This ensures your environments are perfectly reproducible, version-controlled, and instantly deployable.

## 2. Terraform Syntax
Terraform uses HashiCorp Configuration Language (HCL). You declare what you want (e.g., an AWS server), and Terraform figures out how to make it happen across any cloud provider.

## 3. State & Modules
Terraform maps your code to real-world cloud resources using a **State file**. When you run an update, it checks the state to know exactly what to change. **Modules** act like functions, allowing you to reuse Terraform code across different projects.

## 4. Deploy AWS Resources
Using commands like `terraform init`, `terraform plan`, and `terraform apply`, you can spin up complex architectures involving networking, servers, and databases simultaneously.

## Real-World Example
A startup needs to create an identical testing environment that perfectly mimics production. Without **IaC**, an engineer spends days manually configuring AWS. With **Terraform Syntax**, they simply change an environment variable from "prod" to "test", run `terraform apply`, and the entire infrastructure builds automatically in minutes.
''',
      schedule: [
        ScheduleRow('9:00 – 11:00', 'IaC Concepts', '📖 Study'),
        ScheduleRow('11:00 – 12:00', 'Terraform syntax', '💻 Practice'),
        ScheduleRow('12:00 – 13:00', '🍽️ Lunch Break', '—', isBreak: true),
        ScheduleRow('13:00 – 15:00', 'State & Modules', '⚙️ Lab'),
        ScheduleRow('15:00 – 17:00', 'Deploy AWS Resources', '🚀 Project'),
        ScheduleRow('17:00 – 18:00', 'Revision', '📝 Summarize'),
      ],
      covered: ['IaC', 'State', 'Modules'],
      qa: [
        QAItem('What is IaC?', 'Managing and provisioning infrastructure through code instead of manual clicks.'),
        QAItem('What are the core Terraform commands?', '`init` (setup), `plan` (preview), `apply` (build), `destroy` (delete).'),
        QAItem('What is the tfstate file?', 'A file Terraform uses to map real-world resources to your configuration.'),
        QAItem('Why use remote state?', 'To allow teams to collaborate safely and prevent concurrent modifications.'),
      ],
    ),
    DayData(
      dayNumber: 7,
      title: 'Monitoring & Review',
      subtitle: 'Prometheus, Grafana, Full Review',
      tags: ['Monitoring', 'Review'],
      explanation: '''
# Monitoring and Observability

## 1. Prometheus & Grafana
Without visibility, you are flying blind. **Prometheus** is a toolkit that collects metrics (CPU, RAM, error rates) from your servers via a pull model. **Grafana** connects to Prometheus to visualize this data through interactive, beautiful dashboards.

## 2. Log Management
While metrics tell you *if* a system is failing, logs tell you *why*. Centralized log management aggregates text logs from hundreds of servers into one searchable database to aid in rapid troubleshooting.

## 3. End-to-End Pipeline
Tying it all together: writing code, testing it automatically (CI), building a Docker container, deploying it to Kubernetes with Terraform, and monitoring it with Grafana.

## Real-World Example
An online banking app monitors database queries. If **Prometheus** detects that queries suddenly take 5 seconds instead of 0.1 seconds, **Grafana** triggers a visual red alert. The monitoring system automatically pages the on-call engineer, who then checks the **Log Management** system to find the exact error message and fixes the issue before customers even notice.
''',
      schedule: [
        ScheduleRow('9:00 – 11:00', 'Prometheus & Grafana', '📖 Study'),
        ScheduleRow('11:00 – 12:00', 'Log Management', '⚙️ Lab'),
        ScheduleRow('12:00 – 13:00', '🍽️ Lunch Break', '—', isBreak: true),
        ScheduleRow('13:00 – 15:00', 'End-to-End Pipeline', '🚀 Practice'),
        ScheduleRow('15:00 – 17:00', 'Mock Interviews', '❓ Q&A'),
        ScheduleRow('17:00 – 18:00', 'Final Review', '📝 Summarize'),
      ],
      covered: ['Grafana', 'Metrics', 'Logs'],
      qa: [
        QAItem('Prometheus vs Grafana?', 'Prometheus collects and stores metrics. Grafana visualizes them in dashboards.'),
        QAItem('What is DevSecOps?', 'Integrating security checks automatically into every stage of the CI/CD pipeline.'),
        QAItem('What is Ansible?', 'A configuration management tool used to automate software installation on servers.'),
        QAItem('Difference between Ansible and Terraform?', 'Terraform builds the servers (infra). Ansible configures the software inside them.'),
      ],
    ),
  ],
);

// ══════════════════════════════════════════════════
//  AWS
// ══════════════════════════════════════════════════
const awsData = TimetableData(
  id: 'aws',
  label: 'AWS',
  emoji: '☁️',
  subtitle: 'IAM · EC2 · S3 · VPC · RDS · DynamoDB',
  days: [
    DayData(
      dayNumber: 1,
      title: 'AWS Basics & IAM',
      subtitle: 'Console, Regions, Security',
      tags: ['IAM', 'Security'],
      explanation: '''
# AWS Fundamentals & Security

## 1. Cloud Concepts
Cloud computing replaces upfront capital infrastructure expenses with low variable costs that scale with your business. It provides agility, elasticity, and global reach in minutes.

## 2. AWS Console Tour
The AWS Management Console is a web interface to access your cloud resources. It allows you to provision servers, configure networks, and monitor billing directly from your browser.

## 3. IAM Users & Roles
AWS Identity and Access Management (IAM) controls access securely. **Users** represent actual people with passwords. **Roles** are temporary credentials assumed by services (e.g., an EC2 server needing access to a database).

## 4. MFA & Policies
Policies are JSON documents defining exact permissions. Multi-Factor Authentication (MFA) adds an extra layer of protection, requiring a mobile device code in addition to a password.

## Real-World Example
A company hires a new Junior Developer. Instead of giving them the root account password, the admin uses **IAM Users & Roles** to create an account. They attach a strict **Policy** granting only "Read-Only" access to EC2. They also mandate **MFA** so even if the developer's password is stolen, hackers cannot log in.
''',
      imageAsset: 'assets/images/aws_concept.png',
      schedule: [
        ScheduleRow('9:00 – 11:00', 'Cloud Concepts', '📖 Study'),
        ScheduleRow('11:00 – 12:00', 'AWS Console Tour', '💻 Explore'),
        ScheduleRow('12:00 – 13:00', '🍽️ Lunch Break', '—', isBreak: true),
        ScheduleRow('13:00 – 15:00', 'IAM Users & Roles', '⚙️ Lab'),
        ScheduleRow('15:00 – 17:00', 'MFA & Policies', '🔒 Security'),
        ScheduleRow('17:00 – 18:00', 'Revision', '📝 Summarize'),
      ],
      covered: ['Regions', 'AZs', 'IAM'],
      qa: [
        QAItem('Region vs Availability Zone (AZ)?', 'A Region is a geographic area. An AZ is a physical data center within that Region.'),
        QAItem('IAM User vs Role?', 'Users have permanent passwords. Roles provide temporary access tokens for services.'),
        QAItem('What is the Principle of Least Privilege?', 'Giving users only the bare minimum permissions needed for their job.'),
        QAItem('Why use MFA on the root account?', 'The root account has unlimited power. MFA prevents hackers from taking over your account.'),
      ],
    ),
    DayData(
      dayNumber: 2,
      title: 'Compute (EC2 & Lambda)',
      subtitle: 'Servers and Serverless',
      tags: ['EC2', 'Lambda'],
      explanation: '''
# Cloud Compute Models

## 1. EC2 Instance Types & Launching
Amazon EC2 provides virtual servers. Instance types dictate the hardware (e.g., compute-optimized for gaming, memory-optimized for databases). Launching an EC2 means selecting an OS, allocating storage, and booting it up.

## 2. Security Groups & Auto Scaling Groups (ASG)
**Security Groups** are virtual firewalls controlling inbound and outbound traffic. An **Auto Scaling Group (ASG)** automatically adds or removes EC2 instances based on current traffic demand, ensuring you don't overpay for idle servers.

## 3. Lambda Functions
AWS Lambda is the ultimate **serverless** compute. You upload your code (Python, Node.js), and AWS automatically provisions the compute power to run it when triggered, charging you purely by the millisecond.

## Real-World Example
An e-commerce site uses **EC2** servers behind an **Auto Scaling Group**. On Black Friday, the ASG detects heavy CPU usage and automatically launches 10 more EC2 servers. At the same time, users upload profile pictures; an **AWS Lambda Function** is triggered instantly to compress each picture into a thumbnail, running for 200 milliseconds and costing fractions of a cent.
''',
      imageAsset: 'assets/images/aws_day2.png',
      schedule: [
        ScheduleRow('9:00 – 11:00', 'EC2 Instance Types', '📖 Study'),
        ScheduleRow('11:00 – 12:00', 'Launch an EC2', '💻 Lab'),
        ScheduleRow('12:00 – 13:00', '🍽️ Lunch Break', '—', isBreak: true),
        ScheduleRow('13:00 – 15:00', 'Security Groups & ASG', '⚙️ Configure'),
        ScheduleRow('15:00 – 17:00', 'Lambda Functions', '🚀 Code'),
        ScheduleRow('17:00 – 18:00', 'Revision', '📝 Summarize'),
      ],
      covered: ['EC2', 'ASG', 'Lambda'],
      qa: [
        QAItem('What are Security Groups?', 'Virtual firewalls attached to EC2 instances to control inbound and outbound traffic.'),
        QAItem('What is Auto Scaling?', 'Automatically adding or removing EC2 instances based on traffic demand.'),
        QAItem('What is AWS Lambda?', 'A serverless compute service that runs code in response to events without managing servers.'),
        QAItem('ALB vs NLB?', 'Application Load Balancer (ALB) routes HTTP/HTTPS. Network Load Balancer (NLB) routes fast TCP/UDP traffic.'),
      ],
    ),
    DayData(
      dayNumber: 3,
      title: 'Storage (S3 & EBS)',
      subtitle: 'Object and Block Storage',
      tags: ['S3', 'EBS'],
      explanation: '''
# AWS Storage Solutions

## 1. S3 Buckets & Classes
Amazon S3 is **Object Storage** accessed over the internet, perfect for media and backups. It offers storage classes: Standard (fast, expensive), Infrequent Access (cheaper, accessed rarely), and Glacier (cheapest, used for long-term archiving).

## 2. S3 Hosting
S3 can be configured to host static websites (HTML, CSS, JS) directly from a bucket, eliminating the need to provision an EC2 web server entirely.

## 3. EBS Volumes
Amazon EBS is **Block Storage**. It provides high-performance hard drives that are directly attached to EC2 instances. Unlike S3, EBS is required to install an operating system and run databases efficiently.

## 4. EFS & Glacier
Elastic File System (EFS) is a shared network drive that multiple EC2 instances can access simultaneously. Glacier is S3's deep archive class.

## Real-World Example
Spotify stores its massive library of mp3 audio files and album artwork in **S3 Buckets** because they are static files delivered over the web. However, the EC2 server that runs the Spotify recommendation algorithm has an **EBS Volume** attached to act as its high-speed `C:` drive. Meanwhile, 10-year-old billing records are sent to **Glacier** to save on storage costs.
''',
      imageAsset: 'assets/images/aws_day3.png',
      schedule: [
        ScheduleRow('9:00 – 11:00', 'S3 Buckets & Classes', '📖 Study'),
        ScheduleRow('11:00 – 12:00', 'S3 Hosting', '💻 Lab'),
        ScheduleRow('12:00 – 13:00', '🍽️ Lunch Break', '—', isBreak: true),
        ScheduleRow('13:00 – 15:00', 'EBS Volumes', '⚙️ Configure'),
        ScheduleRow('15:00 – 17:00', 'EFS & Glacier', '🚀 Compare'),
        ScheduleRow('17:00 – 18:00', 'Revision', '📝 Summarize'),
      ],
      covered: ['S3', 'EBS', 'EFS'],
      qa: [
        QAItem('S3 vs EBS?', 'S3 is object storage (files, images). EBS is a hard drive attached to an EC2 instance.'),
        QAItem('What is S3 Glacier?', 'A highly secure, extremely low-cost storage class used for long-term data archiving.'),
        QAItem('What is EFS?', 'Elastic File System. A shared network drive that multiple EC2 instances can access at once.'),
        QAItem('Why use S3 Versioning?', 'To easily recover files if they are accidentally deleted or overwritten.'),
      ],
    ),
    DayData(
      dayNumber: 4,
      title: 'Networking (VPC)',
      subtitle: 'Subnets, Routing, CloudFront',
      tags: ['VPC', 'CDN'],
      explanation: '''
# Virtual Private Cloud (VPC)

## 1. VPC Concepts & Building
A VPC lets you provision a logically isolated section of the AWS Cloud. Building a VPC involves choosing an IP range (CIDR), creating subnets, and setting up routing tables to direct traffic.

## 2. NAT Gateways
Public subnets connect directly to the internet. Private subnets do not. A **NAT Gateway** placed in a public subnet allows servers in a private subnet to reach out to the internet (e.g., to download software updates) without allowing the internet to initiate a connection back in.

## 3. Route 53 & CloudFront
**Route 53** is AWS's highly available DNS service that translates domain names into IP addresses. **CloudFront** is a Content Delivery Network (CDN) that caches your website's static files at edge locations globally to reduce latency.

## Real-World Example
An online store uses **Route 53** to route traffic from `mystore.com` to a web server in a **Public Subnet** within their **VPC**. The web server fetches products from a database hidden safely in a **Private Subnet**. When the database needs a security patch, it accesses the internet securely via a **NAT Gateway**. Heavy product images are cached globally using **CloudFront** so customers in Japan and the US experience fast loading times.
''',
      schedule: [
        ScheduleRow('9:00 – 11:00', 'VPC Concepts', '📖 Study'),
        ScheduleRow('11:00 – 12:00', 'Build a VPC', '💻 Lab'),
        ScheduleRow('12:00 – 13:00', '🍽️ Lunch Break', '—', isBreak: true),
        ScheduleRow('13:00 – 15:00', 'NAT Gateways', '⚙️ Configure'),
        ScheduleRow('15:00 – 17:00', 'Route 53 & CloudFront', '🌐 Set up CDN'),
        ScheduleRow('17:00 – 18:00', 'Revision', '📝 Summarize'),
      ],
      covered: ['Subnets', 'NAT', 'Route 53'],
      qa: [
        QAItem('What is a VPC?', 'A logically isolated section of the AWS cloud where you launch resources in a virtual network.'),
        QAItem('Public vs Private Subnet?', 'Public subnets have direct internet access. Private subnets do not.'),
        QAItem('What is a NAT Gateway?', 'It allows resources in a private subnet to access the internet securely for updates.'),
        QAItem('What does CloudFront do?', 'It is a Content Delivery Network (CDN) that caches content close to users for faster loading.'),
      ],
    ),
    DayData(
      dayNumber: 5,
      title: 'Databases',
      subtitle: 'SQL vs NoSQL, RDS, DynamoDB',
      tags: ['RDS', 'DynamoDB'],
      explanation: '''
# AWS Managed Databases

## 1. Relational vs NoSQL
Relational databases (SQL) organize data into strict tables and rows, perfect for complex transactions. NoSQL databases organize data using flexible key-value pairs or documents, perfect for massive scale and unstructured data.

## 2. RDS Setup
Amazon Relational Database Service (RDS) manages SQL engines like PostgreSQL and MySQL. Setting it up involves configuring Multi-AZ for failover redundancy and Read Replicas to offload heavy query traffic.

## 3. DynamoDB Basics
Amazon DynamoDB is a serverless NoSQL database. You simply create tables and start inserting data. It automatically scales to handle millions of requests per second with single-digit millisecond latency.

## 4. ElastiCache
ElastiCache provides managed Redis or Memcached. It sits in front of a database, caching frequently requested data in RAM to drastically speed up application performance.

## Real-World Example
A banking app requires strict financial consistency, so they **setup an RDS** PostgreSQL database. To ensure the bank never goes offline, they enable Multi-AZ failover. Conversely, a globally viral mobile game needs to load millions of player high scores instantly; they use **DynamoDB** to handle the unstructured data scale, and **ElastiCache** to instantly retrieve the top 10 leaderboard.
''',
      schedule: [
        ScheduleRow('9:00 – 11:00', 'Relational vs NoSQL', '📖 Study'),
        ScheduleRow('11:00 – 12:00', 'RDS Setup', '💻 Lab'),
        ScheduleRow('12:00 – 13:00', '🍽️ Lunch Break', '—', isBreak: true),
        ScheduleRow('13:00 – 15:00', 'DynamoDB basics', '⚙️ Create Tables'),
        ScheduleRow('15:00 – 17:00', 'ElastiCache', '🚀 Optimize'),
        ScheduleRow('17:00 – 18:00', 'Revision', '📝 Summarize'),
      ],
      covered: ['RDS', 'DynamoDB', 'ElastiCache'],
      qa: [
        QAItem('RDS vs DynamoDB?', 'RDS is for structured relational data (SQL). DynamoDB is a flexible key-value NoSQL database.'),
        QAItem('What are RDS Read Replicas?', 'Copies of your database used purely for handling heavy read traffic to boost performance.'),
        QAItem('What is RDS Multi-AZ?', 'An automatic standby database in another zone used for backup if the primary database fails.'),
        QAItem('What is ElastiCache?', 'An in-memory caching service (Redis/Memcached) used to speed up database queries.'),
      ],
    ),
    DayData(
      dayNumber: 6,
      title: 'Automation & Containers',
      subtitle: 'CloudFormation, ECS, ECR',
      tags: ['CloudFormation', 'ECS'],
      explanation: '''
# Automation and Container Orchestration

## 1. CloudFormation Basics & Stack Deployment
AWS CloudFormation allows you to model and provision infrastructure using YAML or JSON templates. A "Stack" is a collection of AWS resources you can manage as a single unit, making infrastructure perfectly reproducible.

## 2. ECS & ECR
Amazon Elastic Container Registry (ECR) securely stores Docker images. Amazon Elastic Container Service (ECS) takes those images and orchestrates running them seamlessly across a cluster.

## 3. Fargate vs EC2
When running containers in ECS, you have two choices: EC2 mode (you manage the underlying virtual servers) or Fargate mode (completely serverless compute where AWS manages the servers for you).

## Real-World Example
A team wants to deploy a microservice architecture. They write a **CloudFormation** template to automate everything. The template creates an **ECS** cluster and pulls the required Docker image from **ECR**. Because the team doesn't want to deal with patching operating systems, they choose to run the containers on **Fargate**.
''',
      schedule: [
        ScheduleRow('9:00 – 11:00', 'CloudFormation Basics', '📖 Study'),
        ScheduleRow('11:00 – 12:00', 'Deploy a Stack', '💻 Lab'),
        ScheduleRow('12:00 – 13:00', '🍽️ Lunch Break', '—', isBreak: true),
        ScheduleRow('13:00 – 15:00', 'ECS & ECR', '⚙️ Containers'),
        ScheduleRow('15:00 – 17:00', 'Fargate vs EC2', '🚀 Deploy'),
        ScheduleRow('17:00 – 18:00', 'Revision', '📝 Summarize'),
      ],
      covered: ['IaC', 'ECS', 'Fargate'],
      qa: [
        QAItem('What is CloudFormation?', 'AWS\'s native service for defining infrastructure as code using YAML or JSON.'),
        QAItem('What is Amazon ECR?', 'A secure registry to store and manage your Docker container images.'),
        QAItem('ECS EC2 vs Fargate?', 'In EC2 mode, you manage the underlying servers. Fargate is serverless; AWS manages the servers for you.'),
        QAItem('What is CodePipeline?', 'AWS\'s CI/CD service that automates building, testing, and deploying code.'),
      ],
    ),
    DayData(
      dayNumber: 7,
      title: 'Security & Review',
      subtitle: 'CloudWatch, KMS, Cost Management',
      tags: ['CloudWatch', 'KMS'],
      explanation: '''
# Security, Monitoring & Governance

## 1. CloudWatch & Logs
Amazon CloudWatch provides monitoring and alerting for performance metrics (CPU, RAM). It also aggregates logs from EC2 instances and Lambda functions into central CloudWatch Log Groups for easy querying.

## 2. KMS & Encryption
AWS Key Management Service (KMS) enables you to create and manage the cryptographic keys used to encrypt data at rest across AWS services (like S3 and EBS).

## 3. Cost Explorer
The cloud is easy to use, making it easy to accidentally overspend. Cost Explorer helps you visualize, understand, and manage your AWS costs over time using custom reports and anomaly detection.

## Real-World Example
An engineer notices their monthly AWS bill spiked. They use **Cost Explorer** and discover an EC2 server running at 100% CPU. They check **CloudWatch Logs** and realize the server is under a brute-force attack. To protect sensitive customer data, they ensure the database uses **KMS Encryption** so even if the server is breached, the data remains scrambled and unreadable.
''',
      schedule: [
        ScheduleRow('9:00 – 11:00', 'CloudWatch & Logs', '📖 Study'),
        ScheduleRow('11:00 – 12:00', 'KMS & Encryption', '💻 Lab'),
        ScheduleRow('12:00 – 13:00', '🍽️ Lunch Break', '—', isBreak: true),
        ScheduleRow('13:00 – 15:00', 'Cost Explorer', '⚙️ Analysis'),
        ScheduleRow('15:00 – 17:00', 'Mock Exam', '🚀 Practice'),
        ScheduleRow('17:00 – 18:00', 'Final Review', '📝 Summarize'),
      ],
      covered: ['Security', 'Billing', 'Metrics'],
      qa: [
        QAItem('CloudWatch vs CloudTrail?', 'CloudWatch monitors performance metrics. CloudTrail logs "Who did what" for security audits.'),
        QAItem('What is AWS KMS?', 'Key Management Service. It creates and manages cryptographic keys to encrypt data.'),
        QAItem('What is AWS GuardDuty?', 'An intelligent threat detection service that monitors accounts for malicious activity.'),
        QAItem('What is Trusted Advisor?', 'A tool providing real-time guidance to help provision resources optimally to save money and improve security.'),
      ],
    ),
  ],
);

// ══════════════════════════════════════════════════
//  NETWORKING
// ══════════════════════════════════════════════════
const networkingData = TimetableData(
  id: 'networking',
  label: 'Networking',
  emoji: '🌐',
  subtitle: 'OSI · TCP/IP · Subnetting · Routing · Firewalls',
  days: [
    DayData(
      dayNumber: 1,
      title: 'OSI Model & TCP/IP',
      subtitle: 'Protocols, layers, encapsulation',
      tags: ['OSI', 'TCP/IP'],
      explanation: '''
# OSI Model and TCP/IP Architecture

## 1. OSI 7 Layers & TCP/IP Model
The OSI model divides networking into 7 theoretical layers (Physical, Data Link, Network, Transport, Session, Presentation, Application). The TCP/IP model is a more practical 4-layer model that maps closely to the protocols actually used on the modern internet.

## 2. Encapsulation
As data travels from an application down to the physical cable, it undergoes **encapsulation**—adding specific protocol headers at each layer (e.g., adding an IP header at the Network layer). Upon arriving at the destination, it is decapsulated.

## 3. Wireshark Basics
Wireshark is a packet analyzer. It captures real-time data flowing over a network and allows engineers to inspect the exact encapsulation headers of every packet to troubleshoot issues.

## Real-World Example
When you open a web browser (**Application Layer**) to watch a video, the data is chopped into segments using UDP (**Transport Layer**). It is then stamped with IP addresses (**Network Layer**) to know where to go on the internet, and finally converted to electrical signals over your ethernet cable (**Physical Layer**). A network engineer could use **Wireshark** to intercept and inspect these packets in real-time.
''',
      imageAsset: 'assets/images/networking_concept.png',
      schedule: [
        ScheduleRow('9:00 – 11:00', 'OSI 7 Layers', '📖 Study'),
        ScheduleRow('11:00 – 12:00', 'TCP/IP Model', '💻 Compare'),
        ScheduleRow('12:00 – 13:00', '🍽️ Lunch Break', '—', isBreak: true),
        ScheduleRow('13:00 – 15:00', 'Encapsulation', '⚙️ Learn'),
        ScheduleRow('15:00 – 17:00', 'Wireshark basics', '🚀 Practice'),
        ScheduleRow('17:00 – 18:00', 'Revision', '📝 Summarize'),
      ],
      covered: ['OSI', 'Wireshark', 'Packets'],
      qa: [
        QAItem('What are the 7 OSI layers?', 'Physical, Data Link, Network, Transport, Session, Presentation, Application.'),
        QAItem('TCP vs UDP?', 'TCP is reliable and guarantees delivery. UDP is fast but does not guarantee delivery (used for streaming).'),
        QAItem('What is a MAC address?', 'A unique hardware identifier burned into a network card (Layer 2).'),
        QAItem('What is encapsulation?', 'The process of adding headers (and trailers) to data as it moves down the OSI layers.'),
      ],
    ),
    DayData(
      dayNumber: 2,
      title: 'IP Addressing & Subnetting',
      subtitle: 'IPv4, IPv6, CIDR, Subnet Masks',
      tags: ['IPv4', 'Subnetting'],
      explanation: '''
# IP Addressing and Subnetting

## 1. IPv4 & IPv6 Basics
IPv4 addresses consist of 32 bits (e.g., `192.168.1.1`). Because the world ran out of IPv4 addresses, IPv6 was introduced using 128-bit alphanumeric addresses to provide a virtually limitless supply.

## 2. Public vs Private IPs
Public IPs are unique across the global internet. Private IPs (like `10.x.x.x` or `192.168.x.x`) are used internally within a local network and cannot be routed on the internet directly.

## 3. CIDR Notation & Subnetting Practice
Subnetting divides a single large network into smaller sub-networks. **CIDR** (Classless Inter-Domain Routing) notation (like `/24`) indicates how many bits are used for the network portion, determining the number of available hosts.

## Real-World Example
A university is given a massive block of **Public IPs**. Instead of putting all 10,000 students and staff on one giant network, the IT admin uses **Subnetting** calculations. Using **CIDR Notation**, they slice the network into smaller segments: one private subnet for the dorms, one for the library, and a highly secure subnet for the administration to isolate traffic and improve performance.
''',
      imageAsset: 'assets/images/networking_day2.png',
      schedule: [
        ScheduleRow('9:00 – 11:00', 'IPv4 & IPv6 Basics', '📖 Study'),
        ScheduleRow('11:00 – 12:00', 'Public vs Private IPs', '💻 Lab'),
        ScheduleRow('12:00 – 13:00', '🍽️ Lunch Break', '—', isBreak: true),
        ScheduleRow('13:00 – 15:00', 'CIDR Notation', '⚙️ Math'),
        ScheduleRow('15:00 – 17:00', 'Subnetting Practice', '🚀 Exercise'),
        ScheduleRow('17:00 – 18:00', 'Revision', '📝 Summarize'),
      ],
      covered: ['IPs', 'CIDR', 'Subnets'],
      qa: [
        QAItem('IPv4 vs IPv6?', 'IPv4 uses 32-bit addresses (running out). IPv6 uses 128-bit addresses (virtually infinite).'),
        QAItem('What is a Private IP?', 'An IP address reserved for internal networks (e.g., 192.168.x.x) that cannot be routed on the public internet.'),
        QAItem('What is CIDR?', 'Classless Inter-Domain Routing. A method of allocating IP addresses and IP routing (e.g., /24 means 256 IPs).'),
        QAItem('Why do we subnet?', 'To divide a large network into smaller, efficient, and secure sub-networks.'),
      ],
    ),
    DayData(
      dayNumber: 3,
      title: 'Routing & Switching',
      subtitle: 'VLANs, OSPF, BGP, ARP',
      tags: ['Routing', 'Switching'],
      explanation: '''
# Hardware: Switches and Routers

## 1. Hubs vs Switches vs Routers
Hubs blindly broadcast data to everyone. Switches intelligently forward data to a specific device using MAC tables. Routers connect entirely different networks together using IP addresses.

## 2. ARP & MAC Tables
Address Resolution Protocol (ARP) translates a known IP address into an unknown MAC address. Switches store these MAC addresses in a table to quickly forward frames.

## 3. VLANs & Trunking
Virtual LANs (VLANs) logically separate devices on the same physical switch. Trunking allows multiple VLANs to travel across a single cable connecting two switches.

## 4. Routing (OSPF, BGP)
Routers use protocols to find the best path for data. OSPF calculates the fastest route within an internal corporate network. BGP connects massive external networks and routes traffic across the global internet.

## Real-World Example
In a corporate office, HR and Engineering plug their computers into the exact same physical **Switch**. The admin creates two **VLANs** to securely isolate them. To send data, the PC uses **ARP** to find the router's MAC address. The **Router** then uses **BGP** routing protocols to forward that data out across the internet to reach Google's servers.
''',
      imageAsset: 'assets/images/networking_day3.png',
      schedule: [
        ScheduleRow('9:00 – 11:00', 'Hubs vs Switches vs Routers', '📖 Study'),
        ScheduleRow('11:00 – 12:00', 'ARP & MAC Tables', '💻 Lab'),
        ScheduleRow('12:00 – 13:00', '🍽️ Lunch Break', '—', isBreak: true),
        ScheduleRow('13:00 – 15:00', 'VLANs & Trunking', '⚙️ Configure'),
        ScheduleRow('15:00 – 17:00', 'Routing (OSPF, BGP)', '🚀 Explore'),
        ScheduleRow('17:00 – 18:00', 'Revision', '📝 Summarize'),
      ],
      covered: ['VLAN', 'BGP', 'OSPF'],
      qa: [
        QAItem('Switch vs Router?', 'Switches connect devices within the same network (Layer 2). Routers connect different networks together (Layer 3).'),
        QAItem('What is ARP?', 'Address Resolution Protocol. It maps a known IP address to an unknown MAC address.'),
        QAItem('What is a VLAN?', 'A Virtual LAN. It logically separates network traffic on the same physical switch for security.'),
        QAItem('OSPF vs BGP?', 'OSPF routes traffic *within* an organization (interior). BGP routes traffic *between* organizations/ISPs on the internet (exterior).'),
      ],
    ),
    DayData(
      dayNumber: 4,
      title: 'Network Services (DNS, DHCP)',
      subtitle: 'How the internet resolves names',
      tags: ['DNS', 'DHCP'],
      explanation: '''
# Core Network Services

## 1. DNS Hierarchy & Records
The Domain Name System (DNS) translates domains like `amazon.com` into IPs. The hierarchy starts at Root servers, down to Top Level Domains (.com), and to Authoritative servers. Common records include A (IPv4), AAAA (IPv6), and CNAME (aliases).

## 2. nslookup & dig
These are command-line tools used by engineers to query DNS servers directly, allowing them to troubleshoot why a website name isn't resolving correctly.

## 3. DHCP DORA Process
DHCP assigns IP addresses automatically using the DORA process: **D**iscover (client looks for server), **O**ffer (server offers IP), **R**equest (client accepts), **A**cknowledge (server finalizes).

## 4. NAT / PAT
Network Address Translation (NAT) and Port Address Translation (PAT) allow dozens of internal devices with Private IPs to share a single Public IP address to access the internet securely.

## Real-World Example
When you walk into a coffee shop and connect your phone, a **DHCP** server instantly uses the **DORA process** to hand your phone an IP address. You open a browser and type `youtube.com`. Your phone uses **DNS** to resolve the name, and then your traffic uses **NAT** to share the coffee shop's single public internet connection alongside 30 other customers.
''',
      schedule: [
        ScheduleRow('9:00 – 11:00', 'DNS Hierarchy & Records', '📖 Study'),
        ScheduleRow('11:00 – 12:00', 'nslookup & dig', '💻 Lab'),
        ScheduleRow('12:00 – 13:00', '🍽️ Lunch Break', '—', isBreak: true),
        ScheduleRow('13:00 – 15:00', 'DHCP DORA Process', '⚙️ Process'),
        ScheduleRow('15:00 – 17:00', 'NAT / PAT', '🚀 Setup'),
        ScheduleRow('17:00 – 18:00', 'Revision', '📝 Summarize'),
      ],
      covered: ['DNS', 'DHCP', 'NAT'],
      qa: [
        QAItem('What is DNS?', 'Domain Name System. It acts as the internet\'s phonebook, translating names like google.com into IP addresses.'),
        QAItem('What is DHCP?', 'Dynamic Host Configuration Protocol. It automatically assigns IP addresses to devices joining a network.'),
        QAItem('What are common DNS records?', 'A (maps name to IPv4), AAAA (maps to IPv6), CNAME (alias), MX (mail servers).'),
        QAItem('What is NAT?', 'Network Address Translation. It translates private internal IPs into a single public IP to access the internet.'),
      ],
    ),
    DayData(
      dayNumber: 5,
      title: 'Network Security & Firewalls',
      subtitle: 'Firewalls, IDS/IPS, ACLs',
      tags: ['Firewalls', 'Security'],
      explanation: '''
# Defending the Network

## 1. Firewall Types & Writing ACLs
Firewalls stand between your secure network and the untrusted internet. You control them by writing Access Control Lists (ACLs)—strict rules that allow or deny traffic based on IP address and port numbers (like Port 443 for HTTPS).

## 2. IDS vs IPS
An **Intrusion Detection System (IDS)** monitors network traffic for malicious activity and sends alerts. An **Intrusion Prevention System (IPS)** analyzes the traffic and actively drops malicious packets to stop attacks instantly.

## 3. VPNs & IPsec
A Virtual Private Network (VPN) creates a secure, encrypted tunnel over the public internet, allowing remote workers to access internal corporate networks securely. IPsec is a common protocol suite used to encrypt these tunnels.

## Real-World Example
An employee working from a coffee shop connects to the corporate network using an **IPsec VPN**. They attempt to access an internal database. The corporate **Firewall** checks its **ACLs** and allows the secure VPN traffic. Later, a hacker attempts a port scan on the firewall; the **IPS** detects the malicious signature and instantly bans the hacker's IP address.
''',
      schedule: [
        ScheduleRow('9:00 – 11:00', 'Firewall Types', '📖 Study'),
        ScheduleRow('11:00 – 12:00', 'Writing ACLs', '💻 Lab'),
        ScheduleRow('12:00 – 13:00', '🍽️ Lunch Break', '—', isBreak: true),
        ScheduleRow('13:00 – 15:00', 'IDS vs IPS', '⚙️ Compare'),
        ScheduleRow('15:00 – 17:00', 'VPNs & IPsec', '🚀 Secure'),
        ScheduleRow('17:00 – 18:00', 'Revision', '📝 Summarize'),
      ],
      covered: ['ACLs', 'IPS', 'VPN'],
      qa: [
        QAItem('What is a Firewall?', 'A network security device that monitors and filters incoming and outgoing network traffic based on security rules.'),
        QAItem('IDS vs IPS?', 'IDS detects threats and alerts you. IPS detects threats and actively blocks them.'),
        QAItem('What is a VPN?', 'Virtual Private Network. It creates a secure, encrypted tunnel over the public internet.'),
        QAItem('What is Port 443?', 'The default port used for secure HTTPS web traffic.'),
      ],
    ),
    DayData(
      dayNumber: 6,
      title: 'Wireless Networking & Troubleshooting',
      subtitle: 'Wi-Fi Standards, Ping, Traceroute',
      tags: ['Wi-Fi', 'Troubleshooting'],
      explanation: '''
# Wireless Communications and Diagnostics

## 1. 802.11 Standards & Wireless Security
Wi-Fi operates on 802.11 standards using radio frequencies (2.4GHz for range, 5GHz for speed). Because radio waves travel openly through the air, encrypting the data using WPA3 (Wi-Fi Protected Access 3) is absolutely critical to prevent eavesdropping.

## 2. Ping & Traceroute
When networks fail, command-line tools are required. **Ping** sends an echo request to test basic reachability to an IP address. **Traceroute** maps the exact path and every router hop a packet takes, showing exactly where a connection drops.

## 3. Network Diagrams
Before troubleshooting, engineers create and read network topologies and diagrams to understand exactly how routers, switches, and firewalls are physically and logically connected.

## Real-World Example
A user complains the office **Wi-Fi** (running on **802.11**) is broken because they cannot reach a specific website. The network engineer opens a terminal and runs **Ping**. The ping works, proving the server is online. The engineer then runs **Traceroute** and discovers the connection drops exactly at the ISP's regional router. The engineer now knows the issue is with the ISP, not the local wireless network.
''',
      schedule: [
        ScheduleRow('9:00 – 11:00', '802.11 Standards', '📖 Study'),
        ScheduleRow('11:00 – 12:00', 'Wireless Security (WPA3)', '💻 Lab'),
        ScheduleRow('12:00 – 13:00', '🍽️ Lunch Break', '—', isBreak: true),
        ScheduleRow('13:00 – 15:00', 'Ping & Traceroute', '⚙️ Practice'),
        ScheduleRow('15:00 – 17:00', 'Network Diagrams', '🚀 Draw'),
        ScheduleRow('17:00 – 18:00', 'Revision', '📝 Summarize'),
      ],
      covered: ['Wi-Fi', 'Ping', 'Traceroute'],
      qa: [
        QAItem('What is the difference between 2.4GHz and 5GHz Wi-Fi?', '2.4GHz travels farther but is slower. 5GHz is faster but has a shorter range.'),
        QAItem('What does Ping do?', 'It sends an ICMP Echo Request to a target to check if it is reachable over the network.'),
        QAItem('What does Traceroute do?', 'It shows the exact path and every router hop a packet takes to reach a destination.'),
        QAItem('What is a MAC address filtering?', 'A security feature that only allows specific hardware MAC addresses to connect to a Wi-Fi network.'),
      ],
    ),
    DayData(
      dayNumber: 7,
      title: 'Advanced Concepts & Review',
      subtitle: 'SDN, QoS, Full Review',
      tags: ['SDN', 'QoS'],
      explanation: '''
# Modern Network Engineering

## 1. SDN & Network Automation
Traditional networking requires engineers to log into individual routers manually. **Software-Defined Networking (SDN)** centralizes control. A central software controller pushes configurations to hundreds of hardware devices simultaneously using automation APIs.

## 2. QoS (Quality of Service)
QoS is a feature that prioritizes certain types of network traffic over others. It ensures that time-sensitive applications (like voice or video calls) are processed before bulk data transfers (like file downloads).

## 3. Troubleshooting Scenarios
Tying everything together. Diagnosing complex outages requires a solid understanding of the OSI model, starting at Layer 1 (is the cable plugged in?) and moving up to Layer 7 (is the DNS server failing?).

## Real-World Example
In a crowded corporate office, 100 people are downloading large files while the CEO is hosting a critical video conference. Without intervention, the video call would freeze. The engineer configures **QoS** via their centralized **SDN** controller to prioritize VoIP (Voice over IP) traffic. The controller instantly updates all switches in the building. The downloads slow down slightly, but the CEO's video call remains perfectly clear.
''',
      schedule: [
        ScheduleRow('9:00 – 11:00', 'SDN & Network Automation', '📖 Study'),
        ScheduleRow('11:00 – 12:00', 'QoS (Quality of Service)', '💻 Lab'),
        ScheduleRow('12:00 – 13:00', '🍽️ Lunch Break', '—', isBreak: true),
        ScheduleRow('13:00 – 15:00', 'Troubleshooting Scenarios', '⚙️ Solve'),
        ScheduleRow('15:00 – 17:00', 'Mock Exam', '🚀 Practice'),
        ScheduleRow('17:00 – 18:00', 'Final Review', '📝 Summarize'),
      ],
      covered: ['SDN', 'QoS', 'Review'],
      qa: [
        QAItem('What is SDN?', 'Software-Defined Networking. It separates the control plane (brains) from the data plane (hardware) for centralized management.'),
        QAItem('What is QoS?', 'Quality of Service. It prioritizes specific network traffic (like Voice/Video) to ensure smooth performance.'),
        QAItem('What is VoIP?', 'Voice over IP. Technology that allows you to make voice calls using a broadband Internet connection instead of a regular phone line.'),
        QAItem('Why automate networks?', 'To reduce human error, deploy changes instantly across thousands of devices, and maintain consistency.'),
      ],
    ),
  ],
);

final List<TimetableData> allTimetables = [
  devopsData,
  awsData,
  networkingData,
];
