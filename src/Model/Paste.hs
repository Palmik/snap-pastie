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

import           Snap.Extension.DB.MongoDB
import           Snap.Extension.DB.MongoDB.Generics

import           Application
import           Model.Utils

data Paste = Paste { pasteID :: RecKey
                   , pasteTitle :: String
                   , pasteCode :: String
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
getRecentPastes = liftM fromDocList $ withDB' $ rest =<< (find (select [] "pastes") {sort = ["$natural" =: (-1 :: Int)]})

getRecentPastesDummy :: Application [Paste]
getRecentPastesDummy = return $ map (\ n -> paste ("Title " ++ show n) (content ++ ' ':show n) (description ++ ' ':show n) "cpp") [1..15]
    where content = "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
          description = "In et felis nulla. Vivamus vitae feugiat nulla."

insertPaste :: Paste -> Application ()
insertPaste p = withDB' $ insertADT_ "pastes" p