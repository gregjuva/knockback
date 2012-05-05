// Generated by CoffeeScript 1.3.1
var LocalizedStringLocalizer, LongDateLocalizer, ShortDateLocalizer,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

LocalizedStringLocalizer = (function(_super) {

  __extends(LocalizedStringLocalizer, _super);

  LocalizedStringLocalizer.name = 'LocalizedStringLocalizer';

  function LocalizedStringLocalizer(value, options, view_model) {
    LocalizedStringLocalizer.__super__.constructor.apply(this, arguments);
    return kb.wrappedObservable(this);
  }

  LocalizedStringLocalizer.prototype.read = function(value) {
    if (value.string_id) {
      return kb.locale_manager.get(value.string_id);
    } else {
      return '';
    }
  };

  return LocalizedStringLocalizer;

})(kb.LocalizedObservable);

LongDateLocalizer = (function(_super) {

  __extends(LongDateLocalizer, _super);

  LongDateLocalizer.name = 'LongDateLocalizer';

  function LongDateLocalizer(value, options, view_model) {
    LongDateLocalizer.__super__.constructor.apply(this, arguments);
    return kb.wrappedObservable(this);
  }

  LongDateLocalizer.prototype.read = function(value) {
    return Globalize.format(value, 'dd MMMM yyyy', kb.locale_manager.getLocale());
  };

  LongDateLocalizer.prototype.write = function(localized_string, value, observable) {
    var new_value;
    new_value = Globalize.parseDate(localized_string, 'dd MMMM yyyy', kb.locale_manager.getLocale());
    if (!(new_value && _.isDate(new_value))) {
      return observable.resetToCurrent();
    }
    return value.setTime(new_value.valueOf());
  };

  return LongDateLocalizer;

})(kb.LocalizedObservable);

ShortDateLocalizer = (function(_super) {

  __extends(ShortDateLocalizer, _super);

  ShortDateLocalizer.name = 'ShortDateLocalizer';

  function ShortDateLocalizer(value, options, view_model) {
    var _this = this;
    if (options == null) {
      options = {};
    }
    ShortDateLocalizer.__super__.constructor.call(this, value, _.extend(options, {
      read: function(value) {
        return Globalize.format(value, Globalize.cultures[kb.locale_manager.getLocale()].calendars.standard.patterns.d, kb.locale_manager.getLocale());
      },
      write: function(localized_string, value, observable) {
        var new_value;
        new_value = Globalize.parseDate(localized_string, Globalize.cultures[kb.locale_manager.getLocale()].calendars.standard.patterns.d, kb.locale_manager.getLocale());
        if (!(new_value && _.isDate(new_value))) {
          return observable.resetToCurrent();
        }
        return value.setTime(new_value.valueOf());
      }
    }), view_model);
    return kb.wrappedObservable(this);
  }

  return ShortDateLocalizer;

})(kb.LocalizedObservable);
