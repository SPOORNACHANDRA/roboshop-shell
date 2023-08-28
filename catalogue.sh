echo -e " \e[31m >>>>>>>>>> create catalogue service <<<<<<<<<>[\e[om"
cp catalogue.service /etc/systemd/system/catalogue.service
echo -e " \e[31m>>>>>>>>>> create mongo repo <<<<<<<<<>[\e[om"
cp mongo.repo /etc/yum.repos.d/mongo.repo
echo -e " \e[31m>>>>>>>>>> create nodejs repos <<<<<<<<<>[\e[om"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash
echo -e " \e[31m>>>>>>>>>> install nodejs  <<<<<<<<<>[\e[om"
yum install nodejs -y
echo -e " \e[31m>>>>>>>>>> create an application user <<<<<<<<<>[\e[om"
useradd roboshop
echo -e " \e[31m>>>>>>>>>> create app directory <<<<<<<<>[\e[om"
mkdir /app
echo -e " \e[31m>>>>>>>>>> download app content  <<<<<<<<<>[\e[om"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
echo -e " \e[31m>>>>>>>>>> app extraction  <<<<<<<<<>[\e[om"
cd /app
unzip /tmp/catalogue.zip
cd /app
echo -e " \e[31m>>>>>>>>>> download Nodejs dependencies <<<<<<<<<>[\e[om"
npm install
echo -e " \e[31m>>>>>>>>>> install mongodb client <<<<<<<<<>[\e[om"
yum install mongodb-org-shell -y
echo -e " \e[31m>>>>>>>>>> load catalogue schema <<<<<<<<<>[\e[om"
mongo --host mongodb.poornadevops.online </app/schema/catalogue.js
echo -e " \e[31m>>>>>>>>>> create catalogue service <<<<<<<<<>[\e[om"
systemctl daemon-reload
systemctl enable catalogue
systemctl start catalogue