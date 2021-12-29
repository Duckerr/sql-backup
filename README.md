
# SQL Backup

These bat scripts dumps SQL Databases into an .sql file, then uses 7zip to compress them


## Authors

- [@duckerr](https://www.github.com/duckerr)
- Random snippets referenced from StackOverflow


## Requirements

7zip

MySQL 8.0 or XAMPP


## Installation

Edit either script, depending on if you are using MySQL or XAMPP,  enter the correct DB credentials, and correct PATHS to files and folders needed. 

For the XAMPP script, enter the name of the Database you want to backup at line 43. 

For this to be automated, we will use the Task Scheduler within Windows. 

Open Task Scheduler, and create a task. 

Choose a name, select the options "Run whether user is logged on or not", and the "Hidden" checkbox. 
 
 Next, go to the Actions tab and make a new one. Select the path to the script, and click OK. 
 
 Next, to to Triggers and click New. Choose One time, then check the box that says "Repeat task every:" and choose a time. Make sure the "for a duration of:" is set to Indefinitely, and the "Enabled" box at the bottom is checked. 
 
 Finally, start the task.
    