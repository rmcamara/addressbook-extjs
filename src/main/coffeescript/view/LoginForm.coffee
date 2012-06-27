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
Ext.define 'Addressbook.view.LoginForm',
  extend: 'Ext.form.Panel'
  alias: "widget.addressbook-LoginForm"
  requires: [ 'Ext.form.Panel']
  title: 'Login:'
  bodyPadding: 15
  autoScroll: true

  layout: 'anchor'
  defaults:
    anchor: '100%'


  initComponent: ->
    me = this
    required = '<span class="ux-required-field" data-qtip="Required">*</span>'
    Ext.applyIf( me,
      fieldDefaults:
        msgTarget: 'side'
        labelWidth: 175
        labelAlign: 'right'
      items: [
        xtype: 'textfield'
        name: 'username'
        fieldLabel: 'User Id'
        allowBlank: false
        afterLabelTextTpl: required
        maxLength: 40
        enforceMaxLength: true
        width: 400
        grow: true
        growMin: 400
      ,
        xtype: 'textfield'
        name: 'password'
        inputType: 'password'
        fieldLabel: 'Password'
        allowBlank: false
        afterLabelTextTpl: required
        maxLength: 40
        enforceMaxLength: true
        width: 400
        grow: true
        growMin: 400
      ]
      buttons: [
        text: 'Reset'
        handler: ->
          me.up('form').getForm().reset();
      ,
        text: 'Submit'
        formBind: true
        disabled: true
      ]
    )

    me.callParent( arguments )