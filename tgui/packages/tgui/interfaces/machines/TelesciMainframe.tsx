import { useBackend, useModule } from "../../backend"
import { Window } from "../../layouts";

interface TelesciMainframeData {

}

export const TelesciMainframe = (props, context) => {
  let {act, data} = useBackend<TelesciMainframeData>(context);

  return (
    <Window width={800} height={800}>
      <Window.Content>
        Test
      </Window.Content>
    </Window>
  )
}

