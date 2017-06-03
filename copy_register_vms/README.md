## Scripts for ESXi 6.5 automation.

No need for vCenterServer! Just log in to ur esxi host, run the script and n-joy!

1. Log in to ur ESXi host using SSH:

    ``` ssh root@ipaddr -p port ```
    
2. Copy and paste 2 files: `copy_n_register_vms.sh` and `lifesaver.py` to the default directory with your VM u want to copy (default is `/vmfs/volumes/volumename/`)

3. Run the script:

    ./copy_n_register_vms.sh vmname num_of_copies snapshotnumber