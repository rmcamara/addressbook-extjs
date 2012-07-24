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
Ext.define 'Addressbook.proxy.AbstractProxy',
  extend: 'Ext.data.proxy.Ajax'
  requires: [
    'Addressbook.config.AddressbookEventMap'
    'Ext.data.proxy.Ajax'
  ]

  config:
    eventMap: null

  constructor: ( cfg ) ->
    @setEventMap( Addressbook.config.AddressbookEventMap )

    me = this
    cfg = cfg or {}

    me.callParent( [ Ext.merge(
      headers:
        Accept: 'application/json'
        'Content-Type': 'application/json'
      startParam: undefined
      limitParam: undefined
      pageParam: undefined
      writer:
        type: 'json'
        root: 'data'
      reader:
        type: 'json'
        root: 'data'

      listeners:
        exception: ( proxy, response, operation, eopts ) =>
          try
            errorData = Ext.decode( response.responseText )
          catch error
            errorData = null

          operation.setException( errorData )
          @onProxyException( proxy, response, operation, eopts )
      ,
      cfg ) ]
    )

  onProxyException: ( proxy, response, operation, eopts ) ->
    Ext.log( {msg: 'Proxy exception:', dump: response, level: 'log'} )
