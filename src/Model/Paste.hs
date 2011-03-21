{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE EmptyDataDecls #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE FlexibleContexts #-}

module Model.Paste
( Paste(..)
, getRecentPastes
, DbAccess
, MonadMongoDB
) where

import           Control.Monad (liftM)
import           Data.Maybe

import           Snap.Extension.DB.MongoDB
import           Snap.Extension.DB.MongoDB.Generics

import           Application

data Paste = Paste { pasteID :: RecKey
                   , pasteTitle :: String
                   , pasteContent :: String
                   , pasteDescription :: String
                   , pasteLanguage :: String
                   } deriving (Eq, Show)
                   
$(deriveAll ''Paste "PFPaste")
type instance PF Paste = PFPaste

fromDocList :: (Regular a, FromDoc (PF a)) => [Document] -> [a]
fromDocList = catMaybes . map fromDoc

getRecentPastes :: Application [Paste]
getRecentPastes = liftM fromDocList (withDB' $ rest =<< (find (select [] "pastes")))