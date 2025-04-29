/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import { classes } from 'common/react';
import { createLogger } from 'tgui/logging';
import { IMAGE_RETRY_DELAY, IMAGE_RETRY_LIMIT } from './constants';
import { Tooltip } from 'tgui/components';
import { ChatRenderer } from './ChatRenderer';

export const logger = createLogger('chatRenderer');

// We consider this as the smallest possible scroll offset
// that is still trackable.
export const SCROLL_TRACKING_TOLERANCE = 24;

// List of injectable component names to the actual type
export const TGUI_CHAT_COMPONENTS = {
  Tooltip,
};

// List of injectable attibute names mapped to their proper prop
// We need this because attibutes don't support lowercase names
export const TGUI_CHAT_ATTRIBUTES_TO_PROPS = {
  position: 'position',
  content: 'content',
};

export const findNearestScrollableParent = (startingNode) => {
  const body = document.body;
  let node = startingNode;
  while (node && node !== body) {
    // This definitely has a vertical scrollbar, because it reduces
    // scrollWidth of the element. Might not work if element uses
    // overflow: hidden.
    if (node.scrollWidth < node.offsetWidth) {
      return node;
    }
    node = node.parentNode;
  }
  return window;
};

export const createHighlightNode = (text, color) => {
  const node = document.createElement('span');
  node.className = 'Chat__highlight';
  node.setAttribute('style', 'background-color:' + color);
  node.textContent = text;
  return node;
};

export const createMessageNode = () => {
  const node = document.createElement('div');
  node.className = 'ChatMessage';
  return node;
};

export const createReconnectedNode = () => {
  const node = document.createElement('div');
  node.className = 'Chat__reconnected';
  return node;
};

export const handleImageError = (e) => {
  setTimeout(() => {
    /** @type {HTMLImageElement} */
    const node = e.target;
    if (!node) {
      return;
    }
    const attempts = parseInt(node.getAttribute('data-reload-n'), 10) || 0;
    if (attempts >= IMAGE_RETRY_LIMIT) {
      logger.error(`failed to load an image after ${attempts} attempts`);
      return;
    }
    const src = node.src;
    node.src = null;
    node.src = src + '#' + attempts;
    node.setAttribute('data-reload-n', attempts + 1);
  }, IMAGE_RETRY_DELAY);
};

/**
 * Assigns a "times-repeated" badge to the message.
 */
export const updateMessageBadge = (message) => {
  const { node, times } = message;
  if (!node || !times) {
    // Nothing to update
    return;
  }
  const foundBadge = node.querySelector('.Chat__badge');
  const badge = foundBadge || document.createElement('div');
  badge.textContent = times;
  badge.className = classes(['Chat__badge', 'Chat__badge--animate']);
  requestAnimationFrame(() => {
    badge.className = 'Chat__badge';
  });
  if (!foundBadge) {
    node.appendChild(badge);
  }
};

// Make chat renderer global so that we can continue using the same
// instance after hot code replacement.
if (!window.__chatRenderer__) {
  window.__chatRenderer__ = new ChatRenderer();
}

/** @type {ChatRenderer} */
export const chatRenderer = window.__chatRenderer__;
