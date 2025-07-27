/**
 * @file
 * @license MIT
 */

import { Component, InfernoNode } from "inferno";
import { Box, BoxProps } from "./Box";

/**
 * Low-level vertical virtual scrolling window component.
 * Allows putting a ton of stuff in a single scrollable div by not actually rendering all of it.
 *
 * @prop rowCount number of rows total
 * @prop rowHeight height of a row, as either a string for css or a number.
 */
export class VScrollingWindower extends Component<{
  rowCount: number;
  rowHeight: string | number;
  rowCall: (r: number) => InfernoNode;
} & BoxProps> {
  state: {

  };

  constructor(props) {
    super(props);
    this.state = {

    };
  }

  render() {
    let innerContents;

    return (
      <Box className="VScrollingWindower">
        <Box className="VScrollingWindower__Inner">
          {innerContents}
        </Box>
      </Box>
    );
  }
}
