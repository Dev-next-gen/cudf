# =============================================================================
# cmake-format: off
# SPDX-FileCopyrightText: Copyright (c) 2022-2026, NVIDIA CORPORATION & AFFILIATES. All rights reserved.
# SPDX-License-Identifier: Apache-2.0
# cmake-format: on
# =============================================================================

# This function finds KvikIO
function(find_and_configure_kvikio VERSION)

  include("${CMAKE_CURRENT_FUNCTION_LIST_DIR}/rapids_cpm_project_package_info.cmake")
  cudf_cpm_project_package_info(kvikio VERSION_VAR version FIND_VAR find_args CPM_VAR cpm_args)
  rapids_cpm_find(
    kvikio ${version} ${find_args}
    GLOBAL_TARGETS kvikio::kvikio
    CPM_ARGS ${cpm_args}
    EXCLUDE_FROM_ALL ${CUDF_EXCLUDE_DEPS_FROM_ALL}
    OPTIONS "KvikIO_BUILD_EXAMPLES OFF" "KvikIO_REMOTE_SUPPORT ${CUDF_KVIKIO_REMOTE_IO}"
            "BUILD_SHARED_LIBS OFF"
  )

endfunction()

set(KVIKIO_MIN_VERSION_cudf "${CUDF_VERSION_MAJOR}.${CUDF_VERSION_MINOR}")
find_and_configure_kvikio(${KVIKIO_MIN_VERSION_cudf})
