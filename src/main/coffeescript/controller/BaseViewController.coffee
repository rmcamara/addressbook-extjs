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
###*
* Base ViewController. Includes template methods for configuring and removing application events.
###
Ext.define('Addressbook.controller.BaseViewController',
  extend: 'Deft.mvc.ViewController'
  requires: [ 'Addressbook.config.AddressbookEventMap']
  mixins: [ 'Deft.mixin.Injectable' ]
  inject: []

  config:
    eventMap: null


  init: ->
    @setEventMap(Addressbook.config.AddressbookEventMap)
    @getView()['parentViewController'] = @
    @callParent( arguments )


  destroy: ->
    delete @getView()['parentViewController']
    @callParent( arguments )
)