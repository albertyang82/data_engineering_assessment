# Section 1: Data Pipeline
---

# Table of Contents
- [Overview](#overview)
- [Assumptions](#assumptions)
- [Solution](#solution)

# Overview
This document outlines the setup and function of a data pipeline. It describes how the pipeline processes input files, cleanses the data, and then sorts the resulting records into "successful" and "failed" categories, which are then stored in designated output folders

[Back to Top](#table-of-contents)

# Assumptions
1. **Software:** This solution requires Python and Jupyter Notebook. You'll need to install Python, the pandas library (pip install pandas), and Jupyter Notebook.
2. **Hosting:** The pipeline is designed to be hosted on Amazon Web Services (AWS), using EventBridge for scheduling.
3. **File Structure:** The solution relies on a specific folder structure:
	- input/: For source files awaiting processing.
	- output/success/: For successfully processed files.
	- output/fail/: For files that failed processing.
	- archive/: For storing already processed files to prevent reprocessing.
	
[Back to Top](#table-of-contents)	

# Solution
The core of this solution is a Python script (section_1.ipynb) that reads, processes, and cleanses the input files. The output files are saved with a timestamp (YYYYMMDDHHMISS) appended to their names to prevent overwriting. For example:
	- Successful files: output/success/<original_input_file>_success_YYYYMMDDHHMISS
	- Failed files: output/fail/<original_input_file>_fail_YYYYMMDDHHMISS

After a file is processed, it is automatically moved to the archive folder. This ensures the pipeline only processes new files dropped into the input folder.

**EventBridge Scheduling**  
The pipeline is scheduled to run hourly using AWS EventBridge. You can set this up with the following steps:
1. Navigate to EventBridge > Scheduler > Schedules and click "Create schedule".
2. Provide a schedule name, such as section_1.
3. Select a recurring schedule and choose the cron-based schedule option.
4. Enter the expression 0 * * ? * * for an hourly schedule.
5. Set the Target Detail to "AWS Lambda" and select the appropriate Lambda function.
6. Skip the remaining settings and click "Create schedule".	

[Back to Top](#table-of-contents)