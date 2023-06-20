function include_dependencies() {
    # Функция для подключения всех необходимых скриптов-зависимостей
    
    declare -r local current_script_name=$(basename ${BASH_SOURCE})
    declare -r local dependency_paths="${DEPENDENCY_PATH}/*${EXECUTABLE_FILE_EXT}"
  
    for dependency in ${dependency_paths}; do
        if [[ ${dependency} != *${current_script_name}* ]]; then
            source ${dependency}
            # echo "source ${dependency}"
        fi
    done
}

include_dependencies