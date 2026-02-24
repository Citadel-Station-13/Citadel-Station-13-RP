/**
 * @file
 * @license MIT
 */

import { BooleanLike } from "tgui-core/react";

type MindRefID = string;

interface StargazerMindnetAbility {
  id: string;
  name: string;
  desc: string;
  targeted: BooleanLike;
  requireMindlink: BooleanLike;
}

interface StargazerMindnetLink {
  /**
   * The name the link knows them as.
   */
  knownName: string | null;
  /**
   * Current attunmenet bias of this link, which is added to their
   * 'scan' presence attunement.
   * * Only updated periodically.
   */
  estimatedAttunement: number;
  /**
   * Active? If we don't have enough attunement to sense them, this is inactive.
   */
  isActive: BooleanLike;
}

interface StargazerMindnetScanTarget {
  /**
   * Category name
   */
  category: string;
  /**
   * Default name
   */
  fillerName: string;
  /**
   * Currently known attunement
   * * Only updated periodically (usually on a re-scan)
   */
  estimatedAttunement: number;
};

interface StargazerMindnetContext {
  abilities: Record<string, StargazerMindnetAbility>;
  /**
   * Records named presences, which is how you can determine the name of someone
   * as their mind doens't immediately tell you.
   */
  presenceNames: Record<MindRefID, string>;
  links: Record<MindRefID, StargazerMindnetLink>;
  scanResults: Record<MindRefID, StargazerMindnetScanTarget>;
  scanOnCooldown: BooleanLike;
}
