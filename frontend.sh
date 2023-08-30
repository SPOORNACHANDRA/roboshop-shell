source=common.sh
log=/tmp/roboshop.log
func_exit_status() {
   if [ $? -eq 0 ]; then
   echo -e "\e[32m success \e[0m"
   else
   echo -e "\e[33m failure \e[0m"
   fi
}

echo -e " \e[31m>>>>>>>>>> install nginx service <<<<<<<<<\e[0m"
yum install nginx -y &>>${log}
func_exit_status

echo -e " \e[31m>>>>>>>>>> copy roboshop configuration <<<<<<<<<\e[0m"
cp nginx.roboshop.conf /etc/nginx/default.d/roboshop.conf &>>${log}
func_exit_status

echo -e " \e[31m>>>>>>>>>> clean old content <<<<<<<<<\e[0m"
rm -rf /usr/share/nginx/html/* &>>${log}
func_exit_status

echo -e " \e[31m>>>>>>>>>> Download app content <<<<<<<<<\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${log}
func_exit_status

cd /usr/share/nginx/html

echo -e " \e[31m>>>>>>>>>> extract application content <<<<<<<<<\e[0m"
unzip /tmp/frontend.zip &>>${log}
func_exit_status

echo -e " \e[31m>>>>>>>>>>  start nginx  <<<<<<<<<\e[0m"
systemctl enable nginx &>>${log}
systemctl restart nginx &>>${log}
func_exit_status



