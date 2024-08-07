CMAKE_MINIMUM_REQUIRED(VERSION 3.5)
PROJECT(rinutils)

INCLUDE ("${CMAKE_SOURCE_DIR}/cmake/shlomif_common_bootstrap.cmake")
SHLOMIF_COMMON_SETUP("${private_mod_path}")
INCLUDE ("${CMAKE_SOURCE_DIR}/cmake/JoinPaths.cmake")

CMAKE_POLICY(SET CMP0054 NEW)
option (WITH_TEST_SUITE "Also build and run the test suite.")
option (DISABLE_APPLYING_RPATH "Disable applying rpath")
option (INSTALL_TO_DATADIR "Install libdir files to the architecture independent datadir (e.g for Debian)")

INCLUDE(FindPkgConfig)
INCLUDE(GNUInstallDirs)

# Introduces VERSION , CPACK_PACKAGE_VERSION_MAJOR,
# CPACK_PACKAGE_VERSION_MAJOR, and CPACK_PACKAGE_VERSION_PATCH
READ_VERSION_FROM_VER_TXT()

# This is the equivalent to perform a "make dist"/"make distdir" etc.
SET(CPACK_PACKAGE_NAME "rinutils")
SET(CPACK_PACKAGE_DESCRIPTION_SUMMARY "An ad-hoc header library")
SET(CPACK_PACKAGE_VENDOR "Shlomi Fish")
SET(CPACK_PACKAGE_DESCRIPTION_FILE "${CMAKE_CURRENT_SOURCE_DIR}/README.asciidoc")
SET(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_CURRENT_SOURCE_DIR}/LICENSE")

SET(CPACK_PACKAGE_INSTALL_DIRECTORY "${CPACK_PACKAGE_DESCRIPTION_SUMMARY} ${CPACK_PACKAGE_VERSION_MAJOR}.${CPACK_PACKAGE_VERSION_MINOR}.${CPACK_PACKAGE_VERSION_PATCH}")

SET(CPACK_SOURCE_PACKAGE_FILE_NAME "${CPACK_PACKAGE_NAME}-${CPACK_PACKAGE_VERSION_MAJOR}.${CPACK_PACKAGE_VERSION_MINOR}.${CPACK_PACKAGE_VERSION_PATCH}")

SET (base_with_ver "rinutils-[0-9]+\\\\.[0-9]+\\\\.[0-9]+")
SET(CPACK_SOURCE_GENERATOR "TXZ")
SET(CPACK_SOURCE_IGNORE_FILES
    "/\\\\.act-github/"
    "/\\\\.git/"
    "/\\\\.github/"
    "/\\\\.tidyall\\\\.d/"
    "/tags$"
    "\\\\.swp$"
    "ids-whitelist\\\\.txt"
    "~$"
)

IF (NOT DISABLE_APPLYING_RPATH)
    ### This is to set the RPATH correctly, so when installed under a prefix
    ### the executables will find the libraries.
    ###
    ### See:
    ###
    ### http://www.cmake.org/Wiki/CMake_RPATH_handling
    ###
    ### (Taken from that wiki page)

    # use, i.e. don't skip the full RPATH for the build tree
    SET(CMAKE_SKIP_BUILD_RPATH  FALSE)

    # when building, don't use the install RPATH already
    # (but later on when installing)
    SET(CMAKE_BUILD_WITH_INSTALL_RPATH FALSE)

    # the RPATH to be used when installing
    SET(CMAKE_INSTALL_RPATH "${CMAKE_INSTALL_LIBDIR}")

    # add the automatically determined parts of the RPATH
    # which point to directories outside the build tree to the install RPATH
    SET(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)
ENDIF ()

SET (LIB_BASE "rinutils")

INCLUDE(CPack)

SHLOMIF_ADD_COMMON_C_FLAGS()

SHLOMIF_FINALIZE_FLAGS()

IF (INSTALL_TO_DATADIR)
    SET(RINUTILS_INSTALL_MYLIBDIR "${CMAKE_INSTALL_DATADIR}")
ELSE ()
    SET(RINUTILS_INSTALL_MYLIBDIR "${CMAKE_INSTALL_LIBDIR}")
ENDIF ()

IF ("$ENV{FCS_CLANG}")
    ADD_DEFINITIONS("-Weverything -Wno-language-extension-token -Wno-gnu-statement-expression -Wno-used-but-marked-unused -Wno-padded -Wno-cast-align -Wno-extra-semi-stmt")
ENDIF ()

IF ("$ENV{FCS_GCC}")
    ADD_DEFINITIONS("-W -Waddress -Waggressive-loop-optimizations -Wall -Wattributes -Wbad-function-cast -Wbool-compare -Wbool-operation -Wbuiltin-declaration-mismatch -Wbuiltin-macro-redefined -Wcast-align -Wchar-subscripts -Wchkp -Wclobbered -Wcomment -Wcomments -Wcoverage-mismatch -Wcpp -Wdangling-else -Wdate-time -Wdeprecated -Wdeprecated-declarations -Wdesignated-init -Wdisabled-optimization -Wdiscarded-array-qualifiers -Wdiscarded-qualifiers -Wdiv-by-zero -Wdouble-promotion -Wduplicated-branches -Wduplicated-cond -Wduplicate-decl-specifier -Wempty-body -Wendif-labels -Wenum-compare -Wexpansion-to-defined -Wextra -Wformat-contains-nul -Wformat-extra-args -Wformat-nonliteral -Wformat-security -Wformat-signedness -Wformat-y2k -Wformat-zero-length -Wframe-address -Wfree-nonheap-object -Whsa -Wignored-attributes -Wignored-qualifiers -Wimplicit -Wimplicit-function-declaration -Wimplicit-int -Wincompatible-pointer-types -Winit-self -Winline -Wint-conversion -Wint-in-bool-context -Wint-to-pointer-cast -Winvalid-memory-model -Winvalid-pch -Wjump-misses-init -Wlogical-not-parentheses -Wlogical-op -Wmain -Wmaybe-uninitialized -Wmemset-elt-size -Wmemset-transposed-args -Wmisleading-indentation -Wmissing-braces -Wmissing-declarations -Wmissing-field-initializers -Wmissing-include-dirs -Wmissing-parameter-type -Wmissing-prototypes -Wmultichar -Wnarrowing -Wnested-externs -Wnonnull -Wnonnull-compare -Wnull-dereference -Wodr -Wold-style-declaration -Wold-style-definition -Wopenmp-simd -Woverflow -Woverlength-strings -Woverride-init -Wpacked -Wpacked-bitfield-compat -Wparentheses -Wpointer-arith -Wpointer-compare -Wpointer-sign -Wpointer-to-int-cast -Wpragmas -Wpsabi -Wrestrict -Wreturn-local-addr -Wreturn-type -Wscalar-storage-order -Wsequence-point -Wshadow -Wshift-count-negative -Wshift-count-overflow -Wshift-negative-value -Wsizeof-array-argument -Wsizeof-pointer-memaccess -Wstack-protector -Wstrict-aliasing -Wstrict-prototypes -Wsuggest-attribute=const -Wsuggest-attribute=format -Wsuggest-attribute=noreturn -Wsuggest-attribute=pure -Wsuggest-final-methods -Wsuggest-final-types -Wswitch -Wswitch-bool -Wswitch-default -Wswitch-unreachable -Wsync-nand -Wtautological-compare -Wtrampolines -Wtrigraphs -Wtype-limits -Wuninitialized -Wunsafe-loop-optimizations -Wunused -Wunused-but-set-parameter -Wunused-but-set-variable -Wunused-function -Wunused-label -Wunused-local-typedefs -Wunused-macros -Wunused-parameter -Wunused-result -Wunused-value -Wunused-variable -Wvarargs -Wvariadic-macros -Wvector-operation-performance -Wvla -Wvolatile-register-var -Wwrite-strings -Walloc-size-larger-than=9223372036854775807 -Warray-bounds=2 -Wformat-overflow=2 -Wformat-truncation=2 -Wnormalized=nfc -Wshift-overflow=2 -Wstringop-overflow=2 -Wunused-const-variable=2 -Wstrict-overflow=1  -Wno-switch-default -Wno-vla -Wno-inline  -Wno-jump-misses-init -Wno-unused-result -Wno-unsafe-loop-optimizations")
    # -Wimplicit-fallthrough=5
    # -Wno-vla-larger-than

    IF (NOT IS_DEBUG)
        ADD_DEFINITIONS("-D_FORTIFY_SOURCE=2")
    ENDIF ()
ENDIF ()

INSTALL(
    FILES
        "rinutils/include/rinutils/alloc_wrap.h"
        "rinutils/include/rinutils/bit_rw.h"
        "rinutils/include/rinutils/count.h"
        "rinutils/include/rinutils/dllexport.h"
        "rinutils/include/rinutils/exit_error.h"
        "rinutils/include/rinutils/likely.h"
        "rinutils/include/rinutils/longlong.h"
        "rinutils/include/rinutils/min_and_max.h"
        "rinutils/include/rinutils/portable_time.h"
        "rinutils/include/rinutils/rin_cmocka.h"
        "rinutils/include/rinutils/rinutils.h"
        "rinutils/include/rinutils/str_utils.h"
        "rinutils/include/rinutils/typeof_wrap.h"
        "rinutils/include/rinutils/unused.h"
    DESTINATION
        "${CMAKE_INSTALL_INCLUDEDIR}/rinutils"
)

INSTALL(
    FILES
        "${CMAKE_CURRENT_BINARY_DIR}/lib${CPACK_PACKAGE_NAME}.pc"
    DESTINATION
        "${RINUTILS_INSTALL_MYLIBDIR}/pkgconfig"
)

# https://github.com/shlomif/rinutils/issues/5 ( "pkg-config file is broken when CMAKE_INSTALL_INCLUDEDIR is absolute")
# or libdir)
join_paths(includedir_for_pc_file "\${prefix}" "${CMAKE_INSTALL_INCLUDEDIR}")
join_paths(libdir_for_pc_file "\${exec_prefix}" "${CMAKE_INSTALL_LIBDIR}")

CONFIGURE_FILE(
    ${CMAKE_CURRENT_SOURCE_DIR}/${CPACK_PACKAGE_NAME}.spec.in
    ${CMAKE_CURRENT_SOURCE_DIR}/${CPACK_PACKAGE_NAME}.spec
    )

CONFIGURE_FILE(
    ${CMAKE_CURRENT_SOURCE_DIR}/lib${CPACK_PACKAGE_NAME}.pc.in
    ${CMAKE_CURRENT_BINARY_DIR}/lib${CPACK_PACKAGE_NAME}.pc
    @ONLY
    )

# Rebuild config.h if ver.txt has changed.
ADD_CUSTOM_COMMAND(
    OUTPUT "config.h.in"
    DEPENDS "ver.txt"
    COMMAND "touch"
    ARGS "config.h.in"
)

include(CMakePackageConfigHelpers)
configure_package_config_file(RinutilsConfig.cmake.in
  ${CMAKE_CURRENT_BINARY_DIR}/RinutilsConfig.cmake
  INSTALL_DESTINATION ${RINUTILS_INSTALL_MYLIBDIR}/cmake/Rinutils
  PATH_VARS CMAKE_INSTALL_INCLUDEDIR)
write_basic_package_version_file(
  ${CMAKE_CURRENT_BINARY_DIR}/RinutilsConfigVersion.cmake
  VERSION 1.2.3
  COMPATIBILITY SameMajorVersion )
install(FILES ${CMAKE_CURRENT_BINARY_DIR}/RinutilsConfig.cmake
              ${CMAKE_CURRENT_BINARY_DIR}/RinutilsConfigVersion.cmake
              DESTINATION ${RINUTILS_INSTALL_MYLIBDIR}/cmake/Rinutils )

IF (WITH_TEST_SUITE)

    include(CTest)
    ENABLE_TESTING()
    FIND_PACKAGE (PkgConfig REQUIRED)
    pkg_check_modules(CMOCKA REQUIRED cmocka)
    include_directories (${CMOCKA_INCLUDE_DIRS})
    link_directories (${CMOCKA_LIBRARY_DIRS})
    add_definitions (${CMOCKA_CFLAGS_OTHER})
    INCLUDE_DIRECTORIES (BEFORE "${CMAKE_CURRENT_SOURCE_DIR}/rinutils/include")
    ADD_TEST(
        NAME perl_run_tests
        COMMAND "perl" "${CMAKE_CURRENT_SOURCE_DIR}/run-tests.pl"
    )
    FILE (MAKE_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/t")

    SET (EXE_FILE "bit-reader-and-writer-test.t.exe")

    ADD_EXECUTABLE(
        "${EXE_FILE}"
        "${CMAKE_CURRENT_SOURCE_DIR}/t/bit-reader-and-writer-test.c"
    )
    TARGET_LINK_LIBRARIES (${EXE_FILE} ${CMOCKA_LIBRARIES})

ENDIF()

FILE (WRITE "${CMAKE_CURRENT_BINARY_DIR}/t/TAGS.txt" "")
