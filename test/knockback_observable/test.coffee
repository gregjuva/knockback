$(document).ready( ->
  module("knockback_observable.js")
  test("TEST DEPENDENCY MISSING", ->
    ko.utils; _.VERSION; Backbone.VERSION
  )

  test("Standard use case: direct attributes with read and write", ->
    ContactViewModel = (model) ->
      @name = kb.observable(model, 'name')
      @number = kb.observable(model, {key:'number', write: true}, this)
      @

    model = new Contact({name: 'Ringo', number: '555-555-5556'})
    view_model = new ContactViewModel(model)

    # get
    equal(view_model.name(), 'Ringo', "Interesting name")
    equal(view_model.number(), '555-555-5556', "Not so interesting number")

    # set from the view model
    raises((->view_model.name('Paul')), null, "Cannot write a value to a dependentObservable unless you specify a 'write' option. If you wish to read the current value, don't pass any parameters.")
    equal(model.get('name'), 'Ringo', "Name not changed")
    equal(view_model.name(), 'Ringo', "Name not changed")
    view_model.number('9222-222-222')
    equal(model.get('number'), '9222-222-222', "Number was changed")
    equal(view_model.number(), '9222-222-222', "Number was changed")

    # set from the model
    model.set({name: 'Starr', number: 'XXX-XXX-XXXX'})
    equal(view_model.name(), 'Starr', "Name changed")
    equal(view_model.number(), 'XXX-XXX-XXXX', "Number was changed")

    # and cleanup after yourself when you are done.
    kb.vmRelease(view_model)
  )

  test("Standard use case: direct attributes with custom read and write", ->
    ContactViewModelCustom = (model) ->
      @name = kb.observable(model, {key:'name', read: -> return "First: #{model.get('name')}" })
      @number = kb.observable(model, {
        key:'number'
        read: -> return "#: #{model.get('number')}"
        write: (value) -> model.set({number: value.substring(3)})
      }, this)
      @

    model = new Contact({name: 'Ringo', number: '555-555-5556'})
    view_model = new ContactViewModelCustom(model)

    # get
    equal(view_model.name(), 'First: Ringo', "Interesting name")
    equal(view_model.number(), '#: 555-555-5556', "Not so interesting number")

    # set from the view model
    raises((->view_model.name('Paul')), null, "Cannot write a value to a dependentObservable unless you specify a 'write' option. If you wish to read the current value, don't pass any parameters.")
    equal(model.get('name'), 'Ringo', "Name not changed")
    equal(view_model.name(), 'First: Ringo', "Name not changed")
    view_model.number('#: 9222-222-222')
    equal(model.get('number'), '9222-222-222', "Number was changed")
    equal(view_model.number(), '#: 9222-222-222', "Number was changed")

    # set from the model
    model.set({name: 'Starr', number: 'XXX-XXX-XXXX'})
    equal(view_model.name(), 'First: Starr', "Name changed")
    equal(view_model.number(), '#: XXX-XXX-XXXX', "Number was changed")

    # and cleanup after yourself when you are done.
    kb.vmRelease(view_model)
  )

  test("Read args", ->
    args = []
    ContactViewModelCustom = (model) ->
      @name = kb.observable(model, {key:'name', read: ((key, arg1, arg2) -> args.push(arg1); args.push(arg2); return model.get('name')), args: ['name', 1] })
      @number = kb.observable(model, {key:'name', read: ((key, arg) -> args.push(arg); return model.get('number')), args: 'number' })
      @

    model = new Contact({name: 'Ringo', number: '555-555-5556'})
    view_model = new ContactViewModelCustom(model)
    ok(_.isEqual(args, ['name', 1, 'number']), "got the args")
  )

  test("Standard use case: ko.computed", ->
    ContactViewModel = (model) ->
      @name = kb.observable(model, {key: 'name', write: true})
      @formatted_name = ko.dependentObservable({
        read: @name,
        write: ((value) -> @name($.trim(value))),
        owner: @
      })
      @           # must return this or Coffeescript will return the last statement which is not what we want!

    model = new Contact({name: 'Ringo'})
    view_model = new ContactViewModel(model)

    # get
    equal(view_model.name(), 'Ringo', "Interesting name")
    equal(view_model.formatted_name(), 'Ringo', "Interesting name")

    # set from the model
    view_model.formatted_name(' John ')
    equal(view_model.name(), 'John', "Name changed")
    equal(view_model.formatted_name(), 'John', "Name changed")

    # and cleanup after yourself when you are done.
    kb.vmRelease(view_model)
  )

  test("Error cases", ->
    # TODO
  )
)