Platform : AVMS AWTDA Dev Tree
==============================

This page last changed on Feb 12, 2013 by flefevre.

This document serves as the specification for the general AirVantage
Management Services Device Tree Version 2. This specification applies
starting from Ready Agent v7.

Below is a list of the variables accessible by the device tree APIs.

Attached to this page is the C language header file (devtree\_v2.h) that
defines the standard API that is exported by shared object libraries
(.so files) that implement the device-specific bindings supporting this
tree structure. This header file MUST be kept in sync with the
specification in this page.

**NOTE:** This specification is currently incomplete. Furthermore, it is
inconsistent with what many devices actually provide. For example,
QMI-based devices provide many different RSSI values. Which one should
be used for "system.cellular.link.rssi"?

-   [Cellular Parameters](#AVMSAWTDADevTree-CellularParameters)
-   [ALEOS Custom Cellular
    Parameters](#AVMSAWTDADevTree-ALEOSCustomCellularParameters)
-   [I/O Parameters](#AVMSAWTDADevTree-I/OParameters)
-   [System Parameters](#AVMSAWTDADevTree-SystemParameters)
-   [Location Based Services
    Parameters](#AVMSAWTDADevTree-LocationBasedServicesParameters)
-   [WAN Link Parameters](#AVMSAWTDADevTree-WANLinkParameters)
-   [ALEOS Power Management
    Parameters](#AVMSAWTDADevTree-ALEOSPowerManagementParameters)
-   [Router Parameters](#AVMSAWTDADevTree-RouterParameters)

Cellular Parameters
-------------------

Parameter Path

R/W

Data Type

Data Range

Description

Device mgt parameters

system.cellular.apn.apn

RW

String

variable

configured APN (Use to set APN other than auto-configured)

system.cellular.apn.current

R

String

variable

current APN being used (e.g., if auto-configured)

Default Status Report

system.cellular.cdma.link.ecio

R

Double

CDMA current ECIO

Default Status Report

system.cellular.cdma.link.operator

R

String

variable

CDMA active link's operator

Default Status Report

system.cellular.cdma.link.pn\_offset

R

String

CDMA current PN offset

Default Status Report

system.cellular.cdma.link.sid

R

String

CDMA active link's sector ID (SID)

Default Status Report

system.cellular.cdma.link.nid

R

String

CDMA network identifer (NID)

Default Status Report

system.cellular.cdma.subscriber.nai

R

CDMA subscriber NAI

system.cellular.gsm.apn\_current

R

GSM current APN being used

system.cellular.gsm.apn\_selected

RW

GSM select pre-configured APN

system.cellular.gsm.apn\_status

RW

GSM APN configured (use to set custom APN)

system.cellular.gsm.link.cell\_id

R

String

GSM active link's Cell tower ID

Default Status Report

system.cellular.gsm.link.ecio

R

Double

GSM current ECIO

Default Status Report

system.cellular.gsm.link.operator

R

String

variable

GSM active link's operator

Default Status Report

system.cellular.lte.link.rsrp

R

Signed Integer

LTE Reference Signal Received Power (dBm) - in 1/10 dBm

Default Status Report

system.cellular.lte.link.rsrq

R

Signed Integer

LTE Reference Signal Received Quality (dB) - in 1/10 dB

Default Status Report

system.cellular.hw\_info.model

R

Product model of the cellular radio

system.cellular.hw\_info.imei

R

Cellular modem equipment ID (IMEI/ESN). \
This is mandatory and shall contain same identifier as the one used for
deviceId in Agent ConfigStore

Synchronize

system.cellular.link.bytes\_rcvd

R

Double

Number of bytes received on the cellular link this power cycle

Default Status Report

system.cellular.link.bytes\_sent

R

Double

Number of bytes sent on the cellular link this power cycle

Default Status Report

system.cellular.link.roam\_status

R

String

See desc.

Returns a string indicating the roaming status. Values are:\
 "No roaming" (domestic usage) \
 "International Roaming"

Default Status Report

system.cellular.link.channel

R

Wireless link channel

system.cellular.link.ip

R

String

Cellular connection IP address

Default Status Report

system.cellular.link.pkts\_rcvd

R

Double

Number of packets received on the cellular link this power cycle

Default Status Report

system.cellular.link.pkts\_sent

R

Double

Number of packets sent on the cellular link this power cycle

Default Status Report

system.cellular.link.rssi

R

Signed Integer

-150 - 0

Cellular link signal strength (dBm)

Default Status Report

system.cellular.link.service

R

String

Returns a string indicating the type of wireless service the device has:
\
 "None" \
 "GPRS" \
 "EDGE" \
 "UMTS" \
 "HSDPA" \
 "HSUPA" \
 "HSPA" \
 "1X" \
 "EV-DO Rev.0" \
 "EV-DO Rev.A" \
 "LTE" \
 "Unknown"

Default Status Report

system.cellular.link.state

R

Wireless link state: \
 0 - Link Down \
 1 - Link Up \
 2 - Link Inactive"

system.cellular.sim.iccid

R

SIM ID

Synchronize

system.cellular.sim.imsi

R

SIM Subscriber ID (IMSI)

Synchronize

system.cellular.sim.enable

RW

Set the Sim to Require Verification on startup \
 0 = Don't change \
 1 = Enable \
 2 = Disable

system.cellular.sim.pin

RW

PIN to enable SIM (Integer)

system.cellular.subscriber.phone\_num

R

Cellular subscription phone number (i.e. MDN) in international format.

Synchronize

system.cellular.sw\_info.fw\_ver

R

Cellular radio firmware version

system.cellular.tech

R

Wireless technology of the wireless radio (GSM vs. CDMA)

ALEOS Custom Cellular Parameters
--------------------------------

Parameter Path

R/W

Data Type

Data Range

Description

system.aleos.cellular.state

R

The cellular state of the radio. As the return value is specific to
ALEOS and it is located in the aleos sub-tree. \
 Returns a string reporting the state of the WWAN radio. The following
results are possible: \
 "Network Link Down" \
 "Connecting To Network" \
 "Network Authentication Fail" \
 "Network Negotiation Fail" \
 "Network Access Denied" \
 "Network Ready" \
 "Network Dormant" \
 "No Service" \
 "Hardware Reset" \
 "No SIM or Unexpected SIM Status" \
 "Provisioning..." \
 "Awaiting Provisioning" \
 "Data connection failed. Waiting to retry." \
 "SIM Locked, but bad SIM PIN" \
 "SIM PIN marked as bad, not attempted, Still 3 attempts left" \
 "SIM PIN incorrect 2 attempts left" \
 "SIM PIN incorrect 1 attempts left" \
 "SIM PIN incorrect 0 attempts left" \
 "SIM Blocked, Bad unlock code" \
 "SIM Blocked, unblock code incorrect" \
 "Starting OMADM state." \
 "In HFA.." \
 "In NI PRL Update." \
 "HFA FAILED." \
 "NI PRL Failed." \
 "NI PRL Failed.Waiting to retry." \
 "HFA FAILED.Waiting to retry." \
 "Unknown""

system.aleos.cellular.data\_usage.monthly\_units

RW

Monthly limit units \
 0 = MB \
 1 = GB

system.aleos.cellular.data\_usage.cur\_daily\_usage

R

Current daily data usage (MB)

system.aleos.cellular.data\_usage.daily\_limit

RW

Daily data usage limit (MB)

system.aleos.cellular.data\_usage.monthly\_limit

RW

Monthly data usage limit in units specifid by monthly\_units

system.aleos.cellular.data\_usage.monthly\_start\_day

RW

Day of the month for start of billing cycle (1-28)

system.aleos.cellular.data\_usage.monthly\_usage

R

Current monthly data usage (MB)

system.aleos.cellular.data\_usage.service\_status

R

Data usage service status \
 0 = Blocked - over usage limit \
 1 = Available - under usage limit

I/O Parameters
--------------

Parameter**Path**

R/W

Data Type

Data Range

Description

DM Parameter use

system.aleos.io.in1

R

The current value of the GX400 GPIO pin, 1 high, 0 low.

system.aleos.io.pulse\_cnt1

R

The amount of times the GPIO pin has gone low and then high

system.aleos.io.relay1.last

RW

Configures the GX400 GPIO defualt output value to maintain that of the
last setting.

system.aleos.io.relay1

RW

Represents the GX400 GPIO pin as a relay control, 0 close relay so
voltage high and 1 open relate voltage low. This is the opposite of
system.io.gpio.1

system.io.gpio.1

RW

Exposes the GX400 pin as a generic GPIO. Writing a value of 1 sets
voltage high, value of 0 sets voltage low. Reading the value returns 1
for high voltage and 0 for low voltage.

system.io.ignition\_in

R

Ignition sense pin value

system.io.powerin

R

Double

Voltage status of the input power pin on the GX-400 power connector
cable.

Default Status Report

system.aleos.reserve.dm

RW

Node used to determine whether ALEOS or AAF own access to the Qualcomm
diagnostics port.

system.aleos.reserve.ser0

RW

Node used to determine whether ALEOS or AAF own access to the physical
serial port.

System Parameters
-----------------

Parameter**Path**

R/W

Data Type

Data Range

Description

DM Parameter use

system.hw\_info.global\_id

The unique ID of the device. This is an alpha-numberic sequence. Aleos
only

system.hw\_info.hw\_ver

Device hardware revision

system.hw\_info.product\_str

Product model name \
Exple: LS300, GX400, AC771S

Synchronize

system.sw\_info.boot\_ver

system.sw\_info.fw\_ver

FW version/ FWrevision of the device. In this case the ALEOS version

Synchronize

system.sw\_info.fw\_name

FW name of the device.

Synchronize

system.advanced.board\_temp

R

Signed integer

Board temperature in °C

Default Status Report

system.advanced.radio\_temp

R

Signed integer

Temperature of the radio module in °C

Default Status Report

system.advanced.reset\_nb

R

Integer

Number of system resets

Default Status Report

Location Based Services Parameters
----------------------------------

Parameter**Path**

R/W

Data Type

Data Range

Description

DM parameter use

system.gps.fix

R

GPS fix status \
 0 = no fix, \
 1 = fix (gps.qual \> 0 AND sat\_cnt \>= 3))

system.gps.altitude

R

Double

variable

Altitude of latest location fix

system.gps.latitude

R

Double

variable

Latitude of latest location fix

Default Status Report

system.gps.longitude

R

Double

variable

Longitude of latest location fix

Default Status Report

system.gps.heading

R

Heading of latest location fix (degrees)

system.gps.speed

R

Speed of latest location fix (kph)

system.gps.qual

R

Quality of latest location fix \
 0 = no fix \
 1 = fix \
 2 = WAAS fix

system.gps.sat\_cnt

R

Satelite count of latest location fix

system.gps.seconds

R

Seconds portion of latest of latest location fix

system.gps.minutes

R

Minutes portion of time of latest location fix

system.gps.hours

R

Hours portion of time of latest location fix

system.gps.day

R

Day portion of date of latest location fix

system.gps.month

R

Month of date of latest location fix

system.gps.year

R

Year portion of date of latest location fix

WAN Link Parameters
-------------------

Parameter**Path**

R/W

Data Type

Data Range

Description

system.wan.vpn.1.auth

RW

IKE authentication algorithm \
 1 = MD5 \
 2 = SHA1 \
 3 = SHA-256

system.wan.vpn.1.encrypt

RW

IKE encryption algorithm \
 1 = DES \
 5 = 3DES \
 7 = AES-128 \
 9 = AES-256

system.wan.vpn.1.gateway\_address

RW

VPN gateway address

system.wan.vpn.1.gre\_ttl

RW

GRE tunnel time to live (TTL) in router hops

system.wan.vpn.1.ipsec\_auth

RW

IPSec Authentication Algorithm \
 Values: 0 = None, 1 = MD5, 2 = SHA1, 3 = SHA-256

system.wan.vpn.1.ipsec\_encrypt

RW

IPSec Encrytion Algorithm \
 0 = None \
 1 = DES \
 2 = 3DES \
 3 = AES-128 \
 5 = Cast128 \
 7 = AES-256

system.wan.vpn.1.ipsec\_key\_grp

RW

IPSec Key group \
 0 = None \
 1 = DH1 \
 2 = DH2 \
 5 = DH5

system.wan.vpn.1.ipsec\_sa\_life\_time

RW

IKE SA lifetime (180 - 86400)

system.wan.vpn.1.key\_grp

RW

IKE Key Group \
 1 = DH1 \
 2 = DH2 \
 5 = DH5

system.wan.vpn.1.lan\_addr\_ip

RW

Local address

system.wan.vpn.1.lan\_addr\_mask

RW

Local address netmask

system.wan.vpn.1.lan\_addr\_type

RW

Local address type \
 Values: 1 = use the host subnet, 5 = single address, 17 = subnet
address

system.wan.vpn.1.local\_fqdn

RW

Local or My identity FQDN when local\_id\_type = 2 or 3

system.wan.vpn.1.local\_id\_ip

RW

Local or My identity IP address

system.wan.vpn.1.local\_id\_type

RW

Local or My identity Type \
 1 = IP \
 2 = FQDN \
 3 = User FQDN

system.wan.vpn.1.mode

RW

Negotiation mode \
 1 = Main \
 2 = Aggressive

system.wan.vpn.1.peer\_id\_fqdn

RW

Peer or remote identity FQDN when peer\_id\_type = 2 or 3

system.wan.vpn.1.peer\_id\_ip

RW

Peer or remote identity IP address

system.wan.vpn.1.peer\_id\_type

RW

Peer or remote identity Type \
 1 = IP \
 2 = FQDN \
 3 = User FQDN

system.wan.vpn.1.pfs

RW

Perfect Forward Secrecy

system.wan.vpn.1.pre\_shared\_key

RW

Pre-shared key 1

system.wan.vpn.1.remote\_addr\_ip

RW

Remote address

system.wan.vpn.1.remote\_addr\_mask

RW

Remote address - netmask

system.wan.vpn.1.remote\_addr\_type

RW

Remote address type \
 5 = Single address \
 17 = Subnet address

system.wan.vpn.1.remote\_subnet

RW

Remote Subnet (IP Addr/Mask)

system.wan.vpn.1.sa\_life\_time

RW

IPSec SA life time

system.wan.vpn.1.status

R

VPN connection status \
 Possible values are: "Disabled", "Connected", "Not Connected"

system.wan.vpn.1.tunnel\_type

RW

VPN tunnel type \
 0 = Disabled \
 1 = IPSec \
 2 = GRE \
 3 = SSL

ALEOS Power Management Parameters
---------------------------------

Parameter**Path**

R/W

Data Type

Data Range

Description

system.aleos.low\_pwr.act\_duration

RW

Periodic time active duration before entering low power mode (HH:MM)
[00:05 - 23:59]

system.aleos.low\_pwr.delay

RW

Modem will enter low power mode after time delay (0 - 255 minutes)

system.aleos.low\_pwr.ignt\_sense

RW

Device will enter low power mode when \
 Enabled =1 \
 Disabled = 0

system.aleos.low\_pwr.inact\_dur

RW

Amount of time the modem is in Low Power state (HH:MM) [00:10-23:59]

system.aleos.low\_pwr.mode

RW

Low power mode \
 0 = None \
 1 = Time Delay \
 2 = Low Voltage \
 3 = Time delay+Low voltage \
 4 = Periodic timer \
 5 = Periodic Time Daily Mode

system.aleos.low\_pwr.start\_time

RW

Time at which the modem will become active (HH:MM) [00:00-23:59]

system.aleos.low\_pwr.voltage

RW

The low voltage threshold used to put the modem into low power mode (.1
volts)

system.aleos.low\_pwr.wake\_delta

RW

The voltage delta above the threshold used to wakeup the modem from low
power mode (.1 volts)

system.aleos.pwr\_state

R

Current state of power mode. \
 "INITIAL" \
 "ON" \
 "LOW DELAY" \
 "LOW PENDING 1" \
 "LOW PENDING 2" \
 "LOW FINAL" \
 "LOW"

Router Parameters
-----------------

**Parameter Path**

**R/W**

Data Type

Data **Range**

**Description**

system.aleos.lan.pppoe.passwd

RW

Configure the LAN host authentication mode \
 0 = NONE \
 1 = PAP and CHAP \
 2 = CHAP

system.aleos.lan.pppoe.user\_id

RW

LAN host user ID

system.aleos.lan.pppoe.auth\_type

RW

LAN host password

system.router.dhcp.netmask

RW

DHCP server netmask setting

system.ddns.service.device\_name

RW

Device name for DDNS services.

Attachments:
------------

![image](images/icons/bullet_blue.gif)
[devtree\_v2.h](attachments/37585105/39321900.h)
(application/octet-stream) \

Document generated by Confluence on Mar 11, 2013 16:17
