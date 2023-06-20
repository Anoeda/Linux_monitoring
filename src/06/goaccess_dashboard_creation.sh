function create_dashboard() {
    # Функция для создания дашборда goaccess из логов П.4

    goaccess --log-format=COMBINED --date-format='%x' -ao ${REPORT} \
                             <(to_ga_format "${DEFAULT_LOGS_PATH}")
    xdg-open ${REPORT}
}


function to_ga_format() {
    # Функция для приведения табличного лога к формату goaccess

    declare -ar local logs=$1

    sed -rns "1! s/\s+\\${COLUMN_SEPARATOR}\s+/ /gp" ${logs}
}