Ext.Loader.setConfig( enabled: true)

Ext.application
  autoCreateViewport: false
  name: "Addressbook"
  requires: ['Addressbook.view.AddressbookViewport']
  launch: ->
    Ext.create('Addressbook.view.AddressbookViewport')


