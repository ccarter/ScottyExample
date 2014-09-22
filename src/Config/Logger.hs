module Config.Logger
where

import Network.Wai (Middleware)
import Network.Wai.Middleware.RequestLogger

import Config.Conf

logger :: Environment -> Middleware
logger Development = logStdoutDev
logger Other = logStdout
