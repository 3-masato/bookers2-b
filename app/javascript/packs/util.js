/* global fetch */
export const fetchJSON = async (url) => fetch(url).then(res => res.json());

export const ready = async () => new Promise(resolve => {
    const { readyState } = document;

    if (readyState !== "loading") {
        resolve();
    } else {
        document.addEventListener("DOMContentLoaded", resolve, { once: true });
    }
});

export const isUndefined = (v) => typeof v === "undefined";
