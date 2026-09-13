# =============================================================================
# cmake-format: off
# SPDX-FileCopyrightText: Copyright (c) 2024-2026, NVIDIA CORPORATION & AFFILIATES. All rights reserved.
# SPDX-License-Identifier: Apache-2.0
# cmake-format: on
# =============================================================================

# This function finds nanoarrow and sets any additional necessary environment variables.
function(find_and_configure_nanoarrow BUILD_SHARED EXCLUDE_FROM_ALL)
  include("${CMAKE_CURRENT_FUNCTION_LIST_DIR}/rapids_cpm_project_package_info.cmake")
  cudf_cpm_project_package_info(nanoarrow VERSION_VAR version FIND_VAR find_args CPM_VAR cpm_args)
  rapids_cpm_find(
    nanoarrow ${version} ${find_args}
    GLOBAL_TARGETS nanoarrow_static nanoarrow_shared
    CPM_ARGS ${cpm_args}
    OPTIONS "BUILD_SHARED_LIBS ${BUILD_SHARED}" "NANOARROW_NAMESPACE cudf"
    EXCLUDE_FROM_ALL ${EXCLUDE_FROM_ALL}
  )
  if(nanoarrow_ADDED)
    set_target_properties(nanoarrow_static PROPERTIES POSITION_INDEPENDENT_CODE ON)
    include("${rapids-cmake-dir}/export/find_package_root.cmake")
    rapids_export_find_package_root(
      BUILD nanoarrow "${nanoarrow_BINARY_DIR}" EXPORT_SET cudf-exports
    )
  endif()
endfunction()

if(NOT DEFINED CUDF_DEPS_BUILD_SHARED)
  set(CUDF_DEPS_BUILD_SHARED OFF)
endif()
if(NOT DEFINED CUDF_EXCLUDE_DEPS_FROM_ALL)
  set(CUDF_EXCLUDE_DEPS_FROM_ALL OFF)
endif()

find_and_configure_nanoarrow(${CUDF_DEPS_BUILD_SHARED} ${CUDF_EXCLUDE_DEPS_FROM_ALL})

if(CUDF_DEPS_BUILD_SHARED)
  set(CUDF_nanoarrow_TARGET nanoarrow_shared)
else()
  set(CUDF_nanoarrow_TARGET nanoarrow_static)
endif()
