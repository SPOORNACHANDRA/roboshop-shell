echo -e " \e[31m>>>>>>>>>> create catalogue service <<<<<<<<<\e[0m"
cp catalogue.service /etc/systemd/system/catalogue.service
echo -e " \e[31m>>>>>>>>>> create mongo repo <<<<<<<<<\e[0m"
cp mongo.repo /etc/yum.repos.d/mongo.repo
echo -e " \e[31m>>>>>>>>>> create nodejs repos <<<<<<<<<\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash
echo -e " \e[31m>>>>>>>>>> install nodejs  <<<<<<<<<\e[0m"
yum install nodejs -y
echo ">>>>>>>>>> create an application user <<<<<<<<<\e[0m"
useradd roboshop
echo -e " \e[31m>>>>>>>>>> create app directory <<<<<<<<\e[0m"
mkdir /app
echo -e " \e[31m>>>>>>>>>> download app content  <<<<<<<<<\e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
echo -e " \e[31m>>>>>>>>> app extraction  <<<<<<<<<\e[0m"
cd /app
unzip /tmp/catalogue.zip
cd /app
echo -e " \e[31m>>>>>>>>> download Nodejs dependencies <<<<<<<<<\e[0m"
npm install
echo -e " \e[31m>>>>>>>>>> install mongodb client <<<<<<<<<\e[0m"
yum install mongodb-org-shell -y
echo -e " \e[31m>>>>>>>>>> load catalogue schema <<<<<<<<<\e[0m"
mongo --host mongodb.poornadevops.online </app/schema/catalogue.js
echo -e " \e[31m>>>>>>>>>> create catalogue service <<<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable catalogue
systemctl start catalogue
