import { Module } from "../../components/Module"
import { Window } from "../../layouts"

export const ShuttleConsole = (props, context) => {
  return (
    <Window>
      <Window.Content>
        <Module id="shuttle"></Module>
      </Window.Content>
    </Window>
  )
}
