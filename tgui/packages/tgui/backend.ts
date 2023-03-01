/**
 * This file provides a clear separation layer between backend updates
 * and what state our React app sees.
 *
 * Sometimes backend can response without a "data" field, but our final
 * state will still contain previous "data" because we are merging
 * the response with already existing state.
 *
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import { perf } from 'common/perf';
import { createAction } from 'common/redux';
import { setupDrag } from './drag';
import { focusMap } from './focus';
import { createLogger } from './logging';
import { resumeRenderer, suspendRenderer } from './renderer';

const logger = createLogger('backend');

export const backendUpdate = createAction('backend/update');
export const backendData = createAction('backend/data');
export const backendModuleData = createAction('backend/modules');
export const backendSetSharedState = createAction('backend/setSharedState');
export const backendSuspendStart = createAction('backend/suspendStart');

export const backendSuspendSuccess = () => ({
  type: 'backend/suspendSuccess',
  payload: {
    timestamp: Date.now(),
  },
});

const initialState = {
  config: {},
  data: {},
  modules: {},
  shared: {},
  // Start as suspended
  suspended: Date.now(),
  suspending: false,
};

export const backendReducer = (state = initialState, action) => {
  const { type, payload } = action;

  if (type === 'backend/update') {
    // Merge config
    const config = {
      ...state.config,
      ...payload.config,
    };
    // Merge data
    const data = {
      ...state.data,
      ...payload.static,
      ...payload.data,
    };
    // Merge module data
    // Merge modules
    const modules = {
      ...state.modules,
    };
    if (payload.modules) {
      const merging = payload.modules;
      for (let id of Object.keys(merging)) {
        modules[id] = {
          ...modules[id],
          ...merging[id],
        };
      }
    }
    // Merge shared states
    const shared = { ...state.shared };
    if (payload.shared) {
      for (let key of Object.keys(payload.shared)) {
        const value = payload.shared[key];
        if (value === '') {
          shared[key] = undefined;
        }
        else {
          shared[key] = JSON.parse(value);
        }
      }
    }
    // Return new state
    return {
      ...state,
      config,
      data,
      modules,
      shared,
      suspended: false,
    };
  }

  if (type === 'backend/data') {
    // Merge data
    const data = {
      ...state.data,
      ...payload,
    };
    // Return new state
    return {
      ...state,
      data,
    };
  }

  if (type === 'backend/modules') {
    // Merge modules
    const modules = {
      ...state.modules,
    };
    for (let id of Object.keys(payload)) {
      const data = payload[id];
      const merged = {
        ...modules[data],
        ...data,
      };
      modules[id] = merged;
    }
    // Return new state
    return {
      ...state,
      modules,
    };
  }

  if (type === 'backend/setSharedState') {
    const { key, nextState } = payload;
    return {
      ...state,
      shared: {
        ...state.shared,
        [key]: nextState,
      },
    };
  }

  if (type === 'backend/suspendStart') {
    return {
      ...state,
      suspending: true,
    };
  }

  if (type === 'backend/suspendSuccess') {
    const { timestamp } = payload;
    return {
      ...state,
      data: {},
      shared: {},
      config: {
        ...state.config,
        title: '',
        status: 1,
      },
      suspending: false,
      suspended: timestamp,
    };
  }

  return state;
};

export const backendMiddleware = store => {
  let fancyState;
  let suspendInterval;

  return next => action => {
    const { suspended } = selectBackend(store.getState());
    const { type, payload } = action;

    if (type === 'update') {
      store.dispatch(backendUpdate(payload));
      return;
    }

    if (type === 'data') {
      store.dispatch(backendData(payload));
      return;
    }

    if (type === 'modules') {
      store.dispatch(backendModuleData(payload));
    }

    if (type === 'suspend') {
      store.dispatch(backendSuspendSuccess());
      return;
    }

    if (type === 'ping') {
      Byond.sendMessage('ping/reply');
      return;
    }

    if (type === 'backend/suspendStart' && !suspendInterval) {
      logger.log(`suspending (${Byond.windowId})`);
      // Keep sending suspend messages until it succeeds.
      // It may fail multiple times due to topic rate limiting.
      const suspendFn = () => Byond.sendMessage('suspend');
      suspendFn();
      suspendInterval = setInterval(suspendFn, 2000);
    }

    if (type === 'backend/suspendSuccess') {
      suspendRenderer();
      clearInterval(suspendInterval);
      suspendInterval = undefined;
      Byond.winset(Byond.windowId, {
        'is-visible': false,
      });
      setImmediate(() => focusMap());
    }

    if (type === 'backend/update') {
      const fancy = payload.config?.window?.fancy;
      // Initialize fancy state
      if (fancyState === undefined) {
        fancyState = fancy;
      }
      // React to changes in fancy
      else if (fancyState !== fancy) {
        logger.log('changing fancy mode to', fancy);
        fancyState = fancy;
        Byond.winset(Byond.windowId, {
          titlebar: !fancy,
          'can-resize': !fancy,
        });
      }
    }

    // Resume on incoming update
    if (type === 'backend/update' && suspended) {
      // Show the payload
      logger.log('backend/update', payload);
      // Signal renderer that we have resumed
      resumeRenderer();
      // Setup drag
      setupDrag();
      // We schedule this for the next tick here because resizing and unhiding
      // during the same tick will flash with a white background.
      setImmediate(() => {
        perf.mark('resume/start');
        // Doublecheck if we are not re-suspended.
        const { suspended } = selectBackend(store.getState());
        if (suspended) {
          return;
        }
        Byond.winset(Byond.windowId, {
          'is-visible': true,
        });
        perf.mark('resume/finish');
        if (process.env.NODE_ENV !== 'production') {
          logger.log('visible in',
            perf.measure('render/finish', 'resume/finish'));
        }
      });
    }

    return next(action);
  };
};

export type actFunctionType = (action: string, payload?: object) => void;

/**
 * Sends an action to `ui_act` on `src_object` that this tgui window
 * is associated with.
 */
export const sendAct: actFunctionType = (action: string, payload: object = {}) => {
  // Validate that payload is an object
  const isObject = typeof payload === 'object'
    && payload !== null
    && !Array.isArray(payload);
  if (!isObject) {
    logger.error(`Payload for act() must be an object, got this:`, payload);
    return;
  }
  Byond.sendMessage('act/' + action, payload);
};

type BackendContext = {
  config: {
    title: string,
    status: number,
    interface: string,
    refreshing: number,
    window: {
      key: string,
      fancy: boolean,
      locked: boolean,
    },
    client: {
      ckey: string,
      address: string,
      computer_id: string,
    },
    user: {
      name: string,
      observer: number,
    },
  },
  modules: Record<string, any>,
  shared: Record<string, any>,
  suspending: boolean,
  suspended: boolean,
};

export type Backend<TData> = BackendContext & {
  data: TData,
  act: actFunctionType,
}

/**
 * Selects a backend-related slice of Redux state
 */
export const selectBackend = <TData>(state: any): Backend<TData> => (
  state.backend || {}
);

/**
 * A React hook (sort of) for getting tgui state and related functions.
 *
 * This is supposed to be replaced with a real React Hook, which can only
 * be used in functional components.
 *
 * You can make
 */
export const useBackend = <TData>(context: any): Backend<TData> => {
  const { store } = context;
  const state = selectBackend<TData>(store.getState());
  return {
    ...state,
    act: sendAct,
  };
};

/**
 * A tuple that contains the state and a setter function for it.
 */
type StateWithSetter<T> = [T, (nextState: T) => void];

/**
 * Allocates state on Redux store without sharing it with other clients.
 *
 * Use it when you want to have a stateful variable in your component
 * that persists between renders, but will be forgotten after you close
 * the UI.
 *
 * It is a lot more performant than `setSharedState`.
 *
 * @param context React context.
 * @param key Key which uniquely identifies this state in Redux store.
 * @param initialState Initializes your global variable with this value.
 */
export const useLocalState = <T>(
  context: any,
  key: string,
  initialState: T,
): StateWithSetter<T> => {
  const { store } = context;
  const state = selectBackend(store.getState());
  const sharedStates = state.shared ?? {};
  const sharedState = (key in sharedStates)
    ? sharedStates[key]
    : initialState;
  return [
    sharedState,
    nextState => {
      store.dispatch(backendSetSharedState({
        key,
        nextState: (
          typeof nextState === 'function'
            ? nextState(sharedState)
            : nextState
        ),
      }));
    },
  ];
};

/**
 * Allocates state on Redux store, and **shares** it with other clients
 * in the game.
 *
 * Use it when you want to have a stateful variable in your component
 * that persists not only between renders, but also gets pushed to other
 * clients that observe this UI.
 *
 * This makes creation of observable s
 *
 * @param context React context.
 * @param key Key which uniquely identifies this state in Redux store.
 * @param initialState Initializes your global variable with this value.
 */
export const useSharedState = <T>(
  context: any,
  key: string,
  initialState: T,
): StateWithSetter<T> => {
  const { store } = context;
  const state = selectBackend(store.getState());
  const sharedStates = state.shared ?? {};
  const sharedState = (key in sharedStates)
    ? sharedStates[key]
    : initialState;
  return [
    sharedState,
    nextState => {
      Byond.sendMessage({
        type: 'setSharedState',
        key,
        value: JSON.stringify(
          typeof nextState === 'function'
            ? nextState(sharedState)
            : nextState
        ) || '',
      });
    },
  ];
};

//* TGUI Module Backend

export interface ModuleProps {
  id: string, // module id, this lets it autoload from context
}

export interface ModuleData {
  $tgui: string, // module interface
  $ref: string, // byond ref to self
}

export type ModuleBackend<TData extends ModuleData> = {
  data: TData;
  act: actFunctionType;
  backend: Backend<{}>;
}

/**
 * a hook for getting the module state
 *
 * id is not provided in returned object because it's in props.
 *
 * returns:
 * {
 *    backend - what useBackend usually sends; you usually don't want to use this.
 *    data - our module's data, got from their id
 *    act - a pre-bound module act function that works the same from the UI side
 *        whether or not we're in a module, or being used as a root UI
 * }
 *
 * todo: bind useLocalState, useSharedState properly *somehow*
 *       maybe with a useModuleLocal, useModuleShared?
 */
export const useModule = <TData extends ModuleData>(context): ModuleBackend<TData> => {
  const { is_module } = context;
  let backend = useBackend<TData>(context);
  if (!is_module) {
    return { // not operating in module mode, just send normal backend
      backend: backend,
      data: backend.data,
      act: backend.act,
    };
  }
  let { modules } = backend;
  return {
    backend: backend,
    data: (modules && modules[context.m_id]) || {},
    act: constructModuleAct(context.m_id, context.m_ref),
  };
};

export const constructModuleAct = (id: string, ref: string): actFunctionType => {
  return (action: string, payload: object = {}) => {
    let sent = {
      ...payload,
      "$m_id": id,
      "$m_ref": ref,
    };
    // Validate that payload is an object
    const isObject = typeof payload === 'object'
      && payload !== null
      && !Array.isArray(payload);
    if (!isObject) {
      logger.error(`Payload for module act() must be an object, got this:`, payload);
      return;
    }
    Byond.sendMessage('mod/' + action, sent);
  };
};
