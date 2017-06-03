#!/bin/sh

#########################################################################
#		Copy'n'Register VMs in ESXi 6.5				#
# Version:				0.1				#
# Author: 				Katarzyna Mazur 		#
# License:				GNU General Public License 	#
#########################################################################

#########################################################################
# USAGE		<vmname> <num of copies> <snaphot num> 			#
#########################################################################

# copy vms
vmname=$1
howmanyvms=$2
snapnum=$3
chgto=$4
currdir=`pwd`

i=1
while [ "$i" -le "$howmanyvms" ]; do
    newname="${vmname}_$i"
    # copy vms
    echo "-------------------------------------------------------------------"
    echo "Started copying machine '${vmname}_$i' ... "
    mkdir ./$newname
    cp "${vmname}"/* $newname
    cp lifesaver.py $newname
    echo "Copying machine '$newname' ... DONE!"
    # in each new directory, run python script in order to change the name of the vm in vm's files
    echo "-------------------------------------------------------------------"
    echo "Entering the '$newname' directory ... "
    cd $newname
    echo "Repairing VM files ..."
    python3 lifesaver.py $vmname $newname $snapnum
    echo "Going back to $currdir ..."
    cd ..
    # in each new directory, rename remaining files 
    echo "-------------------------------------------------------------------"
    echo "Entering the '$newname' directory ... "
    cd $newname
    echo "Renaming files ... "
    mv $vmname.nvram $newname.nvram
    mv "${vmname}_0-000001-delta.vmdk" "${newname}_0-000001-delta.vmdk"
    mv "${vmname}_0-flat.vmdk" "${newname}_0-flat.vmdk"
    echo "Going back to $currdir ..."
    cd ..
    # in each new directory, remove unnecessary files
    echo "-------------------------------------------------------------------"
    echo "Entering the '$newname' directory ... "
    cd $newname
    echo "Removing unnecessary files in '$newname' ... "
    rm -rf ${vmname}_0.vmdk
    rm -rf $vmname.vmx
    rm -rf $vmname.nvram
    rm -rf ${vmname}_0-000001.vmdk
    rm -rf $vmname-aux.xml
    rm -rf $vmname-Snapshot$snapnum.vmsn
    rm -rf $vmname-aux.xml  
    rm -rf $vmname.vmsd
    rm -rf *.log
    rm -rf lifesaver.py 
    echo "Going back to $currdir ..."
    cd ..
    # automatically register vms
    echo "-------------------------------------------------------------------"
    echo "Registering VM '$newname' ... "
    vim-cmd solo/registervm $currdir/$newname/$newname.vmx
    echo "-------------------------------------------------------------------"
    i=$((i+1)) 
done 

echo "-------------------------------------------------------------------"
echo "Yay! Copying and registering $howmanyvms virtual machine(s) DONE!"
echo "-------------------------------------------------------------------"
