Ext.Loader.setConfig( enabled: true)

Ext.application
#  autoCreateViewport: false
  name: "addressbook"
  launch: ->
    Ext.create('Ext.container.Viewport',{
      layout: 'fit'
      items:
        title: 'Camara Family Address Book'
        html: 'Hello Ross'
    }
    )


