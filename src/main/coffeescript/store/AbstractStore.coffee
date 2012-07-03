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
Ext.define "Addressbook.store.AbstractStore",
  extend: "Ext.data.JsonStore"
  requires: [ 'Addressbook.config.AddressbookEventMap',
              'Ext.data.JsonStore']

  config:
    eventMap: null

  constructor: ( cfg ) ->
    @setEventMap( Addressbook.config.AddressbookEventMap )

    me = this
    cfg = cfg or {}

    me.callParent( [ Ext.merge(

      listeners:
        beforeload: ( store, operation, options ) =>
          @onBeforeLoad( store, operation, options )

        beforesync: ( options, eopts ) =>
          @onBeforeSync( options, eopts )

      proxy:
        type: 'ajax'
        headers:
          Accept: "application/json"
          "Content-Type": "application/json"

        reader:
          type: 'json'
          root: 'root'

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


  onBeforeLoad: ( store, operation, options ) ->
#    store.getProxy().headers.WidgetTokenId = @csrfSetupProxy.getAuthToken()
    true


  onBeforeSync: ( options, eopts ) ->
#    @getProxy().headers.WidgetTokenId = @csrfSetupProxy.getAuthToken()
    true


  onProxyException: ( proxy, response, operation, eopts ) ->
    Ext.log( {msg: "Proxy exception:", dump: response, level: 'log'} )
