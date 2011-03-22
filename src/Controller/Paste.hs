{-# LANGUAGE FlexibleContexts #-}

module Controller.Paste
( recentPastesSplice
, highlightAsSplice
) where
    
import qualified Data.Text    as T
import qualified Text.XmlHtml as X
import           Text.XHtml.Strict (renderHtmlFragment)
import           Control.Monad.Trans
import           Control.Monad (liftM, liftM2)
import           Data.Maybe
import           Text.Highlighting.Kate

import           Text.Templating.Heist

import           Application        
import           Model.Paste


pasteParts :: Paste -> [(T.Text, T.Text)]
pasteParts p = map applyAndPack [ ("title", pasteTitle)
                                , ("code", pasteCode)
                                , ("description", pasteDescription)
                                , ("language", pasteLanguage) ]
    where applyAndPack (x, f) = (T.pack x, T.pack $ f p)

highlightAsSplice :: Splice Application
highlightAsSplice = do
    l <- liftM2 X.getAttribute (return $ T.pack "lang") getParamNode
    c <- liftM  (X.nodeText . head . X.childNodes) getParamNode
    case l of
         Nothing -> return [X.TextNode c]
         _       -> case highlightAs (T.unpack $ fromJust l) (T.unpack c) of
                         Left _  -> return [X.TextNode c]
                         Right h -> return [X.TextNode . T.pack . renderHtmlFragment $ formatAsXHtml [OptNumberLines] (T.unpack $ fromJust l) h]
    

recentPastesSplice :: Splice Application
recentPastesSplice = do
     ps <- lift getRecentPastesDummy
     mapSplices (runChildrenWithText . pasteParts) ps