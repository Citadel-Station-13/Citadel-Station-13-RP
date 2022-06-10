/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

// UI states, which are mirrored from the BYOND code.
export const UI_INTERACTIVE = 2;
export const UI_UPDATE = 1;
export const UI_DISABLED = 0;
export const UI_CLOSE = -1;

export const UI_NOT_REFRESHING = 0;
export const UI_SOFT_REFRESHING = 1;
export const UI_HARD_REFRESHING = 2;

// All game related colors are stored here
export const COLORS = {
  // Department colors
  department: {
    captain: '#c06616',
    security: '#e74c3c',
    medbay: '#3498db',
    science: '#9b59b6',
    engineering: '#f1c40f',
    cargo: '#f39c12',
    centcom: '#00c100',
    other: '#c38312',
    exploration: '#c38312',
    silicon: '#c38312',
    miscellaneous: '#c38312',
    civillian: '#c38312',
  },
  // VOREStation Addition begin
  manifest: {
    command: "#3333FF",
    security: "#8e0000",
    medical: "#006600",
    engineering: "#b27300",
    science: "#a65ba6",
    cargo: "#bb9040",
    planetside: "#555555",
    civilian: "#a32800",
    miscellaneous: "#666666",
    silicon: "#222222",
  },
  // VOREStation Addition end
  // Damage type colors
  damageType: {
    oxy: '#3498db',
    toxin: '#2ecc71',
    burn: '#e67e22',
    brute: '#e74c3c',
  },
  // reagent / chemistry related colours
  reagent: {
    acidicbuffer: "#fbc314",
    basicbuffer: "#3853a4",
  },
};

// Colors defined in CSS
export const CSS_COLORS = [
  'black',
  'white',
  'red',
  'orange',
  'yellow',
  'olive',
  'green',
  'teal',
  'blue',
  'violet',
  'purple',
  'pink',
  'brown',
  'grey',
  'good',
  'average',
  'bad',
  'label',
];

export const RADIO_CHANNELS = [
  {
    name: 'Mercenary',
    freq: 1213,
    color: '#a52a2a',
  },
  {
    name: 'Red Team',
    freq: 1215,
    color: '#ff4444',
  },
  {
    name: 'Blue Team',
    freq: 1217,
    color: '#3434fd',
  },
  {
    name: 'CentCom',
    freq: 1337,
    color: '#2681a5',
  },
  {
    name: 'Supply',
    freq: 1347,
    color: '#b88646',
  },
  {
    name: 'Service',
    freq: 1349,
    color: '#6ca729',
  },
  {
    name: 'Science',
    freq: 1351,
    color: '#c68cfa',
  },
  {
    name: 'Command',
    freq: 1353,
    color: '#5177ff',
  },
  {
    name: 'Medical',
    freq: 1355,
    color: '#57b8f0',
  },
  {
    name: 'Engineering',
    freq: 1357,
    color: '#f37746',
  },
  {
    name: 'Security',
    freq: 1359,
    color: '#dd3535',
  },
  {
    name: 'AI Private',
    freq: 1447,
    color: '#d65d95',
  },
  {
    name: 'Common',
    freq: 1459,
    color: '#1ecc43',
  },
];

const GASES = [
  {
    'id': 'oxygen',
    'name': 'Oxygen',
    'label': 'O₂',
    'color': 'blue',
  },
  {
    'id': 'n2',
    'name': 'Nitrogen',
    'label': 'N₂',
    'color': 'red',
  },
  {
    'id': 'carbon dioxide',
    'name': 'Carbon Dioxide',
    'label': 'CO₂',
    'color': 'grey',
  },
  {
    'id': 'phoron',
    'name': 'Phoron',
    'label': 'Phoron',
    'color': 'pink',
  },
  {
    'id': 'water_vapor',
    'name': 'Water Vapor',
    'label': 'H₂O',
    'color': 'grey',
  },
  {
    'id': 'nob',
    'name': 'Hyper-noblium',
    'label': 'Hyper-nob',
    'color': 'teal',
  },
  {
    'id': 'n2o',
    'name': 'Nitrous Oxide',
    'label': 'N₂O',
    'color': 'red',
  },
  {
    'id': 'no2',
    'name': 'Nitryl',
    'label': 'NO₂',
    'color': 'brown',
  },
  {
    'id': 'tritium',
    'name': 'Tritium',
    'label': 'Tritium',
    'color': 'green',
  },
  {
    'id': 'bz',
    'name': 'BZ',
    'label': 'BZ',
    'color': 'purple',
  },
  {
    'id': 'stim',
    'name': 'Stimulum',
    'label': 'Stimulum',
    'color': 'purple',
  },
  {
    'id': 'pluox',
    'name': 'Pluoxium',
    'label': 'Pluoxium',
    'color': 'blue',
  },
  {
    'id': 'miasma',
    'name': 'Miasma',
    'label': 'Miasma',
    'color': 'olive',
  },
  {
    'id': 'hydrogen',
    'name': 'Hydrogen',
    'label': 'H₂',
    'color': 'white',
  },
  {
    'id': 'other',
    'name': 'Other',
    'label': 'Other',
    'color': 'white',
  },
  {
    'id': 'pressure',
    'name': 'Pressure',
    'label': 'Pressure',
    'color': 'average',
  },
  {
    'id': 'temperature',
    'name': 'Temperature',
    'label': 'Temperature',
    'color': 'yellow',
  },
];

export const getGasLabel = (gasId, fallbackValue) => {
  const gasSearchString = String(gasId).toLowerCase();
  const gas = GASES.find(gas => gas.id === gasSearchString
    || gas.name.toLowerCase() === gasSearchString);
  return gas && gas.label
    || fallbackValue
    || gasId;
};

export const getGasColor = gasId => {
  const gasSearchString = String(gasId).toLowerCase();
  const gas = GASES.find(gas => gas.id === gasSearchString
    || gas.name.toLowerCase() === gasSearchString);
  return gas && gas.color;
};

// VOREStation Addition start
/** 0.0 Degrees Celsius in Kelvin */
export const T0C = 273.15;
// VOREStation Addition end
