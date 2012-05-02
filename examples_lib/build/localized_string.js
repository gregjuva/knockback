var LocalizedString;
LocalizedString = (function() {
  function LocalizedString(string_id) {
    this.string_id = string_id;
    this.string = kb.locale_manager.get(this.string_id);
  }
  return LocalizedString;
})();