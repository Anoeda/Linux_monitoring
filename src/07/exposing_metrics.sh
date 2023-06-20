function get_metrics() {
    # Функция для получения метрик, отправляемых в prometheus

    while true; do
        ( get_available_ram
          get_total_ram
          get_fs_free_space 
          get_cpu_time_spent_idle ) > ${METRICS_LIST}

        sleep 4
    done 
}


function get_total_ram() {
    # Функция для получения количества RAM

    declare -i local total_ram_bytes=$(awk '(NR==2) {print $2}' <(free -b))

    printf "node_memory_MemTotal_bytes ${total_ram_bytes}\n"
}


function get_available_ram() {
    # Функция для получения количества доступной RAM

    declare -i local available_ram_bytes=$(awk '(NR==2) {print $7}' <(free -b))

    printf "node_memory_MemAvailable_bytes ${available_ram_bytes}\n"
}


function get_fs_free_space() {
    # Функция для получения количества доступной памяти FS

    declare -i local root_fs_available_bytes=$(awk '(NR==2) {print $1}' <(df -B1 --output=avail /))
    
    printf "node_filesystem_avail_bytes{device=\"/dev/sda6\",fstype=\"ext4\",mountpoint=\"/\"} \
                                                     ${root_fs_available_bytes}\n" | tr -s " "
}


function get_cpu_time_spent_idle() {
    # Функция для получения процессорного времени в простое в % за 1с

    declare -i local cpu_time_spent_idle=$(vmstat 1 2 -w | awk '(NR == 4) {print $15}')

    printf "node_cpu_seconds_total{mode=\"idle\"} ${cpu_time_spent_idle}\n"
}