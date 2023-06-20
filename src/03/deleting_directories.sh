#!/bin/bash


function delete_dirs() {
    # Функция для удаления директорий

    declare -Ar local deletion_funcs=( [1]=delete_dir_by_log   \
                                       [2]=delete_file_by_date \
                                       [3]=delete_dir_by_mask )

    ${deletion_funcs[${argv[choice_number]}]}
}


function delete_dir_by_log() {
    # Функция для удаления директорий по логу
   
    declare -r local dir_path_re="\/.*[a-zA-Z]+_[0-9]+$"

    while read -r dir_path; do
        if [[ "${dir_path}" =~ ${dir_path_re} ]]; then
            rm -rf ${dir_path}
        fi
    done < ${DIRECTORY_LOG_PATH}
}


function delete_file_by_date() {
    # Функция для удаления директорий по дате создания

    declare local start_datetime
    declare local end_datetime

    read -rp $'Enter START datetime matching "YYYY-mm-dd HH:MM" format \n' start_datetime
    check_datetime_format "${start_datetime}"

    read -rp $'Enter END datetime matching "YYYY-mm-dd HH:MM" format \n' end_datetime
    check_datetime_format "${end_datetime}"
        
    check_datetime_delta "${start_datetime}" "${end_datetime}"
    
    find / -maxdepth $((${MAX_FIND_DEPTH} + 2)) -type d -newermt "${start_datetime}" -a   \
    -not -newermt "${end_datetime}" -regextype posix-egrep -iregex ".*\/[a-z]+_[0-9]{6}$" \
    -exec rm -r {} \; 2> /dev/null
}


function delete_dir_by_mask() {
    # Функция для удаления директорий по маске

    find / -maxdepth $((${MAX_FIND_DEPTH}+2)) -type d -regextype posix-egrep -iregex \
                              ".*\/[a-z]+_[0-9]{6}$" -exec rm -rf {} \; 2> /dev/null
}