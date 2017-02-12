{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE TypeOperators #-}

module API.V1.Public.Users where

import Data.Aeson.Types
import Servant
import DB.Config
import DB.Schema
import DB.Queries.User
import GHC.Generics
import Database.Persist
import Database.Persist.Postgresql
import Control.Monad.IO.Class (liftIO)

type PublicUsersApi = ReqBody '[JSON] RegistrationRequest :> Post '[JSON] SessionToken

data RegistrationRequest = RegistrationRequest
  { email           :: String
  , username        :: String
  , password :: String
  } deriving (Eq, Show, Generic)
instance FromJSON RegistrationRequest
instance ToJSON RegistrationRequest

publicUserServer :: ServerT PublicUsersApi App
publicUserServer = registerUser
{-
registerUser :: RegistrationRequest -> App SessionToken
registerUser req = do
  userio <- makeUser (email req) (username req) (password req)
-}
