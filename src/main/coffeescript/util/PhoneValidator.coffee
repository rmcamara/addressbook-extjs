Ext.namespace('Addressbook.util');
Ext.require('Ext.form.field.VTypes')
phoneRegEx = /^([\(]{1}[0-9]{3}[\)]{1}[\.| |\-]{0,1}|^[0-9]{3}[\.|\-| ]?)?[0-9]{3}(\.|\-| )?[0-9]{4}$/i
Ext.apply(Ext.form.field.VTypes,

  phone: (value, field) ->
    phoneRegEx.test(value)

  phoneText: 'Not a valid telephone number. Must be in the format (123) 456-7890'
)

Ext.define 'Addressbook.util.PhoneValidator',
  noop: true
