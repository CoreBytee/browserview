#!/bin/zsh
TypeWriter build --input=./Wrapper/Twr/src --branch=Bootstrap
TypeWriter build --input=./Wrapper/Twr/src --branch=Main
TypeWriter build --input=./Wrapper/Twr/src --branch=Static
TypeWriter build --input=./Wrapper/Twr/src --branch=WebHelper

rm ~/Library/Application\ Support/TypeWriter/ApplicationData/BrowserView/Bootstrap.twr
rm ~/Library/Application\ Support/TypeWriter/ApplicationData/BrowserView/BrowserView.twr
rm ~/Library/Application\ Support/TypeWriter/ApplicationData/BrowserView/Static.twr
rm ~/Library/Application\ Support/TypeWriter/ApplicationData/BrowserView/WebHelper.twr

cp ./.TypeWriter/Build/Bootstrap.twr ~/Library/Application\ Support/TypeWriter/ApplicationData/BrowserView/Bootstrap.twr
cp ./.TypeWriter/Build/BrowserView.twr ~/Library/Application\ Support/TypeWriter/ApplicationData/BrowserView/BrowserView.twr
cp ./.TypeWriter/Build/Static.twr ~/Library/Application\ Support/TypeWriter/ApplicationData/BrowserView/Static.twr
cp ./.TypeWriter/Build/WebHelper.twr ~/Library/Application\ Support/TypeWriter/ApplicationData/BrowserView/WebHelper.twr

TypeWriter executebuild --input=./Wrapper/Twr/src --branch=Bootstrap