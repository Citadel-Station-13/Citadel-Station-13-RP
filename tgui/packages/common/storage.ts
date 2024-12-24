/**
 * Browser-agnostic abstraction of key-value web storage.
 *
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

export const IMPL_MEMORY = 0;
export const IMPL_BROWSER_STORAGE = 1;
export const IMPL_INDEXED_DB = 2;

const INDEXED_DB_VERSION = 3;
const INDEXED_DB_NAME = 'tgui-citadel-rp';
const INDEXED_DB_STORE_NAME = 'tgui-storage';

type StorageImplementation =
  | typeof IMPL_MEMORY
  | typeof IMPL_BROWSER_STORAGE
  | typeof IMPL_INDEXED_DB;

const READ_ONLY = 'readonly';
const READ_WRITE = 'readwrite';

const testGeneric = (testFn) => () => {
  try {
    return Boolean(testFn());
  }
  catch {
    return false;
  }
};

const storageProvider = Byond.BLINK ? window.domainStorage : window.localStorage;

// localStorage is only used when BLINK isnt set, else we use byondStorage
const testBrowserStorage = testGeneric(() => (
  storageProvider && storageProvider.getItem
));

const testIndexedDb = testGeneric(() => (
  (window.indexedDB || window.msIndexedDB)
  && (window.IDBTransaction || window.msIDBTransaction)
));

interface StorageBackend {
  get<T>(key: string): Promise<T>;
  set(key: string, value: any): Promise<void>;
  remove(key: string): Promise<void>;
  clear(): Promise<void>;
}

class MemoryBackend implements StorageBackend {
  private store: Record<string, any>;
  public impl: StorageImplementation;

  constructor() {
    this.impl = IMPL_MEMORY;
    this.store = {};
  }

  async get(key: string) {
    return this.store[key];
  }

  async set(key: string, value: any) {
    this.store[key] = value;
  }

  async remove(key: string) {
    this.store[key] = undefined;
  }

  async clear() {
    this.store = {};
  }
}

class BrowserStorageBackend implements StorageBackend {
  public impl: StorageImplementation;

  constructor() {
    this.impl = IMPL_BROWSER_STORAGE;
  }

  async get(key: string) {
    const value = storageProvider.getItem(key);
    if (typeof value === 'string') {
      return JSON.parse(value);
    }
  }

  async set(key: string, value: any) {
    storageProvider.setItem(key, JSON.stringify(value));
  }

  async remove(key: string) {
    storageProvider.removeItem(key);
  }

  async clear() {
    storageProvider.clear();
  }
}

class IndexedDbBackend implements StorageBackend {
  public impl: StorageImplementation;
  public dbPromise: Promise<IDBDatabase>;

  constructor() {
    this.impl = IMPL_INDEXED_DB;
    this.dbPromise = new Promise((resolve, reject) => {
      const indexedDB = window.indexedDB || window.msIndexedDB;
      const req = indexedDB.open(INDEXED_DB_NAME, INDEXED_DB_VERSION);
      req.onupgradeneeded = () => {
        try {
          req.result.createObjectStore(INDEXED_DB_STORE_NAME);
        }
        catch (err) {
          reject(new Error('Failed to upgrade IDB: ' + req.error));
        }
      };
      req.onsuccess = () => resolve(req.result);
      req.onerror = () => {
        reject(new Error('Failed to open IDB: ' + req.error));
      };
    });
  }

  async getStore(mode: IDBTransactionMode) {
    return this.dbPromise.then(db => db
      .transaction(INDEXED_DB_STORE_NAME, mode)
      .objectStore(INDEXED_DB_STORE_NAME));
  }

  async get<T>(key: string) {
    const store = await this.getStore(READ_ONLY);
    return new Promise<T>((resolve, reject) => {
      const req = store.get(key);
      req.onsuccess = () => resolve(req.result);
      req.onerror = () => reject(req.error);
    });
  }

  async set(key: string, value: any) {
    // The reason we don't _save_ null is because IE 10 does
    // not support saving the `null` type in IndexedDB. How
    // ironic, given the bug below!
    // See: https://github.com/mozilla/localForage/issues/161
    if (value === null) {
      value = undefined;
    }
    // NOTE: We deliberately make this operation transactionless
    const store = await this.getStore(READ_WRITE);
    store.put(value, key);
  }

  async remove(key: string) {
    // NOTE: We deliberately make this operation transactionless
    const store = await this.getStore(READ_WRITE);
    store.delete(key);
  }

  async clear() {
    // NOTE: We deliberately make this operation transactionless
    const store = await this.getStore(READ_WRITE);
    store.clear();
  }
}

/**
 * Web Storage Proxy object, which selects the best backend available
 * depending on the environment.
 */
class StorageProxy implements StorageBackend {
  private backendPromise: Promise<StorageBackend>;

  constructor() {
    this.backendPromise = (async () => {
      // 515-516 compat: we want indexdb to load first if its ie but not when its chromium
      if (!Byond.TRIDENT && testBrowserStorage()) {
        return new BrowserStorageBackend();
      }
      if (testIndexedDb()) {
        try {
          const backend = new IndexedDbBackend();
          await backend.dbPromise;
          return backend;
        }
        catch {}
      }
      // useless to load this again if webview fails
      if (Byond.TRIDENT && testBrowserStorage()) {
        return new BrowserStorageBackend();
      }
      console.warn(
        'No supported storage backend found. Using in-memory storage.',
      );
      return new MemoryBackend();
    })();
  }

  async get<T>(key: string) {
    const backend = await this.backendPromise;
    return backend.get<T>(key);
  }

  async set(key: string, value: any) {
    const backend = await this.backendPromise;
    return backend.set(key, value);
  }

  async remove(key: string) {
    const backend = await this.backendPromise;
    return backend.remove(key);
  }

  async clear() {
    const backend = await this.backendPromise;
    return backend.clear();
  }
}

export const storage = new StorageProxy();
