
COMPONENT=mongo
source common.sh

PRINT ""
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo &>>$LOG
STAT $?

PRINT "Install MongoDB"
yum install -y mongodb-org &>>$LOG
STAT $?

PRINT "Configure MongoDB"
sed -i -e 's/127.0.0.1/0.0.0.0/'  /etc/mongod.conf &>>$LOG
STAT $?


PRINT "Enable MongoDB"
systemctl enable mongod &>>$LOG
STAT $?

PRINT "Restart MongoDB Service"
systemctl restart mongod &>>$LOG
STAT $?


PRINT "Download MongoDB File"
curl -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip" &>>$LOG
STAT $?

cd /tmp


PRINT "Extracting MongoDB File"
unzip -o mongodb.zip &>>$LOG
STAT $?


cd mongodb-main

PRINT "Load Catalogue Schema"
mongo < catalogue.js &>>$LOG
STAT $?

PRINT "Load Users Schema"
mongo < users.js &>>$LOG
STAT $?



