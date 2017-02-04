{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE TypeOperators #-}
---
module Requests.GameSessions
  ( SessionToken
  , SessionTokenApi
  , LoginRequest
  , tokenFromRequest
  ) where

import Data.Time
import Data.Aeson.Types
import GHC.Generics
import Servant
import DB.SessionToken

type SessionTokenApi = "game_sessions" :>  ReqBody '[JSON] LoginRequest :> Post '[JSON] SessionToken

data LoginRequest = LoginRequest
  { username :: String
  , password :: String
  } deriving (Eq, Show, Generic)
instance FromJSON LoginRequest
instance ToJSON LoginRequest

tokenFromRequest :: LoginRequest -> IO SessionToken
tokenFromRequest req = do
  time <- getCurrentTime
  let token = "Fucky"
  return $ SessionToken token time
