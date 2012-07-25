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
Ext.define "Addressbook.proxy.LinkPersonProxy",
  extend: 'Addressbook.proxy.AbstractProxy'
  requires: [
    'Addressbook.config.AddressbookEventMap'
    'Addressbook.util.MessageBus',
    'Addressbook.config.AppConfig'
  ]
  mixins: [ 'Deft.mixin.Injectable']
  alias: 'proxy.linkPersonProxy'
  inject: [
    'messageBus'
    'appConfig'
  ]

  constructor: ( cfg ) ->

    me = this
    cfg = cfg or {}

    me.callParent( [ Ext.apply(
      filterParam: 'id'
      api:
        read: @appConfig.getEndpoint('linkPersonRequestRead').url
        update: @appConfig.getEndpoint('linkPersonRequestUpdate').url
      ,
      cfg ) ]
    )

  encodeFilters: (filters) ->
    filterString = []
    for filter in filters
      filterString.push(filter.value)
    filterString.join(',')


