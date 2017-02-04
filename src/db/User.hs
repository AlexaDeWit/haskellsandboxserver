{-# LANGUAGE GADTs                      #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE OverloadedStrings          #-}
{-# LANGUAGE QuasiQuotes                #-}
{-# LANGUAGE MultiParamTypeClasses      #-}
{-# LANGUAGE TemplateHaskell            #-}
{-# LANGUAGE TypeFamilies               #-}

module DB.User where

import Database.Persist
import Data.Time
import Data.Aeson (FromJSON, ToJSON)
import GHC.Generics (Generic)
import Database.Persist.TH
import Database.Persist.Postgresql
import Control.Monad.IO.Class (liftIO)
import Control.Monad.Reader

share [mkPersist sqlSettings, mkSave "entityDefs"] [persistLowerCase|
User
  email String
  UniqueEmail email
  username String
  UniqueUsername username
  passwordHash String
  deriving Show Generic
|]

instance ToJSON User
instance FromJSON User
