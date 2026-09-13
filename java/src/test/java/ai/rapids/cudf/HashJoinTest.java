/*
 * SPDX-FileCopyrightText: Copyright (c) 2019-2026, NVIDIA CORPORATION & AFFILIATES. All rights reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

package ai.rapids.cudf;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;

public class HashJoinTest {
  @Test
  void testGetNumberOfColumns() {
    try (Table t = new Table.TestBuilder().column(1, 2).column(3, 4).column(5, 6).build();
         HashJoin hashJoin = new HashJoin(t, false)) {
      assertEquals(3, hashJoin.getNumberOfColumns());
    }
  }

  @Test
  void testGetCompareNullsEqual() {
    try (Table t = new Table.TestBuilder().column(1, 2, 3, 4).build()) {
      try (HashJoin hashJoin = new HashJoin(t, false)) {
        assertFalse(hashJoin.getCompareNullsEqual());
        assertFalse(hashJoin.getCompareNulls());
      }
      try (HashJoin hashJoin = new HashJoin(t, true)) {
        assertTrue(hashJoin.getCompareNullsEqual());
        assertTrue(hashJoin.getCompareNulls());
      }
    }
  }

  @Test
  void testClosedHashJoin() {
    try (Table build = new Table.TestBuilder().column(7, 9).build();
         Table probe = new Table.TestBuilder().column(7, 8).build()) {
      HashJoin hashJoin = new HashJoin(build, false);
      hashJoin.close();
      assertEquals(1, hashJoin.getNumberOfColumns());
      assertFalse(hashJoin.getCompareNullsEqual());
      assertThrows(IllegalStateException.class, () -> probe.leftJoinGatherMaps(hashJoin));
      assertThrows(IllegalStateException.class, () -> probe.innerJoinGatherMaps(hashJoin));
      assertThrows(IllegalStateException.class, () -> probe.fullJoinGatherMaps(hashJoin));
      assertThrows(IllegalStateException.class, hashJoin::close);
    }
  }
}
