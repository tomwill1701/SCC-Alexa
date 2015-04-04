
Tom Williamson

Iron yard student

---

Current Career

MVS assembler programmer for over 35 years with DTS Software in Raleigh, NC

(what is MVS?)

---

MVS/Zos (Multiple Virutal Storage) is the operating system used on large scale IBM mainframes

Released in 1974

Still used by many large corporations for batch and transaction processing

---

Demo application name

SCC-Monitor (Storage Control Center)

---

SCC-Monitor is a web interface to a product with the same name that is sold by DTS Software

This product provides alerts and reports for MVS subsystems

When run on MVS, SCC-Monitor can only produce old style column/row reports

---

App will allow real-time access to the MVS reporting information and produce Grids and Charts

App consists of:

---

* Users in multiple groups
* Systems/images (called LPARs) in multiple groups (called SYSPLEX)
* Commands in groups that request data from SCC-Monitor (API)
* Jobs are defined to make Command request to LPARs
 * Jobs can have more than one reguest for data and/or display
* Jobs are "run" to actually get the data and display it

---

Technology used:

* Rails
* Heroku
* ActiveAdmin
* typhoeus (concurrent tcpip)
* haml
* ransack (search)
* formtastic
* ActiveMailer

---

* Zlib (compress raw data)
* cocoon (formtastic one-to-many forms)
* delayed job (with activejob)
* Kaminari (pagination)

- Google Charts
- dhtmlgrid

- 20 Models


---

My Goals

To remember how all this works two years from now

---

Contact Me at:

tom@dtssoftware.com

www.dtssoftware.com







