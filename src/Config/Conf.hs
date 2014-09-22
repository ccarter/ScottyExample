{-# LANGUAGE OverloadedStrings #-}

module Config.Conf
    ( MyConfig(..)
    , Environment(..)
    , configFiles
    , myConfig
    , C.load
    )
where

import qualified Data.Configurator as C
import qualified Data.Configurator.Types as CT

type Port = Int
data MyConfig = MyConfig { hcPort :: Port
                         , hcEnvironment :: Environment }

data Environment = Development | Other

configFiles :: [C.Worth FilePath]
configFiles = [C.Required "config/config.cfg"]

myConfig :: CT.Config -> IO MyConfig
myConfig c = do
  let httpConfig = C.subconfig "http" c
  env' <- C.require c "environment"
  port <- C.require httpConfig "port"
  return $ MyConfig port (env env')

env :: String -> Environment
env e = case e of
          "development" -> Development
          _ -> Other
