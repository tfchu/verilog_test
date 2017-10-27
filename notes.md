# CMake
https://cmake.org/Wiki/CMake:How_To_Find_Libraries
https://stackoverflow.com/questions/21047399/cmake-set-environment-variables-from-a-script
https://www.cs.swarthmore.edu/~adanner/tips/cmake.php

## External library already supported by CMake
- `$ cmake --help-module-list`
  - list modules supported, same as looking into /usr/share/cmake/Modules/ (ubuntu)
- `$ cmake --help-module FindBZip2`
  - show a list of variabled of bzip2 library (module name FindBZip2.cmake)
- Note. cmake module name is `FindSomething.cmake` where `Something` is the library to use

## External library CMake does not have module for
### e.g. FindGSL.cmake
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
  - `set(ENV{GSL_ROOT_DIR} "/Users/xxx/gsl")`

# GNU C Complier Options
- Linking
  - `-l*library*`: search the library named *library* when linking. `-L` includes several standard system directories and any specified. 
- Directory Search
  - `-I*dir*`: Add the directory dir to the head of the list of directories to be searched for header files. 
  - `-Ldir`: Add directory dir to the list of directories to be searched for `-l`.

# pkg-config (https://people.freedesktop.org/~dbn/pkg-config-guide.html)
``` Example: gsl.pc
prefix=/usr
exec_prefix=/usr
libdir=/usr/lib/x86_64-linux-gnu
includedir=/usr/include
GSL_CBLAS_LIB=-lgslcblas

Name: GSL
Description: GNU Scientific Library
Version: 2.1
Libs: -L/usr/lib/x86_64-linux-gnu -lgsl ${GSL_CBLAS_LIB} -lm -lm 
Cflags: -I/usr/include
```
- Libs: The link flags specific to this package and any required libraries that don't support pkg-config. 
- Cflags: The compiler flags specific to this package and any required libraries that don't support pkg-config. 

(mac)
- CMakeList.txt uses pkg-config to find gsl
- `$ pkg-config --exists --print-errors gsl`
  - check if gsl exists. if not, error message is shown. 
- copy `/usr/lib/x86_64-linux-gnu/pkgconfig/gsl.pc` from ubuntu
- `$ pkg-config --variable pc_path pkg-config`
  - check where pkg-config stores the pc files
  - e.g. /opt/local/lib/pkgconfig:/opt/local/share/pkgconfig
- copy `gsl.pc` from ubuntu to `/opt/local/lib/pkgconfig/`
- run `$ pkg-config --exists --print-errors gsl` again to check if error is gone, or
  - `$ pkg-config --exists gsl`
  - `$ echo $?`