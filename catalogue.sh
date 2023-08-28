echo ">>>>>>>>>> create catalogue service <<<<<<<<<<"
cp catalogue.service /etc/systemd/system/catalogue.service
echo ">>>>>>>>>> create mongo repo <<<<<<<<<<"
cp mongo.repo /etc/yum.repos.d/mongo.repo
echo ">>>>>>>>>> create nodejs repos <<<<<<<<<<"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash
echo ">>>>>>>>>> install nodejs  <<<<<<<<<<"
yum install nodejs -y
echo ">>>>>>>>>> create an application user <<<<<<<<<<"
useradd roboshop
echo ">>>>>>>>>> create app directory <<<<<<<<<"
mkdir /app
echo ">>>>>>>>>> download app content  <<<<<<<<<<"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
echo ">>>>>>>>>> app extraction  <<<<<<<<<<"
cd /app
unzip /tmp/catalogue.zip
cd /app
echo ">>>>>>>>>> download Nodejs dependencies <<<<<<<<<<"
npm install
echo ">>>>>>>>>> install mongodb client <<<<<<<<<<"
yum install mongodb-org-shell -y
echo ">>>>>>>>>> load catalogue schema <<<<<<<<<<"
mongo --host mongodb.poornadevops.online </app/schema/catalogue.js
echo ">>>>>>>>>> create catalogue service <<<<<<<<<<"
systemctl daemon-reload
systemctl enable catalogue
systemctl start catalogue