Platform : GPIO module
======================

This page last changed on Dec 14, 2010 by dfrancois.

Overview
========

The GPIO module is an embedded module fully written in C. It allows to
read and write to GPIOs values.

Lua API
=======

### **Digital Inputs**

-   **initialization:** newDigitalInputs(table, config{name= 'varname',
    pin= pinId,logic = 'negative' or 'positive'}, pollingperiod)\*\*
    table is a table into which inputs values will be set. Can be nil if
    pollingperiod is set to 0.
    -   config is the list of digital inputs to configure where each
        element is a table with keys:
        -   **pin** : the id of the pin.
        -   **name**: The lua variable name mapped for this pin / port
        -   **logic:** Logic to be applied. When positive low = 0 and up
            = 1, if negative up = 0, low = 1

    -   pollingperiod, in ms. must be \>= 100 or equals to 0. In this
        case, no polling period will be performed (read mode).
    -   This function returns an instance of gpio poller. When this
        poller will be released no input will be read anymore. In case
        of error, it returns nil and an error.

For example :\
 poller\_instance, err = gpio.newDigitalInputs(system, { { name='I0',
pin=7, logic='positive'} , { name='I1', pin=10, logic='negative'} },
200)

will configure the pin 7 and 10 as inputs and mapped their value
respectively to system.I0 and system.I1. Those GPIOs will be read every
200ms.

-   **read:** poller\_instance:read('gpio\_name')\*\* Reads and returns
    the value of the digital input with the given name. If not nil,
    updates the value of the table given at initialization.

-   **release:** poller\_instance:release()
    -   Release the poller\_instance. Inputs will be not read anymore.

It is possible to create many pollers with different inputs and
different polling periods.

It is not possible to simultaneously use the same input in different
pollers.

### **Digital Outputs**

-   **initialization:** newDigitalOutputs(config{name = 'varname', pin =
    pinId, logic = 'negative' or 'positive'}, [blink\_time\_unit])
    -   **config is the list of digital outputs to configure where each
        element is a table with keys:**
        -   **pin** : the id of the pin.
        -   **name**: The lua variable name mapped for this pin / port
        -   **logic:** Logic to be applied. When positive low = 0 and up
            = 1, if negative up = 0, low = 1
        -   **blink\_time\_unit:** blink period factor in ms. Optional,
            if set should be at least equal to 100.

    -   This function returns an instance of gpio output. When this
        instance is released no output can be written anymore. In case
        of error, it returns nil and an error.

For example :\
 output\_instance, err = gpio.newDigitalOutputs({ { name='DO1',
pin=22,logic='positive'} }, 200)

will configure the pin 22 as an output and define the blink period
factor at 200ms

-   **write:** output\_instance:write('gpio\_name', value)\*\* Write
    value *value* into the gpio with given name. Returns "ok" on success
    or nil followed by an error otherwise.

-   **blink:** output\_instance:blink('gpio\_name', on\_period,
    off\_period, nb\_period, [start\_value])\*\* **gpio\_name**: name of
    the output to "flash"
    -   **on\_period:** up level period =\> up time = on\_period \*
        blink\_time\_unit
    -   **off\_period:** off level period =\> off time = off\_period \*
        blink\_time\_unit
    -   **nb\_period:** numbers of time to execute the blinking. If nil
        or equals to 0 the blink is infinite.
    -   **start\_value:** Optional, if define the blinker will start
        with this value. Default is 0
    -   Calling twice the blink function on the same output will
        reconfigure the blink with the last call parameters

-   **stopblink:** output\_instance:stopblink('gpio\_name')\*\* Stop the
    blink of given gpio
-   **release:** output\_instance:release()
    -   Release the output\_instance. Outputs can not be written
        anymore.

It is possible to create many pollers with different outputs and
different polling periods.

It is not possible to reconfigure an ouput.

### **Analog Inputs**

-   **initialization:** newAnalogInputs(table, config {name= 'varname' ,
    id = id, deadband = 'deadband', scalefactor = 'scalefactor', offset
    = 'offset'}, pollingperiod)\*\* table is a table into which inputs
    values will be set. Can be nil if pollingperiod is set to 0.
    -   config is a list of analogs configuration table:
        -   **id**: the id of the pin or a list of pins to configure a
            analog input port.
        -   **name**: The lua variable name mapped for this pin / port
        -   **deadband**: range of values in which analog input will be
            not updated
        -   **scalefactor**: Multiplier factor divided by 65536, i.e to
            multiply acquired value by 2 scalefactor must be 131072 (2
            \* 65536), to divide acquired value by 4, scalefactor must
            be 16384 (65536/ 4)
        -   **offset**: positive or negative value to be added to the
            result of read value multiplied by the scalefactor (i.e:
            applicative\_value = readvalue \* scalefacor + offset)

    -   pollingperiod: in ms, must be at least 500 \* numbers of
        configured analogs. Delay between two consecutive read. Can be
        equals to 0 if no polling is necessary. (read mode)
    -   In case of success, this function return an instance of gpio
        poller. When this poller will be released no input will be read
        anymore. In case of error, it returns nil and an error.

For example :\
 poller\_instance, err = gpio.newAnalogInputs(system, { { name='AI0',
id=0, deadband = 100, scalefactor = 65536, offset = 10} ,{ name='AI1',
id=1, deadband = 10, scalefactor = 131072, offset = 120} }, 1000)

Will read every 500ms (1000 / numbers of pins) the value of an analog
inputs: At t=0ms, pin 7 will be read and its lua value will be updated
if the read value goes outside the limited range computed with the
deadband value (100here). At t=500ms will do the same actions but with
pin 22. At t=1s the pin 7 will be read....

For the M2MBoxPro valid ids are: 0 for AI0, 1 for AI1, 2 for temperature
sensor, 3 for power supply mode / battery level.

-   **read:** poller\_instance:read('analog\_name')\*\* Reads and
    returns the value of the analog input with the given name. If not
    nil, updates the value of the table given at initialization.

-   **release:** poller\_instance:release()
    -   Release the poller\_instance. Inputs will be not read anymore.

It's not possible to have two instances of analog inputs pollers. So to
'add' inputs to read, release the first instance, and then create
another instance with all wanted inputs

Document generated by Confluence on Mar 11, 2013 16:17
