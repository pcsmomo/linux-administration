# m h dom mon dow command
0 6 * * 0 /root/backup.sh # every sunday 6am
0 18 * * 5 /root/backup.sh # every sunday 6pm
* * * * * /root/every_minute.sh # every minute
0 4,6,10 * * * /root/daily.sh # every day 4, 6, 10am
0 9-17 * * 1-5 /root/firewall.sh # once per hour between 9am-5pm on weekdays
10 4,21 */3 * * /root/task.sh # every 3 days at 4:10am and 9:10pm

@yearly /root/happy_new_year.sh # at midnight 1st, Jan every year
@montly /root/montly.sh # at midnight 1st, every month
@weekly /root/weekly.sh # at midnight every Sunday
@daily /root/daily.sh
@hourly /root/hourly.sh
@reboot /root/on_reboot.sh

*/2 * * * * date >> /tmp/date_and_time.txt # every two minute



##########################
## Task Scheduling using Cron
##########################
 
# editing the current user’s crontab file 
crontab -e
 
# listing the current user’s crontab file 
crontab -l
 
# removing the current user’s crontab file 
crontab -r
 
## COMMON EXAMPLES ##
# run every minute
* * * * * /path_to_task_to_run.sh
 
# run every hour at minute 15
15 * * * * /path_to_task_to_run.sh
 
# run every day at 6:30 PM
30 18 * * * /path_to_task_to_run.sh
 
# run every Monday at 10:03 PM
3 22 * * 1 /path_to_task_to_run.sh
 
# run on the 1st of every Month at 6:10 AM
10 6 1 * * /path_to_task_to_run.sh
 
# run every hour at minute 1, 20 and 35
1,20,35 * * * * /path_to_task_to_run.sh
 
# run every two hour at minute 10
10 */2 * * * /path_to_task_to_run.sh
 
# run once a year on the 1st of January at midnight
@yearly     /path_to_task_to_run.sh
 
# run once a month at midnight on the first day of the month
@monthly    /path_to_task_to_run.sh
 
# run once a week at midnight on Sunday
@weekly      /path_to_task_to_run.sh
 
# once an hour at the beginning of the hour
@hourly     /path_to_task_to_run.sh
 
# run at boot time
@reboot     /path_to_task_to_run.sh
 
All scripts in following directories will run as root at that interval:
/etc/cron.hourly
/etc/cron.daily  
/etc/cron.hourly  
/etc/cron.monthly
/etc/cron.weekly