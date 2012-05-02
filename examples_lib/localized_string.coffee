class LocalizedString
  constructor: (@string_id) ->
    @string = kb.locale_manager.get(@string_id)
