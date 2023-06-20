#!/bin/bash


source constants.cfg
source ${DEPENDENCY_PATH}/input_parameters_validation.sh
source ${DEPENDENCY_PATH}/error_processing.sh
source script_parameters_validation.sh
source exposing_metrics.sh


function main() {

    declare -ir local argv_len=$#

    validate_input_data
    get_metrics
}


main $@