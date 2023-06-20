#!/bin/bash


source constants.cfg
source ${DEPENDENCY_PATH}/input_parameters_validation.sh
source ${DEPENDENCY_PATH}/other_functions.sh
source ${DEPENDENCY_PATH}/error_processing.sh
source script_parameters_validation.sh
source logs_processing.sh


function main() {

    declare -ir local argv=( [choice_number]=$1 )
    declare -ir local argv_len=$#

    validate_input_data
    parse_logs
}


main $@