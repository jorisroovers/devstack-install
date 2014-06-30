read -e -p "OS_USERNAME: " OS_USERNAME
export OS_USERNAME
read -e -p "OS_AUTH_URL: " OS_AUTH_URL
export OS_AUTH_URL
read -e -p "OS_TENANT_NAME: " OS_TENANT_NAME
export OS_TENANT_NAME
read -s -p "OS_PASSWORD: " OS_PASSWORD
export OS_PASSWORD

echo # newline
echo "===================================="
echo " OS_USERNAME:    $OS_USERNAME"
echo " OS_TENANT_NAME: $OS_TENANT_NAME"
echo " OS_AUTH_URL:    $OS_AUTH_URL"
echo "===================================="

# Prompts a given yes/no question. 
# Returns 0 if user answers yes, 1 if no
# Reprompts if different answer
ask_yes_no(){
    question=$1
    while true; do
        read -e -p "$question" -i "Y" yn
        case $yn in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
        esac
    done 
}
                                                                       
if ask_yes_no "Write to file [Y/n] ";
then
    read -e -p "Filename? " -i "openrc" filename
    # Check if file exists
    if [ -e "$src" ]; then
        echo "File $filename already exists, skipping filewrite."
    else
        echo "OS_USERNAME=$OS_USERNAME" >> $filename
        echo "OS_AUTH_URL=$OS_AUTH_URL" >> $filename
        echo "OS_TENANT_NAME=$OS_TENANT_NAME" >> $filename
        echo "OS_PASSWORD=$OS_PASSWORD" >> $filename
    fi
fi
