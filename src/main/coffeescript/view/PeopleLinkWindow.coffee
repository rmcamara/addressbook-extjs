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
Ext.define 'Addressbook.view.PeopleLinkWindow',
  extend: 'Ext.window.Window'
  alias: 'widget.addressbook-PeopleLinkWindow'
  requires: [
    'Ext.window.Window'
    'Ext.form.Panel'
    'Addressbook.controller.PeopleLinkViewController'
    'Ext.ux.CheckColumn'
  ]
  mixins: [
    'Deft.mixin.Controllable'
    'Deft.mixin.Injectable'
  ]
  controller:'Addressbook.controller.PeopleLinkViewController'

  title: 'Link people to a location'
  closable: true
  modal: true
  height: 450
  width: 500
  layout: 'fit'

  config:
    locationId: -1

  initComponent: ->
    me = this

    Ext.applyIf( me,
      items: [
        xtype: 'grid'
        itemId: 'linkGrid'
        store: Ext.create('Ext.data.JsonStore',
          autoLoad:false
          )
        columnLines: true
        frame: false
        columns: [
          header: 'Linked'
          xtype: 'checkcolumn'
          dataIndex: 'selected'
          width: 60
          editor:
            xtype: 'checkbox',
            cls: 'x-grid-checkheader-editor'
        ,
          header: 'First Name'
          width: 175
          dataIndex: 'firstname'
        ,
          header: 'Last Name'
          width: 175
          dataIndex: 'lastname'
        ]
      ]
      dockedItems:[
        xtype: 'toolbar'
        dock: 'bottom'
        items:[
          'Filter:'
        ,
          itemId: 'filterTxt'
          text: 'filter'
          xtype: 'textfield'
          flex: 2
          maxWidth: 300
          emptyText: "Enter filter keywords..."
        ,
          xtype:'tbspacer'
          flex: 1
        ,
          itemId: 'saveBtn'
          text: 'Save'
        ,
          itemId: 'cancelBtn'
          text: 'Cancel'
        ]
      ]
    )

    me.callParent( arguments )