Ext.Loader.setConfig(
  enabled: true
  disableCaching: false
  paths:
    'Addressbook': 'app'
    'Ext.ux': 'libs/ext/src/ux'
)

Ext.onReady ->
  Deft.Injector.configure(
    appConfig:
      className: 'Addressbook.config.AppConfig'
      parameters: [ environment: 'PRODUCTION_ENV' ]
    messageBus: 'Addressbook.util.MessageBus'

    placesStore: 'Addressbook.store.PlacesStore'
    personStore: 'Addressbook.store.PersonStore'
  )

Ext.application
  autoCreateViewport: false
  name: "Addressbook"
  requires: [
    'Addressbook.view.AddressbookViewport'
    'Addressbook.util.MessageBus'
    'Addressbook.config.AppConfig'
  ]
  launch: ->
    Ext.create('Addressbook.view.AddressbookViewport')


