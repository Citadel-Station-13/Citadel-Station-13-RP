import fs from 'node:fs';
import { DME_NAME } from "../build.js";

/**
 * Prepends the defines to the .dme.
 * Does not clean them up, as this is intended for TGS which
 * clones new copies anyway.
 * @param {string[]} defines
 */
export async function prependDefines(...defines) {
  const fileName = `${DME_NAME}.dme`;
  const dmeContents = fs.readFileSync(fileName);

  const textToWrite = defines.map((define) => `#define ${define}\n`);
  
  fs.writeFileSync(fileName, `${textToWrite.join("")}\n${dmeContents}`);
}
