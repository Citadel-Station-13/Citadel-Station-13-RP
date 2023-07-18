/**
 * @file
 * @license MIT
 */

import { useBackend } from "../backend";
import { Window } from "../layouts";
import { CharacterLoadout, LoadoutContext, LoadoutData } from "./CharacterSetup/CharacterLoadout";

interface CharacterLoadoutStandaloneContext {
  gearContext: LoadoutContext;
  gearData: LoadoutData;
  characterName: string;
}

/**
 * shim standalone interface for loadout
 */
export const CharacterLoadoutStandalone = (props, context) => {
  let { data, act } = useBackend<CharacterLoadoutStandaloneContext>(context);
  return (
    <Window width={800} height={600} title={`Loadout - ${data.characterName}`}>
      <Window.Content>
        <CharacterLoadout
          gearContext={data.gearContext}
          gearData={data.gearData}
          fill
          scrollable />
      </Window.Content>
    </Window>
  );
};
