# =============================================================================
# cmake-format: off
# SPDX-FileCopyrightText: Copyright (c) 2025-2026, NVIDIA CORPORATION & AFFILIATES. All rights reserved.
# SPDX-License-Identifier: Apache-2.0
# cmake-format: on
# =============================================================================

# Use CPM to find or clone libzstd
function(find_and_configure_zstd)

  set(CPM_DOWNLOAD_zstd ON)
  include("${CMAKE_CURRENT_FUNCTION_LIST_DIR}/rapids_cpm_project_package_info.cmake")
  cudf_cpm_project_package_info(zstd VERSION_VAR version FIND_VAR find_args CPM_VAR cpm_args)
  rapids_cpm_find(
    zstd ${version} ${find_args}
    GLOBAL_TARGETS zstd
    CPM_ARGS ${cpm_args}
    EXCLUDE_FROM_ALL ${CUDF_EXCLUDE_DEPS_FROM_ALL}
    OPTIONS "ZSTD_BUILD_STATIC ON" "ZSTD_BUILD_SHARED OFF" "ZSTD_BUILD_TESTS OFF"
            "ZSTD_BUILD_PROGRAMS OFF" "BUILD_SHARED_LIBS OFF"
  )

  if(zstd_ADDED)
    # disable weak symbols support to hide tracing APIs as well
    target_compile_definitions(libzstd_static PRIVATE ZSTD_HAVE_WEAK_SYMBOLS=0)
    # expose experimental API
    target_compile_definitions(libzstd_static PUBLIC ZSTD_STATIC_LINKING_ONLY=0N)
    # suppress warnings from uninitialized variables and redefining ZSTD_STATIC_LINKING_ONLY
    target_compile_options(libzstd_static PRIVATE -w)
    add_library(zstd ALIAS libzstd_static)
  endif()

  if(DEFINED zstd_SOURCE_DIR)
    set(ZSTD_INCLUDE_DIR
        "${zstd_SOURCE_DIR}/lib"
        PARENT_SCOPE
    )
  endif()
  include("${rapids-cmake-dir}/export/find_package_root.cmake")
  rapids_export_find_package_root(BUILD zstd "${zstd_BINARY_DIR}" EXPORT_SET cudf-exports)

endfunction()

find_and_configure_zstd()
