Ext.Loader.setConfig( enabled: true, disableCaching: false)

Ext.application
  autoCreateViewport: false
  name: "Addressbook"
  requires: ['Addressbook.view.AddressbookViewport']
  launch: ->
    Ext.create('Addressbook.model.Place')
    Ext.create('Addressbook.view.AddressbookViewport')


Ext.onReady ->
  Deft.Injector.configure(
    appConfig:
      className: "Addressbook.config.AppConfig"
      parameters: [ environment: "PRODUCTION_ENV" ]
    messageBus: "Addressbook.util.MessageBus"
    placesStore: 'Addressbook.store.PlacesStore'
  )