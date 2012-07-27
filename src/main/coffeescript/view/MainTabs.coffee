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
Ext.define 'Addressbook.view.MainTabs',
  extend: 'Ext.tab.Panel'
  alias: 'widget.addressbook-MainTabs'
  requires: [
    'Ext.tab.Panel'
    'Addressbook.controller.MainTabsViewController'
    'Addressbook.view.PlaceListingPanel'
    'Addressbook.view.PeopleListingPanel'
  ]
  mixins: [ 'Deft.mixin.Controllable', 'Deft.mixin.Injectable' ]
  controller:'Addressbook.controller.MainTabsViewController'

  plain: true
  maxWidth: 1000
  maxHeight: 700

  initComponent: ->
    me = this

    Ext.applyIf( me,
      items: [
        title:'Places'
        itemId:'placesTab'
        xtype: 'addressbook-PlaceListingPanel'
        bodyPadding:10
      ,
        title:'People'
        itemId:'peopleTab'
        xtype: 'addressbook-PeopleListingPanel'
        hidden: true
        bodyPadding:10
      ]
    )

    me.callParent( arguments )