{-# LANGUAGE FlexibleContexts #-}

module Controller.Paste
( recentPastesSplice
) where
    
import qualified Data.Text    as T
import           Control.Monad.Trans

import           Text.Templating.Heist

import           Application        
import           Model.Paste


pasteParts :: Paste -> [(T.Text, T.Text)]
pasteParts paste = map applyAndPack [ ("title", pasteTitle)
                                    , ("content", pasteContent)
                                    , ("description", pasteDescription)
                                    , ("language", pasteLanguage) ]
    where applyAndPack (x, f) = (T.pack x, T.pack $ f paste)

recentPastesSplice :: Splice Application
recentPastesSplice = do
    pastes <- lift getRecentPastes
    mapSplices (runChildrenWithText . pasteParts) pastes