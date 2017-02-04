module Main where

import Servant
import Network.Wai
import Network.Wai.Handler.Warp
import Control.Monad.Except

--Local Libs
import API.V1

app1 :: Application
app1 = serve v1ServerAPI v1Server

main :: IO ()
main = run 8080 app1
