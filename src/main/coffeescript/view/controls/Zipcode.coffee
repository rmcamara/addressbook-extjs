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
Ext.define 'Addressbook.view.controls.Zipcode',
  extend: 'Ext.form.field.Text'
  alias: 'widget.zipcode'
  requires: [ 'Ext.form.field.Text',
              'Addressbook.util.ZipcodeValidator']

  initComponent: ->
    me = this

    Ext.merge( me,
      fieldLabel: 'Zip Code'
      vtype: 'zipcode'
    )

    me.callParent( arguments )

  valueToRaw: (value) ->
    if !value
      return @callParent( value )
    else
      return Ext.util.Format.leftPad(value, 5, '0')