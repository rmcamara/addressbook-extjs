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

Ext.define('Addressbook.model.Person',
  extend: 'Addressbook.model.BaseModel'
  requires: [
    'Addressbook.model.BaseModel'
    'Addressbook.proxy.PersonProxy'
    'Ext.Date'
  ]

  fields: [
    name: 'firstname'
    type: 'string'
    defaultValue: null
  ,
    name: 'lastname'
    type: 'string'
  ,
    name: 'title'
    type: 'string'
  ,
    name: 'birth'
    type: 'date'
    dateFormat: 'Y-m-d H:i:s'
    defaultValue: undefined
  ,
    name: 'email'
    type: 'string'
  ,
    name: 'cell'
    type: 'string'
  ]

  hasMany: [
    name: 'places'
    model: 'Addressbook.model.Place'
    foreignKey: 'parent_id'
    associationKey: 'places'
  ]

  proxy:
    type: 'personProxy'

  toHtmlString: () ->
    currentDetails = @get('title') + ' '
    currentDetails += @get('firstname') + ' '
    currentDetails += @get('lastname') + ' '
    currentDetails += @get('email') + '\n'
    currentDetails += @get('cell') + '\n'
    currentDetails += @get('birth') + '\n'
)