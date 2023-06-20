function create_directory_tree() {
    # Функция для создания каталогов по абсолютным путям и файлов в них

    # declare -ir local random_paths_count=$((RANDOM % ${MAX_OBJ_COUNT} + 1))
    # declare -ir local random_paths_count=$((RANDOM % 5 + 1))
            declare -ir local random_paths_count=2
    declare -r local creation_date=$(get_creation_date)

    rm -f ${FOLDER_NAMES} ${FILE_NAMES}

    get_absolute_paths
    generate_name "${argv[folder_name]}" "${argv[folder_count]}" >> "${FOLDER_NAMES}"
    generate_name "${argv[file_name]%.*}" "${argv[file_count]}" >> "${FILE_NAMES}"

    for absolute_path in $(sed -n "1,${random_paths_count}p" ${ABSOLUTE_PATHS}); do
        create_dirs
        create_files
    done
}


function create_dirs() {
    # Функция для создания каталогов

    # declare -i local random_folder_count=$((RANDOM % ${MAX_OBJ_COUNT} + 1))
    declare -i local random_folder_count=$((RANDOM % 10 + 1))

    for folder_name in $(sed -n "1,${argv[folder_count]:-${random_folder_count}}p"   \
                                                                 ${FOLDER_NAMES}); do
        declare local folder="${folder_name}_${creation_date}"
        mkdir -p "${absolute_path}/${FOLDERS_DIR}/${folder}"
    done
}


function create_files() {
    # Функция для создания файлов в каталогах

    declare local file

    for folder in ${absolute_path}/${FOLDERS_DIR}/*; do
        # declare -i local random_file_count=$((RANDOM % ${MAX_OBJ_COUNT} + 1))
        declare -i local random_file_count=$((RANDOM % 10 + 1))

        for file_name in $(sed -n "1,${argv[file_count]:-${random_file_count}}p" ${FILE_NAMES}); do
            check_available_space
            file="${argv[file_name]/${argv[file_name]%.*}/${file_name}}"

            fallocate -l ${argv[file_size]:: -1} ${folder}/${file}
        done
    done
}


function generate_name() {
    # Функция для получения комбинаций букв в ходе их перестановки

    declare local letters="${1}"
    declare -i local required_words=$(printf "${2:-${MAX_OBJ_COUNT}}")

    for ((letter_dup = ${MIN_LETTER_DUPLICATES}; ${#template} < ${MAX_LINUX_NAME_LEN}   \
                                             && --((required_words)); letter_dup++)); do
        declare local template=$(get_template ${letters})
        permutate_template_letters
    done
}


function get_template() {
    # Функция для получения шаблона методом дублирования 1ой буквы letter_dup раз

    if [[ ${#letters} -le ${MIN_NAME_LEN} ]]; then
        declare -r local replacement_len=$((${MIN_NAME_LEN} - ${#letters}))
        declare local replacement=$(printf "${letters:0:1}%.s" $(seq ${replacement_len}))
        declare local letters="${letters/${letters:0:1}/${replacement}}"
    fi

    declare -r local replacement=$(printf "${letters:0:1}%.s" $(seq ${letter_dup}))

    printf ${letters/"${letters:0:1}"/${replacement}}
}


function permutate_template_letters() {
    # Функция для получения комбинаций букв шаблона методом замены последнего вхождения
    # текущей буквы из letters на следующую

    declare -ir local template_len=${#template}

    for ((letter = 0; letter < template_len-1 && ${required_words}; letter++)); do   
        while (($(get_letter_count ${template} ${template:letter:1}) > 1 && ${required_words})); do
            printf "${template}\n"
            
            replacement=$(printf "${letters:letter+1:1}%.s" $(seq ${MIN_LETTER_DUPLICATES}))
            
            last_letter_ind=$(expr "$template" : ".*${template:letter:1}" )
            template="${template//"${template:last_letter_ind-1:2}"/${replacement}}"
            ((required_words--))
        done
    done
}


function get_letter_count() {
    # Функция возвращает количество вхождений подстроки sub

    declare -r local string="$1"
    declare -r local substring="$2"

    declare -ir local letter_count=$(printf "${string}" | grep -o "${substring}" | wc -l)

    printf ${letter_count}
}