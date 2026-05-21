---
title: 7. プロット
---

ここまで使ってきたツールはすべて Julia の標準ライブラリの一部でした。
このレッスンでは、初めて外部パッケージを使います。プロットライブラリの [Makie.jl](https://makie.org) です。

Makie.jl は使いやすくて高品質なビジュアライゼーションを生成できる、強力で現代的なプロットライブラリです。
高速描画と対話的なプロットのための GPU 高速化バックエンド、公表用に高品質なベクトルグラフィックを出力する静的バックエンド、ブラウザ上で対話的にプロットできる Web ベースのバックエンドが用意されています。
 
例とドキュメントは公式の [Makie tutorials](https://docs.makie.org/stable/tutorials/getting-started) を参照してください。


## 始める前に
Makie の [Getting Started](https://docs.makie.org/stable/tutorials/getting-started) チュートリアルは非常によくできていて、正直なところ私もこれ以上の入門は書けません。
続ける前に、まずは目を通しておいてください。

Makie は[はじめに](./01-introduction/) でインストール済みですが、念のため簡単におさらいします。


### Makie のインストール
Makie には用途に応じて 3 つのバックエンドがあります。
- **GLMakie:** 高速描画と対話的プロット用の GPU 高速化バックエンド。
- **CairoMakie:** 公表用の高品質なベクトルグラフィックを出力する静的バックエンド。
- **WGLMakie:** ブラウザ上で対話的にプロットするための Web ベースのバックエンド。

用途に応じてどれかひとつを選びます。

ここでは GLMakie を使いますが、CairoMakie でも構いません。
[はじめに](./01-introduction/) で扱ったように、Julia のパッケージマネージャでパッケージをインストールします。

1. `tutorial` フォルダを VS Code で開きます。
2. コマンドパレット (macOS では `cmd+shift+p`、Windows では `ctrl+shift+p`) を開き、`Julia: Start REPL` を選んで Julia REPL を起動します。
3. REPL で `]` を入力してパッケージマネージャに入ります。(バックスペースでパッケージマネージャを抜けて Julia REPL に戻れます。)
4. `add GLMakie` (または `add CairoMakie`) と入力してインストールします。

プロットを始める前に、`tutorial` フォルダの中に `plotting` などの名前で新しいフォルダを作りましょう。
そしてそのフォルダを開いてください。

Julia でパッケージを使うには、まずインポートする必要があります。
通常はファイルの先頭で次のように書きます。

```julia
using GLMakie  # or CairoMakie
```

それでは簡単なプロットを作ってみましょう。


## 基本的なプロットを作る

### Figure と Axis
Makie では `Figure` がトップレベルのコンテナオブジェクトです。
`Axis` はプロットを格納するコンテナオブジェクトです。
ひとつの `Figure` の中に 1 つ以上の `Axis` を配置することでレイアウトを作ります。
VS Code で順を追って試してみましょう。

```julia
using GLMakie

f = Figure()
f
```

`alt+enter` でこのファイル内のコードをすべて実行してください。空の Figure ウィンドウが表示されるはずです。
最初の実行は遅く感じるかもしれません。
これは Julia が JIT (just-in-time) コンパイル方式の言語で、必要に応じてコードをコンパイルするためです。
初回の実行には時間がかかりますが、2 回目以降は格段に速くなります。

`Figure` は、Axis やプロット、ラベルを配置するための真っ白なキャンバスだと考えてください。
それでは Figure に `Axis` を追加してみましょう。

```julia
f = Figure()
ax = Axis(f[1, 1], title = "First Axis")
f
```
![](/Intro-to-Julia-for-spectroscopy/images/one_axis.png)

Axis が Figure 全体を占めていることがわかります。
次は、最初の行・2 列目に別の `Axis` を追加してみましょう。

```julia
f = Figure()
ax = Axis(f[1, 1])
ax2 = Axis(f[1, 2])
f
```
![](/Intro-to-Julia-for-spectroscopy/images/two_axes.png)
最初の Axis は、2 つ目の Axis に合わせて自動的にリサイズされます。
`Axis` は複数の行や列にまたがって配置することもできます。

```julia
f = Figure()
ax = Axis(f[1, 1])
ax2 = Axis(f[1, 2])
ax3 = Axis(f[2, 1:2])
f
```
![](/Intro-to-Julia-for-spectroscopy/images/three_axes.png)


これは Makie の強力なレイアウトシステムのごく基本的な部分にすぎません。
ここではまず、Figure にひとつだけ `Axis` を置いて、データをプロットしてみましょう。


### ノイズ入りデータを生成してプロットする
まずは関数を定義します。時間の関数としての減衰正弦波です。

```julia
function damped_sine(t, A, f, τ)
    return A * exp(-t / τ) * sin(2π * f * t)
end
```

次にデータを生成します。
まずは以下の値から始めましょう。

```julia
A = 3.0  # amplitude
f = 1  # frequency in Hz
τ = 1  # decay time constant in picoseconds
```
ピコ秒単位で線形に並んだ時間値を作り、信号強度を計算して `intensity` という変数に格納します。

```julia
ps = 1:0.1:5  # time in picoseconds
intensity = damped_sine.(ps, A, f, τ)
```

実験データらしく見せるために、少しノイズを加えます。

```julia
noise = 0.1 * randn(length(ps))
intensity_noisy = intensity .+ noise
```

それではデータをプロットし、ラベル・スタイル・凡例を追加しましょう。
`axislegend` の `position` キーワード引数に `:rb` ("right bottom") を指定すると、凡例をプロットの右下に配置できます。

```julia
f = Figure()
ax = Axis(f[1, 1],
    title = "Damped sine wave",
    xlabel = "Time (ps)",
    ylabel = "Intensity",
)
scatter!(
    ps,
    intensity_noisy,
    color = :firebrick3,
    label = "Data",
    )
lines!(
    ps,
    intensity,
    color = :deepskyblue4,
    linestyle = :dash,
    label = "f(x) = A exp(−t / τ) sin(2π f t)",
    )

axislegend(position = :rb)
f
```
![](/Intro-to-Julia-for-spectroscopy/images/damped_sine_wave.png)


プロットが `Axis` の定義の後に来る場合、そのプロットは `Axis` の上に描画され、`ax` 変数を引数として渡す必要はありません。
コード中の色は私の好みです。
カラーパレット一覧は [Colors.jl](https://juliagraphics.github.io/Colors.jl/latest/namedcolors/) にあります。


## プログラムによるプロット
ループや関数といったプログラミングの概念をプロットに組み合わせると、非常に強力になります。
この例ではループを使って、異なる周波数と振幅の正弦波を複数プロットします。
先ほど定義した減衰正弦波関数をふたたび使いましょう。

異なる振幅、周波数、減衰時定数を持つ 3 組のデータがあると仮定します。
それぞれのデータ用にランダムなパラメータを生成します。
以下のコードでは、`rand(1:3, 3)` を使って振幅・周波数・減衰時定数に対応する 1 〜 3 の整数を 3 つ生成しています。
3 つのデータをすべて同じ Axis 上にプロットしますが、重ならないように縦方向にオフセットします。
まずパラメータを設定し、データをプロットするループを書きましょう。
時間値の解像度を上げて、正弦波をなめらかにしてあります。

```julia
ps_hires = 1:0.02:5  # higher resolution time values

num_data_sets = 3
offset = 5  # vertical offset between data sets
noise_level = 0.1

for i in 1:num_data_sets
    A, ω, τ = rand(1:3, 3)
    intensity = damped_sine.(ps, A, ω, τ) .+ noise_level * randn(length(ps))
    lines!(ps, intensity .+ (i - 1) * offset)
end
```

各ループで、y 軸の値が `(i - 1) * offset` だけオフセットされています。これにより、最初のデータは y=0、2 番目は y=5、3 番目は y=10 にプロットされます。
`offset` を変えれば、データ間の縦方向の間隔を変えられます。
これにより複数のデータを柔軟かつ正確にプロットできます。

ループの中で各データに異なるラベルを付けることもできます。
これと他のスタイル設定をいくつか加えると、プロットを見栄えよくできます。

```julia
f = Figure()
ax = Axis(f[1, 1],
    title = "Time traces",
    xlabel = "Time (ps)",
    ylabel = "Intensity",
)

ps_hires = 0:0.02:5

num_data_sets = 3
offset = 5
noise_level = 0.1

for i in 1:num_data_sets
    A, ω, τ = rand(1:3, 3)
    intensity = damped_sine.(ps, A, ω, τ) .+ noise_level * randn(length(ps))
    lines!(ps, intensity .+ (i - 1) * offset, label = "Data set $i")
end

axislegend(ax)
f
```

![](/Intro-to-Julia-for-spectroscopy/images/cascading_layout.png)


## プロットを操作する

以下のような Axis の操作は、[Makie のドキュメント](https://docs.makie.org/stable/reference/blocks/axis#Axis-interaction) で詳しく紹介されています。

### ズーム
スクロールでプロットをズームイン・ズームアウトできます。
`x` または `y` キーを押しながらスクロールすると、その軸のみズームします。
`ctrl` キーを押しながらクリックするとズームをリセットします。

### 領域を選択する
クリック & ドラッグでグラフの一部にズームインできます。
`x` または `y` キーを押しながらドラッグすると、その方向にのみズームインします。
ここでも、`ctrl` キーを押しながらクリックでズームをリセットできます。

### パン
右クリック & ドラッグでプロットをパン (移動) できます。
ズームと同様に、`x` や `y` キーを押しながら操作するとその方向にのみパンします。
`ctrl` キーを押しながらクリックでパンをリセットします。


## VS Code でのコメントとセクション分割
ここまでで、カーソルを行に置いて `shift+enter` を押せば 1 行を実行でき、`alt+enter` でファイル全体を実行できることはご存知かと思います。

コードに何をしているかを説明するコメントを残すのも一般的です。
コメントは行頭に `#` を付けるか、行末に `#` を付けて記述します。
便利な方法として、行を選択して `cmd+/` (Windows では `ctrl+/`) を押すとその行をコメントアウトできます。
もう一度 `cmd+/` (`ctrl+/`) を押すとコメントを解除します。

`markersize` を `10` に変えてみて、コメントアウトのショートカットを試してみてください。

```julia
scatter!(
    ps,
    intensity_noisy,
    color = :firebrick3
    label = "Data",
    # markersize = 10,
)
```

ときどき、コードの一部だけを実行したいことがあります。
たとえばデータを生成するコードとプロットを作るコードを別々に実行したい場合などです。
行頭に `##` を入れることでコードのチャンクを区切れます。
すると `alt+enter` で、そのセクション内のコード (2 つの `##` の間、ファイル先頭から最初の `##` まで、または最後の `##` からファイル末尾まで) を実行できます。
データ生成のコードとプロット作成のコードを 2 つのセクションに分けて試してみてください。


## 保存
プロットは `save` 関数でファイルに保存できます。

`save` 関数でプロットをファイルに保存できます。
このプロットを、`tutorial` フォルダ内に新しく作った `output` フォルダ内の `damped_sine_wave.png` というファイルに保存しましょう。

```julia
save("output/damped_sine_wave.png", f)
```

保存するとプロットはウィンドウに表示されなくなります。
`save` の行をコメントアウトしてもう一度実行すれば、プロットを再度表示できます。


## 問題
1. 3D サーフェスプロットで、2 つの点電荷のポテンシャルを可視化しましょう。
直交座標系での点電荷のポテンシャルの式と、Makie でのサーフェスプロットの作り方を調べる必要があります。

    直交座標における点電荷のポテンシャルは次の式で与えられます。

    $$\phi(x, y) = \frac{q}{4\pi\epsilon_0} \left( \frac{1}{\sqrt{(x+a)^2+y^2}} - \frac{1}{\sqrt{(x-a)^2+y^2}} \right)$$

    ここで $q$ は電荷、$\epsilon_0$ は真空の誘電率、$a$ は 2 つの電荷の間の距離の半分です。
    プロットには 2 つの電荷 $+q$ と $-q$ を $(-a, 0)$ と $(+a, 0)$ に配置してください。
