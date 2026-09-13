# =============================================================================
# cmake-format: off
# SPDX-FileCopyrightText: Copyright (c) 2026, NVIDIA CORPORATION & AFFILIATES. All rights reserved.
# SPDX-License-Identifier: Apache-2.0
# cmake-format: on
# =============================================================================
cmake_minimum_required(VERSION 4.0 FATAL_ERROR)

project(cudf_cmake_tests LANGUAGES NONE)

enable_testing()

set(CUDF_REPOSITORY_DIR
    ""
    CACHE PATH "Path to the cuDF repository root"
)
if(NOT CUDF_REPOSITORY_DIR)
  cmake_path(SET CUDF_REPOSITORY_DIR NORMALIZE "${CMAKE_CURRENT_LIST_DIR}/../../..")
endif()

set(cudf_export_consumer_build_dir "${CMAKE_CURRENT_BINARY_DIR}/cudf_export_consumer")

add_test(
  NAME cudf_export_consumer_configure
  COMMAND
    ${CMAKE_COMMAND} -S "${CMAKE_CURRENT_LIST_DIR}/cudf_export_consumer" -B
    "${cudf_export_consumer_build_dir}" -G "${CMAKE_GENERATOR}"
    "-DCUDF_REPOSITORY_DIR=${CUDF_REPOSITORY_DIR}"
)

add_test(NAME cudf_export_consumer COMMAND ${CMAKE_COMMAND} --build
                                           "${cudf_export_consumer_build_dir}"
)

set_tests_properties(cudf_export_consumer_configure PROPERTIES FIXTURES_SETUP cudf_export_consumer)
set_tests_properties(cudf_export_consumer PROPERTIES FIXTURES_REQUIRED cudf_export_consumer)

set(cpm_project_package_info_source_dir "${CMAKE_CURRENT_LIST_DIR}/cpm_project_package_info")
set(cpm_project_package_info_default_build_dir
    "${CMAKE_CURRENT_BINARY_DIR}/cpm_project_package_info_default"
)
set(cpm_project_package_info_override_build_dir
    "${CMAKE_CURRENT_BINARY_DIR}/cpm_project_package_info_override"
)

add_test(
  NAME cpm_project_package_info_default
  COMMAND
    ${CMAKE_COMMAND} -S "${cpm_project_package_info_source_dir}" -B
    "${cpm_project_package_info_default_build_dir}" -G "${CMAKE_GENERATOR}"
    "-DCUDF_REPOSITORY_DIR=${CUDF_REPOSITORY_DIR}"
)

add_test(
  NAME cpm_project_package_info_override
  COMMAND
    ${CMAKE_COMMAND} -S "${cpm_project_package_info_source_dir}" -B
    "${cpm_project_package_info_override_build_dir}" -G "${CMAKE_GENERATOR}"
    "-DCUDF_REPOSITORY_DIR=${CUDF_REPOSITORY_DIR}"
    "-DRAPIDS_CMAKE_CPM_OVERRIDE_VERSION_FILE=${cpm_project_package_info_source_dir}/override.json"
    "-DEXPECTED_DLPACK_VERSION=9.9.9"
)
