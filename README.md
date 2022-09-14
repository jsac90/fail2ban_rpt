# fail2ban_rpt
I made a custom report that sends me a daily email (in combination with a cron job) about how many people tripped fail2ban in the previous 24 hours. Kind of interesting to see. I know there are probably better solutions to do this but this was my attempt at something completely custom and taught me a lot about bash scripting and linux in general. 

fail2ban_rpt.sh can go anywhere. Just have a cronjob point at it. 

fail2ban_jails is just the configuration of the custom jails for the fail2ban_rpt.sh script. You can add these to your own jail.local file. Make sure you restart fail2ban services after. add these to your etc/fail2baan/jail.local file 

It appears that you need to have a custom filter in /etc/fail2ban/filter.d for SSH-root so I've added that as well. Just add that to your folder.
