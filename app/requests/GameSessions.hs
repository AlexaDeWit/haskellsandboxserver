{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE TypeOperators #-}

module GameSessions
  ( SessionToken
  , SessionTokenApi
  , LoginRequest
  ) where

import Data.Time.Clock
import Data.Aeson.Types
import GHC.Generics
import Servant

type SessionTokenApi = "game_sessions" :>  ReqBody '[JSON] LoginRequest :> Post '[JSON] SessionToken

data SessionToken = SessionToken
  { tokenString :: String
  , expiration :: UTCTime

  } deriving (Eq, Show, Generic)

instance ToJSON SessionToken

data LoginRequest = LoginRequest
  { username :: String
  , password :: String
  } deriving (Eq, Show, Generic)
instance FromJSON LoginRequest
instance ToJSON LoginRequest
