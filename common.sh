log=/tmp/roboshop.log
func_systemd() {
  echo -e " \e[31m>>>>>>>>>> ${component} service <<<<<<<<<\e[0m"
  systemctl daemon-reload &>>${log}
    systemctl enable ${component} &>>${log}
    systemctl start ${component} &>>${log}
    func_exit_status
}
func_exit_status() {
   if [ $? -eq 0 ]; then
      echo -e "\e[32m success \e[0m"
      else
        echo -e "\e[33m failure \e[0m"
        fi
}

func_schema_setup() {
  if [ "$schema_type" == "mongodb" ]; then
  echo -e " \e[31m>>>>>>>>>> install mongodb client <<<<<<<<<\e[0m"
  yum install mongodb-org-shell -y &>>${log}
  func_exit_status
  echo -e " \e[31m>>>>>>>>>> load ${component} schema <<<<<<<<<\e[0m"
  mongo --host mongodb.poornadevops.online </app/schema/${component}.js &>>${log}
func_exit_status
fi
if [ "$schema_type"  == "mysql" ]; then
    echo -e " \e[31m>>>>>>>>>> install mysql client <<<<<<<<<\e[0m"
    yum install mysql -y &>>${log}
    func_exit_status
    echo -e " \e[31m>>>>>>>>>> load ${component} schema  <<<<<<<<<\e[0m"
    mysql -h mysql.poornadevops.online -uroot -pRoboShop@1 < /app/schema/${component}.sql &>>${log}
func_exit_status
fi
}


func_apppreq() {
  echo -e " \e[31m>>>>>>>>>> ${component} service <<<<<<<<<\e[0m"
    cp ${component}.service /etc/systemd/system/${component}.service &>>${log}
    func_exit_status
  echo -e "\e[31m>>>>>>>>>> create an application user <<<<<<<<<\e[0m"

    id roboshop &>>${log}
    if [ $? -ne 0 ]; then
       useradd roboshop &>>${log}
    fi
   func_exit_status
    echo -e "\e[31m>>>>>>>>>>>removing directory<<<<<<<<<<\e[0m"
    rm -rf /app &>>${log}
    func_exit_status
    echo -e " \e[31m>>>>>>>>>> create app directory <<<<<<<<\e[0m"
    mkdir /app &>>${log}
    echo -e " \e[31m>>>>>>>>>> download app content  <<<<<<<<<\e[0m"
    curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log}
    func_exit_status
    echo -e " \e[31m>>>>>>>>> app extraction  <<<<<<<<<\e[0m"
    cd /app &>>${log}
    unzip /tmp/${component}.zip &>>${log}
    func_exit_status
}


func_nodejs() {
  echo -e " \e[31m>>>>>>>>>> create mongo repo <<<<<<<<<\e[0m"
  cp mongo.repo /etc/yum.repos.d/mongo.repo &>>${log}

  echo -e " \e[31m>>>>>>>>>> create nodejs repos <<<<<<<<<\e[0m"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log}
 func_exit_status
  echo -e " \e[31m>>>>>>>>>> install nodejs  <<<<<<<<<\e[0m"
  yum install nodejs -y &>>${log}
 func_exit_status
  func_apppreq
  echo -e " \e[31m>>>>>>>>> download Nodejs dependencies <<<<<<<<<\e[0m"
  npm install &>>${log}
 func_exit_status
 func_schema_setup
func_systemd
}


func_java() {
  echo -e " \e[31m>>>>>>>>>> install maven <<<<<<<<<\e[0m"
  yum install maven -y &>>${log}
  func_exit_status
  func_apppreq
   echo -e " \e[31m>>>>>>>>>> build ${component}  <<<<<<<<<\e[0m"
  mvn clean package &>>${log}
  mv target/${component}-1.0.jar ${component}.jar &>>${log}
  func_exit_status
func_schema_setup
 func_systemd
}


func_python() {
  echo -e " \e[31m>>>>>>>>>> build ${component}  <<<<<<<<<\e[0m"
  yum install python36 gcc python3-devel -y &>>${log}
 func_exit_status
  func_apppreq
  echo -e " \e[31m>>>>>>>>>> build ${component}  <<<<<<<<<\e[0m"
  pip3.6 install -r requirements.txt &>>${log}
  func_exit_status
  func_systemd
}


func_golang() {
  func_apppreq
 echo -e " \e[31m>>>>>>>>>> build ${component}  <<<<<<<<<\e[0m"
  go mod init dispatch &>>${log}
  go get &>>${log}
  go build &>>${log}
 func_exit_status
  func_systemd
}