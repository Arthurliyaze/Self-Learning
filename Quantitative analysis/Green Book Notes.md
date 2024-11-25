## 3.4 Important Calculus Methods

**Newton's Method.** Solve equation $f(x)=0$ with initial value $x_0$ and applies $x_{n+1} = x_n -\frac{f(x_n)}{f'(x_n)}$.

**Lagrange Multipliers.** Solve optimization with equality constraints:
$$
&\min f(x)\\
&\text{s.t. } g(x) = 0
$$
is equivalent to find $x$ and $\lambda$ such that $\nabla (f(x)+\lambda g(x)) = 0$​.

e.g. 
$$
\min f(x,y,z) &= x^2+y^2+z^2 \\
\text{s.t. } g(x,y,z) &= 2x+3y+4z-12 =0
$$

$$
\left.\left.\begin{array}{l}{\frac{\partial f}{\partial x}+\lambda\frac{\partial f}{\partial x}=2x+2\lambda=0}\\{\frac{\partial f}{\partial y}+\lambda\frac{\partial f}{\partial y}=2y+3\lambda=0}\\{\frac{\partial f}{\partial z}+\lambda\frac{\partial f}{\partial z}=2z+4\lambda=0}\\{2x+3y+4z-12=0}\end{array}\right.\right\}\Rightarrow\left\{\begin{array}{l}\lambda=-24/29\\x=24/29\\y=36/29\\z=48/29\end{array}\right.\Rightarrow \min f={\left(\frac{24}{29}\right)^2+\left(\frac{36}{29}\right)^2+\left(\frac{48}{29}\right)^2}=\frac{144}{{29}}
$$

## 3.5 Ordinary Differential Equations

**Separable Differential Equations.** 
$$
\frac{dy}{dx}=g(x)h(y) ~~\Rightarrow~~ \frac{dy}{h(y)}=g(x)dx ~~\Rightarrow~~ \int \frac{dy}{h(y)}= \int g(x)dx
$$
**First-order Linear Differential Equations.** 
$$
\frac{dy}{dx}+P(x)y=Q(x) ~~\Rightarrow~~ \left\{\begin{array}{l}I(x)=e^{\int P(x)dx }\\y=\frac{\int I(x)Q(x)dx}{I(x)}\end{array}\right.
$$
**Homogeneous Linear Equations.**
$$
a\frac{d^{2}y}{dx^{2}}+b\frac{dy}{dx}+cy=0
$$
   1.Determine the characteristic polynomial, $q(r)=ar^2+br+c.$ 

2. Factor $q(r)$​ according to the three possibilities: distinct real roots, a double root, complex roots.

    If $r_{1}$ and $r_{2}$ are real and $r_1\neq r_2$, then the general solution is $y=c_1e^{r_1x}+c_2e^{r_2x};$ 

   If $r_1$ and $r_2$ are real and $r_1=r_2=r$, then the general solution is $y=c_1e^{rx}+c_2xe^{rx};$

   If $r_{1}$ and $r_{2}$ are complex numbers $\alpha\pm i\beta$, then the general solution is $y=e^{\alpha x}(c_{1}\cos\beta x+c_{2}\sin\beta x).$

3. Construct $B_q=\{y_1(t),y_2(t)\}$ as given in Sect. 2.6. 4. The solutions $\nu(t)$ are all linear combinations of the functions in the standard basis $\mathcal{B}_q$. In other words,

$$
y(t)=c_{1}y_{1}(t)+c_{2}y_{2}(t)
$$

for $c_1,\:c_2\in\mathbb{R}.$

**Nonhomogeneous Linear Equations.** 
$$
a\frac{d^{2}y}{dx^{2}}+b\frac{dy}{dx}+cy=d(x) ~~\Rightarrow~~ y = y_p(x)+y_g(x)
$$

## 4.4 Discrete  and Continuous Distributions

**Discrete RV.**

![image-20240416141341661](C:\Users\Yaze Li\AppData\Roaming\Typora\typora-user-images\image-20240416141341661.png)

**Continuous RV.**

![image-20240416141508739](C:\Users\Yaze Li\AppData\Roaming\Typora\typora-user-images\image-20240416141508739.png)

## 4.5 Excepted Value, Variance & Covariance

**Covariance.** $Cov(X,Y)=E[(X-E[X])(Y-E[Y])]=E[XY]-E[X]E[Y].$

**Correlation.** $\rho(X,Y)=\frac{Cov(X,Y)}{\sqrt{Var(X)Var(Y)}}$​

## 4.6 Order Statistics

If for RV $X_i$ define $Y_n = \min(X_1,X_2,\cdots,X_n), Z_n = \max(X_1,X_2,\cdots,X_n)$, then:

$F_Y(y) = 1-(1-F_X(x))^n, ~~~~F_Z(z) = F_X(x)^n$

$f_Y(y) = nf_X(x)(1-F_X(x))^{n-1},~~~~f_Z(z) = nf_X(x)(F_X(x))^{n-1}$
