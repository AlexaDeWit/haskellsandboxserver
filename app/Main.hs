module Main where


import Database.Persist.Postgresql (runSqlPool)
import Network.Wai.Handler.Warp    (run)
import System.Environment (lookupEnv)
import Servant
import Control.Monad.Except
import Safe (readMay)

--Local Libs
import API.V1
import DB.Config
import DB.Schema

main :: IO ()
main = do
  env  <- lookupSetting "ENV" Development
  port <- lookupSetting "PORT" 8080
  pool <- makePool env
  let cfg = Config { getPool = pool, getEnv = env }
      logger = setLogger env
  runSqlPool doMigrations pool
  run port $ logger $ apiV1App cfg


  -- | Looks up a setting in the environment, with a provided default, and
  -- 'read's that information into the inferred type.
lookupSetting :: Read a => String -> a -> IO a
lookupSetting env def = do
    maybeValue <- lookupEnv env
    case maybeValue of
        Nothing ->
            return def
        Just str ->
            maybe (handleFailedRead str) return (readMay str)
  where
    handleFailedRead str =
        error $ mconcat
            [ "Failed to read [["
            , str
            , "]] for environment variable "
            , env
            ]
