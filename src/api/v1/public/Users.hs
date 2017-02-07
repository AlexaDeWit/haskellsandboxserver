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

type PublicUsersApi = ReqBody '[JSON] RegistrationRequest :> Post '[JSON] User

data RegistrationRequest = RegistrationRequest
  { email           :: String
  , confirmEmail    :: String
  , username        :: String
  , password        :: String
  , confirmPassword :: String
  } deriving (Eq, Show, Generic)
instance FromJSON RegistrationRequest
instance ToJSON RegistrationRequest

{-
registerUser :: RegistrationRequest -> App (Maybe User)
registerUser req = do
  let validPassword =
-}
