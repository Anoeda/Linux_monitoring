#!/bin/bash

source constants.cfg
source ${DEPENDENCY_PATH}/include_dependencies.sh
source script_parameters_validation.sh


function main() {

    declare -A local argv=( [folder_name]=$1 [file_name]=$2 [file_size]=$3 )
    declare -Ar local argv_idx=( [folder_name]=1 [file_name]=2 [file_size]=3 )
    declare -ir local argv_len=$#

    validate_input_data "${argv[@]}"
    create_directory_tree
    generate_log
}


measure_time_of "main $@"