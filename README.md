# WatchdogT
Mql4 bot for metatrader 4 that checks other bots activity in a range of time to make shure its running correctly, otherwise it sends an alert to your telegram.

## Parameters
-    minutes_alert: minutes of inactivity that will raise the alert 
-    chat_id: the telegram chat identifier to wich the alert will be sent
-    magic: the magic nuber of the bot you want to watch over
-    minutes_between_alerts: the time span between alerts (1 hour recomended)

## Instructions

1.-    On your telegram account, send "\start" to @userinfobot . You should get back something like this:

    Id: xxxxxxxx
    First: xxxxx
    Last: xxxxxx
    Lang: xx

The Id number will be your chat id.

2.-    In order to allow message requests from the bot, send "\start" to @WatchdogTbot .

3.-    In metatrader 4, open the data folder and place WatchdogTBot.ex4 in the .../MQL4/Experts folder.

4.-    Run the WatchdogTBot in a new chart (on the same account as your trading bot).

5.-    fill the parameters, for scalpers we recomend:

-    minutes_alert: $\leq 360$
-    chat_id: the one you got from @userinfobot
-    magic: the magic nuber of the bot you want to watch over
-    minutes_between_alerts: $\geq 60$


The code is in WatchdogTBot.mq4 if you want to make changes
