---
title: 転送行列
---

この章は物理とプログラミングの両方を扱います。
まずマイクロキャビティ構造での強結合 (strong coupling) を扱い、続いて転送行列法 (transfer matrix method) を使って電磁波が層構造を伝搬する様子をシミュレートします。

物理の概念は以下の文献に基づいています。

Skolnick, Fisher, and Whittaker. Strong coupling phenomena in quantum microcavity structures. *Semicond. Sci. and Technol*. **1998**, *13* (7), 645-669. https://doi.org/10.1088/0268-1242/13/7/003.

理解を補うために他の文献を参照しても構いません。
特に Wikipedia の [分布ブラッグ反射器 (DBR)](https://en.wikipedia.org/wiki/Distributed_Bragg_reflector) のページが参考になります。


## はじめに
Skolnick *et al.* の Introduction を読み、以下の概念問題に答えてください。

1. エキシトンとは何でしょうか? どのように形成されるでしょうか?
2. 量子井戸 (quantum well) とは何でしょうか?
3. DBR ミラーの構造はどうなっていますか? この構造はどのようにして高反射率の面を実現しているのでしょうか?
4. 著者らは量子マイクロキャビティ (QMC) をどう定義していますか?
5. なぜ Fabry-Pérot キャビティは光子を「成長方向」(垂直方向) では量子化させるのに、面内方向では量子化させないのでしょうか?
6. 「バルク」ポラリトンと「キャビティ」ポラリトンの違いは何でしょうか?
7. キャビティ内の光子の分散は、自由空間 (真空) 中の光子の分散とどう異なるでしょうか?
8. 強結合領域 (strong coupling limit) はどのように定義されますか? この領域でどんな現象が起こりますか? 弱結合領域ではどうでしょうか?


## マイクロキャビティの基礎物理
波長 630 nm では、TiO<sub>2</sub> の屈折率は約 2.39、SiO<sub>2</sub> の屈折率は約 1.46 です。TiO<sub>2</sub> と SiO<sub>2</sub> の層が交互に積層された分布ブラッグ反射器 (DBR) ミラーを考えます。

1. TiO<sub>2</sub>/SiO<sub>2</sub> の周期数が 2、4、8 のとき、DBR ミラーの反射率はいくつになるでしょうか?

2. ミラーの光子ストップバンドの帯域幅はいくつでしょうか?

次に、キャビティ長 1 μm で両側に DBR ミラーを持つマイクロキャビティを考えます。

3. 2 つのミラー面間の距離が 1 μm のとき、有効キャビティ長はいくつでしょうか? なぜミラー面間の距離としての測定値と異なるのでしょうか?

4. 630 nm に共振を持つために必要なキャビティ長はいくつでしょうか?

5. 前問のキャビティにおけるキャビティモード幅 Δc はいくつでしょうか? これはどのような寿命に対応しますか? キャビティの Q 値 (Q-factor) はいくつでしょうか?


## 転送行列法
私は、物理の概念を学ぶ最良の方法のひとつは、それをコードで実装することだと思っています。
大学院生のころ、私はまさにそれを行い、まず Python で、次に Julia で (今回使うのはこちらです) 転送行列シミュレーションを構築しました。
ゼロからシミュレーション全体を構築してもらうのは要求しすぎですが、せめて転送行列法を使って簡単な構造に電磁波が伝搬する様子をシミュレートしてみましょう。

転送行列法は、複数の層を電磁波が伝搬する様子をシミュレートします。
反射・透過・吸収、Bloch 表面波、層内部の電場分布など、さまざまな静的現象を再現できます。
非線形効果や時間依存現象には使えないという既知の限界はありますが、誘電体ミラーの設計、複雑な構造の透過スペクトルのシミュレーション、ポラリトン透過スペクトルの解析など、研究室では強力なツールです。
TransferMatrix.jl の実装は Passler *et al.* の研究 (参考文献参照) に基づいています。
これは一般的な 4 × 4 行列形式で、従来の Yeh の形式における特有の落とし穴 (特定の場合に特異点が生じやすいなど) を回避しようとしたものです。
コード自体はモジュール化されよく文書化されている (と願っています) ので、アルゴリズムの一部を必要に応じて改変するのも容易です。


## はじめに

TransferMatrix.jl の [ドキュメントサイト](https://garrek.org/TransferMatrix.jl/stable/) にクイックスタートと長めのチュートリアルを書いてあります。
まずはこれらの例に目を通し、コードが何をしているのか、また生成されたスペクトルの解釈の仕方を理解してください。

それが済んだら、自分で構造を組み立てて透過スペクトルをシミュレートします。


### 問題

転送行列法を使って、前の問題セットで扱った誘電体ミラー構造の反射スペクトルをシミュレートし、以下の問いに数値的に答え、以前の解析的な解答と比較してください。

1. TiO2/SiO2 の周期数が 2、4、8 のとき、DBR ミラーの反射率はいくつでしょうか?

2. ミラーの光子ストップバンドの帯域幅はいくつでしょうか?

次に、入射波長 630 nm に対して TiO<sub>2</sub> と Ta<sub>2</sub>O<sub>5</sub> の層からなるミラーをシミュレートします。

3. TiO<sub>2</sub>/SiO<sub>2</sub> の 2 層よりも高い反射率を得るには、何層必要でしょうか?

4. どちらのミラーがストップバンドが広いでしょうか? なぜでしょうか?

次に、キャビティ長 $\lambda_0$/2 (ただし $\lambda_0$ = 3) の金ミラーキャビティをシミュレートします。キャビティ内の媒質は空気 (n = 1) としてください。(長波長まで含めて必ずスペクトルをプロットしてください。)

5. 透過スペクトルを波長と周波数 (cm<sup>-1</sup>) のそれぞれの単位でプロットしてください。モード間隔について何か気づくことはありますか?

6. 3200-3300 cm<sup>-1</sup> 付近のモードのキャビティモードの FWHM が約 40 cm<sup>-1</sup> になるように金の厚さを調整してください。その厚さはいくつでしょうか?

7. この FWHM はどんな光子寿命に対応するでしょうか? このモードの Q 値はいくつでしょうか?

8. 自由スペクトル領域 (FSR) は隣接するキャビティモード間の周波数間隔として定義されます。金厚 10 nm のこのキャビティの平均 FSR を計算してください。

9. 任意のキャビティモードを選んで、その波長における電場を計算してください。1 次モードを見つけられますか? その電場分布はどうなっていますか?

10. キャビティ長を 3/2 $\lambda_0$ まで増やしてください。電場分布はどう変わりますか? 新しい FSR はいくつでしょうか?


## 参考文献
- Wikipedia の [Transfer Matrix Method](https://en.wikipedia.org/wiki/Transfer-matrix_method_(optics)) のページ
- Yeh, P. *Optical Waves in Layered Media*; Wiley Series in Pure and Applied Optics; Wiley, 2005.

- Passler, N. C.; Paarmann, A. *Generalized 4 × 4 Matrix Formalism for Light Propagation in Anisotropic Stratified Media: Study of Surface Phonon Polaritons in Polar Dielectric Heterostructures*. J. Opt. Soc. Am. B 2017, 34 (10), 2128. https://doi.org/10.1364/JOSAB.34.002128.
- Passler, N. C.; Paarmann, A. *Generalized 4 × 4 Matrix Formalism for Light Propagation in Anisotropic Stratified Media: Study of Surface Phonon Polaritons in Polar Dielectric Heterostructures: Erratum*. J. Opt. Soc. Am. B 2019, 36 (11), 3246. https://doi.org/10.1364/JOSAB.36.003246.
- Garibello, B.; Avilán, N.; Galvis, J. A.; Herreño-Fierro, C. A. *On the Singularity of the Yeh 4 × 4 Transfer Matrix Formalism*. Journal of Modern Optics 2020, 67 (9), 832–836. https://doi.org/10.1080/09500340.2020.1775905.
