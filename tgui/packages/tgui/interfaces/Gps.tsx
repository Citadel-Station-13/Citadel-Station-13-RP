import { useBackend, useLocalState } from "../backend";
import { BooleanLike } from "../../common/react";
import { Window } from "../layouts";
import { Section, Button, LabeledList, Table, Input, Box, Icon } from "../components";

type GpsContext = {
  on: BooleanLike,
  tag: string,
  visible: BooleanLike,
  long_range: BooleanLike,
  has_stealth: BooleanLike,
  updating: BooleanLike,
  x: number,
  y: number,
  level: string,
  signals: GpsSignal[],
  waypoints: GpsWaypoint[],
  tracking: string,
};

interface Trackable {
  ref: string,
  name: string,
  x: number,
  y: number,
  level: string,
}

interface GpsSignal extends Trackable {}
interface GpsWaypoint extends Trackable {}

interface TrackingEntryContext {
  tracking: Trackable,
}

export const Gps = (props, context) => {
  const { act, data } = useBackend<GpsContext>(context);
  const [addWaypointName, setAddWaypointName] = useLocalState(context, 'waypointName', "");
  const [addWaypointX, setAddWaypointX] = useLocalState(context, 'waypointX', "");
  const [addWaypointY, setAddWaypointY] = useLocalState(context, 'waypointY', "");
  const [addWaypointLevel, setAddWaypointLevel] = useLocalState(context, 'waypointLevel', "");
  return (
    <Window
      title="Global Positioning System"
      width={470}
      height={700}>
      <Window.Content scrollable>
        <Section
          title="Control"
          buttons={(
            <Button
              icon="power-off"
              content={data.on? "On" : "Off"}
              selected={!!data.on}
              onClick={() => act('power')} />
          )}>
          <LabeledList>
            <LabeledList.Item label="Tag">
              <Input
                value={data.tag}
                onChange={(_, value) => act('tag', { tag: value })}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Range">
              <Button
                icon="sync"
                content={data.long_range? "Maximum" : "Local"}
                selected={!data.long_range}
                onClick={() => act('range')} />
            </LabeledList.Item>
            <LabeledList.Item label="Updating">
              <Button
                icon={data.updating? "unlock" : "lock"}
                content={data.updating? "Auto" : "Manual"}
                selected={!data.updating}
                onClick={() => act('toggle_update')} />
            </LabeledList.Item>
            {
              data.has_stealth ? (
                <LabeledList.Item label="Stealth">
                  <Button
                    icon="sync"
                    content={data.visible? "Broadcasting" : "Concealed"}
                    selected={!data.visible}
                    onClick={() => act('hide')} />
                </LabeledList.Item>
              ) : (
                <LabeledList.Item label="Signal">
                  {data.visible? "Broadcasting" : "Concealed"}
                </LabeledList.Item>
              )
            }
          </LabeledList>
        </Section>
        {!!data.on && (
          <>
            <Section
              title="Status">
              <Box fontSize="18px">
                Location: {data.x}, {data.y} - {data.level}
              </Box>
            </Section>
            <Section title="Add Waypoint"
              buttons={
                <Button
                  icon="plus"
                  onClick={() => act('add_waypoint', { name: addWaypointName, level_id: addWaypointLevel,
                    x: addWaypointX, y: addWaypointY })} />
              }>
              <Input placeholder="Waypoint" width="25rem"
                value={addWaypointName} onChange={(_, v) => setAddWaypointName(v)} />
              <Input placeholder="X" width="3rem"
                value={addWaypointX} onChange={(_, v) => setAddWaypointX(v)} />
              <Input placeholder="Y" width="3rem"
                value={addWaypointY} onChange={(_, v) => setAddWaypointY(v)} />
              <Input placeholder="Level" width="10rem"
                value={addWaypointLevel} onChange={(_, v) => setAddWaypointLevel(v)} />
            </Section>
            <Section
              title="Signals / Waypoints">
              <Table>
                <Table.Row bold>
                  <Table.Cell />
                  <Table.Cell collapsing>
                    DIR
                  </Table.Cell>
                  <Table.Cell collapsing>
                    CRD
                  </Table.Cell>
                  <Table.Cell collapsing />
                </Table.Row>
                <Table.Row bold>
                  <Table.Cell>
                    SIGNALS
                  </Table.Cell>
                  <Table.Cell collapsing minWidth="5rem" />
                  <Table.Cell collapsing minWidth="5rem" />
                  <Table.Cell collapsing />
                </Table.Row>
                {
                  data.signals.map(signal => (
                    <Table.Row key={signal.ref} className="candystripe">
                      <Table.Cell bold color="label">
                        {signal.name}
                      </Table.Cell>
                      <Table.Cell collapsing>
                        {
                          data.level === signal.level ? (
                            <Icon
                              mr={1}
                              size={1.2}
                              name="arrow-up"
                              rotation={Math.round(Math.atan2(signal.x - data.x, signal.y - data.y) * 180 / Math.PI)} />
                          ) : (
                            `FAR`
                          )
                        }
                      </Table.Cell>
                      <Table.Cell collapsing>
                        {
                          data.level === signal.level? (
                            `${signal.x}, ${signal.y}`
                          ) : (
                            `${signal.level}`
                          )
                        }
                      </Table.Cell>
                      <Table.Cell collapsing>
                        <Button
                          icon="bullseye"
                          selected={data.tracking === signal.ref}
                          onClick={() => act('track', { ref: signal.ref })}
                        />
                      </Table.Cell>
                    </Table.Row>
                  ))
                }
                <Table.Row bold>
                  <Table.Cell>
                    WAYPOINTS
                  </Table.Cell>
                  <Table.Cell collapsing minWidth="5rem" />
                  <Table.Cell collapsing minWidth="5rem" />
                  <Table.Cell collapsing />
                </Table.Row>
                {
                  data.waypoints.map(signal => (
                    <Table.Row key={signal.ref} className="candystripe">
                      <Table.Cell bold color="label">
                        {signal.name}
                      </Table.Cell>
                      <Table.Cell collapsing>
                        {
                          data.level === signal.level && (
                            <Icon
                              mr={1}
                              size={1.2}
                              name="arrow-up"
                              rotation={Math.round(Math.atan2(signal.x - data.x, signal.y - data.y) * 180 / Math.PI)} />
                          )
                        }
                      </Table.Cell>
                      <Table.Cell collapsing>
                        {
                          data.level === signal.level? (
                            `${signal.x}, ${signal.y}`
                          ) : (
                            `FAR: ${signal.level}`
                          )
                        }
                      </Table.Cell>
                      <Table.Cell collapsing>
                        <Button
                          icon="bullseye"
                          selected={data.tracking === signal.ref}
                          onClick={() => act('track', { ref: signal.ref })}
                        />
                        <Button.Confirm
                          icon="trash"
                          onClick={() => act('del_waypoint', { ref: signal.ref })} />
                      </Table.Cell>
                    </Table.Row>
                  ))
                }
              </Table>
            </Section>
          </>
        )}
      </Window.Content>
    </Window>
  );
};

// import { map, sortBy } from 'common/collections';
// import { flow } from 'common/fp';
// import { clamp } from 'common/math';
// import { vecLength, vecSubtract } from 'common/vector';
// import { useBackend } from '../backend';
// import { Box, Button, Icon, LabeledList, Section, Table } from '../components';
// import { Window } from '../layouts';

// const coordsToVec = coords => map(parseFloat)(coords.split(', '));

// export const Gps = (props, context) => {
//   const { act, data } = useBackend(context);
//   const {
//     currentArea,
//     currentCoords,
//     globalmode,
//     power,
//     tag,
//     updating,
//   } = data;
//   const signals = flow([
//     map((signal, index) => {
//       // Calculate distance to the target. BYOND distance is capped to 127,
//       // that's why we roll our own calculations here.
//       const dist = signal.dist && (
//         Math.round(vecLength(vecSubtract(
//           coordsToVec(currentCoords),
//           coordsToVec(signal.coords))))
//       );
//       return { ...signal, dist, index };
//     }),
//     sortBy(
//       // Signals with distance metric go first
//       signal => signal.dist === undefined,
//       // Sort alphabetically
//       signal => signal.entrytag),
//   ])(data.signals || []);
//   return (
//     <Window
//       title="Global Positioning System"
//       width={470}
//       height={700}>
//       <Window.Content scrollable>
//         <Section
//           title="Control"
//           buttons={(
//             <Button
//               icon="power-off"
//               content={power ? "On" : "Off"}
//               selected={power}
//               onClick={() => act('power')} />
//           )}>
//           <LabeledList>
//             <LabeledList.Item label="Tag">
//               <Button
//                 icon="pencil-alt"
//                 content={tag}
//                 onClick={() => act('rename')} />
//             </LabeledList.Item>
//             <LabeledList.Item label="Scan Mode">
//               <Button
//                 icon={updating ? "unlock" : "lock"}
//                 content={updating ? "AUTO" : "MANUAL"}
//                 color={!updating && "bad"}
//                 onClick={() => act('updating')} />
//             </LabeledList.Item>
//             <LabeledList.Item label="Range">
//               <Button
//                 icon="sync"
//                 content={globalmode ? "MAXIMUM" : "LOCAL"}
//                 selected={!globalmode}
//                 onClick={() => act('globalmode')} />
//             </LabeledList.Item>
//           </LabeledList>
//         </Section>
//         {!!power && (
//           <>
//             <Section title="Current Location">
//               <Box fontSize="18px">
//                 {currentArea} ({currentCoords})
//               </Box>
//             </Section>
//             <Section title="Detected Signals">
//               <Table>
//                 <Table.Row bold>
//                   <Table.Cell content="Name" />
//                   <Table.Cell collapsing content="Direction" />
//                   <Table.Cell collapsing content="Coordinates" />
//                 </Table.Row>
//                 {signals.map(signal => (
//                   <Table.Row
//                     key={signal.entrytag + signal.coords + signal.index}
//                     className="candystripe">
//                     <Table.Cell bold color="label">
//                       {signal.entrytag}
//                     </Table.Cell>
//                     <Table.Cell
//                       collapsing
//                       opacity={signal.dist !== undefined && (
//                         clamp(
//                           1.2 / Math.log(Math.E + signal.dist / 20),
//                           0.4, 1)
//                       )}>
//                       {signal.degrees !== undefined && (
//                         <Icon
//                           mr={1}
//                           size={1.2}
//                           name="arrow-up"
//                           rotation={signal.degrees} />
//                       )}
//                       {signal.dist !== undefined && (
//                         signal.dist + 'm'
//                       )}
//                     </Table.Cell>
//                     <Table.Cell collapsing>
//                       {signal.coords}
//                     </Table.Cell>
//                   </Table.Row>
//                 ))}
//               </Table>
//             </Section>
//           </>
//         )}
//       </Window.Content>
//     </Window>
//   );
// };
