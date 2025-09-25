import { Button, Section, Stack } from 'tgui-core/components';

import { useBackend, useLocalState } from '../backend';
import { Window } from '../layouts';

type LanguagePickerContext = {
  categories: string[],
  languages: Language[],
};

type Language = {
  id: string,
  name: string,
  desc: string,
  category: string,
};

export const LanguagePicker = (props) => {
  const { act, data } = useBackend<LanguagePickerContext>();

  return (
    <Window width={800} height={400}>
      <Window.Content>
        <Stack fill>
          <Stack.Item width="25%">
            <LanguageCategories />
          </Stack.Item>
          <Stack.Item width="25%">
            <LanguageSelect />
          </Stack.Item>
          <Stack.Item width="50%">
            <LanguageInfo />
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

const LanguageInfo = (props) => {
  const { act, data } = useBackend<LanguagePickerContext>();
  const [selectedLanguage, setSelectedLanguage] = useLocalState<string | null>("selectedLanguage", null);
  let lang = data.languages.find((l) => l.id === selectedLanguage);
  if (lang === undefined) {
    return (<Section fill />);
  } else {
    return (
      <Section
        fill
        scrollable
        title={lang?.name}
      >
        {lang?.desc}
        <Button
          onClick={() => act('pick', { id: lang?.id })}
          position="absolute"
          left="10px"
          right="10px"
          width="auto"
          bottom="10px"
          textAlign="center"
        >
          Select
        </Button>
      </Section>
    );
  }
};

const LanguageCategories = (props) => {
  const { act, data } = useBackend<LanguagePickerContext>();
  const { categories } = data;
  let [selectedCategory, setSelectedCategory] = useLocalState<string | null>("selectedCategory", null);
  return (
    <Section fill scrollable title="Categories">
      {
        Object.values(categories).map((c) => {
          return (
            <Button
              fluid
              color="transparent"
              key={c}
              selected={c === selectedCategory}
              onClick={() => setSelectedCategory(c)}
            >
              {c}
            </Button>
          );
        })
      }
    </Section>
  );
};

const LanguageSelect = (props) => {
  const { act, data } = useBackend<LanguagePickerContext>();
  let [selectedLanguage, setSelectedLanguage] = useLocalState<string | null>("selectedLanguage", null);
  let [selectedCategory, setSelectedCategory] = useLocalState<string | null>("selectedCategory", null);
  if (selectedCategory === null) {
    return (
      <Section fill />
    );
  } else {
    return (
      <Section fill scrollable title="Languages">
        {
          data.languages.filter((l) => l.category === selectedCategory).map((l) => {
            return (
              <Button
                key={l.name}
                fluid
                color="transparent"
                selected={selectedLanguage === l.id}
                onClick={() => setSelectedLanguage(l.id)}
              >
                {l.name}
              </Button>
            );
          })
        }
      </Section>
    );
  }
};
