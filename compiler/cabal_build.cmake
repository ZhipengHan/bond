# This is a workaround for Windows quirks.
# CMake Visual Studio generator translates add_custom_command into a batch file
# embedded in Visual Studio project. Batch files have problems with paths that
# contain non-ascii characters because they are limited to DOS encoding. It so
# happens that cabal is quite likely to be installed in such a path because by
# default cabal install uses directory under %APPDATA% which contains user name.
# As a workaround we execute this .cmake script as a custom command and use CMake
# cache to get access to variables set during configuration.
execute_process (
    COMMAND ${Haskell_CABAL_EXECUTABLE} --require-sandbox install   --with-compiler=${Haskell_GHC_EXECUTABLE} --only-dependencies --jobs
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    RESULT_VARIABLE error)

if (error)
    message (FATAL_ERROR)
endif()

execute_process (
    COMMAND ${Haskell_CABAL_EXECUTABLE} --require-sandbox configure --with-compiler=${Haskell_GHC_EXECUTABLE} --builddir=${output_dir}
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    RESULT_VARIABLE error)

if (error)
    message (FATAL_ERROR)
endif()
    
execute_process (
    COMMAND ${Haskell_CABAL_EXECUTABLE} --require-sandbox build     --with-ghc=${Haskell_GHC_EXECUTABLE} --ghc-option=-O2 --jobs --builddir=${output_dir}
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    RESULT_VARIABLE error)

if (error)
    message (FATAL_ERROR)
endif()
    
