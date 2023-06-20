function parse_logs() {
    # Функция для обработки выбора пользователя

    declare -Ar local parse_logs_functions=( [1]=sort_by_response_code       \
                                             [2]=sort_by_uniq_ip             \
                                             [3]=get_error_code_records      \
                                             [4]=get_uniq_ip_with_error_code )

    declare -Ar local log_names=( [1]="${RESPONSE_CODE_SORTING_LOG}"   \
                                  [2]="${UNIQ_IP_SORTING_LOG}"         \
                                  [3]="${ERROR_CODE_SORTING_LOG}"      \
                                  [4]="${UNIQ_IP_WITH_ERROR_CODE_LOG}" )

    mkdir -p ${LOGS_DIR}

    ${parse_logs_functions[${argv[choice_number]}]} <(sed -sn "1! p" ${DEFAULT_LOGS_PATH}) | \
                                           to_table > ${log_names[${argv[choice_number]}]}
}


function sort_by_response_code() {
    # Функция для сортировки логов по коду ответа http-сервера

    declare -r local logs=$1

    sort -n -t "${COLUMN_SEPARATOR}" -k ${RESPONSE_CODE_POSITION},${RESPONSE_CODE_POSITION} ${logs}
}


function sort_by_uniq_ip() {
    # Функция для сортировки по уникальным ip адресам

    declare -r local logs=$1

    awk -F "${COLUMN_SEPARATOR}" '!seen[$'$IP_POSITION']++' ${logs}
}


function get_error_code_records() {
    # Функция для получения всех запросов с ошибочными кодами ответов

    declare -r local logs=$1

    awk -F "${COLUMN_SEPARATOR}" '{if ($'$RESPONSE_CODE_POSITION' ~ /[45][0-9]{2}/) print $0}' \
                                                                                      ${logs}
}


function get_uniq_ip_with_error_code() {
    # Функция для получения всех запросов с ошибочными кодами ответов
    # и уникальными ip

    declare -r local logs=$1

    awk -F "${COLUMN_SEPARATOR}" '!seen[$'$IP_POSITION']++ {if ($'$RESPONSE_CODE_POSITION' ~ \
                                                       /[45][0-9]{2}/) print $0}' ${logs}
}