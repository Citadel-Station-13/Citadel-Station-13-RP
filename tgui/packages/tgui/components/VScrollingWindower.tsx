/**
 * @file
 * @license MIT
 */

import { Component } from "inferno";
import { Box, BoxProps } from "./Box";

/**
 * Low-level vertical virtual scrolling window component.
 * Allows putting a ton of stuff in a single scrollable div by not actually rendering all of it.
 */
export class VScrollingWindower extends Component<{

} & BoxProps> {
  state: {

  };

  constructor(props) {
    super(props);
    this.state = {

    };
  }

  render() {


    return (
      <Box className="VirtualScrolContainer">
        <Box className="VirtualScrollInner">
          {}
        </Box>
      </Box>
    );
  }
}
