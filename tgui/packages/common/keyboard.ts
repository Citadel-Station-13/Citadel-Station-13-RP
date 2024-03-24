//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/**
 * IE lacks these defines so we have to package it ourselves
 * https://developer.mozilla.org/en-US/docs/Web/API/KeyboardEvent/location
 * this is event.location on a KeyboardEvent
 */
export enum IEKeyboardEventLocation {
  Standard = 0,
  Left = 1,
  Right = 2,
  Numpad = 3,
}
