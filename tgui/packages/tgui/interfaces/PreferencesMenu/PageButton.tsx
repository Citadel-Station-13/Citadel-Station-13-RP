import { InfernoNode } from "inferno";
import { Button } from "../../components";

export const PageButton = <P extends unknown>(props: {
  readonly currentPage: P,
  readonly page: P,
  readonly otherActivePages?: P[],

  readonly setPage: (page: P) => void,

  readonly children?: InfernoNode,
}) => {
  const pageIsActive = props.currentPage === props.page
    || (
      props.otherActivePages
        && props.otherActivePages.indexOf(props.currentPage) !== -1
    );

  return (
    <Button
      align="center"
      fontSize="1.2em"
      fluid
      selected={pageIsActive}
      onClick={() => props.setPage(props.page)}
    >
      {props.children}
    </Button>
  );
};
