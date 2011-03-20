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

data Paste = Paste { pasteID :: RecKey
                   , pasteTitle :: String
                   , pasteContent :: String
                   , pasteDescription :: String
                   , pasteLanguage :: String
                   } deriving (Eq, Show)
                   
$(deriveAll ''Paste "PFPaste")
type instance PF Paste = PFPaste

fromDocList :: (Regular a, FromDoc (PF a)) => [Document] -> [a]
fromDocList = map fromJust . filter isJust . map fromDoc

getRecentPastes :: (MonadMongoDB m, DbAccess m) => m [Paste]
getRecentPastes = liftM fromDocList (rest =<< (withDB' $ find (select [] "team")))