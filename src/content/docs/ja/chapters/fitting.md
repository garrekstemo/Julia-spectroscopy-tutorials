---
title: 8. フィッティング
---

この章では、[最小二乗法 (least squares)](https://en.wikipedia.org/wiki/Least_squares) を使ってデータにモデルをフィッティングする際の基本原理を扱います。
フィッティングには [CurveFit.jl](https://github.com/SciML/CurveFit.jl) パッケージを使います。


## 最小二乗フィッティング
$n$ 個のデータ点の組 $(x_i, y_i)$ (ただし $i = 1, \dots, n$) からなる実験データがあるとします。$y_i$ は $x_i$ で観測された値です。
モデルがデータをどの程度説明できるかを調べ、モデルの関数がデータに最も「フィット」するまでモデルのパラメータを調整することで、このデータから物理的な知見を得たいと考えます。
たとえば、液体サンプルの吸光度をさまざまな濃度で測定すると、吸光度と濃度の間に線形関係があると期待されます (有名な Beer-Lambert 則)。
測定した吸光度と線形モデルとの差が誤差です。
直線の傾きと切片が、データに最もよく合致する直線を見つけるために変化させるパラメータです。

研究対象の系がどのようなものであれ、データに最もよくフィットするモデルを生み出すパラメータが、測定した物理系について何か有益なことを示してくれることを期待します。
物理的に妥当なモデルを選ぶこと以外に、モデルがデータにどれだけ「フィット」しているかを定量化する必要もあります。
モデル関数は $f(p, x)$ という形を取り、ここで $p$ はフィッティングによって求めたいパラメータのベクトルです。
この「ベストフィット」のパラメータベクトルを見つけることが目的です。
モデルがデータにどれだけ合っているかは、観測値 $y_i$ と、与えられた $p$ に対するモデル値 $f(p, x_i)$ との差で測ります。
この差の集合は残差 (residuals) と呼ばれ、次のように定義されます。

$$
r_i = y_i - f(p, x_i)
$$

最小二乗法では、残差を二乗してすべて足し合わせます。
この二乗残差の和を最小化することで、最適なパラメータ値 $p$ が得られます。
二乗残差の和は次の式で与えられます。

$$
S = \sum_{i=1}^n r_i^2 = \sum_{i=1}^n \left(y_i - f(p, x_i) \right)^2
$$

この関数はコスト関数または [損失関数 (loss function)](https://en.wikipedia.org/wiki/Loss_function) とも呼ばれます。誤差関数 (error function) と呼ばれることもあります。

下の例は、ランダムに生成したデータに対する線形フィットと、データ点と当てはめ直線の間の線として描画した残差を示しています。
点線は初期推定パラメータでの直線です。

![](/images/linear_fit.png)


## 例: ローレンツ型のピーク

ノイズの多いサンプルのスペクトルを測定し、500 nm 付近にひとつのピークを観測したとします。分光学でよく現れる線形であるローレンツ関数 (Lorentzian) でこのピークが表せると考える理由があるとしましょう。
ローレンツ型のラインシェイプは次の式で与えられます。

$$
L(x) = \frac{I_0}{1 + \left(\frac{x - x_0}{\Gamma / 2}\right)^2}
$$

ここで $I_0$ は振幅、$x_0$ はピークの中心周波数 (波数で表されることが多い)、$\Gamma$ は半値全幅 (FWHM) で、$x = x_0 \pm \frac{\Gamma}{2}$ の点で現れます。

CurveFit.jl の `NonlinearCurveFitProblem` と `solve` を使って、以下のパラメータでローレンツ関数をフィッティングしてみましょう。モデル関数のシグネチャは `f(p, x)`、つまりパラメータベクトルが先、独立変数が後です。フィッティング後、ベストフィットパラメータは `coef(sol)` で、その標準誤差は `stderror(sol)` で取得します。

```julia
A = 1.0
Γ = 28
x0 = 510
```

データ点の数や加えるノイズの量によりますが、結果は下のようなものになるはずです。
各パラメータの誤差推定値も忘れずに報告してください。

![](/images/lorentzian_fit_residuals.png)

フィット結果の残差をプロットして、結果がデータにどれだけ合っているかを確認するのは有用です。
残差に系統的な構造が見られないことが望ましく、もし見られればモデルがデータをうまく説明できていないことを意味します。


## 例: ポラリトン分散

ポラリトン系の Rabi 分裂を、ビーム入射角の関数として測定するとしましょう。
透過スペクトル中には 2 つのピークが現れ、一方はアッパーポラリトン、もう一方はロワーポラリトンに対応し、それぞれ角度に応じて周波数が変化します。
Rabi 分裂を取り出す方法のひとつは、角度分解スペクトルを測定し、周波数を入射角に対してプロットして、次のハミルトニアンで与えられる単純な結合調和振動子モデルでデータをフィッティングすることです。

$$
H_\text{total} =
\begin{pmatrix}
    \omega_c(\theta) & 0 \\
    0 & \omega_v
    \end{pmatrix}
    + \begin{pmatrix}
    0 & \Omega_R / 2 \\
    \Omega_R / 2 & 0
    \end{pmatrix}
    = \begin{pmatrix}
    \omega_c(\theta) & \Omega_R / 2 \\
    \Omega_R / 2 & \omega_v
\end{pmatrix}
$$

このハミルトニアンを対角化すると、アッパー/ロワーポラリトンのエネルギーが得られます。

$$
\omega_\pm(\theta) = \frac{1}{2}\left[ \omega_c(\theta) + \omega_v \pm \sqrt{\left(\omega_c(\theta) - \omega_v\right)^2 + \Omega_R^2}\right]
$$

分子振動遷移は $\omega_v$、Rabi 分裂の大きさは $\Omega_R$ です。キャビティモードの周波数 $\omega_c$ は次の式で与えられます。

$$
\omega_c(\theta) = \omega_c(0)\left(1 - \frac{\sin^2\theta}{n^2} \right)^{-1/2}
$$

ここで $\theta$ はキャビティ表面の法線に対するビームの角度、$n$ はキャビティ内媒質の屈折率です。

2 つのポラリトンブランチを同時にフィッティングするには、両方を返すモデル関数をひとつ書くだけで済みます。アッパーとロワーのブランチの予測値を `vcat` で連結し、連結したデータと比較します。

```julia
using CurveFit

function cavity_mode_energy(θs, E_0, n)
    # Your code here
end

function polariton_branch(θs, E_v, E_0, n, Ω, branch)
    # Your code here — branch = +1 for UP, -1 for LP
end

function model(p, θs)
    E_v, E_0, n, Ω = p
    LP = polariton_branch(θs, E_v, E_0, n, Ω, -1)
    UP = polariton_branch(θs, E_v, E_0, n, Ω, +1)
    return vcat(LP, UP)
end
```

そして `NonlinearCurveFitProblem` を構築し、`solve()` を呼び出します。

```julia
prob = NonlinearCurveFitProblem(model, [E_v, E_0, n, Ω], θs, vcat(LP, UP))
sol = solve(prob)
```

ベストフィットパラメータは `coef(sol)`、その標準誤差は `stderror(sol)` で取得します。

![](/images/polariton_fit.png)


## 問題

1. 上で述べたノイズ入りのローレンツスペクトルをフィッティングしましょう。ピーク位置、FWHM、振幅と、それぞれの標準誤差を報告してください。

2. `cavity_mode_energy` と `polariton_branch` 関数を実装しましょう。これらを使って、$\omega_c(0)$ = 1900 cm<sup>-1</sup>、$\omega_v$ = 1950 cm<sup>-1</sup>、$\Omega_R$ = 60 cm<sup>-1</sup>、$n$ = 1.4 のパラメータでガウシアンノイズを加えた 2 つのポラリトンブランチのデータを生成してください。

3. `NonlinearCurveFitProblem` を構築して `solve()` を呼び出し、モデルをデータにフィッティングしましょう。パラメータの初期推定値をいろいろ変えてみて、フィット結果にどう影響するかを観察してみてください。

4. フィッティングパラメータの数を変えてみましょう。
上の例では 4 つのパラメータを変動させましたが、既知の値のものを固定することもできます。
たとえば、分子の振動モードは既知である場合が多いです。
各パラメータの標準誤差と信頼区間を必ず報告してください。
これらの量は何を意味するでしょうか?


## 参考資料

- Wikipedia の [Least Squares Fitting](https://en.wikipedia.org/wiki/Least_squares) のページ
- [Khan Academy](https://www.khanacademy.org/math/ap-statistics/bivariate-data-ap/xfb5d8e68:residuals/v/regression-residual-intro) の残差と最小二乗回帰の解説
- Ledvij, M. "[Curve Fitting Made Easy](http://physik.uibk.ac.at/hephy/muon/origin_curve_fitting_primer.pdf)." Industrial Physicist 9, 24-27, Apr./May 2003.
