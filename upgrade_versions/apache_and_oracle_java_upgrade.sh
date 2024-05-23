#!/bin/bash

# Define variables for Apache
APACHE_PATH="/app/httpd"
OLD_APACHE_VERSION="9.0.85"
NEW_APACHE_VERSION="9.0.88"
APACHE_URL="https://downloads.apache.org/httpd/httpd-$NEW_APACHE_VERSION.tar.gz"

# Define variables for Java
JAVA_INSTALL_PATH="/usr/java"
OLD_JAVA_VERSION="1.8.0_391"
NEW_JAVA_VERSION="1.8.0_411"
JAVA_URL="https://download.oracle.com/java/8/latest/jdk-8u411-linux-x64.tar.gz"
JAVA_DIR="jdk1.8.0_411"

# Change to the Apache installation directory
cd $APACHE_PATH || { echo "Failed to change directory to $APACHE_PATH"; exit 1; }

# Backup current configuration and binaries
echo "Backing up current Apache configuration and binaries..."
tar -czvf backup_httpd_$OLD_APACHE_VERSION.tar.gz $APACHE_PATH

# Download the new Apache version
echo "Downloading Apache $NEW_APACHE_VERSION..."
wget $APACHE_URL -O httpd-$NEW_APACHE_VERSION.tar.gz

# Extract the new Apache version
echo "Extracting Apache $NEW_APACHE_VERSION..."
tar -xvzf httpd-$NEW_APACHE_VERSION.tar.gz

# Stop the current Apache service
echo "Stopping current Apache service..."
$APACHE_PATH/bin/apachectl stop

# Backup current Apache binaries
echo "Backing up current Apache binaries..."
mv $APACHE_PATH $APACHE_PATH.bak

# Move new Apache version to the installation path
echo "Installing new Apache version..."
mv httpd-$NEW_APACHE_VERSION $APACHE_PATH

# Copy old Apache configuration to the new installation
echo "Copying old Apache configuration to the new installation..."
cp -r $APACHE_PATH.bak/conf $APACHE_PATH/

# Ensure correct permissions for Apache
echo "Setting correct permissions for Apache..."
chown -R apache:apache $APACHE_PATH

# Start the new Apache service
echo "Starting new Apache service..."
$APACHE_PATH/bin/apachectl start

# Clean up Apache files
echo "Cleaning up Apache files..."
rm httpd-$NEW_APACHE_VERSION.tar.gz

# Change to the Java installation directory
cd $JAVA_INSTALL_PATH || { echo "Failed to change directory to $JAVA_INSTALL_PATH"; exit 1; }

# Backup current Java installation
echo "Backing up current Java installation..."
tar -czvf backup_java_$OLD_JAVA_VERSION.tar.gz jdk$OLD_JAVA_VERSION

# Download the new Java version
echo "Downloading Java $NEW_JAVA_VERSION..."
wget --header "Cookie: oraclelicense=accept-securebackup-cookie" $JAVA_URL -O jdk-$NEW_JAVA_VERSION-linux-x64.tar.gz

# Extract the new Java version
echo "Extracting Java $NEW_JAVA_VERSION..."
tar -xvzf jdk-$NEW_JAVA_VERSION-linux-x64.tar.gz

# Update the symbolic link to point to the new Java version
echo "Updating symbolic link to point to the new Java version..."
ln -sfn $JAVA_INSTALL_PATH/$JAVA_DIR $JAVA_INSTALL_PATH/latest

# Ensure correct permissions for Java
echo "Setting correct permissions for Java..."
chown -R root:root $JAVA_INSTALL_PATH/$JAVA_DIR

# Clean up Java files
echo "Cleaning up Java files..."
rm jdk-$NEW_JAVA_VERSION-linux-x64.tar.gz

# Update JAVA_HOME and PATH
echo "Updating JAVA_HOME and PATH..."
export JAVA_HOME=$JAVA_INSTALL_PATH/latest
export PATH=$JAVA_HOME/bin:$PATH

echo "Apache has been upgraded from version $OLD_APACHE_VERSION to $NEW_APACHE_VERSION."
echo "Oracle Java has been upgraded from version $OLD_JAVA_VERSION to $NEW_JAVA_VERSION."

# End of script
