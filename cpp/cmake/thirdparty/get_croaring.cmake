# =============================================================================
# cmake-format: off
# SPDX-FileCopyrightText: Copyright (c) 2025-2026, NVIDIA CORPORATION & AFFILIATES. All rights reserved.
# SPDX-License-Identifier: Apache-2.0
# cmake-format: on
# =============================================================================

# Find or build the CRoaring library needed for libcudf tests and benchmarks.
function(find_and_configure_roaring VERSION EXCLUDE_FROM_ALL)

  include("${CMAKE_CURRENT_FUNCTION_LIST_DIR}/rapids_cpm_project_package_info.cmake")
  cudf_cpm_project_package_info(roaring VERSION_VAR version FIND_VAR find_args CPM_VAR cpm_args)
  rapids_cpm_find(
    roaring ${version} ${find_args}
    GLOBAL_TARGETS roaring::roaring
    CPM_ARGS ${cpm_args}
    EXCLUDE_FROM_ALL ${EXCLUDE_FROM_ALL}
    OPTIONS "ROARING_BUILD_STATIC ON"
            "BUILD_SHARED_LIBS OFF"
            "ENABLE_ROARING_TESTS OFF"
            "ENABLE_ROARING_MICROBENCHMARKS OFF"
            "ROARING_DISABLE_NEON ON"
            "ROARING_DISABLE_X64 ON"
            "ROARING_DISABLE_AVX2 ON"
            "ROARING_DISABLE_AVX512 ON"
  )
  if(roaring_ADDED)
    set_target_properties(roaring PROPERTIES POSITION_INDEPENDENT_CODE ON)
  elseif(NOT TARGET roaring AND TARGET roaring::roaring)
    # When found via find_package (e.g. conda), the target is namespaced. Create an alias so
    # consumers can use the non-namespaced name.
    add_library(roaring ALIAS roaring::roaring)
  endif()

  if(DEFINED roaring_SOURCE_DIR)
    set(roaring_INCLUDE_DIR
        "${roaring_SOURCE_DIR}"
        PARENT_SCOPE
    )
  endif()

endfunction()

set(roaring_VERSION_cudf "4.4.2")
find_and_configure_roaring(${roaring_VERSION_cudf} ${CUDF_EXCLUDE_DEPS_FROM_ALL})
