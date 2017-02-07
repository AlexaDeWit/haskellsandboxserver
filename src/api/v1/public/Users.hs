{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE TypeOperators #-}

module API.V1.Public.User where

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

registerUser :: RegistrationRequest -> App User
registerUser req = do
  validateForm
  where
    validateForm = do
      f (email req == confirmEmail req) "Email fields do not match"
      f (password req == confirmPass rew) "Password fields do not match"
      f (length (password req) > 12) "Password must be longer than 12 characters"
    f True  _ = return ()
    f False e = throwError $ err400 { errBody = e }
  let emailAvailable = do
    maybeTakenUser <- runDb (getBy $ UniqueEmail email req)
    case maybeTakenUser of
      Nothing -> return true
      Just user -> return False
  let usernameAvailable = do
    maybeTakenUser <- runDb (getBy $ UniqueUsername username req)
    case maybeTakenUser of
      Nothing -> return true
      Just user -> return False
