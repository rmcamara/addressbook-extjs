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
Ext.define( 'Addressbook.controller.PlaceListingViewController',
  extend: 'Addressbook.controller.AbstractListingViewController'
  requires: [ 'Addressbook.config.AddressbookEventMap',
              'Addressbook.controller.AbstractListingViewController',
              'Addressbook.util.MessageBus',
              'Ext.util.Filter']
  mixins: [ 'Deft.mixin.Injectable' ]
  inject: [ 'appConfig' ,'messageBus', 'placesStore']

  init: ->
    @setFilterFields(['name', 'address', 'address2', 'details', 'city', 'state', 'zipcode'])
    @setListingStore(@placesStore)
    @callParent( arguments )

  switchDisplayMode: (button) ->
    @getMessageBus().fireEvent(@getEventMap().SWITCH_DISPLAY_MODE, true)
    @callParent( arguments )
)