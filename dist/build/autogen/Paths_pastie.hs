module Paths_pastie (
    version,
    getBinDir, getLibDir, getDataDir, getLibexecDir,
    getDataFileName
  ) where

import Data.Version (Version(..))
import System.Environment (getEnv)

version :: Version
version = Version {versionBranch = [0,1], versionTags = []}

bindir, libdir, datadir, libexecdir :: FilePath

bindir     = "/home/palmik/.cabal/bin"
libdir     = "/home/palmik/.cabal/lib/pastie-0.1/ghc-7.0.2"
datadir    = "/home/palmik/.cabal/share/pastie-0.1"
libexecdir = "/home/palmik/.cabal/libexec"

getBinDir, getLibDir, getDataDir, getLibexecDir :: IO FilePath
getBinDir = catch (getEnv "pastie_bindir") (\_ -> return bindir)
getLibDir = catch (getEnv "pastie_libdir") (\_ -> return libdir)
getDataDir = catch (getEnv "pastie_datadir") (\_ -> return datadir)
getLibexecDir = catch (getEnv "pastie_libexecdir") (\_ -> return libexecdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
