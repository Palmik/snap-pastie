{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeSynonymInstances #-}

module Controller.Paste
( recentPastesSplice
, addPasteHandler
) where
    
import qualified Data.Text    as T
import qualified Text.XmlHtml as X
import           Control.Monad.Trans
import           Control.Applicative ((<$>), (<*>))
import           Text.Digestive.Blaze.Html5
import           Text.Digestive
import           Text.Blaze (Html, (!))
import qualified Text.Blaze.Html5 as H
import qualified Text.Blaze.Html5.Attributes as A
import           Text.Blaze.Renderer.Utf8 (renderHtml)

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
     ps <- lift getRecentPastesDummy
     mapSplices (runChildrenWithText . pasteParts) ps

addPasteForm :: SnapForm Html BlazeFormHtml Paste
addPasteForm = paste
    <$> label "Title: " ++> inputText (Just "Title")
    <*> label "Code: " ++> inputTextArea (Just 10) (Just 20) (Just "Code")
    <*> label "Description: " ++> inputTextArea (Just 5) (Just 20) (Just "Description")
    <*> label "Language: " ++> inputText (Just "Language")

blaze :: Html -> Application ()
blaze response = do
    modifyResponse $ addHeader "Content-Type" "text/html; charset=UTF-8"
    writeLBS $ renderHtml response

addPasteHandler :: Application ()
addPasteHandler = do
    r <- eitherSnapForm addPasteForm "add-paste-form"
    case r of
        Left form' -> blaze $ do
            let (fhtml, enctype) = renderFormHtml form'
            H.form ! A.enctype (H.stringValue $ show enctype)
                   ! A.method "POST" ! A.action "/" $ do
                fhtml
                H.input ! A.type_ "submit" ! A.value "Submit"
        Right paste' -> insertPaste paste'

         
    