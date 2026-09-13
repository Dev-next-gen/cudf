# =============================================================================
# cmake-format: off
# SPDX-FileCopyrightText: Copyright (c) 2020-2026, NVIDIA CORPORATION & AFFILIATES. All rights reserved.
# SPDX-License-Identifier: Apache-2.0
# cmake-format: on
# =============================================================================

# This function finds dlpack and sets any additional necessary environment variables.
function(find_and_configure_dlpack VERSION EXCLUDE_FROM_ALL)

  include(${rapids-cmake-dir}/find/generate_module.cmake)
  rapids_find_generate_module(DLPACK HEADER_NAMES dlpack.h)
  include("${CMAKE_CURRENT_FUNCTION_LIST_DIR}/rapids_cpm_project_package_info.cmake")
  cudf_cpm_project_package_info(dlpack VERSION_VAR version FIND_VAR find_args CPM_VAR cpm_args)

  rapids_cpm_find(
    dlpack ${version} ${find_args}
    CPM_ARGS ${cpm_args}
    DOWNLOAD_ONLY TRUE
    EXCLUDE_FROM_ALL ${EXCLUDE_FROM_ALL}
    OPTIONS "BUILD_MOCK OFF"
  )

  if(DEFINED dlpack_SOURCE_DIR)
    # otherwise find_package(DLPACK) will set this variable
    set(DLPACK_INCLUDE_DIR
        "${dlpack_SOURCE_DIR}/include"
        PARENT_SCOPE
    )
  endif()
endfunction()

set(CUDF_MIN_VERSION_dlpack 0.8)

if(NOT DEFINED CUDF_EXCLUDE_DEPS_FROM_ALL)
  set(CUDF_EXCLUDE_DEPS_FROM_ALL OFF)
endif()

find_and_configure_dlpack(${CUDF_MIN_VERSION_dlpack} ${CUDF_EXCLUDE_DEPS_FROM_ALL})
