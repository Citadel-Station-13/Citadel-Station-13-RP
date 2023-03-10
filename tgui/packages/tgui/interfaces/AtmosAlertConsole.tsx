import { useBackend } from '../backend';
import { Button, Section } from '../components';
import { Window } from '../layouts';

interface AtmosAlertConsoleData {
  priority_alarms: Array<AtmosAlert>;
  minor_alarms: Array<AtmosAlert>;
}

interface AtmosAlert {
  name: string;
  ref: string;
}

export const AtmosAlertConsole = (props, context) => {
  const { act, data } = useBackend<AtmosAlertConsoleData>(context);
  return (
    <Window
      width={350}
      height={300}>
      <Window.Content scrollable>
        <Section title="Alarms">
          <ul>
            {data.priority_alarms.length === 0 && (
              <li className="color-good">
                No Priority Alerts
              </li>
            )}
            {data.priority_alarms.map(alert => (
              <li key={alert.ref}>
                <Button
                  icon="times"
                  content={alert.name}
                  color="bad"
                  onClick={() => act('clear', { zone: alert })} />
              </li>
            ))}
            {data.minor_alarms.length === 0 && (
              <li className="color-good">
                No Minor Alerts
              </li>
            )}
            {data.minor_alarms.map(alert => (
              <li key={alert.ref}>
                <Button
                  icon="times"
                  content={alert.name}
                  color="average"
                  onClick={() => act('clear', { zone: alert })} />
              </li>
            ))}
          </ul>
        </Section>
      </Window.Content>
    </Window>
  );
};
