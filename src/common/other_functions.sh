# function create_directory_tree() {
#     # Функция для создания каталогов по абсолютным путям и файлов в них

#     # declare -ir local random_paths_count=$((RANDOM % ${MAX_OBJ_COUNT} + 1))
#     # declare -ir local random_paths_count=$((RANDOM % 5 + 1))
#             # echo "random_paths_count = ${random_paths_count}"
#             declare -ir local random_paths_count=2
#     declare -r local creation_date=$(get_creation_date)

#     get_absolute_paths

#     if ! [[ -e ${FOLDER_NAMES} ]]; then
#         generate_name "${argv[folder_name]}" "${argv[folder_count]}" >> "${FOLDER_NAMES}"
#     fi

#     if ! [[ -e ${FILE_NAMES} ]]; then
#         generate_name "${argv[file_name]%.*}" "${argv[file_count]}" >> "${FILE_NAMES}"
#     fi

#     for absolute_path in $(sed -n "1,${random_paths_count}p" ${ABSOLUTE_PATHS}); do
#         create_dirs
#         # create_files
#     done
# }


# function create_dirs() {
#     # Функция для создания каталогов

#     # declare -i local random_folder_count=$((RANDOM % ${MAX_OBJ_COUNT} + 1))
#     declare -i local random_folder_count=$((RANDOM % 10 + 1))

#     for folder_name in $(sed -n "1,${argv[folder_count]:-${random_folder_count}}p" ${FOLDER_NAMES}); do
#         declare local folder="${folder_name}_${creation_date}"
#         mkdir -p "${absolute_path}/${FOLDERS_DIR}/${folder}"
#     done
# }


# function create_files() {
#     # Функция для создания файлов в каталогах

#     declare local file

#     for folder in ${absolute_path}/${FOLDERS_DIR}/*; do
#         # declare -i local random_file_count=$((RANDOM % ${MAX_OBJ_COUNT} + 1))
#         declare -i local random_file_count=$((RANDOM % 10 + 1))

#         for file_name in  $(sed -n "1,${argv[file_count]:-${random_file_count}}p" ${FILE_NAMES}); do
#             check_available_space
#             file="${argv[file_name]/${argv[file_name]%.*}/${file_name}}"

#             fallocate -l ${argv[file_size]:: -1} ${folder}/${file}
#         done
#     done
# }


function get_absolute_paths() {
    # Функция для получения путей из / каталога, исключая "sbin/bin/proc"

    rm -f ${ABSOLUTE_PATHS}

    if [[ -z ${argv[absolute_path]} ]]; then
        egrep -m ${random_paths_count} -vw "\/(^[s]?bin|proc)" <(find / -maxdepth 2 -type d | shuf) \
                                                                               >> ${ABSOLUTE_PATHS}
    else 
        printf "${argv[absolute_path]}\n" >> ${ABSOLUTE_PATHS}
    fi    
}


function get_creation_date() {
    # Функция для получения времени создания объекта

    declare -r local creation_date="$(date +"%d%m%y")"
    
    printf "${creation_date}"
}


function check_available_space() {
    # Функция для получения величины оставшегося на диске 
    # свободного места

    declare -ir local available_space=$(df -m / | awk '(NR == 2) {print $4}')

    if [[ ${available_space} -le ${MIN_AVAILABLE_FREE_SPACE} ]]; then
        generate_log
        raise_exception ${NOT_ENOUGH_FREE_SPACE}
    fi
}


function generate_log() {
    # Функция для генерации лога созданных папок и файлов

    rm -f ${DIRECTORY_LOG}

    while read -r absolute_path; do
        find "${absolute_path}/${FOLDERS_DIR}" -maxdepth 1 -type d -regextype posix-egrep -iregex \
        '.*\/[a-z]+_[0-9]{6}$' -exec tree -f {} \; >> ${DIRECTORY_LOG}
    done < ${ABSOLUTE_PATHS}

    sed -i "s/${argv[file_name]#*.}$/& $(get_creation_date) ${argv[file_size]}/g" ${DIRECTORY_LOG}
}


function measure_time_of() {
    # Функция для измерения времени выполнения другой функции

    declare -r local start=$(date +"%F %T")

    eval "$@"

    declare -r local end=$(date +"%F %T")
    declare -r local result="$((SECONDS / 60))m.$((SECONDS % 60))s"

    printf "\n${start}\n${end}\nScript execution time = ${result}\n" | tee -a ${DIRECTORY_LOG}
}


function to_table() {
    # Функция для приведения лога к табличному виду

    declare -r local logs=$1

    column -t -s "${COLUMN_SEPARATOR}" -o "${OUTPUT_SEPARATOR}" -N "${HEADER}" ${logs}
}