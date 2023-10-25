/* global fetch */
export const fetchJSON = async (url) => fetch(url).then(res => res.json());

export const isUndefined = (v) => typeof v === "undefined";