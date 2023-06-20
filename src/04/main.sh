#!/bin/bash


source constants.cfg
source ${DEPENDENCY_PATH}/include_dependencies.sh
source script_parameters_validation.sh
source log_creation.sh


function main() {

    declare -ir local argv_len=$#

    validate_input_data
    create_log
}


main $@