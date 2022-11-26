STAT() {
  if [ $1 -eq 0 ]; then
    echo -e "\e[32mSUCCESS\e[0m"
  else
    echo -e "\e[31mSUCCESS\e[0m"
    exit
  fi
}

PRINT() {
  echo -e "\e[33m$1\e[0m"
}

LOG=/tmp/${COMPONENT}.log
rm -rf $LOG

SYSTEMD_SETUP() {
  PRINT "Configure Endpoints for SystemD Configuration"
    sed -i -e 's/REDIS_ENDPOINT/redis.devopsb69.online/' -e 's/CATALOGUE_ENDPOINT/catalogue.devopsb69.online/' /home/roboshop/${COMPONENT}/systemd.service &>>$LOG
    mv /home/roboshop/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}
    STAT $?

    PRINT "Setup SystemD Service"
    mv /home/roboshop/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service &>>$LOG
    STAT $?

    PRINT "Reload SystemD"
    systemctl daemon-reload &>>$LOG
    STAT $?

    PRINT "Restart ${COMPONENT}"
    systemctl restart ${COMPONENT} &>>$LOG
    STAT $?

    PRINT "Enable ${COMPONENT} Service"
    systemctl enable ${COMPONENT} &>>$LOG
    STAT $?
}

NODEJS() {
  PRINT "Install NodeJS Repos"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$LOG
  STAT $?

  PRINT "INSTALL NodeJS"
  yum install nodejs -y &>>$LOG
  STAT $?

  PRINT "Adding Application User"
  id roboshop &>>$LOG
  if [ $? -ne 0 ]; then
    useradd roboshop
  fi
  STAT $?

  PRINT "Download App Content"
  curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/roboshop-devops-project/${COMPONENT}/archive/main.zip" &>>$LOG
  STAT $?

  PRINT "Remove previous Version of App"
  cd /home/roboshop &>>$LOG
  rm -rf ${COMPONENT} &>>$LOG
  STAT $?

  PRINT "Extracting App Content"
  unzip -o /tmp/${COMPONENT}.zip &>>$LOG
  STAT $?

  mv ${COMPONENT}-main ${COMPONENT}
  cd ${COMPONENT}

  PRINT "Install NodeJS Dependencies for App"
  npm install &>>$LOG
  STAT $?

  SYSTEMD_SETUP
}

JAVA() {
PRINT "Install Maven"
yum install maven -y &>>$LOG
STAT $?

PRINT "Adding User"
useradd roboshop &>>$LOG
STAT $?


cd /home/roboshop

PRINT "Download App Content"
curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/roboshop-devops-project/shipping/archive/main.zip" &>>$LOG
STAT $?

PRINT "Extracting App Content"
unzip /tmp/${COMPONENT}.zip &>>$LOG
STAT $?

mv shipping-main shipping
cd ${COMPONENT}

PRINT "Clean Package"
mvn clean package &>>$LOG
STAT $?

PRINT "Download Maven Dependecies"
mv target/${COMPONENT}-1.0.jar ${COMPONENT}.jar &>>$LOG
STAT $?

SYSTEMD_SETUP
}


PYTHON() {
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