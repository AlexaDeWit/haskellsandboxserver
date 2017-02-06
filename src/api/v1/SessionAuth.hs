{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE TypeOperators #-}

module API.V1.SessionAuth where


import Data.Time
import Data.Aeson.Types
import GHC.Generics
import Servant
import DB.Schema

--To-Do make it possible to authenticate a login
userAuthHandler :: AuthHandler Request User
userAuthHandler =
  let handler req = case lookup "session-token" (requestHeaders req) of
    Nothing -> throwError ( err401 { errBody = "Missing session token header" })
    Just authSessionToken -> lookupUser authSessionToken
  in mkAuthHandler handler
