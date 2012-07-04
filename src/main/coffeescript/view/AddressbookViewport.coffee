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
Ext.define 'Addressbook.view.AddressbookViewport',
  extend: 'Ext.container.Viewport'
  requires: [ 'Addressbook.view.LoginWindow',
              'Addressbook.config.AddressbookEventMap',
              'Addressbook.util.MessageBus',
              'Addressbook.view.MainTabs']
  mixins: [ 'Deft.mixin.Controllable', 'Deft.mixin.Injectable' ]
  inject: [ 'messageBus' ]
  renderTo: Ext.getBody()
  config:
    me: null
    eventMap: null

  padding: 10
  layout:
    type: 'fit'

  initComponent: ->
    me = this
    @setEventMap(Addressbook.config.AddressbookEventMap)
    if me
      Ext.create('widget.addressbook-LoginWindow').show()

    @messageBus.addListener(@getEventMap().LOGIN_SUCCESS, @renderMainUI, me)

    me.callParent( arguments )

  renderMainUI: ->
    main = Ext.create('widget.addressbook-MainTabs');
    this.add(main)