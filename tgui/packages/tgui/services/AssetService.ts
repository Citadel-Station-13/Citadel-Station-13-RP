/**
 * @file
 * @license MIT
 */

class AssetServiceAPI {
  /**
   * Fetches a JSON pack (see '../bindings/' folder).
   *
   * @return pack, or null if not yet loaded.
   */
  fetchJsonAsset<T>(name: string): T | null {
    return null;
  }
}

export const AssetService = new AssetServiceAPI();
