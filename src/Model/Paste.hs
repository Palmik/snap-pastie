{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE EmptyDataDecls #-}
{-# LANGUAGE TypeFamilies #-}

module Model.Paste
( Paste(..)
, paste
, getRecentPastes
, getRecentPastesDummy
, pastesTable
, insertPaste
) where

import           Control.Monad (liftM)
import qualified Data.Text as T
import           Data.Text (Text)

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
getRecentPastes = liftM fromDocList $ withDB' $ rest =<< (find (select [] "pastes") {sort = ["$natural" =: (-1 :: Int)]})

getRecentPastesDummy :: Application [Paste]
getRecentPastesDummy = return $ map (\ n -> paste (T.pack $ "Title " ++ show n) (T.pack $ content ++ ' ':show n) (T.pack $ description ++ ' ':show n) "cpp") [1..15]
    where content = "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
          description = "In et felis nulla. Vivamus vitae feugiat nulla."

insertPaste :: Paste -> Application ()
insertPaste p = withDB' $ insertADT_ pastesTable p