Platform : Mediation
====================

This page last changed on Mar 10, 2011 by lbarthelemy.

Mediation module
================

This ReadyAgent module enables the connexion with Mediation server using
the [Mediation
Protocol](https://confluence.sierrawireless.com/display/PLT/Mediation+Protocol).

Mediation Vs Bearers
====================

Mediation Protocol have heavy dependencies on the bearer/network
characteristics used to communicate.

![image](images/icons/emoticons/warning.png)

Especially, GPRS networks characteristics need to be checked before
trying to use this service

Please read [Mediation
Protocol](https://confluence.sierrawireless.com/display/PLT/Mediation+Protocol)
documents to get more details.

API
===

~~~~ {.theme: .Confluence; .brush: .java; .gutter: .false
style="font-size:12px;"}
stop()
~~~~
>
> Stop Mediation link

~~~~ {.theme: .Confluence; .brush: .java; .gutter: .false
style="font-size:12px;"}
start(period, index)
~~~~
>
> Start Mediation link

Document generated by Confluence on Mar 11, 2013 16:15
