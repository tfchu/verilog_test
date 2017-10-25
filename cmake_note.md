https://cmake.org/Wiki/CMake:How_To_Find_Libraries

# External library already supported by CMake
- `$ cmake --help-module-list  // list modules supported, same as looking into /usr/share/cmake/Modules/ (ubuntu)`
- `$ cmake --help-module FindBZip2 // show a list of variabled of bzip2 library (module name FindBZip2.cmake)`

# External library CMake does not have moudle for
e.g FindGSL.cmake   // cmake module name: FindSomething.cmake where Something is the library to use

- download https://github.com/Kitware/CMake/blob/master/Modules/FindGSL.cmake
- modify the code, add GSL root folder
    GSL_ROOT_DIR = (path)
- move the file under cmake/Modules
- modify CMkaeLists.txt
```
find_package(gsl REQUIRED)
include_directories(${LibGSL++_INCLUDE_DIRS})
set(LIBS ${LIBS} ${LibGSL++_LIBRARIES})

target_link_libraries(exampleProgram ${LIBS})

// if you put downloaded file under your project/cmake/Modules
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/cmake/Modules/")
```