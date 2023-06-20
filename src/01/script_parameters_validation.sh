function validate_input_data() {
    # Функция для валидации переданных скрипту аргументов

    check_parameters_count 
    check_absolute_path
    check_folder_count
    check_folder_name
    check_file_count
    check_file_name
    check_file_size
}