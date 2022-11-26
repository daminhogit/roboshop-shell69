COMPONENT=rabbit
source common.sh

PRINT "Download Rabbit App"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>>$LOG
STAT $?

PRINT "Install Rabbit App"
Install RabbitMQ &>>$LOG
STAT $?

PRINT "Install Rabbit Server"
yum install rabbitmq-server -y &>>$LOG

PRINT "Enable Rabbit Server"
systemctl enable rabbitmq-server &>>$LOG
STAT $?

PRINT "Start Rabbit Server"
systemctl start rabbitmq-server &>>$LOG
STAT $?


PRINT "Create Application User"
rabbitmqctl add_user roboshop roboshop123 &>>$LOG
STAT $?

PRINT "Set User Tags"
rabbitmqctl set_user_tags roboshop administrator &>>$LOG
STAT $?

PRINT "Set Permission"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$LOG
STAT $?