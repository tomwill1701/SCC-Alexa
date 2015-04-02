# Using the app

- Only admin can create users/lpars/commands
- User login and creates jobs
- Jobs consists of entries of LPAR / Command
  - Each entry tells what command to run and where to run it
- Jobs are run and once all the data is acquired a Run View is created
- Job can get data from rails cache or web request
- Job can run "real-time" or bacground (activejob) - email sent once active job finshed
- Views are use to display the data in text/grid/chart form
- More than one View per job

- Activeadmin used for User/Group Lpar/group Command/Group
- Only models that app needs is Job (plus job-items) / Runs (plus Data / plus Display)
- There is also a simple notifications table  
- only four controllers: Application / Jobs / Runs / Run_Views  


# Models

- User (activeadmin)
- UGroup (activeadmin)
- User_Ugroup (join)

- LPAR (LPAR is a system or image to talk to) (activeadmin)
- LGroup (activeadmin)
- LPAR_LGroup (join)

- Command (activeadmin)
- CGroup (activeadmin)
- Command_Cgroup (join)

- CommandLoad (just used to load/import commands) (activeadmin)
- CommandLoadItem (activeadmin)

- Job
- JobItem

- Run
- RunCommand
- RunView

- Notice

# Controllers

- Application
- Welcome + About page
- Home (once login)

- User (for profile only)

- Jobs
  - CRUD + Favorite/Unfavorite/Run/Clone
  - Can only edit/delete Job that you created
  - Can copy/clone another non-private job
  - Each job contains multiple JobItem (LPAR/Command)
  - Index search using ransack

- Runs
  - Index/Show/Destroy
  - Index search using ransack

- Run_views
  - Show entire job output (all run_views = Index?)
  - Show just one part of job (one run_view = Show?)

# Features

- Code uses groups for all functions
- User belongs to more than one group + individual group
- LPARS in groups (SYSPLEX)
- Commands in groups
- Setup LPAR (activeadmin) test connection
- Download command definitions from LPAR (activeadmin)
- Signon with local or LPAR password
- Prompt for userid/password for LPAR

- Commands can be Text, Grid, Chart, External
- Command has cache keep time
- Test for all cache first
- More than one tcpip request at a time
- Command can run local or ActiveJob
- Show staus of activejob run
- Email when activejob run finishes

- View can show entire run output
- View can just show part of run (one command/view)
- View can also show raw data from tcpip request
- Email should have links to Views

- Prompt for other values in commands (IF TIME)
- For External command build email with attachment (IF TIME)
- Use S3 for attachments (PDF) (IF TIME)
- Drill down from one command to another based on keys or target command (IF TIME)
- Allow ruby code to post-process the grid data acquired (IF TIME)

# Gems
- ActiveAdmin


- typhoeus (concurrent tcpip)
- haml
- bcrypt (signon)
- ransack (search)
- formtastic
- cocoon (formtastic one-to-many forms)
- delayed job (with activejob)
- bootstrap-datepicker (search dates)
- Kaminari (pagination)
- GoogleVisualr

# Other technology
- ActiveJob
- Mailer
- Google Charts
- dhtmlgrid

