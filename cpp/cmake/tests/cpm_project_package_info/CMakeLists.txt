# =============================================================================
# cmake-format: off
# SPDX-FileCopyrightText: Copyright (c) 2026, NVIDIA CORPORATION & AFFILIATES. All rights reserved.
# SPDX-License-Identifier: Apache-2.0
# cmake-format: on
# =============================================================================
cmake_minimum_required(VERSION 4.0 FATAL_ERROR)

project(cpm_project_package_info_test LANGUAGES NONE)

set(CUDF_REPOSITORY_DIR
    ""
    CACHE PATH "Path to the cuDF repository root"
)
if(NOT CUDF_REPOSITORY_DIR)
  cmake_path(SET CUDF_REPOSITORY_DIR NORMALIZE "${CMAKE_CURRENT_LIST_DIR}/../../../..")
endif()

set(EXPECTED_DLPACK_VERSION
    "0.8"
    CACHE STRING "Expected resolved DLPack version"
)

include("${CUDF_REPOSITORY_DIR}/cmake/rapids_config.cmake")
include("${rapids-cmake-dir}/cpm/init.cmake")
rapids_cpm_init()
include("${CUDF_REPOSITORY_DIR}/cpp/cmake/thirdparty/rapids_cpm_project_package_info.cmake")

cudf_cpm_project_package_info(dlpack VERSION_VAR resolved_dlpack_version)
if(NOT resolved_dlpack_version STREQUAL EXPECTED_DLPACK_VERSION)
  message(
    FATAL_ERROR
      "Expected DLPack version ${EXPECTED_DLPACK_VERSION}, got ${resolved_dlpack_version}"
  )
endif()
