echo -e " \e[31m>>>>>>>>>> create catalogue service <<<<<<<<<\e[0m"
cp catalogue.service /etc/systemd/system/catalogue.service &>/tmp/roboshop.log
echo -e " \e[31m>>>>>>>>>> create mongo repo <<<<<<<<<\e[0m"
cp mongo.repo /etc/yum.repos.d/mongo.repo &>/tmp/roboshop.log
echo -e " \e[31m>>>>>>>>>> create nodejs repos <<<<<<<<<\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>/tmp/roboshop.log
echo -e " \e[31m>>>>>>>>>> install nodejs  <<<<<<<<<\e[0m"
yum install nodejs -y &>/tmp/roboshop.log
echo ">>>>>>>>>> create an application user <<<<<<<<<\e[0m"
useradd roboshop &>/tmp/roboshop.log
echo -e "\e[31m>>>>>>>>>>>removing directory<<<<<<<<<<\e[0m"
rm -rf /app &>/tmp/roboshop.log
echo -e " \e[31m>>>>>>>>>> create app directory <<<<<<<<\e[0m"
mkdir /app &>/tmp/roboshop.log
echo -e " \e[31m>>>>>>>>>> download app content  <<<<<<<<<\e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>/tmp/roboshop.log
echo -e " \e[31m>>>>>>>>> app extraction  <<<<<<<<<\e[0m"
cd /app &>/tmp/roboshop.log
unzip /tmp/catalogue.zip &>/tmp/roboshop.log
cd /app &>/tmp/roboshop.log
echo -e " \e[31m>>>>>>>>> download Nodejs dependencies <<<<<<<<<\e[0m"
npm install &>/tmp/roboshop.log
echo -e " \e[31m>>>>>>>>>> install mongodb client <<<<<<<<<\e[0m"
yum install mongodb-org-shell -y &>/tmp/roboshop.log
echo -e " \e[31m>>>>>>>>>> load catalogue schema <<<<<<<<<\e[0m"
mongo --host mongodb.poornadevops.online </app/schema/catalogue.js &>/tmp/roboshop.log
echo -e " \e[31m>>>>>>>>>> create catalogue service <<<<<<<<<\e[0m"
systemctl daemon-reload &>/tmp/roboshop.log
systemctl enable catalogue &>/tmp/roboshop.log
systemctl start catalogue &>/tmp/roboshop.log
