
export interface IngredientsNeeded {

}

export interface IngredientsAvailable {

}

export interface IngredientsDisplayProps {
  available: IngredientsAvailable;
}

export interface IngredientsRequirementProps {
  available: IngredientsAvailable;
  needed: IngredientsNeeded;
}

export const IngredientsDisplay = (props: IngredientsDisplayProps, context) => {

};

export const IngredientsRequirement = (props: IngredientsRequirementProps, context) => {

};
