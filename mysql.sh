USERID=$(id -u)

TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log

echo "Script started executing at: $TIMESTAMP"
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

echo "Please enter DB Password"
read  mysql_root_password 

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2....$R FAILURE $N"
        exit 4
    else
        echo -e "$2....$G SUCCESS $N"
    fi
}

if [ $USERID -ne 0 ]
then 
    echo "You must be root user"
    exit 5
else
    echo "You are the root user"
fi

dnf install mysql-server -y &>>LOGFILE
VALIDATE $? "Installing mysql....."

systemctl enable mysqld &>>LOGFILE
VALIDATE $? "Enabling MY-SQL Server....."

systemctl start mysqld &>>LOGFILE
VALIDATE $? "started mysqld"

# mysql_secure_installation --set-root-pass ExpenseApp@1 &>>LOGFILE
# VALIDATE $? "Setting Up root password"


mysql -h db.dawsmani.site -uroot -pExpenseApp@1 -e 'show databases;'&>>LOGFILE
if [ $? -ne 0 ]
then 
     mysql_secure_installation --set-root-pass ${mysql_root_password} &>>$LOGFILE
    VALIDATE $? "MySQL Root password Setup"
else
    echo -e "MySQL Root password is already setup...$Y SKIPPING $N"
fi
