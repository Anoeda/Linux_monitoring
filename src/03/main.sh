#!/bin/bash


source constants.cfg
source ${DEPENDENCY_PATH}/input_parameters_validation.sh
source ${DEPENDENCY_PATH}/error_processing.sh
source script_parameters_validation.sh
source deleting_directories.sh


function main() {

    declare -A local argv=([choice_number]="$1")
    declare -Ar local argv_len=$#

    validate_input_data ${argv[@]}
    delete_dirs
}


main $@