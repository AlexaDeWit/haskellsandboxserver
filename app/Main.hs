module Main where

import Servant
import Network.Wai
import Network.Wai.Handler.Warp
import Control.Monad.Except

--Local Libs
import Lib
import Requests.GameSessions

server :: Server SessionTokenApi
server = game_session
  where game_session :: LoginRequest -> Handler SessionToken
        game_session  req = liftIO $ tokenFromRequest req

gameSessionsAPI :: Proxy SessionTokenApi
gameSessionsAPI = Proxy

app1 :: Application
app1 = serve gameSessionsAPI server

main :: IO ()
main = run 8080 app1
