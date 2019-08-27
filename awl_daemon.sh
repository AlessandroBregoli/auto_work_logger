#!/bin/sh
# Settigs variables
awl_folder=~/.awl
awl_file_log=$awl_folder/awl.log
awl_file_config=$awl_folder/awl.config
awl_tmp_file=/tmp/awl_last_window
max_idle_time=300000
awl_update_time=30

# Functions
prepare_folders()
{
  if [ ! -d $awl_folder ]; then
    mkdir $awl_folder
  fi

  if [ ! -f $awl_file_log ]; then
    touch $awl_file_log
  fi

  if [ -f awl_file_config ]; then
    . $awl_file_config
  fi
  if [ -f $awl_tmp_file ]; then
    rm $awl_tmp_file
  fi
}

check_idle()
{
  if [ "$(xprintidle)" -gt "$max_idle_time" ]; then
    is_idle=true
  fi
}

check_event()
{
  if [[ $is_idle == true ]]; then
    current_status="Idle\tIdle"
    is_idle=false
  else
    current_window_id=`xprop -root 32x '\t$0' _NET_ACTIVE_WINDOW | cut -f 2`
    if [ "$current_window_id" == "0x0" ]; then
      current_status="Idle\tIdle"
    else
      class=`xprop -id $(xprop -root 32x '\t$0' _NET_ACTIVE_WINDOW | cut -f 2) -notype WM_CLASS | grep -Po '= \"\K[^\"]*'`
      name=`xprop -id $(xprop -root 32x '\t$0' _NET_ACTIVE_WINDOW | cut -f 2) -notype _NET_WM_NAME | grep -Po '= \"\K[^\"]*'`
      current_status="$class\t$name"
    fi
  fi
  current_status=`echo -e $current_status`
  
  if [ -f $awl_tmp_file ]; then
    old_status=`cat $awl_tmp_file`
    if [ "$old_status" != "$current_status" ]; then
      echo -e "$current_status" > $awl_tmp_file
      echo -e "stop\t$(date +%s)\t$old_status">>$awl_file_log
    fi
  else
    echo -e "start\t$(date +%s)\tstart\tstart">>$awl_file_log
    echo -e "$current_status" > $awl_tmp_file
  fi
}

###
# Main
###

prepare_folders
while [ true ]
do
  check_idle
  check_event
  sleep $awl_update_time
done
