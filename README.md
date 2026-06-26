# perfSONAR Workshop Kit

This repository contains utilities for setting up an archive and web
server for perfSONAR workshops.

**THIS IS A WORK IN PROGRESS.**


## Installation

Log into the archive system:
```
ssh -i ssh-key psworkshop@ARCHIVE-SYSTEM-IP
```

Clone this repository:
```
git clone https://github.com/perfsonar/workshop.git
```

Change into the workshop directory:
```
cd workshop
```

Obtain a list of the hosts for the workshop and collect it into a CSV
file named `hosts.csv`.  Format is described in `hosts-sample.csv`.
There must be one host named `archive` which as the archive system's
IPs.


TODO: Finish this.
