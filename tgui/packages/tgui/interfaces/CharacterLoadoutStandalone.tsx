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
  // ids
  gearAllowed: string[];
  characterName: string;
}

/**
 * shim standalone interface for loadout
 */
export const CharacterLoadoutStandalone = (props) => {
  let { data, act } = useBackend<CharacterLoadoutStandaloneContext>();
  return (
    <Window width={800} height={900} title={`Loadout - ${data.characterName}`}>
      <Window.Content>
        <CharacterLoadout
          gearContext={data.gearContext}
          gearData={data.gearData}
          gearAllowed={data.gearAllowed}
          fill
          customizeDescAct={(id, desc) => act('redesc', { id: id, desc: desc })}
          customizeColorAct={(id, color) => act('recolor', { id: id, color: color })}
          customizeNameAct={(id, name) => act('rename', { id: id, name: name })}
          toggleAct={(id) => act('toggle', { id: id })}
          tweakAct={(id, tweakId) => act('tweak', { id: id, tweakId: tweakId })}
          slotRenameAct={(index, name) => act('slotName', { index: index, name: name })}
          slotChangeAct={(index) => act('slot', { index: index })}
          clearSlotAct={(index) => act('clear', { index: index })} />
      </Window.Content>
    </Window>
  );
};
