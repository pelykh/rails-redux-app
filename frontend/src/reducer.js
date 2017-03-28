import { combineReducers } from 'redux'
import { Map } from 'immutable'
import currentUser from './reducers/currentUser'
import errors from './reducers/errors'
import user from './reducers/user'
import pages from './reducers/pages'
import usersList from './reducers/usersList'
import postsList from './reducers/postsList'

const appReducer = combineReducers({
  currentUser,
  user,
  pages,
  errors,
  usersList,
  postsList
})

const reducer = (state = {}, action) => {
  if (action.type === 'LOGOUT') {
    return {}
  }
  return appReducer(state, action)
}

export default reducer
