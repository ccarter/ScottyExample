module Paths_ScottyExample (
    version,
    getBinDir, getLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
catchIO = Exception.catch


version :: Version
version = Version {versionBranch = [0,1,0,0], versionTags = []}
bindir, libdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/Users/testadmin/.cabal/bin"
libdir     = "/Users/testadmin/.cabal/lib/x86_64-osx-ghc-7.8.2/ScottyExample-0.1.0.0"
datadir    = "/Users/testadmin/.cabal/share/x86_64-osx-ghc-7.8.2/ScottyExample-0.1.0.0"
libexecdir = "/Users/testadmin/.cabal/libexec"
sysconfdir = "/Users/testadmin/.cabal/etc"

getBinDir, getLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "ScottyExample_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "ScottyExample_libdir") (\_ -> return libdir)
getDataDir = catchIO (getEnv "ScottyExample_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "ScottyExample_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "ScottyExample_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
