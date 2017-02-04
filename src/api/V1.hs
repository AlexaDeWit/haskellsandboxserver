{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

module API.V1
  ( APIV1
  , v1ServerAPI
  , v1Server
  ) where

import Servant
import Data.Aeson.Types
import GHC.Generics
import Requests.GameSessions
import Control.Monad.Except

type APIV1 = "api" :> "v1" :>
  SessionTokenApi

v1Server :: Server APIV1
v1Server = sessionToken
  where sessionToken :: LoginRequest -> Handler SessionToken
        sessionToken req = liftIO $ tokenFromRequest req

v1ServerAPI :: Proxy APIV1
v1ServerAPI = Proxy
