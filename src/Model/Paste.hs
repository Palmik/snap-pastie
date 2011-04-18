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
    , pasteIDText
    , ObjectId
    ) where

import           Data.Either
import           Control.Monad
import           Control.Monad.IO.Class
import qualified Data.Text as T
import qualified Data.Text.Encoding as T (decodeUtf8)
import           Data.Text (Text)

import           Snap.Extension.DB.MongoDB
import           Snap.Extension.DB.MongoDB.Generics

import           Application
import           Model.Utils

data Paste = Paste
           { pasteID :: RecKey
           , pasteTitle :: Text
           , pasteCode :: Text
           , pasteDescription :: Text
           , pasteLanguage :: Text
           } deriving (Eq, Show)

$(deriveAll ''Paste "PFPaste")
type instance PF Paste = PFPaste

-- | Name of the collection where Pastes are stored
pastesTable :: Collection
pastesTable = "pastes"

-- | Smart Paste constructor which takes care of RecKey initialization
paste :: Text -> Text -> Text -> Text -> Paste
paste t c d l = Paste (RecKey Nothing) t c d l

-- | Returns all pastes in descending order by date
getRecentPastes :: Application [Paste]
getRecentPastes = do
    res <- withDB $ rest =<< (find (select [] pastesTable) {sort = ["$natural" =: (-1 :: Int)]})
    return $ either (const []) (fromDocList) res

-- | Returns Pastes's ObjectId as a Text
pasteIDText :: Paste -> Maybe Text
pasteIDText p = maybe Nothing (Just . T.decodeUtf8 . objid2bs) (unRK $ pasteID p)

-- | Returns Paste with the given ObjectId
getPaste :: ObjectId -> Application (Maybe Paste)
getPaste pid = do
    res <- withDB $ findOne (select ["_id" =: pid] pastesTable)
    return $ either (const Nothing) (maybe Nothing fromDoc) res

-- | Inserts Paste into the Paste collection
insertPaste :: Paste -> Application ()
insertPaste p = withDB' $ insertADT_ pastesTable p