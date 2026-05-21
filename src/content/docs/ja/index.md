---
title: 分光学のための Julia 入門
---

分光学のデータ解析に Julia プログラミング言語を使うための入門です。プログラミング未経験の読者を想定していますが、他言語で少しだけ経験のある方にも役立つはずです。

前半の章ではプログラミングの基礎を、後半の章ではデータ解析と可視化を扱います。

## このチュートリアルの使い方

各章には、章の途中で出てくる **演習 (Exercises)** (短く、読みながら手を動かすもの) と、章末の **問題 (Problems)** (やや長く、後の章で再利用する関数を作るものもあります) があります。ただ読むだけでなく、実際にコードを書くことが大切です。多くの問題には `@test` ブロックが用意されていて、自分の答えを検証できます。本資料を授業で利用される教員の方など、模範解答が必要な場合は [garrekstemo@icloud.com](mailto:garrekstemo@icloud.com) までご連絡ください。

## ソースコードと演習データ

各章で使用する図の生成コードは [`generate_images`](https://github.com/garrekstemo/Intro-to-Julia-for-spectroscopy/tree/main/generate_images) にあります。例題と問題で使うデータは [`data`](https://github.com/garrekstemo/Intro-to-Julia-for-spectroscopy/tree/main/data) にあります。
