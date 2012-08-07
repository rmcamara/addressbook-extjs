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
    if @get('email')
      currentDetails += '\n' + @get('email')
    if @get('cell')
      currentDetails += '\n' + @getFormattedPhone(@get('cell'))
    if @get('birth')
      currentDetails += '\n' + Ext.util.Format.date(@get('birth'), 'n/d/Y')
    return currentDetails

  toLinkedHtmlString: () ->
    currentDetails = @get('title') + ' '
    currentDetails += @get('firstname') + ' '
    currentDetails += @get('lastname') + ' '
    if @get('email')
      currentDetails += '\n<a href="mailto:' +@get('email') + '" >' + @get('email') + '</a>'
    if @get('cell')
      currentDetails += '\n<a href="tel:' +@get('cell') + '" >' + @getFormattedPhone(@get('cell')) + '</a>'
    if @get('birth')
      currentDetails += '\n' + Ext.util.Format.date(@get('birth'), 'F d, Y')
    return currentDetails

  getFormattedPhone: (value) ->
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
)