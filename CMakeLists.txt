cmake_minimum_required(VERSION 3.16)
project(COARE-V2 LANGUAGES CXX)
set(CMAKE_CXX_STANDARD 17)

find_package(Drogon REQUIRED)
find_package(OpenSSL REQUIRED)

include_directories(${CMAKE_SOURCE_DIR}/src)

add_executable(coare_v2 src/main.cpp)
target_link_libraries(coare_v2 Drogon::Drogon OpenSSL::SSL OpenSSL::Crypto pthread)
