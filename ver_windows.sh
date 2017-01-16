#!/bin/bash

IamRoot() {
    # /usr/bin/sudo
    [[ $(id -u) != "0" ]] && {
	echo "Il faut exécuter ce programme avec /usr/bin/sudo"
	exit 0
    }
}

initVerWindows() {
    # Montage /win
    mount -o ro -t ntfs-3g /dev/sda3 /win
    # Liste des fichiers dans Windows 
    find /win -name "*" -exec ls -l {} \; > /tmp/ver-windows-files.list
    # Calcul de la somme MD5 de fichiers dans Windows
    find /win -name "*" -exec md5sum {} \; > /tmp/ver-windows-files.md5sum
}

saveVerWindows() {
    # sauve les 2 dernières dates d'exécution
    cp /var/log/ver-windows/ver-windows.dat /var/log/ver-windows/ver-windows.old
    echo $(date +%Y%m%d) > /var/log/ver-windows/ver-windows.dat
    # Déplace les fichiers dans /var/log/ver-windows
    for i in $(ls  /tmp/ver-windows-files.*)
    do
	sort -k 9 /tmp/$i >  /tmp/sort$i 
	mv /tmp/sort$i /var/log/ver-windows/$i.$(date +%Y%m%d)
    done
}

diffSortVerWindows(){
    read AIER < /var/log/ver-windows/ver-windows.old 
    read UEI < /var/log/ver-windows/ver-windows.dat 
    diff /var/log/ver-windows/*$AIER /var/log/ver-windows/*$UEI
}

IamRoot
initVerWindows
saveVerWindows
diffSortVerWindows

