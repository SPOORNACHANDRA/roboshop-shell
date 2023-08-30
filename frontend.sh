source=common.sh
echo -e " \e[31m>>>>>>>>>> install nginx service <<<<<<<<<\e[0m"
yum install nginx -y
func_exit_status

echo -e " \e[31m>>>>>>>>>> copy roboshop configuration <<<<<<<<<\e[0m"
cp nginx.roboshop.conf /etc/nginx/default.d/roboshop.conf
func_exit_status

echo -e " \e[31m>>>>>>>>>> clean old content <<<<<<<<<\e[0m"
rm -rf /usr/share/nginx/html/*
func_exit_status

echo -e " \e[31m>>>>>>>>>> Download app content <<<<<<<<<\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip
func_exit_status

cd /usr/share/nginx/html

echo -e " \e[31m>>>>>>>>>> extract application content <<<<<<<<<\e[0m"
unzip /tmp/frontend.zip
func_exit_status

echo -e " \e[31m>>>>>>>>>>  start nginx  <<<<<<<<<\e[0m"
systemctl enable nginx
systemctl start nginx
systemctl restart nginx
func_exit_status




