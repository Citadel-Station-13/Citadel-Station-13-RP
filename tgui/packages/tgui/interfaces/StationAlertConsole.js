import { useBackend } from '../backend';
import { Section, Button, Box } from '../components';
import { Window } from '../layouts';

export const StationAlertConsole = (props) => {
  const {
    useModern = false,
  } = props;
  return (
    <Window
      width={425}
      height={600}
      resizable>
      <Window.Content scrollable>
        {useModern ? (<StationAlertConsoleContentModern />): (<StationAlertConsoleContent />)}
      </Window.Content>
    </Window>
  );
};

// to be used by modular computers only; not fucking around with the old alarm thing
export const StationAlertConsoleContentModern = (props, context) => {
  const { data } = useBackend(context);
  const categories = data.alarms || [];
  const fire = categories['Fire'] || [];
  const atmos = categories['Atmosphere'] || [];
  const power = categories['Power'] || [];
  return (
    <>
      <Section title="Fire Alarms">
        <ul>
          {fire.length === 0 && (
            <li className="color-good">
              Systems Nominal
            </li>
          )}
          {fire.map(alert => (
            <li key={alert} className="color-average">
              {alert}
            </li>
          ))}
        </ul>
      </Section>
      <Section title="Atmospherics Alarms">
        <ul>
          {atmos.length === 0 && (
            <li className="color-good">
              Systems Nominal
            </li>
          )}
          {atmos.map(alert => (
            <li key={alert} className="color-average">
              {alert}
            </li>
          ))}
        </ul>
      </Section>
      <Section title="Power Alarms">
        <ul>
          {power.length === 0 && (
            <li className="color-good">
              Systems Nominal
            </li>
          )}
          {power.map(alert => (
            <li key={alert} className="color-average">
              {alert}
            </li>
          ))}
        </ul>
      </Section>
    </>
  );
};

export const StationAlertConsoleContent = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    categories = [],
  } = data;
  return categories.map(category => (
    <Section key={category.category} title={category.category}>
      <ul>
        {category.alarms.length === 0 && (
          <li className="color-good">
            Systems Nominal
          </li>
        )}
        {category.alarms.map(alarm => {
          let footer = "";

          // To be clear, this is never the case unless the user is an AI.
          if (alarm.has_cameras) {
            footer = (
              <Section>
                {alarm.cameras.map(camera => (
                  <Button
                    key={camera.name}
                    disabled={camera.deact}
                    content={camera.name
                      + (camera.deact ? ' (deactived)' : '')}
                    icon="video"
                    onClick={() => act('switchTo', {
                      camera: camera.camera,
                    })} />
                ))}
              </Section>
            );
          } else if (alarm.lost_sources) {
            footer = (
              <Box color="bad">
                Lost Alarm Sources: {alarm.lost_sources}
              </Box>
            );
          }

          return (
            <li key={alarm.name}>
              {alarm.name}
              {alarm.origin_lost
                ? <Box color="bad">Alarm Origin Lost.</Box>
                : ''}
              {footer}
            </li>
          );
        })}
      </ul>
    </Section>
  ));
};
