{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

module DB.Queries.User where

import Database.Persist
import Database.Persist.Postgresql
import DB.Schema
import DB.Config
import Crypto.BCrypt
import Control.Monad.Reader        (ReaderT, runReaderT)
import Control.Monad.Reader.Class
import Control.Monad.IO.Class (liftIO)
import Data.Validation
import qualified Data.ByteString.Char8

makeUser :: String -> String -> String -> App (Key User)
makeUser email username rawPass = do
  let pack = Data.ByteString.Char8.pack
  p <- liftIO $ hashPasswordUsingPolicy slowerBcryptHashingPolicy (pack rawPass)
  let password = ask p
  runDb $ insert $ User email username (show password)

newtype Username = Username { unUsername :: String} deriving Show
newtype Password = Password { unPassword :: String} deriving Show
newtype Email = Email { unEmail :: String} deriving Show

data UserValidationError = EmailAvailable
                         | UsernameAvailable
                         | ValidEmailFormat
                         | PasswordFormat
                         deriving Show

--mkUsername :: String -> AccValidation [UserValidationError] Username
