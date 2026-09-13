# =============================================================================
# cmake-format: off
# SPDX-FileCopyrightText: Copyright (c) 2024-2026, NVIDIA CORPORATION & AFFILIATES. All rights reserved.
# SPDX-License-Identifier: Apache-2.0
# cmake-format: on
# =============================================================================

# Use CPM to find or clone flatbuffers
function(find_and_configure_flatbuffers VERSION EXCLUDE_FROM_ALL)

  include("${CMAKE_CURRENT_FUNCTION_LIST_DIR}/rapids_cpm_project_package_info.cmake")
  cudf_cpm_project_package_info(
    flatbuffers VERSION_VAR version FIND_VAR find_args CPM_VAR cpm_args
  )
  rapids_cpm_find(
    flatbuffers ${version} ${find_args}
    GLOBAL_TARGETS flatbuffers
    CPM_ARGS ${cpm_args}
    EXCLUDE_FROM_ALL ${EXCLUDE_FROM_ALL}
    OPTIONS "FLATBUFFERS_BUILD_TESTS OFF"
  )

  include("${rapids-cmake-dir}/export/find_package_root.cmake")
  rapids_export_find_package_root(
    BUILD flatbuffers "${flatbuffers_BINARY_DIR}" EXPORT_SET cudf-exports
  )

endfunction()

find_and_configure_flatbuffers(24.3.25 ${CUDF_EXCLUDE_DEPS_FROM_ALL})
