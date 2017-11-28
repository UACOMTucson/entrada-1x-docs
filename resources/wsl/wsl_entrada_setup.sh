#!/bin/bash
# Install the packages necessary to run Entrada/Medlearn in Windows Subsystem for Linux (unbutnu)
# Usages:
# wsl_entrada_prep -y  :: will install all the packages in order and not prompt the user
# wsl_entrada_prep -y <package group> :: will install all the packages the specified group
#    pacakage groups: APACHE, MARIADB, PHP, OTHER, COMPOSER
script_dir=$PWD
clear
#
# SET -y or not
read -r -p "Would you like to add (-y) to the package install commands? [Y/n]" response
case "$response" in
    [nN][oO]|[nN])
        YES=
        ;;

    *)
        YES=-y
        ;;

esac
# APACHE
read -r -p "Install Apache Packages? [Y|n]" response
case "$response" in
    [nN][oO]|[nN])
        ;;

    *)
        echo "--------------------------------------------"
        echo "Installing Apache2"
        echo "--------------------------------------------"
        sudo apt install apache2 $YES
        ;;

esac
# MARIADB
read -r -p "Install MariaDB Packages? [Y|n]" response
case "$response" in
    [nN][oO]|[nN])
        ;;

    *)
        echo "--------------------------------------------"
        echo "Installing MariaDB Packages"
        echo "--------------------------------------------"
        sudo apt-get install software-properties-common $YES
        sudo apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xF1656F24C74CD1D8 $YES
        sudo add-apt-repository 'deb [arch=amd64,i386,ppc64el] http://mirror.nodesdirect.com/mariadb/repo/10.2/ubuntu xenial main' $YES
        sudo apt update $YES
        sudo apt-get install mariadb-server $YES
        ;;

esac
# PHP
read -r -p "Install PHP Packages? [Y|n]" response
case "$response" in
    [nN][oO]|[nN])
        ;;

    *)
        echo "--------------------------------------------"
        echo "Installing PHP Packages"
        echo "--------------------------------------------"
        sudo add-apt-repository ppa:ondrej/php $YES
        sudo apt-get update  $YES
        sudo apt-get upgrade $YES
        sudo apt-get install php5.6 $YES
        sudo apt install php5.6-opcache $YES
        sudo apt install php5.6-mcrypt $YES
        sudo apt install php5.6-gd $YES
        sudo apt install php5.6-devel $YES
        sudo apt install php5.6-mysql $YES
        sudo apt install php5.6-intl $YES
        sudo apt install php5.6-mbstring $YES
        sudo apt install php5.6-bcmath $YES
        sudo apt install php5.6-ldap $YES
        sudo apt install php5.6-imap $YES
        sudo apt install php5.6-pspell $YES
        sudo apt install php5.6-soap $YES
        sudo apt install php5.6-xml $YES
        sudo apt install php5.6-xmlrpc $YES
        sudo apt install php5.6-curl $YES
        ;;

esac
# OTHER LIBS
read -r -p "Install Other Packages? [Y|n]" response
case "$response" in
    [nN][oO]|[nN])
        ;;

    *)
        echo "--------------------------------------------"
        echo "Installing Other Packages"
        echo "--------------------------------------------"
        sudo apt install openssl $YES
        sudo apt install mod_ssl $YES
        sudo apt install git $YES
        sudo apt install htmldoc $YES
        sudo apt install wkhtmltopdf $YES
        sudo apt install curl $YES
        sudo apt install ruby $YES
        sudo apt install gem $YES
        sudo gem install capistrano -v 2.15.9
        sudo gem install colorize
        sudo gem install sshkit
        sudo gem install gnm-caplock
        ;;

esac
# COMPOSER
read -r -p "Install COMPOSER Packages? [Y|n]" response
case "$response" in
    [nN][oO]|[nN])
        ;;

    *)
        echo "--------------------------------------------"
        echo "Installing Composer"
        echo "--------------------------------------------"
        curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer
        ;;

esac
# APACHE SETUP
read -r -p "Configure your Apache Server? [Y|n]" response
case "$response" in
    [nN][oO]|[nN])
        ;;

    *)
        echo "--------------------------------------------"
        echo " Configuring Apache for Entrada "
        echo "--------------------------------------------"
        # Collect apache settings
        read -r -p "Entrada Server Host Name: [entrada-local]" hostname
        if [ "$hostname" == "" ] 
        then
            hostname=entrada-local
        fi

        read -r -p "Entrada Server Port Number: [8088]" hostport
        hostport=($hostport + 0 )
        if [ $hostport -eq 0 ] 
        then
            hostport=8088
        fi
        
        # read -r -p "MedLearn Server URI: [entrada]" uri
        # if [$uri == ''] 
        # then
        #     uri=entrada
        # fi
        
        read -r -p "Entrada Document Root: [/mnt/c/development/comit/entrada/entrada-1x-me/www-root]" docroot
        if [ "$docroot" == "" ] 
        then
            docroot=/mnt/c/development/comit/entrada/entrada-1x-me/www-root
        fi

        echo "Settings: http://${hostname}:${hostport}/${uri} -> ${docroot}"
        read -r -p "Continue? [Y|n]" cresponse
        case "$cresponse" in
            [nN][oO]|[nN])
                ;;

            *)
                echo "--------------------------------------------"
                echo " Upadating your system"
                echo "--------------------------------------------"
                read -r -p "Add hosts entries for ${hostname}? [Y/n]" addhost
                case "$cresponse" in
                    [nN][oO]|[nN])
                        ;;

                    *)
                        # sudo sed -i.bak -e "s/# BEGIN/127.0.0.1 ${hostname}\n\n# BEGIN/" >> /mnt/c/Windows/System32/drivers/etc/hosts
                        sudo sed -i.bak -e "/^# This file was automatically/ d" /etc/hosts #remove line so file doesn't get overwritten
                        sudo sed -i -e "1s/^/127.0.0.1  ${hostname}\n/" /etc/hosts
                        ;;
                esac
                echo "***************************************************************************************************"
                echo "  You need to add the following line to your windows hosts file (windows/system32/drivers/etc/hosts)"
                echo "    127.0.0.1  ${hostname}"
                echo "***************************************************************************************************"
                sudo a2enmod rewrite
                configfile=/etc/apache2/sites-available/$hostname.conf
                portsfile=/etc/apache2/ports.conf
                defaultconfig=/etc/apache2/sites-available/000-default.conf
                sudo cp $defaultconfig $configfile 
                sudo sed -i.bak -e "s/Listen 80/Listen ${hostport}/" $portsfile 
                sudo sed -i.bak -e "s/:80/:${hostport}/" $configfile 
                sudo sed -i -e "s/#ServerName www.example.com/ServerName ${hostname}/" $configfile 
                esc_docroot="$(sed -e 's/[\/&]/\\&/g' <<<"$docroot")"
                sudo sed -i -e "s/\/var\/www\/html/${esc_docroot}/" $configfile 
                sudo sed -i -e "s/<\/VirtualHost>/\t<Directory ${esc_docroot} >\n\t\tOptions FollowSymLinks\n\t\tAllowOverride all\n\t\tRequire all granted\n\t<\/Directory>\n<\/VirtualHost>/" $configfile
                read -r -p "Run composer update? [Y/n]" composer_update
                case "$composer_update" in
                    [nN][oO]|[nN])
                        ;;

                    *)
                        cd $docroot
                        composer update
                        cd $script_dir
                        ;;
                esac
                sudo a2dissite 000-default
                sudo service apache2 start
                sudo a2ensite $hostname
                sudo service apache2 restart
                ;;

        esac
        ;;

esac
# ENTRADA DB SETUP
read -r -p "Initialize your Entrada Database? [Y|n]" response
case "$response" in
    [nN][oO]|[nN])
        ;;

    *)
        echo "--------------------------------------------"
        echo " Initializing Entrada Database"
        echo "--------------------------------------------"

        db_configfile=/etc/mysql/my.cnf

        # Collect settings
        read -r -p "MariaDB port: [3306]" db_port
        db_port=($db_port + 0)
        if [ $db_port -eq 0 ] 
        then
            db_port=3306
        fi

        read -r -p "Entrada Database Name: [entrada]" db_basename
        if [ "$db_basename" == "" ] 
        then
            db_basename=entrada
        fi

        read -r -s -p "DB Password:" db_password
        read -r -s -p "Verify Password:" db_password_verify

        while [ "$db_password_verify" != "$db_password" ]; do
            echo "!! Paswords did not match. Please retry. !!"
            read -r -s -p "DB Password:" db_password

            read -r -s -p "Verify Password:" db_password_verify
        done

        sudo service mysql stop
        sudo sed -i.bak -e "/^port/s/= .*/= ${db_port}/g" $db_configfile
        sudo service mysql start
        sudo sed -e "s/entrada/${db_basename}/g" ./entrada.create.db.sql > ./tmp.create.db.sql
        sudo sed -i -e "s/password/${db_password}/g" ./tmp.create.db.sql
        mysql -u root -p < ./tmp.create.db.sql
        rm ./tmp.create.db.sql
        ;;


esac
# SSH Setup
read -r -p "Copy SSH keys folder? [Y|n]" response
case "$response" in
    [nN][oO]|[nN])
        ;;

    *)
        read -r -p "Windows Username:" windows_username 
        windows_user_dir=/mnt/c/Users/$windows_username/.ssh
        echo "--------------------------------------------"
        echo " Copying SSH keys from ${windows_user_dir} "
        echo "--------------------------------------------"
        cp -r $windows_user_dir ~/.ssh
        ;;
esac