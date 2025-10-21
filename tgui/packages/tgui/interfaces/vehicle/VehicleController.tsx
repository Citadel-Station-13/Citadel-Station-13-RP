/**
 * @file
 * @license MIT
 */

import { Component } from "react";
import { Section } from "tgui-core/components";

import { Window } from "../../layouts";

/**
 * Vehicle controller app window
 */
// eslint-disable-next-line react/prefer-stateless-function
export class VehicleController extends Component {

  render() {
    return (
      <Window width={500} height={800}>
        <Window.Content>
          <Section>
            Test
          </Section>
        </Window.Content>
      </Window>
    );
  }
}
