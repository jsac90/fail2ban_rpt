#fail2ban report
#requisites - fail2ban and mailutils installed. 
#I created 2 custom fail2ban jails which should be located in the repository. 

#! /bin/bash
{ 
echo "Here is a report for" $(date "+%A, %B %d, %Y")
echo ""
echo "Last reboot was:"
who -b | awk '{print $3, $4}'
echo ""
echo "Current uptime"
uptime -p
echo ""
echo "----------"
echo ""
timing=$(uptime -p | awk '{print $3}')
if 
[ "$timing" == "hour," ] ||
[ "$timing" == "hours," ] ||
[ "$timing" == "minutes," ] || 
[ "$timing" == "seconds," ];
then
echo "The server was restarted less than 1 day ago. Because of the way Fail2Ban works, it will re-add ALL banned IPs after a restart, making it look like all bans happened on one day. To avoid confusion and long run times, we have decided to skip reports on these days"
echo ""
echo "If there is an emergency need to see what happened today, please look at the log in /var/log/fail2ban.log"
echo ""
else
echo "Temporary Bans - 3 incorrect logins in 10 minutes"
echo ""
echo "Number of unique temporary bans"
echo ""
grep '\[sshd] Ban' /var/log/fail2ban.log |
grep `date +%Y-%m-%d` | awk '{print $1, $2, $NF}' |
sort | wc -l
echo ""
grep '\[sshd] Ban' /var/log/fail2ban.log | 
grep `date +%Y-%m-%d` | awk '{print $1, "     ", $2, "     ", $NF}' | 
sort 
echo ""
echo "----------"
echo ""
echo "Permanent Bans - Repeat. 3 temporary bans in 30 days"
echo ""
echo "Number of Permanent Repeat bans"
echo ""
grep '\[ssh-repeat] Ban' /var/log/fail2ban.log | grep `date +%Y-%m-%d` | awk '{print $1, $2, $NF}' | sort | wc -l
echo ""
grep '\[ssh-repeat] Ban' /var/log/fail2ban.log | grep `date +%Y-%m-%d` | awk '{print $1, "     ", $2, "     ", $NF}' | sort
echo ""
echo "----------"
echo ""
echo "Permanent Bans - Root. User attempted to log in as root remotely ONE time."
echo ""
echo "Number of Permanent ROOT bans"
echo ""
grep '\[sshd-root] Ban' /var/log/fail2ban.log |
grep `date +%Y-%m-%d` | awk '{print $1, $2, $NF}' |
sort | wc -l
echo ""
grep '\[sshd-root] Ban' /var/log/fail2ban.log |
grep `date +%Y-%m-%d` | awk '{print $1, "     ", $2, "     ", $NF}' |
sort
fi
echo ""
#MAKE SURE YOU CHANGE THIS TO YOUR CUSTOM EMAIL ADDRESSES
} | mail -s "Your Daily FAIL2BAN report for $(date "+%A, %B %d, %Y")" YOU@EMAIL.COM -aFrom:FAIL2BAN@SERVER.COM
 

