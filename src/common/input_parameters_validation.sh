function check_parameters_count() {
    # Функция для проверки корректности количества передаваемых в скрипт параметров

    if [[ "${argv_len}" -ne ${REQUIRED_PARAMETER_COUNT} ]]; then
        raise_exception ${INCORRECT_NUMBER_OF_PARAMETERS} 
    fi
}


function check_absolute_path() {
    # Функция для проверки существования указанной директории и корректности абсолютного пути

    declare -r local absolute_path_re="^\/.+$"

    if ! [[ "${argv[absolute_path]}" =~ ${absolute_path_re} ]] ||
       ! [[ -d "${argv[absolute_path]}" ]]; then
            raise_exception ${ABSOLUTE_PATH_ERROR}
    fi
}


function check_folder_count() {
    # Функция для проверки корректности числа вложенных папок

    declare -r local folder_count_re="^\+?[1-9][0-9]{0,3}$"

    if ! [[ "${argv[folder_count]}" =~ ${folder_count_re} ]]; then
        raise_exception ${INCORRECT_NUMBER_OF_FOLDERS}
    fi
}


function check_folder_name() {
    # Функция для проверки корректности ввода имени папки

    declare -r local letter_count_re="^[[:alpha:]]{1,${MAX_FOLDER_NAME_LEN}}$"

    if ! [[ "${argv[folder_name]}" =~ ${letter_count_re} ]] || 
         [[ $(are_letters_uniq "${argv[folder_name]}") -ne ${TRUE} ]]; then
            raise_exception ${INCORRECT_FOLDER_NAME}
    fi
}


function check_file_count() {
    # Функция для проверки корректности числа файлов
   
    declare -r local file_count_re="^\+?[1-9][0-9]{0,3}$"

    if ! [[ "${argv[file_count]}" =~ ${file_count_re} ]]; then 
        raise_exception ${INCORRECT_NUMBER_OF_FILES}
    fi
}


function check_file_name() {
    # Функция для проверки корректности ввода имени файла

    declare -r local file_name_ext_re="^[[:alpha:]]{1,${MAX_FILE_NAME_LEN}}\.[[:alpha:]]{1,${MAX_FILE_EXTENSION_LEN}}$"
    declare -r local file_name="${argv[file_name]%.*}"
    declare -r local file_ext="${argv[file_name]#*.}"

    if ! [[ "${argv[file_name]}" =~ ${file_name_ext_re} ]] ||
         [[ $(are_letters_uniq "${file_name}") -ne ${TRUE} ]] ||
         [[ $(are_letters_uniq "${file_ext}") -ne ${TRUE} ]]; then
            raise_exception ${INCORRECT_FILE_NAME}
    fi
}


function check_file_size() {
    # Функция для проверки корректности ввода размера файла

    declare -r local file_size_re="^\+?([1-9][0-9]?|100)${FILE_SIZE_SUFFIX}$"

    if ! [[ "${argv[file_size]}" =~ ${file_size_re} ]]; then
        raise_exception ${INCORRECT_FILE_SIZE}
    fi
}


function check_choice_number() {
    # Функция для проверки корректности значения для выбора опции удаления фалов

    declare -r local choice_value_re="^\+?[${MIN_CHOICE_NUMBER}-${MAX_CHOICE_NUMBER}]$"

    if ! [[ "${argv[choice_number]}" =~ ${choice_value_re} ]]; then 
        raise_exception ${INCORRECT_CHOICE_NUMBER}
    fi
}


function check_datetime_format() {
    # Функция для проверки корректности ввода даты и времени

    declare -r local datetime_re="^[0-9]{4}-((0[1-9])|1[0-2])-[0-9]{2}\s[0-9]{2}:[0-9]{2}$"
    declare local datetime="$1"

    if ! [[ "${datetime}" =~ ${datetime_re} ]]; then
        raise_exception ${INCORRECT_DATETIME_FORMAT}
    fi
}


function check_datetime_delta() {
    # Функция для проверки корректности ввода даты и времени 2х параметров относительно друг друга

    declare local start_datetime="$1"
    declare local end_datetime="$2"

    start_datetime=$(date --date="$(tr ' ' 'T' <<< ${start_datetime})" +%s)
    end_datetime=$(date --date="$(tr ' ' 'T' <<< ${end_datetime})" +%s)

    if [[ ${start_datetime} -ge ${end_datetime} ]]; then
        raise_exception ${INCORRECT_DATETIME_DELTA}
    fi
}


function are_letters_uniq() {
    # Функция для проверки уникальности букв в строке

    declare -r local string="${1}"
    declare -ir local are_letters_uniq=$(printf "${string}" | \
                                         grep -P "^(?:([[:alpha:]])(?!.*\1))*$" | wc -l)
    printf "${are_letters_uniq}"
}