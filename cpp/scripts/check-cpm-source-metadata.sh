#!/usr/bin/env bash
# SPDX-FileCopyrightText: Copyright (c) 2026, NVIDIA CORPORATION & AFFILIATES. All rights reserved.
# SPDX-License-Identifier: Apache-2.0

# Project dependency sources belong in rapids-cpm-versions.json. That allows
# RAPIDS_CMAKE_CPM_OVERRIDE_VERSION_FILE to replace them without source patches.
set -euo pipefail

for cmake_file in "$@"; do
  if grep -nE '^[[:space:]]*GIT_(REPOSITORY|TAG|SHALLOW)[[:space:]]' "${cmake_file}"; then
    echo "ERROR: ${cmake_file} declares a direct Git source." >&2
    echo "Move its source metadata to the project rapids-cpm-versions.json catalog and use cudf_cpm_project_package_info()." >&2
    exit 1
  fi
done
