# Use boost 1.54. There was previously incompatibilities between boost and Qt which leads
# to compilation errors for OTB.  We could increase boost version to last stable
# release in future version of superbuild as we've patchedOTB code to
# support both libraries. See the related changeset in OTB trunk:
# http://hg.orfeo-toolbox.org/OTB/r# ev/8da67e36c78d

if(NOT __EXTERNAL_BOOST__)
set(__EXTERNAL_BOOST__ 1)

if(USE_SYSTEM_BOOST)
  message(STATUS "  Using Boost system version")
else()
  SETUP_SUPERBUILD(PROJECT BOOST)

  message(STATUS "  Using Boost superbuild version")

  option(SUPERBUILD_BOOST_HEADER_ONLY "Only use Boost headers" ON)
  mark_as_advanced(SUPERBUILD_BOOST_HEADER_ONLY)

  if(UNIX)
    if(SUPERBUILD_BOOST_HEADER_ONLY)
      ExternalProject_Add(BOOST
        PREFIX BOOST
        URL "http://sourceforge.net/projects/boost/files/boost/1.50.0/boost_1_50_0.tar.bz2/download"
        URL_MD5 52dd00be775e689f55a987baebccc462
        BINARY_DIR ${BOOST_SB_BUILD_DIR}
        INSTALL_DIR ${SB_INSTALL_PREFIX}
      DOWNLOAD_DIR ${DOWNLOAD_LOCATION}
        CMAKE_CACHE_ARGS
        -DCMAKE_INSTALL_PREFIX:STRING=${SB_INSTALL_PREFIX}
        -DCMAKE_BUILD_TYPE:STRING=Release
        -DBUILD_SHARED_LIBS:BOOL=ON
        PATCH_COMMAND ${CMAKE_COMMAND} -E copy
        ${CMAKE_SOURCE_DIR}/patches/BOOST/CMakeLists.txt
        ${BOOST_SB_SRC}
      )
    else()
      ExternalProject_Add(BOOST
        PREFIX BOOST
        URL "http://sourceforge.net/projects/boost/files/boost/1.50.0/boost_1_50_0.tar.bz2/download"
        URL_MD5 52dd00be775e689f55a987baebccc462
        BINARY_DIR ${BOOST_SB_BUILD_DIR}
        INSTALL_DIR ${SB_INSTALL_PREFIX}
      DOWNLOAD_DIR ${DOWNLOAD_LOCATION}
        CONFIGURE_COMMAND
          ${BOOST_SB_BUILD_DIR}/bootstrap.sh
            --prefix=${SB_INSTALL_PREFIX}
            --with-libraries=graph,test,regex
        BUILD_COMMAND ./b2
        INSTALL_COMMAND ./b2 install
        PATCH_COMMAND ${CMAKE_COMMAND} -E copy_directory
          ${CMAKE_SOURCE_DIR}/patches/BOOST/1.54.0
          ${BOOST_SB_SRC}
      )

      ExternalProject_Add_Step(BOOST copy_source
        COMMAND ${CMAKE_COMMAND} -E copy_directory
          ${BOOST_SB_SRC} ${BOOST_SB_BUILD_DIR}
        DEPENDEES patch update
        DEPENDERS configure
      )
    endif()

    message(STATUS "  Using Boost SuperBuild version")

  else(MSVC)
    #TODO: find hash for archives properly
    set(BOOST_HEADERS_URL_HASH 1605dc6085cb2dc778ef5ab6c0e59083)
    set(BOOST_GRAPH_URL_HASH c246516ca84a3c79ae8a0b22fceb0344)
    set(BOOST_REGEX_URL_HASH a3bfc2dc9a3ebe3c050518ecb29d6f8b)
    set(BOOST_UTF_URL_HASH 75971963a74c76d32e01974a8e48be11)

    if(MSVC10)
        set(BOOST_HEADERS_URL_HASH 1605dc6085cb2dc778ef5ab6c0e59083)
        set(BOOST_GRAPH_URL_HASH c246516ca84a3c79ae8a0b22fceb0344)
        set(BOOST_REGEX_URL_HASH a3bfc2dc9a3ebe3c050518ecb29d6f8b)
        set(BOOST_UTF_URL_HASH 75971963a74c76d32e01974a8e48be11)
    else(MSVC80)

    else(CMAKE_COMPILER_2005)

    endif()

    set(BOOST_HEADERS_URL "http://sourceforge.net/projects/boost/files/boost-binaries/1.50.0/boost_1_50_headers.zip/download")
    set(BOOST_GRAPH_URL "http://sourceforge.net/projects/boost/files/boost-binaries/1.50.0/libboost_graph-vc100-mt-1_50.zip/download")
    set(BOOST_UTF_URL "http://sourceforge.net/projects/boost/files/boost-binaries/1.50.0/boost_unit_test_framework-vc100-mt-1_50.zip/download")
    set(BOOST_REGEX_URL "http://sourceforge.net/projects/boost/files/boost-binaries/1.50.0/libboost_regex-vc100-mt-1_50.zip/download")

    ExternalProject_Add(BOOST_HEADERS
        PREFIX BOOST/_HEADERS
        URL ${BOOST_HEADERS_URL}
        URL_MD5 ${BOOST_HEADERS_URL_HASH}
        SOURCE_DIR ${BOOST_SB_SRC}/include/boost
        CONFIGURE_COMMAND ""
        BUILD_COMMAND ""
        INSTALL_COMMAND ${CMAKE_COMMAND} -E copy_directory ${BOOST_SB_SRC}/include/ ${SB_INSTALL_PREFIX}/include/
     )
    set(BOOSTLIBS)
    foreach(BOOSTLIB "REGEX" "GRAPH" "UTF")
        ExternalProject_Add(BOOST_${BOOSTLIB}
            PREFIX BOOST/_${BOOSTLIB}
            URL ${BOOST_${BOOSTLIB}_URL}
            URL_MD5 ${BOOST_${BOOSTLIB}_URL_HASH}
            SOURCE_DIR ${BOOST_SB_SRC}/lib
            DEPENDS BOOST_HEADERS
            CONFIGURE_COMMAND ""
            BUILD_COMMAND ""
            INSTALL_COMMAND ${CMAKE_COMMAND} -E copy_directory ${BOOST_SB_SRC}/lib ${SB_INSTALL_PREFIX}/lib
        )
    list(APPEND BOOSTLIBS BOOST_${BOOSTLIB})
    endforeach()

    ExternalProject_Add(BOOST
      PREFIX BOOST
      DOWNLOAD_COMMAND ""
      SOURCE_DIR ${BOOST_SB_SRC}
      DEPENDS ${BOOSTLIBS}
      CONFIGURE_COMMAND ""
      BUILD_COMMAND ""
      INSTALL_COMMAND ""
    )

    message(STATUS "  Using Boost SuperBuild version (prebuilt binaries)")

  endif() #end else MSVC

  set(_SB_Boost_INCLUDE_DIR ${SB_INSTALL_PREFIX}/include)
  set(_SB_Boost_LIBRARY_DIR ${SB_INSTALL_PREFIX}/lib)


endif()
endif()
