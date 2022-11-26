COMPONENT=payment
source common.sh


PRINT "Installing Python"
yum install python36 gcc python3-devel -y &>>$LOG
STAT $?

PRINT "Adding User"
useradd roboshop &>>$LOG
STAT $?

cd /home/roboshop

PRINT "Download Payment App"
curl -L -s -o /tmp/payment.zip "https://github.com/roboshop-devops-project/payment/archive/main.zip" &>>$LOG
STAT $?

PRINT "Extracting Payment App"
unzip /tmp/payment.zip &>>$LOG
STAT $?

mv payment-main payment &>>$LOG
STAT $?

cd /home/roboshop/payment  &>>$LOG
STAT $?

PRINT "Installing Dependencies"
pip3 install -r requirements.txt &>>$LOG
STAT $?

USER_ID=(id -u roboshop)
GROUP_ID=(id -g roboshop)
sed -i -e "/uid/ c uid = ${USER_ID}" ${COMPONENT}.ini
sed -i -e "/gid/ c gid = ${GROUP_ID}" ${COMPONENT}.ini


SYSTEMD_SETUP

 }
