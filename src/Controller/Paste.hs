{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeSynonymInstances #-}

module Controller.Paste
( recentPastesSplice
, addPasteHandler
) where
    
import qualified Data.Text    as T
import qualified Data.Text.Encoding as T (decodeUtf8)
import qualified Text.XmlHtml as X
import           Control.Monad.Trans
import           Control.Monad (mzero)
import qualified Data.ByteString.Char8 as BS (unpack)
import           Debug.Trace (trace)

import           Snap.Types
import           Text.Digestive.Forms.Snap
import           Text.Templating.Heist

import           Application
import           Model.Utils      
import           Model.Paste


pasteParts :: Paste -> [(T.Text, T.Text)]
pasteParts p = map applyAndPack [ ("title", pasteTitle)
                                , ("code", pasteCode)
                                , ("description", pasteDescription)
                                , ("language", pasteLanguage) ]
    where applyAndPack (x, f) = (T.pack x, T.pack $ f p)

recentPastesSplice :: Splice Application
recentPastesSplice = do
    ps <- lift getRecentPastes
    mapSplices (runChildrenWithText . pasteParts) ps

addPasteHandler :: Application ()
addPasteHandler = do
    t <- getParam "title" >>= maybe (redirect "/") (return . T.unpack . T.decodeUtf8)
    c <- getParam "code" >>= maybe (redirect "/") (return . T.unpack . T.decodeUtf8)
    d <- getParam "description" >>= maybe (redirect "/") (return . T.unpack . T.decodeUtf8)
    l <- return "cpp"
    if (not $ any null [t, c, d, l]) then insertPaste $ paste t c d l else return ()
    redirect "/"

         
    