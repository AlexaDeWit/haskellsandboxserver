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

--Needs to fetch real login info from ENV later
connectionString ="host=localhost user=postgres dbname=catsandbox password=scalasandboxserver port=5432"

main :: IO ()
main =  runStderrLoggingT $ withPostgresqlPool connectionString 10 $ \pool ->
  liftIO $
    flip runSqlPersistMPool pool $ do
      runMigration migrateAll
      liftIO $ print "Migrate Complete"
