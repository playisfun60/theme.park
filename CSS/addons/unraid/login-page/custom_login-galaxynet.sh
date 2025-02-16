#!/bin/bash
TYPE="galaxynet"
THEME="universe.css"
DOMAIN="playisfun60.github.io"
ADD_JS="true"
JS="custom_text_header.js"
DISABLE_THEME="false"

echo -e "Variables set:\\n\
THEME         = ${THEME}\\n\
DOMAIN        = ${DOMAIN}\\n\
ADD_JS        = ${ADD_JS}\\n\
JS            = ${JS}\\n\
DISABLE_THEME = ${DISABLE_THEME}\\n"

# Restore login.php
if [ ${DISABLE_THEME} = "true" ]; then
  echo "Restoring backup of login.php" 
  cp -p /usr/local/emhttp/login.php.backup /usr/local/emhttp/login.php
  exit 0
fi

# Backup login page if needed.
if [ ! -f /usr/local/emhttp/login.php.backup ]; then
  echo "Creating backup of login.php" 
  cp -p /usr/local/emhttp/login.php /usr/local/emhttp/login.php.backup
fi

# Adding stylesheets
if ! grep -q ${DOMAIN} /usr/local/emhttp/login.php; then
  echo "Adding stylesheet"
  sed -i -e "\@<style>@i\    <link rel='stylesheet' href='https://${DOMAIN}/theme.park/CSS/addons/unraid/login-page/${TYPE}/${THEME}'>" /usr/local/emhttp/login.php
  echo 'Stylesheet set to' ${THEME}
fi

# Adding/Removing javascript
if [ ${ADD_JS} = "true" ]; then
  if ! grep -q ${JS} /usr/local/emhttp/login.php; then
    if grep -q "<script type='text/javascript' src='https://${DOMAIN}/theme.park/CSS/addons/unraid/login-page/" /usr/local/emhttp/login.php; then
      echo "Replacing Javascript"
      sed -i "/<script type='text\/javascript' src='https:\/\/${DOMAIN}\/theme.park\/CSS\/addons\/unraid\/login-page/c <script type='text/javascript' src='https://${DOMAIN}/theme.park/CSS/addons/unraid/login-page/${TYPE}/js/${JS}'></script>" /usr/local/emhttp/login.php
    else
      echo "Adding javascript"
      sed -i -e "\@</body>@i\    <script type='text/javascript' src='https://${DOMAIN}/theme.park/CSS/addons/unraid/login-page/${TYPE}/js/${JS}'></script>" /usr/local/emhttp/login.php
    fi
  fi
else
  if grep -q ${JS} /usr/local/emhttp/login.php; then
    echo "Removing javascript.."
    sed -i "/<script type='text\/javascript' src='https:\/\/${DOMAIN}\/theme.park\/CSS\/addons\/unraid\/login-page/d" /usr/local/emhttp/login.php
  fi
fi

# Changing stylesheet
if ! grep -q ${TYPE}"/"${THEME} /usr/local/emhttp/login.php; then
  echo "Changing existing custom stylesheet.." 
  sed -i "/<link rel='stylesheet' href='https:\/\/${DOMAIN}\/theme.park\/CSS\/addons\/unraid\/login-page/c <link rel='stylesheet' href='https://${DOMAIN}/theme.park/CSS/addons/unraid/login-page/${TYPE}/${THEME}'>" /usr/local/emhttp/login.php
  echo 'Stylesheet set to' ${THEME}
fi