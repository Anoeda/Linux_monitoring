function create_log() {
    # Функция для создания лога nginx в combined формате

    mkdir -p ${LOGS_DIR}

    for log_number in $(seq ${LOGS_NUMBER}); do
        declare -i local records_number=$((${RANDOM} % ${LOG_LINES_NUMBER_DIFF} +   \
                                                       ${MIN_LOG_LINES_NUMBER} + 1))

        for record_number in $(seq ${records_number}); do
            get_ip_address
            get_log_file_line_date
            get_request_method
            get_response_code
            get_url
            get_agent
        done | to_table >> ${LOGS_DIR}/${LOG_NAME}_${log_number}.log
    done
}


function get_ip_address() {
    # Функция для получения ip адреса

    declare -r local ip_address="$(get_ip_octet).$(get_ip_octet).$(get_ip_octet).$(get_ip_octet)"

    printf "${ip_address}${COLUMN_SEPARATOR}"
}


function get_ip_octet() {
    # Функция для получения корректного октета ip адреса

    declare -i local ip_octet=$((${RANDOM} % ${MAX_IP_OCTET_VALUE} + 1))

    printf "${ip_octet}"
}


function get_response_code() {
    # Функция для получения кода ответа HTTP сервера
    
    declare -ir local response_codes_number=${#RESPONSE_CODES[@]}
    declare -i local response_code_number=$((${RANDOM} % ${response_codes_number}))

    printf "${RESPONSE_CODES[response_code_number]}${COLUMN_SEPARATOR}"
}


function get_request_method() {
    # Функция для получения метода запроса к http-серверу

    declare -ir local request_methods_number=${#REQUEST_METHODS[@]}
    declare -i local request_method_number=$((${RANDOM} % ${request_methods_number}))

    printf "\"${REQUEST_METHODS[request_method_number]}\"${COLUMN_SEPARATOR}"
}


function get_log_file_line_date() {
    # Функция для получения даты создания записи в лог

    declare local current_date=$(date +"%x:%T %z" --date="${log_number} day ${log_number} \
                                                          hour ${record_number} minutes")

    printf "[${current_date}]${COLUMN_SEPARATOR}"
}


function get_url() {
    # Функция для получения url'а

    declare -ir local urls_number=${#URLS[@]}
    declare -i local url_number=$((${RANDOM} % ${urls_number}))

    printf "${URLS[url_number]}${COLUMN_SEPARATOR}"
}


function get_agent() {
    # Функция для получения агента

    declare -ir local agents_number=${#AGENTS[@]}
    declare -i local agent_number=$((${RANDOM} % ${agents_number}))

    printf "${AGENTS[agent_number]}\n"
}


# 200 - Запрос выполнен успешно
# 201 - Запрос выполнен успешно и привёл к созданию ресурса
# 400 - Запрос не может быть понят сервером из-за некорректного синтаксиса.
# 401 - Для доступа к документу необходимо быть авторизованным пользователем.
# 403 - Доступ к ресурсу запрещен.
# 404 - Ресурс не найден
# 500 - Внутренняя ошибка сервера
# 501 - Метод не поддерживается
# 502 - Ошибка шлюза
# 503 - Служба недоступна