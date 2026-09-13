#!/usr/bin/env bash
# SPDX-FileCopyrightText: Copyright (c) 2026, NVIDIA CORPORATION & AFFILIATES. All rights reserved.
# SPDX-License-Identifier: Apache-2.0

set -euo pipefail

readonly checker=cpp/scripts/check-cpm-source-metadata.sh
test_dir="$(mktemp -d)"
readonly test_dir
trap 'rm -rf "${test_dir}"' EXIT

readonly comment_only="${test_dir}/comment-only.cmake"
readonly inline_source="${test_dir}/inline-source.cmake"

printf '%s\n' '# GIT_REPOSITORY in a comment is allowed.' > "${comment_only}"
printf '%s\n' 'rapids_cpm_find(example GIT_REPOSITORY https://example.invalid/example.git)' > "${inline_source}"

"${checker}" "${comment_only}"
if "${checker}" "${inline_source}" > /dev/null 2>&1; then
  echo "ERROR: Inline GIT_REPOSITORY declaration was not detected." >&2
  exit 1
fi
