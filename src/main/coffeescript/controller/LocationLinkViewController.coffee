#    
#    Copyright 2012 Ross Camara
#
#    This file is part of Addressbook.
#
#    Addressbook is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    AddressBook is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with addressbook.  If not, see <http://www.gnu.org/licenses/>.
#
Ext.define( 'Addressbook.controller.LocationLinkViewController',
  extend: 'Addressbook.controller.BaseViewController'
  requires: [
    'Addressbook.config.AddressbookEventMap'
    'Addressbook.controller.BaseViewController'
    'Addressbook.util.MessageBus'
    'Addressbook.model.LinkLocation'
  ]
  mixins: [ 'Deft.mixin.Injectable' ]
  inject: [ 'appConfig' ,'messageBus']

  control:
    saveBtn:
      click: 'onSave'
    cancelBtn:
      click: 'onCancel'
    linkGrid: true

  config:
    view: null
    messageBus: null
    store: null


  init: ->
    store = Ext.create('Ext.data.Store',
      model: 'Addressbook.model.LinkLocation'
      remoteFilter: true
      filters: [
        property: 'id'
        value: @getView().getLocationId()
      ]
      sorters: [
        property: 'selected'
        direction: 'DESC'
      ,
        property: 'name'
        direction: 'ASC'
      ]
    )
    store.load()
    @setStore(store)

    @getLinkGrid().reconfigure(store)
    @callParent( arguments )

  onCancel: ->
    @getView().hide(null, =>
      @getView().destroy()
    )

  onSave: ->
    store = @getStore()
    if store.getUpdatedRecords()?.length?
      @getView().setLoading('Saving...')
      store.sync(
        callback: =>
          @getView().setLoading(false)
        success: =>
          @onCancel()
      )
)