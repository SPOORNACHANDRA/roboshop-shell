log=/tmp/roboshop.log
func_systemd() {
  echo -e " \e[31m>>>>>>>>>> ${component} service <<<<<<<<<\e[0m"
  systemctl daemon-reload &>>${log}
    systemctl enable ${component} &>>${log}
    systemctl start ${component} &>>${log}
}
func_schema_setup(){
  if ["$schema_type" =="mongodb" ]; then
   echo -e " \e[31m>>>>>>>>>> install mongodb client <<<<<<<<<\e[0m"
    yum install mongodb-org-shell -y &>>${log}
    echo -e " \e[31m>>>>>>>>>> load user schema <<<<<<<<<\e[0m"
    mongo --host mongodb.poornadevops.online </app/schema/${component} &>>${log}
fi
if [ "$schema_type"  == "mysql" ]; then
    echo -e " \e[31m>>>>>>>>>> install mysql client <<<<<<<<<\e[0m"
    yum install mysql -y &>>${log}
    echo -e " \e[31m>>>>>>>>>> load schema  <<<<<<<<<\e[0m"
    mysql -h mysql.poornadevops.online -uroot -pRoboShop@1 < /app/schema/${component}.sql &>>${log}
fi
}
func_apppreq(){
  echo -e " \e[31m>>>>>>>>>> ${component} service <<<<<<<<<\e[0m"
    cp shipping.service /etc/systemd/system/shipping.service &>>${log}
  echo -e "\e[31m>>>>>>>>>> create an application user <<<<<<<<<\e[0m"
    useradd roboshop &>>${log}
    echo -e "\e[31m>>>>>>>>>>>removing directory<<<<<<<<<<\e[0m"
    rm -rf /app &>>${log}
    echo -e " \e[31m>>>>>>>>>> create app directory <<<<<<<<\e[0m"
    mkdir /app &>>${log}
    echo -e " \e[31m>>>>>>>>>> download app content  <<<<<<<<<\e[0m"
    curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log}
    echo -e " \e[31m>>>>>>>>> app extraction  <<<<<<<<<\e[0m"
    cd /app &>>${log}
    unzip /tmp/${component}.zip &>>${log}
    cd /app &>>${log}
}

func_nodejs() {
  log=/tmp/roboshop.log
  echo -e " \e[31m>>>>>>>>>> create mongo repo <<<<<<<<<\e[0m"
  cp mongo.repo /etc/yum.repos.d/mongo.repo &>>${log}
  echo -e " \e[31m>>>>>>>>>> create nodejs repos <<<<<<<<<\e[0m"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log}
  echo -e " \e[31m>>>>>>>>>> install nodejs  <<<<<<<<<\e[0m"
  yum install nodejs -y &>>${log}
func_apppreq
  echo -e " \e[31m>>>>>>>>> download Nodejs dependencies <<<<<<<<<\e[0m"
  npm install &>>${log}

 func_schema_setup

func_systemd
}
func_java() {

  echo -e " \e[31m>>>>>>>>>> install maven <<<<<<<<<\e[0m"
  yum install maven -y &>>${log}
  func_apppreq
   echo -e " \e[31m>>>>>>>>>> build ${component}  <<<<<<<<<\e[0m"
  mvn clean package &>>${log}
  mv target/${component}-1.0.jar ${component}.jar &>>${log}
func_schema_setup
 func_systemd
}
func_python(){
  echo -e " \e[31m>>>>>>>>>> build ${component}  <<<<<<<<<\e[0m"
  yum install python36 gcc python3-devel -y &>>${log}
  func_apppreq
  echo -e " \e[31m>>>>>>>>>> build ${component}  <<<<<<<<<\e[0m"
  pip3.6 install -r requirements.txt &>>${log}
  func_systemd
}
func_golang(){
  func_apppreq
 echo -e " \e[31m>>>>>>>>>> build ${component}  <<<<<<<<<\e[0m"
  go mod init dispatch &>>${log}
  go get &>>${log}
  go build &>>${log}
  func_systemd
}