function raise_exception() {
    # Функция для вывода описания кода ошибки

    declare -ir local error_code=$1
    declare -ar local error_description=( 
        "Incorrect number of script parameters"
        "[${argv_idx[absolute_path]}] Absolute path is not correct"
        "[${argv_idx[folder_count]}] The number of folders must be an integer between 1 and  \
                                                                          ${MAX_OBJ_COUNT}"  
        "[${argv_idx[folder_name]}] The folder name letters must be of the English alphabet, \
                                uniq and its number must not exceed ${MAX_FOLDER_NAME_LEN}"  
        "[${argv_idx[file_count]}] The number of files must be an integer between 1 and      \
                                                                      ${MAX_OBJ_COUNT}"      
        "[${argv_idx[file_name]}] The file name letters must be of the English alphabet,     \
         uniq and name must not exceed ${MAX_FILE_NAME_LEN} and extension must not exceed    \
                                                               ${MAX_FILE_EXTENSION_LEN}"
        "[${argv_idx[file_size]}] The file size must be an integer between 1 and             \
                ${MAX_FILE_SIZE} and postfix must match \"${FILE_SIZE_SUFFIX}\""                    
        "There is not enough space available on the disk"
        "The choice number must be an integer between ${MIN_CHOICE_NUMBER} and               \
         ${MAX_CHOICE_NUMBER}"
        "End datetime should be greater than start datetime"
        "Incorrect datetime format" )
    
    printf "${error_description[${error_code}]}\n" | tr -s " " > /dev/stderr
    exit ${error_code}
}