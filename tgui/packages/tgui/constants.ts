/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

type Gas = {
  id: string;
  path: string;
  name: string;
  label: string;
  color: string;
};

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
} as const;

// Colors defined in CSS
export const CSS_COLORS = [
  'average',
  'bad',
  'black',
  'blue',
  'brown',
  'good',
  'green',
  'grey',
  'label',
  'olive',
  'orange',
  'pink',
  'purple',
  'red',
  'teal',
  'transparent',
  'violet',
  'white',
  'yellow',
] as const;

export type CssColor = (typeof CSS_COLORS)[number];

/* IF YOU CHANGE THIS KEEP IT IN SYNC WITH CHAT CSS */
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
] as const;


const GASES = [
  {
    id: 'o2',
    path: '/datum/gas/oxygen',
    name: 'Oxygen',
    label: 'O₂',
    color: 'blue',
  },
  {
    id: 'n2',
    path: '/datum/gas/nitrogen',
    name: 'Nitrogen',
    label: 'N₂',
    color: 'yellow',
  },
  {
    id: 'co2',
    path: '/datum/gas/carbon_dioxide',
    name: 'Carbon Dioxide',
    label: 'CO₂',
    color: 'grey',
  },
  {
    id: 'phoron',
    path: '/datum/gas/phoron',
    name: 'Phoron',
    label: 'PHR',
    color: 'pink',
  },
  {
    id: 'n2o',
    path: '/datum/gas/nitrous_oxide',
    name: 'Nitrous Oxide',
    label: 'N₂O',
    color: 'bisque',
  },
  {
    id: 'no2',
    path: '/datum/gas/nitrodioxide',
    name: 'Nitrogen Dioxide',
    label: 'NO₂',
    color: 'brown',
  },
  {
    id: 'helium',
    path: '/datum/gas/helium',
    name: 'Helium',
    label: 'He',
    color: 'aliceblue',
  },
] as const;

// Returns gas label based on gasId
export const getGasLabel = (gasId: string, fallbackValue?: string) => {
  if (!gasId) return fallbackValue || 'None';

  const gasSearchString = gasId.toLowerCase();

  for (let idx = 0; idx < GASES.length; idx++) {
    if (GASES[idx].id === gasSearchString) {
      return GASES[idx].label;
    }
  }

  return fallbackValue || 'None';
};

// Returns gas color based on gasId
export const getGasColor = (gasId: string) => {
  if (!gasId) return 'black';

  const gasSearchString = gasId.toLowerCase();

  for (let idx = 0; idx < GASES.length; idx++) {
    if (GASES[idx].id === gasSearchString) {
      return GASES[idx].color;
    }
  }

  return 'black';
};

// Returns gas object based on gasId
export const getGasFromId = (gasId: string): Gas | undefined => {
  if (!gasId) return;

  const gasSearchString = gasId.toLowerCase();

  for (let idx = 0; idx < GASES.length; idx++) {
    if (GASES[idx].id === gasSearchString) {
      return GASES[idx];
    }
  }
};

// Returns gas object based on gasPath
export const getGasFromPath = (gasPath: string): Gas | undefined => {
  if (!gasPath) return;

  for (let idx = 0; idx < GASES.length; idx++) {
    if (GASES[idx].path === gasPath) {
      return GASES[idx];
    }
  }
};
