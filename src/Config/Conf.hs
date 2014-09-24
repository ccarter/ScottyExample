{-# LANGUAGE OverloadedStrings #-}

module Config.Conf
    ( MyConfig(..)
    , Environment(..)
    , HttpConfig(..)
    , EkgConfig(..)
    , configFiles
    , myConfig
    , C.load
    )
where

import qualified Data.Configurator as C
import qualified Data.Configurator.Types as CT
import qualified Data.ByteString as BS

type Port = Int
data HttpConfig = HttpConfig { hcPort :: Port }
data EkgConfig = EkgConfig { ecHost :: BS.ByteString
                           , ecPort :: Port }
data Environment = Development | Other

data MyConfig = MyConfig { mcHttp :: HttpConfig
                         , mcEkg :: EkgConfig
                         , mcEnvironment :: Environment }

configFiles :: [C.Worth FilePath]
configFiles = [C.Required "config/config.cfg"]

myConfig :: CT.Config -> IO MyConfig
myConfig c = do
  httpConf <- httpConfig c
  ekgConf <- ekgConfig c
  env' <- C.require c "environment"
  return $ MyConfig httpConf ekgConf (env env')

httpConfig :: CT.Config -> IO HttpConfig
httpConfig c = do
  let subConf = C.subconfig "http" c
  port <- C.require subConf "port"
  return $ HttpConfig port

ekgConfig :: CT.Config -> IO EkgConfig
ekgConfig c = do
  let subConf = C.subconfig "ekg" c
  host <- C.require subConf "host"
  port <- C.require subConf "port"
  return $ EkgConfig host port

env :: String -> Environment
env e = case e of
          "development" -> Development
          _ -> Other
