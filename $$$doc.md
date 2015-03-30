# Models

- User
- UGroup
- User_Ugroup (join)

- LPAR
- LGroup
- LPAR_LGroup (join)

- Command
- CGroup
- Command_Cgroup (join)

- Job
- JobItem

- Run
- RunCommand
- RunView

- CommandLoad
- CommandLoadItem

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

- For External command build email with attachment
- Use S3 for attachments (PDF)
- Drill down from one command to another based on keys or target command
- Allow ruby code to post-process the grid data acquired

# Gems
- ActiveAdmin
- Fog
- Draper
- typhoeus (concurrent tcpip)
- haml
- bcrypt (signon)
- ransack (search)
- formtastic
- cocoon (formtastic one-t0-many forms)
- delayed job (with activejob)
- bootstrap-datepicker (search dates)
- Mailer

# Other technology
- Google Charts
- dhtmlgrid

