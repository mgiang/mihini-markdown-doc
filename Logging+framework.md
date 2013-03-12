Platform : Logging framework
============================

This page last changed on Jan 31, 2013 by lbarthelemy.

Logging framework
=================

![image](images/icons/emoticons/warning.png)

Logging framework is only available within Lua VM.

Log display
===========

How to use log framework to print a log trace:

~~~~ {.theme: .Confluence; .brush: .java; .gutter: .false
style="font-size:12px;"}
local log = require"log"

log(module, severity, fmt, ...)
~~~~

fmt parameter (and next ones) is to be used to format text like in print
function.

Example
-------

~~~~ {.theme: .Confluence; .brush: .java; .gutter: .false
style="font-size:12px;"}
log("GENERAL", "INFO", "Starting %s", "some module")
~~~~

produces following output:

~~~~ {.theme: .Confluence; .brush: .java; .gutter: .false
style="font-size:12px;"}
2011-01-26 11:31:59 GENERAL-INFO: Starting some module
~~~~

Format configuration:
---------------------

Those parameters can be modified using ReadyAgent Config (see Config
section), or directly by modifying module values:

-   log.format\
     string used to apply specific formating before the log is outputted
    \
    within a format, the following token are available (in addition of
    standard text)
    -   %l =\> the actual log (given in 3rd argument when calling log()
        function)
    -   %t =\> the current date
    -   %m =\> module name
    -   %s =\> log level (severity)\
         if format is set to false/nil then default format is used: "%t
        %m-%s: %l"

-   log.timestampformat\
     string to define the format of the timestamp, same format as what
    os.date takes\
     It applies only if %t is in log.format parameter.

#### Fallback printing

Log module can fail to format log because of :

-   bad configuration of previous parameters
-   bad usage, like string formating with nil parameter (e.g
    log("Something", "INFO", "%s", nil) )

When such an error is detected, the log uses fallback printing and
produces something like:

~~~~ {.theme: .Confluence; .brush: .java; .gutter: .false
style="font-size:12px;"}
Error in the log formating! (bad argument #2 to '?' (string expected, got no value)) - Fallback to raw printing:
module=(something), severity=(INFO), format=("%s"), args=()
~~~~

![image](images/icons/emoticons/information.png)

Fallback printing output is stored like any other log when using log
storing policies

Log filtering
=============

Before being printed or stored, log are filtered depending on the
severity (i.e. ordered levels) chosen for the log.\
 The filtering is done by module:

-   you can define a minimum level for each module, log with level
    strictly below minimum level are not displayed.
-   however, if a module has no specific level configured, a defautlevel
    is used.

Log level per module can be configured either by using ReadyAgent
config, or using log.setlevel function

Here is the order of the levels configuration, from the most restrictive
to the most verbose level:\
 'NONE', 'ERROR', 'WARNING', 'INFO', 'DETAIL', 'DEBUG', 'ALL'

Filtering examples:\
 if "TEST" module minimum level is set to "WARNING", then a call to
log("TEST", "INFO", "something") will not be discarded.

If the log severity is not in previous level list, the log is not
filtered.

![image](images/icons/emoticons/information.png)

Log filtering applies for both printing and storing logs, i.e. if a log
is filtered/discarded, log storing policies don't apply for this log.

Log colors
==========

Only, ERROR, WARNING, DEBUG, INFO, DETAIL have custom colors that can be
changed for now.\
 Log colors are added in ReadyAgent, standalone log module doesn't
produce color.\
 To be activated, config.log.enablecolors has to be set.

Once activated, the **terminal emulator** has to **support the ASCII
control characters** used to produce the colors.

![image](images/icons/emoticons/information.png)

Log colors are not stored when using log storing policies.

Log policies
============

A log policy is to determine how/when to store logs in flash/persistent
storage, eventually using a RAM buffer to store them temporarily.

### Main features / Overview

-   Only available from Lua
-   Storing logs in flash and ram buffers
-   Retrieve logs stored flash and ram using AWT-DA command
-   Log size (in flash and ram) configurable
-   Log storing does not depend on ReadyAgent
-   Lua Log API is common between Open AT and Linux devices

Existing Policies:\
 Note: Each policy needs to have parameters to be initialized.

-   **context**:\
     Store in flash logs that reach the configured level plus the
    preceding cached log entries coming from ram buffer:\
     i.e. store all logs entries in ram, except the logs with a higher
    severity level than the level config parameter.\
     When a log with an higher severity level is outputted (log level
    severity \>= level config paramater severity), \
     the ram buffer is copied in flash, followed by the current log.\
    parameters:
    -   level: optional, minimum severity level that triggers the copy
        of RAM log buffer to flash storage. Default value is set to
        ERROR.\
         E.g.:if level is set to "WARNING", logs with ERROR or WARNING
        levels will trigger copy of RAM log buffer to flash storage, and
        then be copied to flash too.
    -   ramlogger: mandatory, table with parameters to init RAM buffer
        (size) , see [Log storing internal API and implemetation
        details](Log%2Bstoring%2Binternal%2BAPI%2Band%2Bimplemetation%2Bdetails.html)
        for details.
    -   flashlogger: mandatory, table with parameters to init flash
        buffer (size, path (optional), ...), see [Log storing internal
        API and implemetation
        details](Log%2Bstoring%2Binternal%2BAPI%2Band%2Bimplemetation%2Bdetails.html)
        for details.

-   **sole**:\
     Store in flash all logs entries with higher severity than the
    configured level. No context is stored, only the sole log entry.\
     If ram buffer is activated, store all logs in RAM.\
    parameters:
    -   level: optional, minimum severity level to trigger log entry
        writing to flash. Default value is set to WARNING.\
         E.g.: if level is set to "WARNING", each log with ERROR or
        WARNING levels will be written to flash storage.
    -   ramlogger: optionnal, table with parameters to init RAM buffer
        (size) , see [Log storing internal API and implemetation
        details](Log%2Bstoring%2Binternal%2BAPI%2Band%2Bimplemetation%2Bdetails.html)
        for details.
    -   flashlogger: mandatory, table with parameters to init flash
        buffer (size, path (optional), ...), see [Log storing internal
        API and implemetation
        details](Log%2Bstoring%2Binternal%2BAPI%2Band%2Bimplemetation%2Bdetails.html)
        for details.

-   **buffered\_all**:\
     Each log entry is stored in ram, then when the ram buffer is full,
    the buffer is stored in flash.\
    parameters:
    -   ramlogger: mandatory, table with parameters to init RAM buffer
        (size) , see [Log storing internal API and implemetation
        details](Log%2Bstoring%2Binternal%2BAPI%2Band%2Bimplemetation%2Bdetails.html)
        for details.
    -   flashlogger: mandatory, table with parameters to init flash
        buffer (size, path (optional), ...), see [Log storing internal
        API and implemetation
        details](Log%2Bstoring%2Binternal%2BAPI%2Band%2Bimplemetation%2Bdetails.html)
        for details.

![image](images/icons/emoticons/information.png)

For now, those limitations apply to log policies:

-   Log policy can be configured only on boot.
-   A log policy can be added only by modifying logtools.lua in
    trunk/luafwk
-   Existing log policies cannot be stopped dynamically once configured.
-   Only one log policy can be active at the time.

More details about implementation and low level API can be found in [Log
storing internal API and implemetation
details](Log%2Bstoring%2Binternal%2BAPI%2Band%2Bimplemetation%2Bdetails.html)

Log upload AWT-DA Command
=========================

Note: feature for ReadyAgent only

-   FTP or HTTP Post (Not supported yet)
-   upload of logs stored in flash or in ram

In order to identify the uploaded logs, the file is uploaded with this
name

![image](images/icons/emoticons/information.png)

ReadyAgent\_deviceid\_type\_ts.log

where some fields are dynamic:

-   deviceid is the device unique id
-   type is ram or flash, to indicate if uploaded logs come from ram or
    flash space.
-   ts is the timestamp of log upload action.

For LogUpload command description, please see : [Device
Management](Device%2BManagement.html) page.

### FTP upload security

For FTP upload, the ReadyAgent can used user/pwd parameters to upload to
a FTP server which requires to login.\
 Those parameters are to be set in ReadyAgent Configuration. Please
refer to ReadyAgent Configuration log subsection to correctly set FTP
user and password parameters.

Attachments:
------------

![image](images/icons/bullet_blue.gif)
[Présentation1.jpg](attachments/21397910/21529018.jpg) (image/jpeg) \

Document generated by Confluence on Mar 11, 2013 16:15
