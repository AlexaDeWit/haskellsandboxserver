{-# LANGUAGE FlexibleContexts           #-}
{-# LANGUAGE GADTs                      #-}
{-# LANGUAGE MultiParamTypeClasses      #-}
{-# LANGUAGE OverloadedStrings          #-}
{-# LANGUAGE TypeFamilies               #-}

module Main where

import Control.Monad.IO.Class  (liftIO)
import Control.Monad.Logger    (runStderrLoggingT)
import Database.Persist
import Database.Persist.Postgresql
import Database.Persist.TH
import DB.Schema

connectionString ="host=localhost user=postgres dbname=catsandbox password=scalasandboxserver port=5432"

main :: IO ()
main =  runStderrLoggingT $ withPostgresqlPool connectionString 10 $ \pool ->
  liftIO $
    flip runSqlPersistMPool pool $ do
      runMigration migrateAll
      --testAccountId <- insert $ User "alexa.dewit@gmail.com" "cattest" "notanactualhas"
      liftIO $ print "Migrate Complete"
