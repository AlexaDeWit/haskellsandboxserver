{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE TypeOperators #-}


module API.V1.Resources.SessionToken
  ( SessionToken
  , SessionTokenApi
  , LoginRequest
  , tokenServer
  ) where

import Data.Time
import Data.Aeson.Types
import GHC.Generics
import Database.Persist.Postgresql (Entity (..), fromSqlKey, insert,
       selectFirst, selectList, (==.))
import Servant
import DB.Config
import DB.Schema
import Control.Monad.Except

type SessionTokenApi = ReqBody '[JSON] LoginRequest :> Post '[JSON] SessionToken

data LoginRequest = LoginRequest
  { username :: String
  , password :: String
  } deriving (Eq, Show, Generic)
instance FromJSON LoginRequest
instance ToJSON LoginRequest

tokenFromRequest :: LoginRequest -> App SessionToken
tokenFromRequest req = do
  time <- liftIO getCurrentTime
  let token = "Fucky"
  return $ SessionToken token time

tokenServer :: ServerT SessionTokenApi App
tokenServer = tokenFromRequest
