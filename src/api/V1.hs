{-# LANGUAGE DataKinds                  #-}
{-# LANGUAGE TypeOperators              #-}

module API.V1
  ( APIV1
  , v1ServerAPI
  , apiV1App
  ) where


import Control.Monad.Except
import Control.Monad.Reader        (ReaderT, runReaderT)
import Control.Monad.Reader.Class
import Data.Int                    (Int64)
import Database.Persist.Postgresql (Entity (..), fromSqlKey, insert,
                                             selectFirst, selectList, (==.))
import Network.Wai                 (Application)
import Servant
import DB.Config (App (..), Config (..))
import GHC.Generics
import API.V1.Public.SessionToken

apiV1App :: Config -> Application
apiV1App cfg = serve v1ServerAPI (appToServer cfg)

appToServer :: Config -> Server SessionTokenApi
appToServer cfg = enter (convertApp cfg) tokenServer

convertApp :: Config -> App :~> ExceptT ServantErr IO
convertApp cfg = Nat (flip runReaderT cfg . runApp)

type APIV1 = "api" :> "v1" :>
  SessionTokenApi

v1ServerAPI :: Proxy APIV1
v1ServerAPI = Proxy
