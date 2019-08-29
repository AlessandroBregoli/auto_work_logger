# Settigs variables
awl_folder=~/.awl
awl_file_log=$awl_folder/awl.log
awl_file_config=$awl_folder/awl.config
awl_tmp_file=/tmp/awl_last_window
max_idle_time=300000
awl_update_time=30
pidfile=/tmp/awl.pidfile
#Time in second after midnight i.e. 7200 is 2am
virtual_midnight=7200

# load config file
if [ -f $awl_file_config ]; then
    . $awl_file_config
fi

#functions

fn_get_vmidnight_timestamp()
{
  now=$(date '+%s')
  midnight=$(date -d 'today 00:00:00' '+%s')

  vmidnight_timestamp=`echo $midnight+$virtual_midnight|bc`
  if [ "`echo $now-$midnight|bc`" -lt "$virtual_midnight" ];then
    vmidnight_timestamp=`echo $vmidnight_timestamp-86400|bc`
  fi
  echo $vmidnight_timestamp
}



