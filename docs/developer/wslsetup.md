# Setup Entrada on WSL (Windows Subsystem for Linux aka Ubuntu Subsystem)

# Requirements

* Windows 10 Professional with the Anniversary Update
* Enable Developer Mode
* WSL started and configured for the first time

For more on what you need to make WSL run on Windows 10 go [here](https://msdn.microsoft.com/en-us/commandline/wsl/about)

This guide assumes you are using Ubuntu Xenial, but with the Fall Creators Update or later (build 16215) you can install any distro of Linux you can get in the Windows Store. 

You may need to adapt some commands and scripts to your Linux distro.

## Setup the Entrada code

WSL mounts your entire c drive to the WSL instance. So anything you put on your c drive is accessible from your Linux bash. You can put your Entrada code anywhere that works for you and your WSL will be able to access it. This also includes any services like Apache.

The path to any files on your Windows host will start with `/mnt`:

```/mnt/c/```

If you have other drives, WSL might also mount those.

## Install dependencies 

You will install:

* Apache 2.4
* MariaDB
* PHP dependencies
* Lots of other pakcages and UNIX programs

### Apache

We are going to install Apache 2.4 because that is what apt on Xenial will grab for you. It will work just fine.

```sudo apt install apache2```

### MariaDB

You can use this guide to setup and install the MariaDB from the repository for your Linux distro.

[Setting up MariaDB Repositories](https://downloads.mariadb.org/mariadb/repositories/#mirror=digitalocean-sfo&distro=Ubuntu&distro_release=xenial--ubuntu_xenial&version=10.2)

During the install MariaDB will prompt you to enter a root password. You'll need this later so make a note of it.

 ### PHP libraries

 This guide assumes you are using php5.6. You may need to change these commands to install the version of PHP you are using.

 ```sudo apt install php5.6```

 ```sudo apt install php5.6-opcache```

 ```sudo apt install php5.6-mcrypt```

 ```sudo apt install php5.6-gd```

 ```sudo apt install php5.6-devel```

 ```sudo apt install php5.6-mysql```

 ```sudo apt install php5.6-intl```

 ```sudo apt install php5.6-mbstring```

 ```sudo apt install php5.6-bcmath```

 ```sudo apt install php5.6-ldap```

 ```sudo apt install php5.6-imap```

 ```sudo apt install php5.6-pspell```

 ```sudo apt install php5.6-soap```

 ```sudo apt install php5.6-xmlrpc```
 
 ```sudo apt install php5.6-curl```

 ## Other libraries

 ```sudo apt install openssl```

 ```sudo apt install mod_ssl```

 ```sudo apt install git```

 ```sudo apt install htmldoc```

 ```sudo apt install wkhtmltopdf```

 ```sudo apt install curl```

 ```sudo apt install ruby```

 ```sudo apt install gem```

 ```sudo gem install capistrano -v 2.15.9```

 ```sudo gem install colorize```

 ```sudo gem install sshkit```

 ```sudo gem install gnm-caplock```

  ## Composer

  Do this.

  ```curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer```

  ## Configure Apache

  This assumes Apache 2.4. There are significant changes from 2.2 to 2.4 so your usual Entrada conf file may not work.

  Apache configuration is located here:

  ```/etc/apache2```

  You now start and stop apache like this:

  ```sudo service apache2 stop```

  ```sudo service apache2 start```

  Apache2 comes with commands that help you do things with apache, like enable modules.
  
  You will need to enable the rewrite module with the `a2enmod` command.

  ```sudo a2enmod rewrite``` 

  You can also use the commands to setup and enable a site, but first you need to create the Entrada conf file for your Entrada site. We are going to do this by copying the default conf file in sites-available.

  ```sudo cp sites-available/000-default.conf sites-available/entrada.conf```

  I used entrada.conf but you can use any name that suits your setup.

  Open entrada.conf in a text editor (I like vim for the syntax highlighting).

  Of course there isn't much in there but you want it to look like the sample conf below, but with all document paths replaced with the actual paths to your Entrada source code. I have multiple versions of Entrada setup with relative paths so I make my document root point to a folder where all of my Entradas live. 

  Notice the ServerName directive. I use this as a hostname on my host Windows system that points to 127.0.0.1. This lets me do a URL like this:

  ```http://medlearn-local:8088/entrada```

  I added this to the hosts file on Windows. I highly recommend you do this, too.

  Note that I am also not using port 80 in order to avoid conflicts with other sites hosted in IIS. Your port may vary.

  If you use a ServerName you will need to add the name to your WSL hosts. Doing this on Ubuntu is similar to doing this on windows.

  Open `/etc/hosts` in a text editor. I like vim:

  ```sudo vim /etc/hosts```

  Add this to the top section before the "The following lines are desireable for IPv6 capable hosts.

  ```127.0.0.1       entrada-local```

  Replace `entrada-local` with your hostname.

  You will want to make this change persistent. Notice the comment at the top:

  ```This file was automatically generated by WSL. To stop automatic generation of this file, remove this line.```

  That comment is right. Remove or move that comment so there is no line at the top of the file. This will stop WSL from regenerating that file every time you start the WSL bash, which would lose your hostname.

Sample conf
------

```
<VirtualHost *:8088>
        # The ServerName directive sets the request scheme, hostname and port that
        # the server uses to identify itself. This is used when creating
        # redirection URLs. In the context of virtual hosts, the ServerName
        # specifies what hostname must appear in the request's Host: header to
        # match this virtual host. For the default virtual host (this file) this
        # value is not decisive as it is used as a last resort host regardless.
        # However, you must set it for any further virtual host explicitly.
        ServerName medlearn-local

        ServerAdmin webmaster@localhost
        DocumentRoot /mnt/c/development/comit/entrada

        # Available loglevels: trace8, ..., trace1, debug, info, notice, warn,
        # error, crit, alert, emerg.
        # It is also possible to configure the loglevel for particular
        # modules, e.g.
        #LogLevel info ssl:warn

        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined

        <Directory /mnt/c/development/comit/entrada >
                Options FollowSymLinks
                AllowOverride all
                Require all granted
        </Directory>

        # For most configuration files from conf-available/, which are
        # enabled or disabled at a global level, it is possible to
        # include a line for only one particular virtual host. For example the
        # following line enables the CGI configuration for this host only
        # after it has been globally disabled with "a2disconf".
        #Include conf-available/serve-cgi-bin.conf
</VirtualHost>

# vim: syntax=apache ts=4 sw=4 sts=4 sr noet
```

Once you have your entrada.conf setup you can enable the site. This sets up a symlink between sites-availble and sites-enabled.

Make sure apache is running, first.

```sudo service apache2 start```

Enable the site.

```sudo a2ensite entrada```

*Replace `entrada` with whatever the name of your site/site conf file is.*

You can see other commands on the [manpages](https://manpages.debian.org/jessie/apache2/index.html).

Restart apache

```sudo service apache2 restart```

You should be able to load Entrada in the browser. This is my URL:

```http://medlearn-local:8088/uacomtucson/entrada-1x-me/www-root/```

If you get PHP errors you probably just need to run composer update.

# Connecting to MariaDB

You can use the usualy command on bash to connect to MariaDB

```mysql -u root -p```

Once you have users and databases setup you can also connect to MariaDB with HeidiSQL. I made a copy of my existing connection to my MariaDB that was running in VirtualBox/CentOS (vagrant) and changed the password to match what I setup in the WSL MariaDB.

# Entrada Setup

You should be able to run the Entrada setup now. You'll want to create your database in MariaDB first.

```sql
CREATE DATABASE `entrada` CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE DATABASE `entrada_auth` CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE DATABASE `entrada_clerkship` CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE USER 'entrada'@'localhost' IDENTIFIED BY 'password';
GRANT ALL ON entrada.* TO 'entrada'@'%';
GRANT ALL ON entrada_auth.* TO 'entrada'@'%';
GRANT ALL ON entrada_clerkship.* TO 'entrada'@'%';
```

You can give yourself access to MariaDB like this.

```sql
CREATE USER '<myusername>'@'%' IDENTIFIED BY 'password';
GRANT ALL ON entrada.* TO '<myusername>'@'%';
GRANT ALL ON entrada_auth.* TO '<myusername>'@'%';
GRANT ALL ON entrada_clerkship.* TO '<myusername>'@'%';
```

And then use that to connect to MariaDB with HeidiSQL.

# Capistrano and the SSH keys

If you are planning on using Capistrano to deploy from WSL, you'll want to move your SSH key into the .ssh folder in your WSL account and set the permissions to make that work. This is where you `.ssh` folder is.

```/home/<username>/.ssh```

### Check capistrano is working and you can deploy

If you are setup to use Capistrano you'll want to test it. 


