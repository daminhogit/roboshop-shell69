COMPONENT=redis

source common.sh


PRINT "Install Redis Repo"
dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>$LOG
STAT $?

PRINT "Enabling Redis Repo"
dnf module enable redis:remi-6.2 -y &>>$LOG
STAT $?

PRINT "Installing Redis"
yum install redis -y &>>$LOG
STAT $?

PRINT "Update Redis Listen Address"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf /etc/redis/redis.conf &>>$LOG
STAT $?

PRINT "Enabling Redis"
systemctl enable redis &>>$LOG
STAT $?

PRINT "Restarting Redis"
systemctl restart redis &>>$LOG
STAT $?