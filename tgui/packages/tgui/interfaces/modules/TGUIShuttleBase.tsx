/**
 * @file
 * @license MIT
 */

enum ShuttleDockAlignmentQueryDirs {
  North = 1,
  South = 2,
  East = 4,
  West = 8,
}

export interface ShuttleDockAlignmentQueryResults {
  centerDirs: ShuttleDockAlignmentQueryDirs;
  ports: Record<string, string>; // id = name
}

export interface ShuttleControllerBaseData {
  /// can we control the shuttle at all? otherwise, we don't show the usual interface.
  controllable: BooleanLike;
}
