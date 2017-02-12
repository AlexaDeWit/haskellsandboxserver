{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

module DB.Queries.SessionToken where

import Database.Persist
import Database.Persist.Postgresql
import Data.Time
import DB.Schema
import DB.Config
import Control.Monad.Reader        (ReaderT, runReaderT)
import Control.Monad.Reader.Class
import Control.Monad.IO.Class (liftIO)
import Data.Validation
import DB.Queries.User
import qualified Data.ByteString.Char8

newSessionToken :: Key User -> App (Key SessionToken)
newSessionToken user = do
  time <- liftIO getCurrentTime
  let token = "Fucky"
  return $ runDb $ insert $ SessionToken user token time
