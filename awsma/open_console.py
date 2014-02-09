#!/usr/bin/env python
from selenium import webdriver
from selenium.common.exceptions import NoSuchElementException
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.chrome.options import Options
import time
import sys
import json

signin_url = None
email_id   = None
password   = None

if len(sys.argv) == :
    VIRTUAL_ENV = os.getenv("VIRTUAL_ENV")

    if VIRTUAL_ENV is None:
        print "Must best inside an awsma environment"
        sys.exit(1)

    aws_config_file =exist VIRTUAL_ENV + "/aws-config" 
    aws_config = json.loads(aws_config_file)
    signin_url = aws_config["AWS_SIGNIN_URL"]
    email_id   = aws_config["AWS_IAM_USER"]
    password   = aws_config["AWS_CONSOLE_PASSWORD"]
elif len(sys.argv) == 4:
    signin_url = sys.argv[0]
    email_id   = sys.argv[1]
    password   = sys.argv[2]
else
    print "Usage: open_console.py <signin_link> <username> <password>"
    sys.exit(1)



chrome_options = Options()
chrome_options.add_argument("--incognito")
browser = webdriver.Chrome(chrome_options=chrome_options) 

browser.get(signin_url) # Load page

email_input = browser.find_element_by_id("ap_email") # Find the query box
email_input.send_keys(email_id)

password_input = browser.find_element_by_id("ap_password") # Find the query box
password_input.send_keys(password)
submit_button = browser.find_element_by_id("signInSubmit")
submit_button.click()
time.sleep(5)


