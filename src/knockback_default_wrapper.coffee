###
  knockback_default_wrapper.js
  (c) 2011 Kevin Malakoff.
  Knockback.DefaultWrapper is freely distributable under the MIT license.
  See the following for full license details:
    https://github.com/kmalakoff/knockback/blob/master/LICENSE
###

######################################
# Knockback.defaultWrapper to provide a default value when an observable is null, undefined, or the empty string
# Provide a observable with observable and/or non observable default argument in the form of:
#   kb.defaultWrapper(some_observable, "blue")
######################################
class Knockback.DefaultWrapper
  constructor: (observable, @default_value) ->
    _.bindAll(this, 'destroy', 'setToDefault')

    @_kb_observable = ko.dependentObservable({
      read: =>
        value = ko.utils.unwrapObservable(observable())
        return if not value then ko.utils.unwrapObservable(@default_value) else value
      write: (value) -> observable(value)
      owner: {}
    })

    # publish public interface on the observable and return instead of this
    @_kb_observable.destroy = @destroy
    @_kb_observable.setToDefault = @setToDefault

    return kb.wrappedObservable(this)

  destroy: ->
    @_kb_observable = null
    @default_value = null

  setToDefault: -> @_kb_observable(@default_value)

Knockback.defaultWrapper = (observable, default_value) -> return new Knockback.DefaultWrapper(observable, default_value)
