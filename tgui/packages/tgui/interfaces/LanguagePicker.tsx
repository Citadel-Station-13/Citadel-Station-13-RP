import { useBackend } from '../backend';

type LanguagePickerContext = {

};

export const LanguagePicker = (props, context) => {
  const { act, data } = useBackend<LanguagePickerContext>(context);

  return (
    "TESTING CODE"
  );
};


// var/list/built = list()
// var/list/categories = list("General")
// for(var/name in SScharacters.language_names)
// 	var/datum/language/L = SScharacters.language_names
// 	if(L.language_flags & RESTRICTED)
// 		continue
// 	built[++built.len] = list(
// 		"id" = L.id,
// 		"name" = L.name,
// 		"desc" = L.desc,
// 		"category" = L.category
// 	)
// 	LAZYOR(categories, L.category)
// .["languages"] = built
