import { ModuleData, useBackend, useModule } from "../../backend"
import { Window } from "../../layouts";

interface TelesciControlData  {

}

export const TelesciControl = (props, context) => {
  let {act, data} = useBackend<TelesciControlData>(context);

  return (
    <Window width={800} height={800}>
      <Window.Content>
        Test
      </Window.Content>
    </Window>
  )
}
