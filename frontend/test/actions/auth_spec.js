import configureMockStore from 'redux-mock-store'
import thunk from 'redux-thunk'
import * as actions from '../../src/actions/auth'
import nock from 'nock'
import { expect } from 'chai'
import chai from 'chai';
import axios from 'axios'
import httpAdapter from 'axios/lib/adapters/http'

const host = 'http://localhost';

axios.defaults.host = host;
axios.defaults.adapter = httpAdapter;

describe('async auth actions', () => {

  const middlewares = [ thunk ]
  const mockStore = configureMockStore(middlewares)

  afterEach(() => {
    nock.cleanAll()
  })

  it('creates LOGIN_SUCCESS and save token in browser when logining has been done', () => {
    var response = { user: { name: "Naruto", id: "1", token: "token" }}
    var loginPayload = { user: { email: "email@gmail.com", password: "password" }}
    nock(host)
      .post('/sessions')
      .reply(200, response)

    const expectedActions = [
      actions.login(),
      actions.loginSuccess(response.user)
    ]
    const store = mockStore()

    store.dispatch(actions.logIn(loginPayload)).then(() => {
      expect(store.getActions()).to.include(expectedActions[0]);
      expect(store.getActions()).to.include(expectedActions[1]);
      expect(localStorage.getItem('token')).to.be.equal('token');
    })
  });

  it('creates LOGIN_FAILURE when get 403 response', () => {
    var response = { errors: {'login-form': 'error'}}
    var loginPayload = { user: { email: "email", password: "pass" }}
    nock(host)
      .post('/sessions')
      .reply(403, response)

    const expectedActions = [
      actions.login(),
      actions.loginFailure(response.errors)
    ]
    const store = mockStore()

    store.dispatch(actions.logIn(loginPayload)).then(() => {
      expect(store.getActions()).to.include(expectedActions[0]);
      expect(store.getActions()).to.include(expectedActions[1]);
    })
  });
});
