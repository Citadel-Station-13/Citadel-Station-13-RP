/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import { toFixed } from 'common/math';
import { useLocalState } from 'tgui/backend';
import { useDispatch, useSelector } from 'common/redux';
import { Box, Button, Collapsible, ColorBox, Divider, Icon, Input, LabeledList, NoticeBox, Section, Slider, Stack, Tabs, TextArea } from 'tgui/components';
import { ChatPageSettings } from '../chat';
import { rebuildChat, saveChatToDisk } from '../chat/actions';
import { THEMES } from '../themes';
import { addHighlightSetting, changeSettingsTab, exportSettings, removeHighlightSetting, updateHighlightSetting, updateSettings } from './actions';
import { FONTS, SETTINGS_TABS, WARN_AFTER_HIGHLIGHT_AMT } from './constants';
import { selectActiveTab, selectHighlightSettingById, selectHighlightSettings, selectSettings } from './selectors';
import { capitalize } from 'common/string';
import { importChatSettings } from './settingsImExport';

const TabsViews = ['default', 'classic', 'scrollable'];
const LinkedToChat = () => (
  <NoticeBox color="red">Unlink Stat Panel from chat!</NoticeBox>
);

export const SettingsPanel = (props, context) => {
  const activeTab = useSelector(context, selectActiveTab);
  const dispatch = useDispatch(context);

  return (
    <Stack fill>
      <Stack.Item>
        <Section fitted fill minHeight="8em">
          <Tabs vertical>
            {SETTINGS_TABS.map((tab) => (
              <Tabs.Tab
                key={tab.id}
                selected={tab.id === activeTab}
                onClick={() =>
                  dispatch(
                    changeSettingsTab({
                      tabId: tab.id,
                    }),
                  )
                }
              >
                {tab.name}
              </Tabs.Tab>
            ))}
          </Tabs>
        </Section>
      </Stack.Item>
      <Stack.Item grow basis={0}>
        {activeTab === 'general' && <SettingsGeneral />}
        {activeTab === 'chatPage' && <ChatPageSettings />}
        {activeTab === 'textHighlight' && <TextHighlightSettings />}
      </Stack.Item>
    </Stack>
  );
};

export const SettingsGeneral = (props, context) => {
  const {
    theme,
    fontFamily,
    fontSize,
    lineHeight,
    highlightText,
    highlightColor,
    matchWord,
    matchCase,
  } = useSelector(context, selectSettings);
  const dispatch = useDispatch(context);
  const [freeFont, setFreeFont] = useLocalState(context, "freeFont", false);
  return (
    <Section>
      <LabeledList>
        <LabeledList.Item label="Theme">
          {THEMES.map((THEME) => (
            <Button
              key={THEME}
              selected={theme === THEME}
              color="transparent"
              onClick={() =>
                dispatch(
                  updateSettings({
                    theme: THEME,
                  }),
                )
              }
            >
              {capitalize(THEME)}
            </Button>
          ))}
        </LabeledList.Item>
        <LabeledList.Item label="Font style">
          <Stack.Item>
            {!freeFont ? (
              <Collapsible
                title={fontFamily}
                // width={'100%'}
                buttons={
                  <Button
                    icon={freeFont ? 'lock-open' : 'lock'}
                    color={freeFont ? 'good' : 'bad'}
                    onClick={() => {
                      setFreeFont(!freeFont);
                    }}
                  >
                    Custom font
                  </Button>
                }
              >
                {FONTS.map((FONT) => (
                  <Button
                    key={FONT}
                    fontFamily={FONT}
                    selected={fontFamily === FONT}
                    color="transparent"
                    onClick={() =>
                      dispatch(
                        updateSettings({
                          fontFamily: FONT,
                        }),
                      )
                    }
                  >
                    {FONT}
                  </Button>
                ))}
              </Collapsible>
            ) : (
              <Stack>
                <Input
                  width={'100%'}
                  value={fontFamily}
                  onChange={(e, value) =>
                    dispatch(
                      updateSettings({
                        fontFamily: value,
                      }),
                    )
                  }
                />
                <Button
                  ml={0.5}
                  icon={freeFont ? 'lock-open' : 'lock'}
                  color={freeFont ? 'good' : 'bad'}
                  onClick={() => {
                    setFreeFont(!freeFont);
                  }}
                >
                  Custom font
                </Button>
              </Stack>
            )}
          </Stack.Item>
        </LabeledList.Item>
        <LabeledList.Item label="Font size" verticalAlign="middle">
          <Stack textAlign="center">
            <Stack.Item grow>
              <Slider
                width="100%"
                step={1}
                stepPixelSize={20}
                minValue={8}
                maxValue={32}
                value={fontSize}
                unit="px"
                format={(value) => toFixed(value)}
                onChange={(e, value) =>
                  dispatch(updateSettings({ fontSize: value }))
                }
              />
            </Stack.Item>
          </Stack>
        </LabeledList.Item>
        <LabeledList.Item label="Line height">
          <Slider
            width="100%"
            step={0.01}
            minValue={0.8}
            maxValue={5}
            value={lineHeight}
            format={(value) => toFixed(value, 2)}
            onDrag={(e, value) =>
              dispatch(
                updateSettings({
                  lineHeight: value,
                }),
              )
            }
          />
        </LabeledList.Item>
      </LabeledList>
      <Divider />

      <Stack fill>
        <Stack.Item mt={0.15}>
          <Button
            icon="compact-disc"
            tooltip="Export chat settings"
            onClick={() => dispatch(exportSettings())}
          >
            Export settings
          </Button>
        </Stack.Item>
        <Stack.Item mt={0.15}>
          <Button.File
            accept=".json"
            tooltip="Import chat settings"
            icon="arrow-up-from-bracket"
            // @ts-expect-error file momento
            onSelectFiles={(files) => importChatSettings(context, files)}
          >
            Import settings
          </Button.File>
        </Stack.Item>
        <Stack.Item grow mt={0.15}>
          <Button
            icon="save"
            tooltip="Export current tab history into HTML file"
            onClick={() => dispatch(saveChatToDisk())}
          >
            Save chat log
          </Button>
        </Stack.Item>
      </Stack>
    </Section>
  );
};

export function TextHighlightSettings(props, context) {
  const highlightSettings = useSelector(context, selectHighlightSettings);
  const dispatch = useDispatch(context);


  return (
    <Section fill scrollable height="250px">
      <Stack vertical>
        {highlightSettings.map((id, i) => (
          <TextHighlightSetting
            key={i}
            id={id}
            mb={i + 1 === highlightSettings.length ? 0 : '10px'}
          />
        ))}
        <Stack.Item>
          <Box>
            <Button
              color="transparent"
              icon="plus"
              onClick={() => {
                dispatch(addHighlightSetting());
              }}
            >
              Add Highlight Setting
            </Button>
            {highlightSettings.length >= WARN_AFTER_HIGHLIGHT_AMT && (
              <Box inline fontSize="0.9em" ml={1} color="red">
                <Icon mr={1} name="triangle-exclamation" />
                Large amounts of highlights can potentially cause performance
                issues!
              </Box>
            )}
          </Box>
        </Stack.Item>
      </Stack>
      <Divider />
      <Box>
        <Button icon="check" onClick={() => dispatch(rebuildChat())}>
          Apply now
        </Button>
        <Box inline fontSize="0.9em" ml={1} color="label">
          Can freeze the chat for a while.
        </Box>
      </Box>
    </Section>
  );
}


function TextHighlightSetting(props, context) {
  const { id, ...rest } = props;
  const highlightSettingById = useSelector(context, selectHighlightSettingById);
  const dispatch = useDispatch(context);
  const {
    highlightColor,
    highlightText,
    highlightWholeMessage,
    matchWord,
    matchCase,
  } = highlightSettingById[id];

  return (
    <Stack.Item {...rest}>
      <Stack mb={1} color="label" align="baseline">
        <Stack.Item grow>
          <Button
            color="transparent"
            icon="times"
            onClick={() =>
              dispatch(
                removeHighlightSetting({
                  id: id,
                }),
              )
            }
          >
            Delete
          </Button>
        </Stack.Item>
        <Stack.Item>
          <Button.Checkbox
            checked={highlightWholeMessage}
            tooltip="If this option is selected, the entire message will be highlighted in yellow."
            onClick={() =>
              dispatch(
                updateHighlightSetting({
                  id: id,
                  highlightWholeMessage: !highlightWholeMessage,
                }),
              )
            }
          >
            Whole Message
          </Button.Checkbox>
        </Stack.Item>
        <Stack.Item>
          <Button.Checkbox
            checked={matchWord}
            tooltipPosition="bottom-start"
            tooltip="If this option is selected, only exact matches (no extra letters before or after) will trigger. Not compatible with punctuation. Overriden if regex is used."
            onClick={() =>
              dispatch(
                updateHighlightSetting({
                  id: id,
                  matchWord: !matchWord,
                }),
              )
            }
          >
            Exact
          </Button.Checkbox>
        </Stack.Item>
        <Stack.Item>
          <Button.Checkbox
            tooltip="If this option is selected, the highlight will be case-sensitive."
            checked={matchCase}
            onClick={() =>
              dispatch(
                updateHighlightSetting({
                  id: id,
                  matchCase: !matchCase,
                }),
              )
            }
          >
            Case
          </Button.Checkbox>
        </Stack.Item>
        <Stack.Item>
          <ColorBox mr={1} color={highlightColor} />
          <Input
            width="5em"
            monospace
            placeholder="#ffffff"
            value={highlightColor}
            onInput={(e, value) =>
              dispatch(
                updateHighlightSetting({
                  id: id,
                  highlightColor: value,
                }),
              )
            }
          />
        </Stack.Item>
      </Stack>
      <TextArea
        height="3em"
        value={highlightText}
        placeholder="Put words to highlight here. Separate terms with commas, i.e. (term1, term2, term3)"
        onChange={(e, value) =>
          dispatch(
            updateHighlightSetting({
              id: id,
              highlightText: value,
            }),
          )
        }
      />
    </Stack.Item>
  );
}
