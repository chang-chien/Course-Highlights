cmake_minimum_required(VERSION 3.10)

project(QuantLibExample123
  VERSION 1.0.0
  DESCRIPTION "An example project using QuantLib"
  LANGUAGES CXX
)

# 指定 C++ 的版本
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# 設定專案的目錄結構
set(SRC_DIR ${CMAKE_SOURCE_DIR}/src)
set(INCLUDE_DIR ${CMAKE_SOURCE_DIR}/include)
set(EXTERNAL_DIR ${CMAKE_SOURCE_DIR}/external)
set(DATA_DIR ${CMAKE_SOURCE_DIR}/data)
set(BIN_DIR ${CMAKE_SOURCE_DIR}/bin)

# 設定執行檔名稱與原始檔名稱 #################################
set(SOURCE_FILES ${SRC_DIR}/main.cpp)          #    原始檔名稱
set(EXECUTABLE_NAME MyApp)                       #    執行檔名稱
##############################################################

# 使用 GLOB 收集原始檔案
file(GLOB SOURCE_FILES "${SRC_DIR}/*.cpp")

# Set the BOOST_ROOT variable to the root directory of your Boost installation
# set(BOOST_ROOT "C:/Program Files/boost/boost_1_82_0")

# 設定 QuantLib 的原始碼路徑
set(QUANTLIB_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/external/QuantLib-1.33)
# ${CMAKE_CURRENT_SOURCE_DIR} 是 CMake 內建的變數，表示當前 CMakeLists.txt 文件所在的目錄的路徑。
# 假設 CMakeLists.txt 文件位於您的專案的根目錄下，這條命令將把 QUANTLIB_SOURCE_DIR 設置為 ${專案根目錄}/external/QuantLib-1.30。
set(Boost_USE_STATIC_LIBS ON)
set(Boost_USE_MULTITHREADED ON)

# 將 QuantLib 的原始碼添加到您的專案中
add_subdirectory(${QUANTLIB_SOURCE_DIR})
# 在這個例子中，${QUANTLIB_SOURCE_DIR} 是一個變數，表示 QuantLib 的原始碼所在的目錄路徑，是之前使用 set() 命令設定的。
# ${QUANTLIB_SOURCE_DIR} 的值應該是 QuantLib 原始碼的根目錄。

# 設定可執行檔案的輸出目錄
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${BIN_DIR})



# 設定執行檔名稱和源文件
add_executable(${EXECUTABLE_NAME} ${SOURCE_FILES})
# MyApp 是要創建的執行檔名稱(目標target)，main.cpp 是該執行檔所依賴的源文件。
# 這個指令告訴 CMake 創建一個名為 MyApp 的執行檔，該執行檔的源文件是 main.cpp。


# 連接 QuantLib 程式庫
target_link_libraries(${EXECUTABLE_NAME} ql_library)
# 將目標 MyApp 連接（link）到 ql_library 程式庫。
# 在這裡，使用了 add_subdirectory(${QUANTLIB_SOURCE_DIR}) 命令將 QuantLib 的原始碼目錄添加到專案中，從而生成了 ql_library 程式庫。
# target_link_libraries() 命令確保了 MyApp 執行檔在編譯時能夠找到 ql_library 程式庫的二進位檔案，並在執行時能夠使用它提供的函數和功能。
# 在連接程式庫時，CMake 將根據目標平台和編譯器使用適當的連接器（例如 g++、clang++、Visual Studio 等）來建立連接。


# 將 QuantLib 的頭文件目錄添加到編譯器的包含路徑
target_include_directories(${EXECUTABLE_NAME} PRIVATE ${QUANTLIB_SOURCE_DIR})
# 將 include 目錄添加到編譯器的包含路徑中
target_include_directories(${EXECUTABLE_NAME} PRIVATE ${INCLUDE_DIR})

# 最後將測試資料複製一份到輸出目錄(bin資料夾)
file(COPY ${DATA_DIR} DESTINATION ${BIN_DIR})