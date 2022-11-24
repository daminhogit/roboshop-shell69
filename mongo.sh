COMPONENT=mongodb
source common.sh
PRINT ""
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo &>>$LOG
STAT$?

PRINT ""
yum install -y mongodb-org &>>$LOG
STAT$?

PRINT ""
sed -i -e 's/127.0.0.1/0.0.0.0/'  /etc/mongod.conf &>>$LOG
STAT$?


PRINT ""
systemctl enable mongod &>>$LOG
STAT$?

PRINT""
systemctl restart mongod &>>$LOG
STAT$?


PRINT ""
curl -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip" &>>$LOG
STAT$?

cd /tmp


PRINT ""
unzip -o mongodb.zip &>>$LOG
STAT$?


cd mongodb-main

PRINT ""
mongo < catalogue.js &>>$LOG
STAT$?

PRINT ""
mongo < users.js &>>$LOG
STAT$?



