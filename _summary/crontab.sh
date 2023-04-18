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