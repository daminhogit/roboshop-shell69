COMPONENT=frontend

source common.sh

PRINT "Install Nginx"
yum install nginx -y &>>$LOG
STAT $?

PRINT "Download Frontend App"
curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" &>>$LOG
cd /usr/share/nginx/html &>>$LOG
STAT $?

rm -rf *

PRINT "Extract App Content"
unzip /tmp/frontend.zip &>>$LOG
STAT $?

mv frontend-main/static/* . &>>$LOG
STAT $?

PRINT "Move Config Files"
mv frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf &>>$LOG
STAT $?

PRINT "Enable Nginx"
systemctl enable nginx &>>$LOG
STAT $?

PRINT "Restart Nginx"
systemctl restart nginx &>>$LOG
STAT $?

