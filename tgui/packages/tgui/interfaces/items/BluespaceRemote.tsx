import { useBackend } from "../../backend"
import { Window } from "../../layouts";

interface BluespaceRemoteData {

}

export const BluespaceRemote = (props, context) => {
  let {act, data} = useBackend<BluespaceRemoteData>(context);

  return (
    <Window width={800} height={800}>
      <Window.Content>
        Test
      </Window.Content>
    </Window>
  )
}
