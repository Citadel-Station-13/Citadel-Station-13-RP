/**
 * @file
 * @license MIT
 */

import { Component } from "inferno";
import { Box, BoxProps } from "./Box";

/**
 * Allows putting a ton of stuff in a single scrollable div by not actually rendering all of it.
 */
export class VirtualScrollContainer extends Component<{

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
