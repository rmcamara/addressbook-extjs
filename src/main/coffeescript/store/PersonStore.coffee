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
Ext.define "Addressbook.store.PersonStore",
  extend: 'Addressbook.store.AbstractStore'
  requires: [ 'Addressbook.config.AddressbookEventMap',
              'Addressbook.model.Person',
              'Addressbook.util.MessageBus',
              'Addressbook.config.AppConfig']
  mixins: [ 'Deft.mixin.Injectable',
            'Addressbook.util.Filterable']
  inject: ['messageBus', 'appConfig']
  alias: 'Person'

  constructor: ( cfg ) ->

    me = this
    cfg = cfg or {}

    me.callParent( [ Ext.apply(
      model: 'Addressbook.model.Person'
      autoLoad: true
      autoSync: false
      proxy:
        api:
          read: @appConfig.getEndpoint('personRequestRead').url
          create: @appConfig.getEndpoint('personRequestCreate').url
          update: @appConfig.getEndpoint('personRequestUpdate').url
          destroy: @appConfig.getEndpoint('personRequestDestroy').url
        writer:
          root: 'data'
        reader:
          root: 'data'
        startParam: undefined
        limitParam: undefined
        pageParam: undefined

      listeners:
        load: (store, records, successful, eOpts) ->
          @onLoad(store, records, successful, eOpts)
      ,
      cfg ) ]
    )

  onLoad: (store, records, successful, eOpts) ->
    if Ext.isDefined(Ext.global.console)
      Ext.global.console.log('Records loaded: ' + records.length)


