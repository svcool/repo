лучше делать из новой папки *_build
#папка с cmakelist.txt, запускаем из папки куда хотим собрать проект
cmake ..\L11_Task3_CM_DLL
#сборка, можно указать папку
cmake --build .


###пример
cmake_minimum_required(VERSION 3.22.0)
#имя проекта
project(main)
#папка для библиотеки
include_directories(lib)
#задать список source_exe файлов
set(source_exe main.cpp) 
# указываем исполняемый файл 
add_executable(main ${source_exe})
#добавляем поддиректорию lib
add_subdirectory(lib)
#линкуем библиотеку
target_link_libraries(main main_dll)