ConfigStore
======================

## Access to the configuration

The following configuration elements are accessible through different
APIs/Protocols.

#### From the Server through M3DA

The configuration table can be read (M3DA Command *ReadNode*) and
written (Data writing).

The path of the elements is prefixed by the path '@sys.config'.

#### From The Lua Shell:

In the Lua Shell you can access the configuration table thanks to the
'agent.config' module:

    -- Load/retrieve the config module
    c = require 'agent.config'
    -- print all config from the mediation sub category
    p(c.mediation)
    -- assign a new parameter (de-activate mediation stuff)
    c.mediation.activate = false

#### From the asset application:

See DeviceTree library API. A couple of function for setting and reading
variables are provided.\
 Generated doc is available here:
[http://docs.anyware/platform/embedded/](http://docs.anyware/platform/embedded/)

Most likely, user will need the following command:

    dt = require "devicetree"
    dt.init()
    :dt.get("config")
    -- user may append strings after config in order to browse deeper into the tree, e.g. ":dt.get("config.server.autoconnect")"

#### From AT Shell (OpenAT Only)

    at+lua="c = require 'agent.config' ; c.network.bearer.GPRS= {apn='orange.fr', retry = 2 , retryperiod = 50}"
    OK

## How does the Config Store works

#### Default configuration

The ReadyAgent comes with a default configuration that can be altered
and restored at any time. The default configuration of the ReadyAgent is
specified into the file **defaultconfig.lua** that comes with the
ReadyAgent. The ReadyAgent must be redeployed (build/installed) in order
to change the **defaultconfig.lua**.

#### Persisted configuration

In addition of the defaultconfig.lua it is possible to modify the
ReadyAgent configuration at anytime.\
 When changed the configuration entries are persisted into a non
volatile storage area.\
 On OpenAT it uses ADL Flash Objects. The object is named
"ConfigStore".\
 On Linux and similar OS it uses a QDBM file stored into a flash file
system. By default, the ConfigStore is stored into
"./persist/ConfigStore" file, relative to the directory where the
ReadyAgent is executed.

#### Configuration loading workflow

When the ReadyAgent starts it looks if it has an already stored
configuration (ConfigStore). If it does not find one then (and only
then) it uses the **defaultconfig.lua** as a default configuration, and
create the ConfigStore object. This means that changing the
**defaultconfig.lua** after the first start of the ReadyAgent, ***will
not*** change the current configuration of the ReadyAgent. A call to
config.default() method is necessary to reload the default
configuration.

The configuration tree is stored in persisted memory (flash). Any change
to the configuration is written synchronously, meaning that the settings
are persisted as soon as returning from a 'set' function.

#### ConfigStore API

The Configuration module has an API to manipulate the configuration
store, in a lua shell you can type:

    agent.config.default(path)   -- reloads the configuration subtree 'path' from the defaultconfig.lua file.
    agent.config.diff(path)      -- returns a list of items that are different from the default config.
    agent.config.pdiff(path)     -- pretty print the above list
    agent.config.set(path, value)-- set a value in the configuration
    agent.config.get(path)       -- gets a value for the configuration subtree

## Configuration parameters that can be applied to Mihini

#### Agent generic settings

--Defines the local port on which the agent is listening in order to communicate with the assets

agent.assetport = 9999

--Address on which the agent is accepting connection in order to communicate with the assets

--Pattern is accepted: can be set to "\*" to accept connection from any address, by default shell accepts only 
localhost connection.

 --agent.assetaddress = "\*"

--Devices ID used to communicate with the platform server
 agent.deviceId = "012345678901234"

--Device type, for example to be used in Update before accepting an
update.
 --Not used on Open AT for now.
 agent.devicetype= ""

--Defines the local port on which the agent is listening in order to
receive LUASIGNAL from external applications (Linux only)
 agent.signalport = 18888

--Persistence options
 agent.persistlatency = 60 --latency before data persistence in seconds,nil to disable
 agent.persistsize = 20000 --max byte length

#### Server connection settings

--URL on which the agent will try the server connection. This parameter
is only relevant for HTTP transport protocol\
 server.url = "http://m2mop.net/device/com"

--When the device is behind a proxy this settings defines a HTTP proxy.
This parameter is only relevant for HTTP transport protocol\
 --server.proxy must be a URL starting by "http://".\
 server.proxy = "some.proxy.server"

--Agent auto connection policy\
 server.autoconnect = {}\
 --server.autoconnect.onboot = true -- connect a few seconds after the
ReadyAgent started\
 --server.autoconnect.period = 5 -- period in minute (connect every 5
minutes)\
 --server.autoconnect.cron = "0 0 \* \* \*" -- cron entry (connect once
a day at midnight)\
 server.autoconnect.ondemand = 10 -- latency before connection (in
seconds) after some data has been given to the ReadyAgent before it
connects to the server (connect will occur at maximum 10 seconds after
some data has been written)

#### Mediation protocol settings

--Activate or de-activate the mediation client on the device\
 mediation.activate = true\
 --Connection timeout (in seconds)\
 mediation.timeout = 5\
 --Defines the ordered list of mediation server to connect to\
 mediation.servers = { {addr = "webplt-qa.anyware-tech.com", port =
2048}, {addr = "m2mop.anyware-tech.com", port = 2048} }\
 --this is equivalent to\
 --mediation.servers[1].addr = "webplt-qa.anyware-tech.com"\
 --mediation.servers[1].port = 2048\
 --mediation.servers[2].addr = "m2mop.anyware-tech.com"\
 --mediation.servers[2].port = 2048

--Defines the polling period (in seconds) of the mediation protocol
according to each bearer\
 --When period is set to 0, it will do a one time polling when the
bearer is mounted.\
 --If a bearer is absent from this list, mediation protocol is not used
on that bearer\
 mediation.pollingperiod = { ETH=0, GPRS=10}\
 --this is equivalent to\
 --mediation.pollingperiod.ETH=0\
 --mediation.pollingperiod.GPRS=10

--Defines the number of attempts before considering current mediation
servers as dead\
 mediation.servers.retries = 5

--Mediation restart after failure delay (in seconds), default value (if
not set) is 1800 seconds (30 minutes)\
 mediation.retrydelay = 300

#### Shell related settings

--Activate the Lua Shell\
 shell.activate = true\
 --Local port on which the Lua Shell server is listening\
 shell.port = 2000\
 --Address on which the Lua Shell server is accepting connection\
 --Pattern is accepted: can be set to "\*" to accept connection from any
address, by default shell accepts only localhost connection.\
 --shell.address = "\*"\
 shell.editmode = "edit" -- can be "line" if the trivial line by line
mode is wanted\
 shell.historysize = 30 -- only valid for edit mode

#### Time related settings

-- activate Time Services (see ntppolling config param): sync can be
done on demand using synchronize API. \
time.activate = true

--timezone: signed integer representing quarter(s) of hour to be added
to UTC time (examples: -4 for UTC-1, 23 for UTC+5:45, ...) \
time.timezone = 0\
-- daylight time saving: signed integer (1, -1) to be added to UTC \
time.dst = 0

-- NTP params \
time.ntpserver = "pool.ntp.org"

--polling period for auto time sync \
--whatever ntppolling value, time sync is done on ReadyAgent boot if
Time and NetworkManager are activated \
--if ntppolling is set to 0 or nil value, no periodic time sync is done
\
--if set to string value, it will be interpreted as a cron entry (see
timer.lua doc) \
--else positive number representing minutes is expected to specify
periodic time sync \
time.ntppolling = 0

#### Modem configuration

--activate\
 modem.activate = true\
 --SIM pin code\
 modem.pin = ""

--AT Serial interface (Linux Only)\
 modem.atport = "/dev/ttyS0"\
 --PPP Serial port\
 modem.pppport = "/dev/ttyS2"\
 --export sms api to assets\
 modem.sms = true

#### Network connectivity settings

-- Activate / deactivate the NetworkManager\
 network.activate = true

-- FakeNetman Signal\
 -- When non nil and network.activate==false then the signal("NETMAN",
"CONNECTED", network.initsignal) is emitted when the ReadyAgent is
initialized\
 network.initsignal = "Default"

--Maximum failures on bearer selection\
 --network.maxfailure = 2

--List of supported bearers and ordered priority\
 network.bearerpriority = {"ETH","GPRS"}\
 --this is equivalent to\
 --network.bearerpriority[1] = "ETH"\
 --network.bearerpriority[2] = "GPRS"

--amount of time to wait before going back to the preferred bearer if
connected bearer is not the first of bearerpriority list.\
 --if set to nil or equals to 0 netman will never go back automatically
to first bearer.\
 network.maxconnectiontime = 30

--SMS fallback - Activate the SMS fallback: if the network is
unavailable, an sms is sent instead of making an http connection\
 --network.smsfallback = "+33102345879" --address to send outgoing sms
to (e.g. server SMS reception number)\
 --network.pinghost --host for tcpping\
 --network.pingport --port for tcpping

-- Bearer configuration\
 network.bearer = {}\
 --GPRS configuration\
 -- retry is the number of retries before switching to the next bearer,
MANDATORY\
 --retryperiod is the time (in seconds on linux, in 100ms on openAT)
between 2 retries on the same bearer, MANDATORY\
 network.bearer.GPRS = { retry = 2, retryperiod = 50, apn =
"internet-entreprise", username="orange", password="orange"} username
and password can be not set if not mandatory by the operator

--If network.bearer.XXX.retry and / or network.bearer.XXX.retryperiod
are not specified the NetworkManager will try to use those 'global'
setting\
 network.retry=5\
 network.retryperiod=50

--ETHERNET configuration\
 --ETHERNET with DHCP\
 -- retry is the number of retries before switching to the next bearer,
MANDATORY\
 --retryperiod is the time (in seconds on linux, in 100ms on openAT)
between 2 retries on the same bearer, MANDATORY\
 --device is the name of the openAT device. This field is used by the
driver to initialize correctly the driver. Only m2mboxpro and fastrack
are supported today. MANDATORY, OAT DEVICES ONLY\
 --macaddress is the mac address of the ethernet card. If not defined,
the driver will try to retrieve it from flash OAT DEVICES ONLY\
 network.bearer.ETH = {retry = 2, retryperiod = 5, mode = "dhcp",
device='m2mboxpro'}\
 --ETHERNET with static IP\
 --network.bearer.ETH = {retry = 2, retryperiod = 5, mode = "static",
address = "10.0.2.87", netmask = "255.255.0.0", broadcast =
"10.0.255.255", gateway= "10.0.0.254", nameserver1 = "10.6.0.224",
nameserver2 = "10.6.0.225"}

#### Device Management and monitoring settings

--Device Management and monitoring settings\
 --Activate the Device Management module\
 device.activate = true\
 --ip address or host name and port number of the server hosting the
ServerAppSide for the TCPRemoteConnect command\
 --device.tcprconnect ={addr = '10.41.51.50', port = 2065 }

#### Logging framework

--default log level: can be one of NONE, ERROR, INFO, DETAIL, DEBUG,
ALL. See log.lua for details\
log.defaultlevel = "ALL"\
--per module log level\
log.moduleslevel.GENERAL = "ALL"\
log.moduleslevel.SERVER = "INFO"\
--formating options\
--log.enablecolors = true\
-- change default format for all logs\
-- log.format = "%t %m-%s: %l"\
-- timestampformat specifies strftime format to print date/time.\
-- timestampformat is useful only if %t% is in formatter string\
log.timestampformat = "%F %T"

-- Log policies config : nothing activated by default

-- Log policy is activated only if log.policy is not nil\
-- log.policy.name can take 3 values for now: "buffered\_all", "sole" or
"context"

-- log.policy= {}\
-- log.policy.name = "buffered\_all"\
-- log.policy.name = "sole"\
-- log.policy.name = "context"

-- log.policy.params = {}\
-- params.level can be used to configure trigger level for some
policies\
-- log.policy.params.level="WARNING"\
-- When activated, log policy needs a config for low level module
logstore\
-- Shared config for Ram logstore: ramlogger with size param to
rammaxsize\
--log.policy.params.ramlogger = {size = 2048}\
-- Regular config for Flash logstore for Linux: flashlogger with size
param to flashmaxsize and path param to set logs location\
--log.policy.params.flashlogger ={size = 15\*1024, path="logs/" }\
-- Regular config for Flash logstore for Open AT: flashlogger with size
param to flashmaxsize\
--log.policy.params.flashlogger = {size = 15\*1024 }

--Parameter for Log upload command\
--log.policy.ftpuser = ""\
--log.policy.ftppwd = ""

#### Update framework

--Update module settings\
--Activate the Update Agent\
update.activate = false

--Update process settings\
--retries number per component, default value:2\
--update.retries = 2\
--timeout in seconds for component update response, default value:40\
--update.timeout = 40

--dwlnotifperiod: number of seconds between update notification during
downloads, default value is 2s.\
--update.dwlnotifperiod = 30

--Activate Application Container\
appcon.activate = false\
-- Tcp Port to connect to appmon\_daemon.\
-- No need to use this config value if using appmon\_daemon default port
(4242)\
--appcon.port = 4243

#### Monitoring system

– activate the monitoring\
 monitoring.activate = true\
 – gives access to the global environment into the monitoring scripts\
 monitoring.debug = true

#### Lua RPC server

– activate LuaRPC server\
 rpc.activate = true\
 – optional: define the address to bind the server socket to. default
value is 'localhost'\
 rpc.address = 'localhost'\
 – optional: define the port to bind the server socket to. default value
is 1999\
 rpc.port = 1999

#### Data queues

– activate Data queues\
 data.activate = true\
 data.queues = { } – list of available Data queues\
 – Each data queue correspond to a data sending policy, there are three
main types of policies:\
 – manual: data sending is triggered by the user\
 – cron: data sending is triggered on cron events\
 – latency: data sending is triggered some times after a data push\
 data.queues.default = { 'manual' } – default data queue to use when no
policy name is used when sending data\
 data.queues.hourly = { latency = 60\*60 }\
 data.queues.daily = { latency = 24\*60\*60 }\
 data.queues.never = { 'manual' }\
 data.queues.now = { latency = 5 }

