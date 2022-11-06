import { useBackend } from '../backend';
import { Window } from '../layouts';
import { Stack } from '../components';

type LanguagePickerContext = {
  categories: String[],
  languages: Language[],
};

type Language = {
  id: String,
  name: String,
  desc: String,
  category: String,
};

export const LanguagePicker = (props, context) => {
  const { act, data } = useBackend<LanguagePickerContext>(context);

  return (
    <Window width={800} height={400}>
      <Window.Content>
        <Stack fill>
          <Stack.Item>
            test2
          </Stack.Item>
          <Stack.Item grow={3}>
            test1
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

const LanguageInfo = (props, context) => {
  const { act, data } = useBackend<LanguagePickerContext>(context);

};

const LanguageSelect = (props, context) => {
  const { act, data } = useBackend<LanguagePickerContext>(context);

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
