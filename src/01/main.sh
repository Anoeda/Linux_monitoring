#!/bin/bash

source constants.cfg
source ${DEPENDENCY_PATH}/include_dependencies.sh
source script_parameters_validation.sh


function main() {
    
    declare -Ar local argv=( [absolute_path]=$1 [folder_count]=$2 [folder_name]=$3 \
                             [file_count]=$4 [file_name]=$5 [file_size]=$6 )

    declare -Ar local argv_idx=( [absolute_path]=1 [folder_count]=2 [folder_name]=3 \
                                 [file_count]=4 [file_name]=5 [file_size]=6 )

    declare -ir local argv_len=$#

    validate_input_data ${argv[@]}
    create_directory_tree
    generate_log
}


main $@