#!/bin/sh
# Settigs variables
awl_folder=~/.awl
awl_file_log=$awl_folder/awl.log
awl_tmp_file=/tmp/awl_last_window
max_idle_time=300000

# Functions
prepare_folders()
{
  if [ ! -d $awl_folder ]; then
    mkdir $awl_folder
  fi

  if [ ! -f $awl_file_log ]; then
    touch $awl_file_log
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
  if [ $is_idle ]; then
    current_status=Idle\tIdle 
  else
    current_window_id=`xprop -root 32x '\t$0' _NET_ACTIVE_WINDOW | cut -f 2`
    if [ "$current_window_id" == "0x0" ]; then
      current_status=Idle\tIdle
    else
      class=`xprop -id $(xprop -root 32x '\t$0' _NET_ACTIVE_WINDOW | cut -f 2) -notype WM_CLASS | grep -Po '= \"\K[^\"]*'`
      name=`xprop -id $(xprop -root 32x '\t$0' _NET_ACTIVE_WINDOW | cut -f 2) -notype _NET_WM_NAME | grep -Po '= \"\K[^\"]*'`
      current_status=$class\t$name
    fi
  fi
  
  if [ -f $awl_tmp_file ]; then
    old_status=`cat $awl_tmp_file`
    if [ "$old_status" != "$current_status" ]; then
      echo -e "$current_status" > $awl_tmp_file
      echo -e "stop\t$(date +%s)\t$old_status">>$awl_file_log
      echo -e "start\t$(date +%s)\t$current_status">>$awl_file_log
    fi
  else
    echo -e "$current_status" > $awl_tmp_file
    echo -e "start\t$(date +%s)\t$current_status">>$awl_file_log
  fi
}

###
# Main
###

prepare_folders
check_idle
check_event

