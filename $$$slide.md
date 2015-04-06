
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

Why am I here?

When I started there was no PCs or internet.  Just punched cards and paper tape.

NO expereience with any Web based systems.  No html/css/java script/backend.

Wanted to understand how web application were written.

Much better weather in Florida!

---

Demo application name

SCC-Monitor (Storage Control Center)

---

SCC-Monitor is a web interface to a product with the same name that is sold by DTS Software

This product provides alerts and reports for MVS subsystems

When run on MVS, SCC-Monitor can only produce old style column/row reports (green bar paper)

---

App will allow real-time access to the MVS reporting information and produce
interactive Grids and Charts

App consists of:

---

* Users
* Systems/images (called LPARs) where information is obtained
* Commands that request information from system (API request)
* Jobs are created to make Command (API) request to LPARs (Systems)
 * Jobs can have more than one reguest for information and/or display
* Jobs are "run" to actually get the data and display it

---

https://sccdemo.herokuapp.com


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
- dhtmlxgrid

- 20 Models


---

My Goals

To remember how all this works two years from now

---

Contact Me at:

tom@dtssoftware.com

www.dtssoftware.com

---

to do:

* Spinner has wrong font
* tabs will not show selection
* Select runs to delete from list
* Prompts
* drill down
* merge grids










