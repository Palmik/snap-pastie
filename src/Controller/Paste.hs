{-# LANGUAGE FlexibleContexts #-}

module Controller.Paste
( recentPastesSplice
) where
    
import qualified Data.Text    as T
import qualified Text.XmlHtml as X
import           Control.Monad.Trans

import           Text.Templating.Heist

import           Application        
import           Model.Paste


pasteParts :: Paste -> [(T.Text, T.Text)]
pasteParts p = map applyAndPack [ ("title", pasteTitle)
                                , ("code", pasteCode)
                                , ("description", pasteDescription)
                                , ("language", pasteLanguage) ]
    where applyAndPack (x, f) = (T.pack x, T.pack $ f p)

recentPastesSplice :: Splice Application
recentPastesSplice = do
     ps <- lift getRecentPastesDummy
     mapSplices (runChildrenWithText . pasteParts) ps