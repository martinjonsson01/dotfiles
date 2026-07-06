// Chrome exposes no incognito signal at the window-manager level, so mark
// incognito titles here and let the awatcher filters redact them. Requires
// "Allow in incognito".
if (chrome.extension.inIncognitoContext) {
  // The title getter strips surrounding whitespace, so an empty title marked
  // with " (Incognito)" reads back without the leading space; guard on the
  // trimmed form or the observer would append a second marker.
  const MARK = "(Incognito)";
  const mark = () => {
    if (!document.title.endsWith(MARK)) document.title += " " + MARK;
  };
  mark();
  // At document_start <head> is not parsed yet; watching the root marks the
  // title the moment the parser (or later page script) sets it, instead of
  // leaving it exposed until DOMContentLoaded.
  new MutationObserver(mark).observe(document.documentElement, {
    subtree: true,
    childList: true,
    characterData: true,
  });
}
