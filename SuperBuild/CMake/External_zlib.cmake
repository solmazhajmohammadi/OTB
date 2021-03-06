if(NOT __EXTERNAL_ZLIB__)
set(__EXTERNAL_ZLIB__ 1)

if(USE_SYSTEM_ZLIB)
  find_package(ZLIB)
  message(STATUS "  Using Zlib system version")
else()
  SETUP_SUPERBUILD(PROJECT ZLIB)
  message(STATUS "  Using zlib SuperBuild version")

  # Try official release 1.2.8
  ExternalProject_Add(ZLIB
    PREFIX ZLIB
    URL "http://sourceforge.net/projects/libpng/files/zlib/1.2.8/zlib-1.2.8.tar.gz/download"
    URL_MD5 44d667c142d7cda120332623eab69f40
    BINARY_DIR ${ZLIB_SB_BUILD_DIR}
    INSTALL_DIR ${SB_INSTALL_PREFIX}
      DOWNLOAD_DIR ${DOWNLOAD_LOCATION}
    CMAKE_CACHE_ARGS
      -DCMAKE_INSTALL_PREFIX:PATH=${SB_INSTALL_PREFIX}
      -DCMAKE_BUILD_TYPE:STRING=Release
      #-DCMAKE_CXX_COMPILER:FILEPATH=${CMAKE_CXX_COMPILER}
      #-DCMAKE_C_COMPILER:FILEPATH=${CMAKE_C_COMPILER}
      -DBUILD_SHARED_LIBS:BOOL=ON
      CMAKE_COMMAND ${SB_CMAKE_COMMAND})

    if(UNIX)
      ExternalProject_Add_Step(ZLIB remove_static
        COMMAND ${CMAKE_COMMAND} -E remove ${SB_INSTALL_PREFIX}/lib/libz.a
        DEPENDEES install)
    endif()

    if(MSVC)
      ExternalProject_Add_Step(ZLIB msvc_copy_hell
        COMMAND ${CMAKE_COMMAND} -E copy ${ZLIB_SB_BUILD_DIR}/zlib.lib ${SB_INSTALL_PREFIX}/lib/zdll.lib
        DEPENDEES install)
    endif()

    set(_SB_ZLIB_INCLUDE_DIR ${SB_INSTALL_PREFIX}/include)
    if(WIN32)
      set(_SB_ZLIB_LIBRARY ${SB_INSTALL_PREFIX}/lib/zdll.lib)
    elseif(UNIX)
      set(_SB_ZLIB_LIBRARY ${SB_INSTALL_PREFIX}/lib/libz${CMAKE_SHARED_LIBRARY_SUFFIX})
    endif()

endif()

endif()
