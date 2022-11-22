echo -e "\e[33mDownloading MySQL Repo File\e[0m"
curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo
if [ $? -eq 0 ]; then
  echo SUCCESS
else
  echo FAILURE
  exit
fi

echo Disable MySQL 8 Version repo
dnf module disable mysql -y
if [ $? -eq 0 ]; then
  echo SUCCESS
else
  echo FAILURE
  exit
fi

echo install MySQL
yum install mysql-community-server -y
if [ $? -eq 0 ]; then
  echo SUCCESS
else
  echo FAILURE
  exit
fi

echo Enable MySQL Service
systemctl enable mysqld
if [ $? -eq 0 ]; then
  echo SUCCESS
else
  echo FAILURE
  exit
fi

echo Start MySQL Service
systemctl restart mysqld
if [ $? -eq 0 ]; then
  echo SUCCESS
else
  echo FAILURE
  exit
fi
