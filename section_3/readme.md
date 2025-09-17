# Section3: Design 2 (Architecture Design)
---

## A. Explanation on system flow and architecture
1. API Gateway exposes the API, triggering Lambda (Lambda to upload files 1) to store image metadata in DynamoDB and save raw image files to the S3 raw images bucket.

2. Amazon MSK (Kafka) receives messages, which are processed by Lambda (Lambda to upload files 2) to similarly store metadata in DynamoDB and upload raw images to the S3 raw images bucket.

## B. Assumptions
- The system is built using AWS-managed services.
- The client application restricts image uploads up to 10MB, aligning with API Gateway's payload limit.
- AWS Lambda restricts limits up to 15 minutes per execution and up to 10GB memory / 6 vCPUs.
- Terraform automates infrastructure provisioning, with its scripts stored and version-controlled in AWS CodeCommit.
- The system retains raw and processed images for up to 7 days to meet compliance requirements, so DynamoDB is used for storage. If long-term retention were required and cost were not a constraint, I would instead design the solution using Redshift.

## C. AWS-managed services used in this solution.

![view here](architecture_design.png)

### IAM (Identity and Access Management)
AWS’s service for securely managing users, groups, and permissions to control access to cloud resources.

### Amazon CloudWatch
A monitoring and observability service that collects and tracks metrics, logs, and events to provide real-time insights into AWS resources, applications, and infrastructure.

### AWS CodePipeline (CI/CD)
A fully managed service that automates continuous integration and continuous delivery, streamlining application and infrastructure updates.

### AWS CloudTrail: 
A service that records, monitors, and audits all API calls and account activity across AWS environments to ensure security and compliance.

### AWS Secrets Manager
Securely stores, manages, and rotates sensitive information—such as database credentials, API keys, and tokens—to protect access to applications and resources.

### AWS Key Management Service (KMS)
A managed service for creating, managing, and controlling cryptographic keys to securely encrypt and decrypt data across AWS services and applications.

### Amazon GuardDuty
A threat detection service that continuously monitors AWS accounts, workloads, and data for malicious activity and unauthorized behavior.

### Amazon API Gateway
A fully managed service that enables developers to create, publish, secure, and monitor APIs at any scale.

### Apache Kafka
A distributed streaming platform that allows real-time publishing, storing, and processing of high-throughput event and message streams.

### AWS Lambda
A serverless compute service that runs code in response to events without requiring you to provision or manage servers.

### Amazon DynamoDB
A fully managed, serverless NoSQL database that provides fast and predictable performance with seamless scalability.

### Amazon QuickSight
A cloud-based business intelligence service that enables users to create interactive dashboards, visualizations, and insights from their data.

### Amazon S3 (Simple Storage Service) bucket
A scalable, durable cloud storage container used to store and retrieve objects such as files, images, and backups.

### AWS CloudFormation
A service that allows you to define and provision AWS infrastructure as code using templates, enabling automated, repeatable, and consistent deployments