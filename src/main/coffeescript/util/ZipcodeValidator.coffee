Ext.namespace('Addressbook.util');
Ext.require('Ext.form.field.VTypes')
zipRegEx = /(^\d{5}$)|(^\d{5}-\d{4}$)/i
Ext.apply(Ext.form.field.VTypes,

  zipcode: (value, field) ->
    zipRegEx.test(value)

  zipcodeText: 'Not a valid zipcode. Must be in the format XXXXX-XXXX'
)

Ext.define 'Addressbook.util.ZipcodeValidator',
  noop: true
