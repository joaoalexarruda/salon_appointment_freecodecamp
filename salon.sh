#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

# ---
# Your script file should have executable permissions (chmod +x)
# You should not use the clear command in your script
# ---

# You should display a numbered list of the services you offer 
# before the first prompt for input, each with the format #) <service>. 
# For example, 1) cut, where 1 is the service_id
echo -e "\n~~~~~ MY SALON ~~~~~\n"
echo -e "How can I help you?\n"

MAIN_MENU () {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi
  SERVICES=$($PSQL "SELECT service_id, name FROM services")

  if [[ -z $SERVICES ]]
  then
    echo -e "Get the fuck outta here"
  else
    echo "$SERVICES" | while read SERVICE_ID BAR SERVICE_NAME
    do
      echo "$SERVICE_ID) $SERVICE_NAME"
    done
    read SERVICE_ID_SELECTED
    SERVICE_AVAILABILITY=$($PSQL "SELECT available FROM services WHERE service_id = $SERVICE_ID_SELECTED AND available = true")
    if [[ -z $SERVICE_AVAILABILITY ]]
    then
    # If you pick a service that doesn't exist, 
    # you should be shown the same list of services again
      MAIN_MENU "Sorry, we don't have that. Would you like anything else?\n"
    else
      echo -e "\nWhat's your phone number?"
      read CUSTOMER_PHONE
      CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
      if [[ -z $CUSTOMER_NAME ]]
      then
        echo -e "\nI don't have a record for that phone number, what's your name?"
        read CUSTOMER_NAME
        INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(phone, name) values('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
      fi
      SERVICE_NAME_TO_FILL=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
      echo -e "\nWhat time would you like your $(echo $SERVICE_NAME_TO_FILL | sed -E 's/^ *| *$//g'), $(echo $CUSTOMER_NAME | sed -E 's/^ *| *$//g')?"
      read SERVICE_TIME
      CUSTOMER_ID_TO_FILL=$($PSQL "SELECT customer_id from customers WHERE phone = '$CUSTOMER_PHONE'")
      INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) values('$CUSTOMER_ID_TO_FILL', '$SERVICE_ID_SELECTED', '$SERVICE_TIME')")
      echo -e "\nI have put you down for a $(echo $SERVICE_NAME_TO_FILL | sed -E 's/^ *| *$//g') at $(echo $SERVICE_TIME | sed -E 's/^ *| *$//g'), $(echo $CUSTOMER_NAME | sed -E 's/^ *| *$//g')."
    fi
  fi
}

MAIN_MENU