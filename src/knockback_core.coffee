###
  knockback.js 0.14.2
  (c) 2011 Kevin Malakoff.
  Knockback.js is freely distributable under the MIT license.
  See the following for full license details:
    https://github.com/kmalakoff/knockback/blob/master/LICENSE
  Dependencies: Knockout.js, Backbone.js, and Underscore.js.
    Optional dependency: Backbone.ModelRef.js.
###

# export or create Knockback namespace and kb alias
if typeof(exports) != 'undefined' then (Knockback = kb = exports) else (@Knockback = @kb = {})

# Current version.
Knockback.VERSION = '0.14.2'

# import Underscore, Backbone, and Knockout
_ = if not @_ and (typeof(require) != 'undefined') then require('underscore') else @_
Backbone = if not @Backbone and (typeof(require) != 'undefined') then require('backbone') else @Backbone
ko = if not @ko and (typeof(require) != 'undefined') then require('knockout') else @ko

# Locale Manager - if you are using localization, set this property.
# It must have Backbone.Events mixed in and implement a get method like Backbone.Model, eg. get: (attribute_name) -> return somthing
Knockback.locale_manager

# helpers
Knockback.wrappedObservable = (instance) ->
  throw new Error('Knockback: _kb_observable missing from your instance') if not instance._kb_observable
  return instance._kb_observable

Knockback.setToDefault = (observable) -> observable.setToDefault() if observable and observable.setToDefault
Knockback.vmSetToDefault = (view_model) -> kb.setToDefault(observable) for key, observable of view_model

Knockback.vmRelease = (view_model) ->
  (view_model.release(); return) if (view_model instanceof kb.ViewModel_RCBase)
  Knockback.vmReleaseObservables(view_model)

Knockback.vmReleaseObservables = (view_model, keys) ->
  for key, value of view_model
    continue if not value
    continue if not (ko.isObservable(value) or (value instanceof kb.Observables) or (value instanceof kb.ViewModel_RCBase))
    continue if keys and (keys.indexOf(key) == -1) # skip
    view_model[key] = null
    kb.vmReleaseObservable(value)

Knockback.vmReleaseObservable = (observable) ->
  return if not (ko.isObservable(observable) or (observable instanceof kb.Observables) or (observable instanceof kb.ViewModel_RCBase))
  if observable.destroy
    observable.destroy()
  else if observable.dispose
    observable.dispose()
  else if observable.release
    observable.release()
