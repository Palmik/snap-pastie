{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE EmptyDataDecls #-}
{-# LANGUAGE TypeFamilies #-}

module Model.Paste
( Paste(..)
, paste
, getRecentPastes
, getPaste
, pastesTable
, insertPaste

, ObjectId
) where

import           Data.Either
import           Control.Monad
import           Control.Monad.IO.Class
import qualified Data.Text as T
import           Data.Text (Text)
import           Debug.Trace

import           Snap.Extension.DB.MongoDB
import           Snap.Extension.DB.MongoDB.Generics

import           Application
import           Model.Utils

data Paste = Paste { pasteID :: RecKey
                   , pasteTitle :: Text
                   , pasteCode :: Text
                   , pasteDescription :: Text
                   , pasteLanguage :: Text
                   } deriving (Eq, Show)

$(deriveAll ''Paste "PFPaste")
type instance PF Paste = PFPaste

pastesTable :: Collection
pastesTable = "pastes"

paste :: Text -> Text -> Text -> Text -> Paste
paste t c d l = Paste (RecKey Nothing) t c d l

getRecentPastes :: Application [Paste]
getRecentPastes = do
    res <- withDB $ rest =<< (find (select [] "pastes") {sort = ["$natural" =: (-1 :: Int)]})
    return $ either (const []) (fromDocList) res

getPaste :: ObjectId -> Application (Maybe Paste)
getPaste pid = do
    res <- withDB $ findOne (select ["_id" =: pid] "pastes")
    return $ either (const Nothing) (maybe Nothing fromDoc) res

insertPaste :: Paste -> Application ()
insertPaste p = withDB' $ insertADT_ pastesTable p