{-# LANGUAGE GADTs                      #-}
{-# LANGUAGE DeriveGeneric              #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE OverloadedStrings          #-}
{-# LANGUAGE QuasiQuotes                #-}
{-# LANGUAGE MultiParamTypeClasses      #-}
{-# LANGUAGE TemplateHaskell            #-}
{-# LANGUAGE TypeFamilies               #-}
{-# LANGUAGE FlexibleInstances          #-}

module DB.Schema where

import Database.Persist
import Data.Time
import Data.Aeson (FromJSON, ToJSON)
import GHC.Generics (Generic)
import Database.Persist.TH
import Database.Persist.Postgresql
import Control.Monad.IO.Class (liftIO)
import Control.Monad.Reader

share [mkPersist sqlSettings, mkMigrate "migrateAll"] [persistLowerCase|
User json
  email String
  UniqueEmail email
  username String
  UniqueUsername username
  passwordHash String
  deriving Show Generic

SessionToken json
  token String
  UniqueToken token
  expiration UTCTime
  deriving Show Generic
|]
