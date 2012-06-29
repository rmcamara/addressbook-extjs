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
Ext.define( 'Addressbook.controller.LoginViewController',
  extend: 'Addressbook.controller.BaseViewController'
  requires: [ 'Addressbook.config.AddressbookEventMap', 'Addressbook.controller.BaseViewController', 'Addressbook.util.MessageBus' ]
  mixins: [ 'Deft.mixin.Injectable' ]
  inject: [ 'appConfig' ,'messageBus']

  control:
    submitButton:
      click: 'onFormSubmit'
    resetButton:
      click: 'resetForm'
    loginForm: true

  config:
    view: null
    messageBus: null

  resetForm: ->
    @getLoginForm().getForm().reset()

  init: ->
    @resetForm()
    @callParent( arguments )

  onFormSubmit: ( button ) ->
    basicForm = @getLoginForm().getForm()

    if( basicForm.isValid() )
      @getView().setLoading( 'Validating Credentials' )
      basicForm.submit(
        url: @appConfig.getEndpoint( 'authentication').url
        success: (form, action) =>
          @getView().setLoading( false )
          values = basicForm.getFieldValues();
          @appConfig.setUsername(values['username'])
          @appConfig.setPassword(values['password'])
          @getMessageBus().fireEvent(@getEventMap().LOGIN_SUCCESS)
          @getView().hide(null, =>
            @getView().destroy()
          )

        failure: (form, action) =>
          @getView().setLoading( false )
          Ext.Msg.alert('Authentication Failed')
      )
)