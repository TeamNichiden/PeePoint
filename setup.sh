#!/bin/bash

# XcodeGenの確認とインストール
if ! command -v xcodegen &> /dev/null
then
    echo "XcodeGenがインストールされていません。インストールします。"
    brew install xcodegen
else
    echo "XcodeGenはすでにインストールされています。"
fi

# CocoaPodsの確認とインストール
if ! command -v pod &> /dev/null
then
    echo "CocoaPodsがインストールされていません。インストールします。"
    brew install cocoapods
else
    echo "CocoaPodsはすでにインストールされています。"
fi

# SwiftLintの確認とインストール
if ! command -v swiftlint &> /dev/null
then
    echo "SwiftLintがインストールされていません。インストールします。"
    brew install swiftlint
else
    echo "SwiftLintはすでにインストールされています。"
fi

# XcodeGenでプロジェクトを生成
echo "XcodeGenでプロジェクトを生成します。"
xcodegen generate

# CocoaPodsで依存関係をインストール
echo "CocoaPodsで依存関係をインストールします。"
pod install

# SwiftLintでコードをチェック
echo "SwiftLintでコードをチェックします。"
swiftlint lint

