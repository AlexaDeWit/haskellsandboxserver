{- Most of Main.hs is from https://github.com/parsonsmatt/servant-persistent
Copyright (c) 2015 Matt Parsons

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.-}
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
