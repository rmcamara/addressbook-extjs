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
Ext.define 'Addressbook.view.controls.Telephone',
  extend: 'Ext.form.field.Text'
  alias: 'widget.telephone'
  requires: [ 'Ext.form.field.Text',
              'Addressbook.util.PhoneValidator']

  initComponent: ->
    me = this

    Ext.merge( me,
      vtype: 'phone'
    )

    me.callParent( arguments )

  valueToRaw: (value) ->
    if !value or value == 0
      return @callParent( value )

    # Hacked to work arround existing data with garbage values (remove "()- ")
    string = value.replace(/[ \-\(\)]/gi, '')

    arr = string.split('')
    if arr.length == 7
      prefix = arr.splice(0, 3)
      return first_part.join() + '-' + arr.join('')
    if arr.length == 10
      areacode = arr.splice(0,3)
      prefix = arr.splice(0, 3)
      return '(' + areacode.join('') + ') '+ prefix.join('') + '-' + arr.join('')
    return string

  rawToValue: (value) ->
    value.replace(/[ \-\(\)]/gi, '')