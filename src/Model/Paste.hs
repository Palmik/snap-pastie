{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE EmptyDataDecls #-}
{-# LANGUAGE TypeFamilies #-}

module Model.Paste
( Paste(..)
, paste
, getRecentPastes
, pastesTable
) where

import           Control.Monad (liftM)

import           Snap.Extension.DB.MongoDB
import           Snap.Extension.DB.MongoDB.Generics

import           Application
import           Model.Utils

data Paste = Paste { pasteID :: RecKey
                   , pasteTitle :: String
                   , pasteContent :: String
                   , pasteDescription :: String
                   , pasteLanguage :: String
                   } deriving (Eq, Show)

$(deriveAll ''Paste "PFPaste")
type instance PF Paste = PFPaste

pastesTable :: String
pastesTable = "pastes"

paste :: String -> String -> String -> String -> Paste
paste t c d l = Paste (RecKey Nothing) t c d l

getRecentPastes :: Application [Paste]
getRecentPastes = liftM fromDocList $ withDB' $ rest =<< (find (select [] "pastes"))

