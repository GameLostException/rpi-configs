#!/bin/bash

##########################################################
# SETUP

# URL of a Web service to retrieve our public IP. It is
# assumed to return a plain text IP.
IP_SERVICE='https://ipinfo.io/ip'

# URL of a web service to retrieve the location details of
# our public IP. It is assumed to take an plai text IP in
# argument as an extra path level at the end of the URL
# and return a JSON payload that we'll parse using the JQ_*
# constants further bellow.
LOC_SERVICE='https://ipinfo.io'

# jq based json parsing queries to retrieve various elements
# from the response of the IP location details.
JQ_CITI='.city?'
JQ_COUNTRY='.country?'
JQ_CONTINENT='.timezone?'

# The name of the city our ISP is usually delivering an IP
# from. It is compared with the one we get from our public
# IP and warns if they match each others: if our public IP
# is located in our ISP City, chances are we're not
# connected through a VPN.
LOCAL_CITY='London'

# END OF SETUP 
###########################################################

COL_RED="\\e[91m"
COL_CYAN="\\e[96m"
COL_BLINK="\\e[5m"
COL_BOLD="\\e[1m"
COL_UNDER="\\e[4m"
COL_RESET="\\e[0m"

# Displays a text spinner just after the string passed as argument,
# if any. Spins as long as the process invoked just before the
# function call runs.
function spin () {
    prevPID=$!
    spinner='-\|/'
    #spinner='⠁⠂⠄⡀⢀⠠⠐⠈'
    i=0
    while kill -0 $prevPID 2>/dev/null
    do
	i=$(( (i+1) %4 ))
	echo -ne "\r$1${spinner:$i:1}"
	sleep .1
    done   
}

# Get our external IP and save it to a tmp file
curl -s $IP_SERVICE > /tmp/ip.txt &
spin "public IP: "
publicIP=$(cat /tmp/ip.txt)
echo -e "\rpublic IP: $COL_UNDER$COL_CYAN$publicIP$COL_RESET"

# Get the location details of our external IP and parse them clean
curl -s $LOC_SERVICE/$publicIP > /tmp/loc.txt &
spin "Public location: "
publicInfo=$(cat /tmp/loc.txt)
publicCity=$(echo $publicInfo | jq $JQ_CITI | sed 's/"//g')
publicCountry=$(echo $publicInfo | jq $JQ_COUNTRY | sed 's/"//g')
publicContinent=$(echo $publicInfo | jq $JQ_CONTINENT | sed 's/"//g')


# Check if our public location matches our local city, in which case it may
# show our VPN is down
style="$COL_CYAN"
if [ "$publicCity" = "$LOCAL_CITY" ]; then
    style="$COL_BLINK$COL_RED"
    alert="\n$COL_BOLD$COL_RED/!\\ $COL_RESET$style Our public IP location being $publicCity, we might not be behind a VPN!$COL_RESET $COL_BOLD$COL_RED/!\\ $COL_RESET \n" 
fi

# Finally display our local details. If our public IP is located
# in the same city as the one setup as "LOCAL_CITI", show the
# details in red along with an alert message.
echo -e "\rPublic location: $style$publicCity$COL_RESET, $style$publicCountry$COL_RESET ($style$publicContinent$COL_RESET)"
echo -e "$alert"
