Platform : Migration Helper
===========================

This page last changed on Oct 18, 2011 by lbarthelemy.

Location
--------

The migration logic itself will be put in application code, not in
ReadyAgent. The ReadyAgent only provides a generic module that can
automatically load migration scripts.

Migration process
-----------------

The migration module will determine if a migration is needed.\
 For that purpose, it will use a persisted object named
**"ReadyAgentVersion"**.\
 The content of this persisted object is the value of
**\_READYAGENTRELEASE** Lua global variable (the version is also
displayed in the logs).

If the content of persisted object is different of current version
result then the migration will be done.\
 This includes the case where the persisted object doesn't exist, then
versionFrom migration param (see bellow) will be set to "unknown".

Then the user/project specific migration code is done.\
 Finally, the persisted object value is set with current version.

User/Project specific code
--------------------------

Lua API only.\
 When migration is needed, generic code will load user/project specific
migration code using:

~~~~ {.theme: .Confluence; .brush: .java; .gutter: .false
style="font-size:12px;"}
require "agent.migration"
~~~~

It's up to the user/project to provide the migration code itself.
(ReadyAgent dev team is here to help of course.
![(smile)](s/en_GB/3397/d976175803f1ca76369950eacde52f8cbf5a54d9.5/_/images/icons/emoticons/smile.png)
)\
 The migration code is very likely to be a Lua file named
"agent/migration.lua".\
 However, if the user migration needs to run C code, it is possible,
providing the C code exports a function:

~~~~ {.theme: .Confluence; .brush: .java; .gutter: .false
style="font-size:12px;"}
int luaopen_agent_migration(LuaState* L);
~~~~

So that it can be loaded the same way if it was Lua file.

In any case, *agent.migration* **must** provide one function:

~~~~ {.theme: .Confluence; .brush: .java; .gutter: .false
style="font-size:12px;"}
function execute(versionFrom, versionTo)
~~~~

This is the function that will be called in order to actually do the
migration, with those parameters:\
 versionFrom: string, current value of persisted of object, or "unknown"
if no ReadyAgent version was persisted yet.\
 versionTo: string, current value of getversion() result

![image](images/icons/emoticons/warning.png)

Please pay attention to make the migration script as light as possible,
with minimum dependencies with others modules.\
 agent.migraion will be executed very early at the ReadyAgent boot
phase, no configuration will be loaded, no module will be running, only
low level features of Lua VM will be available.\
 For example, do not use log module, when agent.migration will be
executed, log is not configured yet.\
 If you need to report some error, check next section: Migration status
reporting

![image](images/icons/emoticons/information.png)

It is also the responsibility of the user/project to put the migration
code in the application binary.\
 By default, ReadyAgent doesn't embed any migration code, only the
migration helper module.

![image](images/icons/emoticons/information.png)

To ease the migration code development, specific page provide
compatibility breaks and often provide migration templates.\
 See
[https://confluence.anyware-tech.com/display/PLT/Compatibility+breaks](https://confluence.anyware-tech.com/display/PLT/Compatibility+breaks)

### Migration status reporting

The user migration script needs to **throw Lua error** to report some
error in migration.\
 Otherwise, the migration script execution is considered as successful.\
 Note: if migration script is absent, an error will be reported once.

When migration script is triggered, migration execution status is logged
in ReadyAgent boot logs:

~~~~ {.theme: .Confluence; .brush: .java; .gutter: .false
style="font-size:12px;"}
+LUALOG: "GENERAL","INFO","Migration executed successfully"
~~~~

### Migration script templates

For Lua migration script template, pick up migration.lua\
 For C-Lua migration script template, pick up migration.c **and**
migration.h\
 CMakeLists.txt is an example of how to compile migration.c using CMake.

[Name](/display/PLT/Migration+Helper?sortBy=name)

[Size](/display/PLT/Migration+Helper?sortBy=size)

Creator

[Creation Date](/display/PLT/Migration+Helper?sortBy=createddate)

Labels

Comment

[](# "Show All Versions") ![Please
wait](s/fr_FR/3397/d976175803f1ca76369950eacde52f8cbf5a54d9.5/_/images/icons/wait.gif)

Text File
[CMakeLists.txt](/download/attachments/21404391/CMakeLists.txt?api=v2 "CMakeLists.txt")

0.2 kB

[Laurent Barthelemy](/display/~lbarthelemy)

Feb 26, 2013

-   None
-   [Edit Labels](# "Edit Labels")

Update CMakeLists.txt to use swi\_log

-   [$itemLabel]($itemRenderedUrl)
-   [$itemLabel]($itemRenderedUrl)

[](# "Show All Versions") ![Please
wait](s/fr_FR/3397/d976175803f1ca76369950eacde52f8cbf5a54d9.5/_/images/icons/wait.gif)

File
[MigrationScript.h](/download/attachments/21404391/MigrationScript.h?api=v2 "MigrationScript.h")

0.1 kB

[Laurent Barthelemy](/display/~lbarthelemy)

Feb 26, 2013

-   None
-   [Edit Labels](# "Edit Labels")

Update MigrationScript.h to use swi\_log

-   [$itemLabel]($itemRenderedUrl)
-   [$itemLabel]($itemRenderedUrl)

[](# "Show All Versions") ![Please
wait](s/fr_FR/3397/d976175803f1ca76369950eacde52f8cbf5a54d9.5/_/images/icons/wait.gif)

File
[MigrationScript.c](/download/attachments/21404391/MigrationScript.c?api=v2 "MigrationScript.c")

0.6 kB

[Laurent Barthelemy](/display/~lbarthelemy)

Feb 26, 2013

-   None
-   [Edit Labels](# "Edit Labels")

Update MigrationScript.c to use swi\_log

-   [$itemLabel]($itemRenderedUrl)
-   [$itemLabel]($itemRenderedUrl)

File
[migration.lua](/download/attachments/21404391/migration.lua?api=v2 "migration.lua")

0.7 kB

[Laurent Barthelemy](/display/~lbarthelemy)

Feb 26, 2013

-   None
-   [Edit Labels](# "Edit Labels")

Migration Lua script: sample from src repo, installed by default

-   [$itemLabel]($itemRenderedUrl)
-   [$itemLabel]($itemRenderedUrl)

File uploaded successfully

Implementation constraints
--------------------------

As the migration helper code has to be common for Open AT / Linux
device, the persisted object is saved/retrieved using **persist** common
API.

Attachments:
------------

![image](images/icons/bullet_blue.gif)
[MigrationScript.c](attachments/21404391/31359039.c)
(application/octet-stream) \
 ![image](images/icons/bullet_blue.gif)
[MigrationScript.h](attachments/21404391/31359040.h)
(application/octet-stream) \
 ![image](images/icons/bullet_blue.gif)
[MigrationScript.c](attachments/21404391/47874536.c) (text/x-csrc) \
 ![image](images/icons/bullet_blue.gif)
[MigrationScript.h](attachments/21404391/47874537.h) (text/x-chdr) \
 ![image](images/icons/bullet_blue.gif)
[CMakeLists.txt](attachments/21404391/47874538.txt) (text/plain) \
 ![image](images/icons/bullet_blue.gif)
[migration.lua](attachments/21404391/47874535.lua) (text/x-lua) \
 ![image](images/icons/bullet_blue.gif)
[MigrationScript.c](attachments/21404391/21529154.c) (text/x-csrc) \
 ![image](images/icons/bullet_blue.gif)
[MigrationScript.h](attachments/21404391/21529155.h) (text/x-chdr) \
 ![image](images/icons/bullet_blue.gif)
[CMakeLists.txt](attachments/21404391/31359041.txt) (text/plain) \

Document generated by Confluence on Mar 11, 2013 16:15
