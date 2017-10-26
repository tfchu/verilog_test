https://cmake.org/Wiki/CMake:How_To_Find_Libraries
https://stackoverflow.com/questions/21047399/cmake-set-environment-variables-from-a-script
https://www.cs.swarthmore.edu/~adanner/tips/cmake.php

# External library already supported by CMake
- `$ cmake --help-module-list`
  - list modules supported, same as looking into /usr/share/cmake/Modules/ (ubuntu)
- `$ cmake --help-module FindBZip2`
  - show a list of variabled of bzip2 library (module name FindBZip2.cmake)
- Note. cmake module name is `FindSomething.cmake` where `Something` is the library to use

# External library CMake does not have module for
## e.g. FindGSL.cmake
- download https://github.com/Kitware/CMake/blob/master/Modules/FindGSL.cmake
  - note. need to use cmake to set environmental variable GSL_ROOT_DIR
- move the file under cmake/Modules
- modify CMakeLists.txt
```
find_package(gsl REQUIRED)
include_directories(${LibGSL++_INCLUDE_DIRS})
set(LIBS ${LIBS} ${LibGSL++_LIBRARIES})

target_link_libraries(exampleProgram ${LIBS})

// if you put downloaded file under your project/cmake/Modules
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/cmake/Modules/")
```
- Set variable in command line
  - `$ cmake -DGSL_ROOT_DIR=/Users/xxx/gsl`
- Set variable in CMakeFileList.txt, add
  - `set(GSL_ROOT_DIR, "/Users/xxx/gsl")`
- Set environmental variable, e.g. PATH
  - `set(ENV{PATH} "/Users/xxx:$ENV{PATH}")`

