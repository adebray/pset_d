\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{lightnotes_d}[2016/5/10 Arun Debray's minimal notes template]
% I found myself making the same few changes when using minnotes_d, so I created
% this class, which applies all of my macros (functionality) changes, and a very few
% style changes.
%
% Provides a way to check whether this class is being used
\def\UsingLightNotesD{}
%
% For now, this is a one-off that disables the " -> ^(...) feature.
% If you want to use Hood's spectralsequences package, you will encounter bizarre errors unless
% you use the no_quotes option.
\DeclareOption{quotes}{\def\qu@es{YES}}
\DeclareOption{no_quotes}{\def\noqu@es{}}
\ExecuteOptions{quotes}
% Avoids redefining \H to be the quaterions, which causes a problem when writing double accute accents.
% The most common example is "Erdős".
\DeclareOption{redefine_H}{\def\redef@H{YES}}
\DeclareOption{no_redefine_H}{\def\noredef@H}
\ExecuteOptions{redefine_H}
% Other options can be handed off to the amsart class (e.g. fontsize)
% I want to double-check that I am doing option-passing correctly.
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{amsart}}
\ProcessOptions\relax
%
\LoadClass{amsart}
% This has to be put before cleveref for links to work correctly
\numberwithin{equation}{section}
%
\RequirePackage[utf8]{inputenc}
\RequirePackage[T1]{fontenc} % this and the next package needed to use ogoneks
\RequirePackage{lmodern} % TODO: does this work with other fonts?
% Keeping this because, even for minimal notes, makes printing take up considerably less paper
\RequirePackage[margin=1in]{geometry}
\RequirePackage[usenames, dvipsnames]{xcolor}
\RequirePackage{graphicx}
\RequirePackage{mathtools}
\RequirePackage{amssymb}
\RequirePackage{amsthm}
\RequirePackage{xparse}
\RequirePackage{xspace}
\RequirePackage{mathrsfs}
\RequirePackage[all]{xy}
\RequirePackage{adforn}
\RequirePackage[backref=page]{hyperref}
\RequirePackage[all]{hypcap}
\RequirePackage[capitalize, noabbrev]{cleveref}
% Some shortcuts that simplify live-TeXing using XY.
%
% Forces all XY entries to be typeset with displaymath, which is much more
% common for me
\everyentry={\displaystyle}
%
% Short exact sequences: write
% \shortexact[f][g]{A}{B}{C}, for:
%
% f g
% 0 -> A -> B -> C -> 0,
% (or 1 -> A -> B -> C -> 1 with a star)
\DeclareDocumentCommand{\shortexact}{s O{} O{} mmmm}{
\IfBooleanTF{#1}{ % if star
 \xymatrix{
  1\ar[r] & #4\ar[r]^-{#2} & #5\ar[r]^-{#3} & #6\ar[r] & 1#7
 }
}{ % no star
 \xymatrix{
  0\ar[r] & #4\ar[r]^-{#2} & #5\ar[r]^-{#3} & #6\ar[r] & 0#7
 }
}}
% exactly the same, but for 0 -> A -> B -> C
\DeclareDocumentCommand{\leftexact}{O{} O{} mmmm}{
\xymatrix{
 0\ar[r] & #3\ar[r]^-{#1} & #4\ar[r]^-{#2} & #5 #6
}}
% ... and the same, for A -> B -> C -> 0
\DeclareDocumentCommand{\rightexact}{O{} O{} mmmm}{
\xymatrix{
 {#3}\ar[r]^-{#1} & #4\ar[r]^-{#2} & #5\ar[r] & 0#6
}}
%
% Double right arrow, which I found myself writing a lot (e.g. equalizer, kernel,
% or cokernel diagrams)
% usage:
% X\dblarrow[r][f][g] & Y
% f
% X => Y
% g
% Since LaTeX is parsing a class file, we need to tell it that @ is not part of the
% \ar command, or we get some opaque errors.
\makeatother
\DeclareDocumentCommand{\dblarrow}{O{} O{} O{}}{%
 \ar@<0.4ex>[#1]^-{#2}\ar@<-0.4ex>[#1]_-{#3}%
}
% Note: it would be a useful exercise to figure out how to define this so it can
% be used as \dblarrow[r]^f_g.
%
% Useful for morphisms in overcategories (aka slice categories), such as vector bundles,
% covering spaces, field extensions, schemes over a base... or just commutative triangles
% Usage: \overtriangle[f][\pi_1][\pi_2]{X_1}{X_2}{B}.
% Note: the last argument is punctuation; if you don't want punctuation, pass it as {}
\DeclareDocumentCommand{\overtriangle}{O{} O{} O{} mmmm}{
\xymatrix@C=0.4cm{
 {#4}\ar[rr]^{#1}\ar[dr]_{#2} && {#5}\ar[dl]^{#3}\\ % comment for cpp. Don't delete
 & {#6 #7}
}}
\makeatletter
%
% TODO: do I want these going in the other direction?
% Source: http://tug.org/pipermail/xy-pic/2001-July/000015.html
\newcommand{\pullbackcorner}[1][dr]{\save*!/#1+1.2pc/#1:(1,-1)@^{|-}\restore}
\newcommand{\pushoutcorner}[1][dr]{\save*!/#1-1.2pc/#1:(-1,1)@^{|-}\restore}
%
% TODO more? Especially pullback or pushout squares.
%
% An xymatrix environment wrapped in gathered to ensure its equation number is vertically centered
\newcommand{\gathxy}[2][]{%
\begin{gathered}
\xymatrix#1{#2}
\end{gathered}
}
% Mathematicians have lots of fancy fonts
% TODO: Hood has a way to define a whole bunch of these at once
% \mathbb -- notable sets
% TODO: would be nice to allow people to override \mathbb with \mathbf
\newcommand{\A}{\mathbb A} % affine space
\newcommand{\C}{\mathbb C} % complex numbers
\newcommand{\D}{\mathbb D} % unit disc inside \C
\newcommand{\E}{\mathbb E} % expected value, family of operads
\newcommand{\F}{\mathbb F} % finite fields
\newcommand{\G}{\mathbb G} % additive/multiplicative groups
\ifdefined\noredef@H
\else
\AtBeginDocument{ % some fonts redefine this (e.g. charter)
 \let\oldH\H
 \renewcommand{\H}{\mathbb H}
}
\fi
\newcommand{\N}{\mathbb N} % natural numbers
\renewcommand{\P}{\mathbb P} % probability, projective space
\newcommand{\Q}{\mathbb Q} % rational numbers
\newcommand{\R}{\mathbb R} % real numbers
\newcommand{\Sph}{\mathbb S} % sphere spectrum
\newcommand{\T}{\mathbb T} % circle group
\newcommand{\Z}{\mathbb Z} % integers
\newcommand{\RP}{\mathbb{RP}} % real projective space
\newcommand{\CP}{\mathbb{CP}} % complex projective space
% \mathcal -- lots of different things
\newcommand{\cA}{\mathcal A} % Steenrod algebra, etc.
\newcommand{\cB}{\mathcal B} % bundles of frames
\newcommand{\cG}{\mathcal G} % groupoid
\newcommand{\cH}{\mathcal H} % Hilbert space
\newcommand{\cM}{\mathcal M} % moduli space
\newcommand{\cX}{\mathcal X} % vector fields, tangential structures
% \mathfrak -- Lie algebras, open covers, prime ideals
\newcommand{\p}{\mathfrak p} % prime ideal
\newcommand{\q}{\mathfrak q} % another prime ideal
\newcommand{\m}{\mathfrak m} % maximal ideal
\newcommand{\fg}{\mathfrak g} % general Lie algebra
\newcommand{\gl}{\mathfrak{gl}} % general linear Lie algebra
\renewcommand{\sl}{\mathfrak{sl}} % special linear
\renewcommand{\sp}{\mathfrak{sp}} % symplectic
\newcommand{\fo}{\mathfrak o} % orthogonal
\newcommand{\so}{\mathfrak{so}} % special orthogonal
\newcommand{\fu}{\mathfrak u} % unitary
\newcommand{\su}{\mathfrak{su}} % special unitary
\newcommand{\fU}{\mathfrak U} % open covers, à la Bott-Tu
% \mathrm -- usually Lie groups
\newcommand{\GL}{\mathrm{GL}} % general linear
\newcommand{\SL}{\mathrm{SL}} % special linear
\AtBeginDocument{ % redefined by mathdesign
 \renewcommand{\O}{\mathrm O} % orthogonal
}
\newcommand{\SO}{\mathrm{SO}} % special orthogonal
\newcommand{\U}{\mathrm U} % unitary
\newcommand{\SU}{\mathrm{SU}} % special unitary
\newcommand{\Sp}{\mathrm{Sp}} % symplectic
\newcommand{\Spin}{\mathrm{Spin}} % spin
\newcommand{\Pin}{\mathrm{Pin}} % pin
\newcommand{\PGL}{\mathrm{PGL}} % projective general linear
\newcommand{\PSL}{\mathrm{PSL}} % projective special linear
% The uppercase version is for mathmode or the beginning of a sentence in textmode.
% The lowercase version is for the middle of a sentence in textmode.
% \Pinp for pin+, \Pinm for pin-
% TODO: it would be "fun" to make a macro for these kinds of definitions
\newcommand{\Spinc}{\relax\ifmmode{\Spin^c}\else Spin\textsuperscript{$c$}\xspace\fi}
\newcommand{\spinc}{spin\textsuperscript{$c$}\xspace}
\newcommand{\Pinc}{\relax\ifmmode{\Pin^c}\else Pin\textsuperscript{$c$}\xspace\fi}
\newcommand{\pinc}{pin\textsuperscript{$c$}\xspace}
\newcommand{\Pinp}{\relax\ifmmode{\Pin^+}\else Pin\textsuperscript{$+$}\xspace\fi}
\newcommand{\pinp}{pin\textsuperscript{$+$}\xspace}
\newcommand{\Pinm}{\relax\ifmmode{\Pin^-}\else Pin\textsuperscript{$-$}\xspace\fi}
\newcommand{\pinm}{pin\textsuperscript{$-$}\xspace}
% \mathscr -- usually sheaves
\newcommand{\sF}{\mathscr F} % sheaf
\newcommand{\sG}{\mathscr G} % sheaf
\newcommand{\sH}{\mathscr H} % sheaf
\newcommand{\sI}{\mathscr I} % sheaf of ideals, index category
\newcommand{\sL}{\mathscr L} % line bundle
\newcommand{\sM}{\mathscr M} % quasicoherent sheaf
\newcommand{\sO}{\mathscr O} % ring of functions
% \mathsf -- categories
% TODO: flag to switch with mathsf
%\newcommand{\cat}{\mathsf}
% playing around
\RequirePackage[mathscr]{eucal}
\def\instring#1#2{TT\fi\begingroup
  \edef\x{\endgroup\noexpand\in@{#1}{#2}}\x\ifin@}
%
\def\isuppercase#1{%
  \instring{#1}{ABCDEFGHIJKLMNOPQRSTUVWXYZ}%
}%
\newcommand{\C@lIfUpper}[1]{
 \if\isuppercase{#1}\mathscr{#1}%
 \else #1%
 \fi
}
\newcommand{\cat}[1]{\mathit{\@tfor\next:=#1\do{\C@lIfUpper{\next}}}}
% The user can redefine \cat to be something else (e.g. mathbf). However, I'd also
% like them to be able to redefine things like Set, Grp, and so forth without having
% to use AtBeginDocument.
% TODO: do I even need this AtBeginDocument here...?
\newcommand{\newcat}[2]{\newcommand{#1}{\cat{#2}}}
\AtBeginDocument{
 \newcat{\fC}{C}
 \newcat{\fD}{D}
 \newcat{\Set}{Set} % sets
 \newcat{\Grp}{Grp} % groups
 \newcat{\Gpd}{Gpd} % groupoids
 \newcat{\Ab}{Ab} % abelian groups
 \newcat{\Ring}{Ring} % rings
 \newcat{\Mod}{Mod} % modules (over a ring)
 \newcat{\Alg}{Alg} % algebras (over a ring)
 \newcat{\Vect}{Vect} % vector spaces (over a field)
 \newcat{\sVect}{sVect} % super-vector-spaces
 \def\Top{\cat{Top}} % topological space (sometimes already defined, e.g. by kpfonts)
 % TODO what other categories of topological/geometric objects do I need?
 \newcat{\LocRing}{LocRing} % locally ringed spaces
 \newcat{\AffSch}{AffSch} % affine schemes
 \newcat{\Sch}{Sch} % schemes
 \newcat{\sSet}{sSet} % simplicial sets
 \newcat{\Man}{Man} % manifolds
 \newcat{\Fun}{Fun} % functor categories
 \newcat{\Rep}{Rep} % representations
}
% Setting up some theorem environments
%
% The "exampx" and similar provisional environments are in use so that I can
% append a marker at the end of examples, remarks, claims, facts, and notes.
% (Of course, it would be good for me to determine how to do this automatically.)
% Source: http://tex.stackexchange.com/a/32394/
%
\newtheorem{thm}[equation]{Theorem}
\newtheorem{lem}[equation]{Lemma}
\newtheorem{cor}[equation]{Corollary}
\newtheorem{prop}[equation]{Proposition}
\theoremstyle{definition}
\newtheorem{ex}[equation]{Exercise}
\newtheorem{exampx}[equation]{Example}
\newtheorem{defn}[equation]{Definition}
\newtheorem{claim}[equation]{Claim}
% TODO: add ending mark for these?
\newtheorem{conj}[equation]{Conjecture}
\newtheorem{ques}[equation]{Question}
\theoremstyle{remark}
\newtheorem{remx}[equation]{Remark}
\newtheorem*{fctx}{Fact}
\newtheorem*{notex}{Note}
%
%
\newcommand{\exampleQED}{\smash\adfhalfleftarrowhead}
\newenvironment{exm}
  {\pushQED{\qed}\renewcommand{\qedsymbol}{\exampleQED}\exampx}
  {\popQED\endexampx}
\newenvironment{rem}
  {\pushQED{\qed}\renewcommand{\qedsymbol}{\exampleQED}\remx}
  {\popQED\endremx}
\newenvironment{fct}
  {\pushQED{\qed}\renewcommand{\qedsymbol}{\exampleQED}\fctx}
  {\popQED\endfctx}
\newenvironment{note}
  {\pushQED{\qed}\renewcommand{\qedsymbol}{\exampleQED}\notex}
  {\popQED\endnotex}
% NOTE: if you try to use a proof inside an example, remark, or fact, the QED symbol will be wrong
% you can restore it as follows
% WARNING: this is currently a kludge. I would like this to be dealt with automatically, and also
% only use boxtimes if I've turned on style
\newcommand{\insideexample}{\renewcommand{\qedsymbol}{\small{\ensuremath\boxtimes}}}
%
%
% Another possibility: "definition-theorems" as used in universal properties
% I will probably also want starred theorems (propositions, subsections, etc.).
% Crefnames, allowing me to reference multiple theorems at once
\crefname{thm}{Theorem}{Theorems}
\crefname{lem}{Lemma}{Lemmas}
\crefname{cor}{Corollary}{Corollaries}
\crefname{prop}{Proposition}{Propositions}
\crefname{ex}{Exercise}{Exercises}
\crefname{exampx}{Example}{Examples}
\crefname{defn}{Definition}{Definitions}
\crefname{claim}{Claim}{Claims}
\crefname{remx}{Remark}{Remarks}
\crefname{fctx}{Fact}{Facts}
\crefname{notex}{Note}{Notes}
% Unfortunately, this has to be placed before loading the cleveref package, so it's
% in packages.tex.
% \numberwithin{equation}{section}
%
% This could be considered a stylistic choice, but works much better with how I use
% subsections as subject changes in a lecture.
\setcounter{tocdepth}{1}
%
% These can be changed downstream
\newcommand{\term}{\emph} % e.g. "The \term{trace} is defined to be..."
\newcommand{\latin}{\textit} % e.g. \latin{per se}, \latin{mutatis mutandis}
%
% Often, I find myself making a theorem, definition, etc. that's purely a combination
% of statements, either bulleted or numbered. In that case, using \hfill typesets each
% item uniformly. It would probably be best to make this into a custom enumitem
% environment, especially if I want to refer to specific items (e.g. 12.2.1 inside
% Theorem 12.2).
% Usage: \begin{comp}[eggs]{thm}{enumerate}
% \item
% \end{comp}
% sets up an enumerate environment inside a theorem, and labels it "eggs."
\NewDocumentEnvironment{comp}{omm}{%
 \csname #2\endcsname\hfill
 % check for optional argument
 \IfNoValueF{#1}{
  \label{#1}
 }
 \csname #3\endcsname
}{
 \csname end#3\endcsname
 \csname end#2\endcsname
}
%
% since I find myself using \renewcommand{...}{\operatorname{...}} a lot.
% possible TODO: also define a starred version?
% could also define \ProvideMathOperator but I wouldn't use that at all
\newcommand{\RenewMathOperator}[2]{\renewcommand{#1}{\operatorname{#2}}}
%
% other shortcuts I use for live-TeXing
\newcommand{\vp}{\varphi}
\newcommand{\e}{\varepsilon}
\newcommand{\inj}{\hookrightarrow}
\newcommand{\surj}{\twoheadrightarrow}
\newcommand{\id}{\mathrm{id}}
\newcommand{\pt}{\mathrm{pt}}
\newcommand{\many}[2][\dotsb]{#2 #1 #2} % optional argument for kind of dots
\newcommand{\TFAE}{The following are equivalent}
\newcommand{\TODO}{\textcolor{red}{TODO}}
%
% use a longer \mapsto in display math
\let\shortmapsto\mapsto
\renewcommand{\mapsto}{\mathchoice{\longmapsto}{\shortmapsto}{\shortmapsto}{\shortmapsto}}
%
% Use \ud for things that need additional space, e.g. f(x) dx (in integrals or for
% differential forms). \d is for things that don't (e.g. after a wedge, or just dx on
% its own). I would be interested in unifying them.
% Some packages that I use often (e.g. font packages) overwrite \d, and therefore this
% class needs to define \d after it's overwritten, which is why I use \AtBeginDocument.
\AtBeginDocument{
 \newcommand{\ud}{\,\mathrm{d}}
 \renewcommand{\d}{\mathrm d}
 % accepts optional argument for higher derivatives
 \newcommand{\dfr}[3][]{\frac{\mathrm d^{#1} #2}{\mathrm d #3{}^{#1}}}
 \newcommand{\@dpfr}[3][]{\frac{\partial^{#1} #2}{\partial #3{}^{#1}}}
 \newcommand{\@spfr}[3][]{\partial^{#1} #2 / \partial #3{}^{#1}}
 \newcommand{\pfr}[3][]{\mathchoice{\@dpfr[#1]{#2}{#3}}{\@dpfr[#1]{#2}{#3}}
  {\@spfr[#1]{#2}{#3}}{\@spfr[#1]{#2}{#3}}}
 \newcommand{\mixedpfr}[3]{\frac{\partial^2 #1}{\partial #2 \partial #3}}
}
%
% This allows \paren{...} to replace \left(...\right) (and similarly for \bkt). For
% \ang, \set, \abs, and \norm, I find myself using autoexpansion less often.
% This code, along with some other shortcuts, is duplicated in my problem set template;
% perhaps I should have them include a common file?
\DeclarePairedDelimiter\paren{(}{)}
\DeclarePairedDelimiter\ang{\langle}{\rangle}
\DeclarePairedDelimiter\abs{\lvert}{\rvert}
\DeclarePairedDelimiter\norm{\lVert}{\rVert}
\DeclarePairedDelimiter\bkt{[}{]}
\DeclarePairedDelimiter\set{\{}{\}}
\DeclarePairedDelimiter\bra{\langle}{\rvert}
\DeclarePairedDelimiter\ket{\lvert}{\rangle}
% Swap paren* and paren, etc., so that the normal version resizes by default.
% Meanwhile, one can use \paren*[\Big]{...} to customize the size easily.
\let\oldparen\paren
\def\paren{\@ifstar{\oldparen}{\oldparen*}}
\let\oldbkt\bkt
\def\bkt{\@ifstar{\oldbkt}{\oldbkt*}}
%
% This allows a"1 as a shortcut for a^{(1)} and a"{10} as a shortcut for a^{(10)}.
\ifdefined\noqu@es
\else
 \AtBeginDocument{\catcode`\"=13}
 \catcode`\"=13
 \newcommand*{"}[1]{^{(#1)}}%
 \catcode`\"12
\fi
%
% Now, for a bunch of field-specific commands.
% TODO: document
% TODO: starred command, perhaps as http://tex.stackexchange.com/a/4388/
\newcommand{\newoperator}[1]{\expandafter\DeclareMathOperator\csname #1\endcsname{\operatorname{#1}}}
%
% Algebra
\newoperator{Ann}
\newoperator{Aut}
\newoperator{Cliff}
\DeclareMathOperator{\chr}{char}
\newoperator{coker}
\newoperator{End}
\newoperator{Ext}
\newoperator{Frac}
\newoperator{Gal}
\newoperator{Hom}
\AtBeginDocument{ % some packages redefine this
 \RenewMathOperator{\Im}{Im} % also complex analysis
}
\newoperator{Mat}
\newcommand{\op}{^{\cat{op}}} % for the opposite of a category
\newcommand{\rop}{^{\mathrm{op}}} % for the opposite of an algebra or monoid
\newoperator{rank}
\newoperator{sign}
\DeclareMathOperator{\spa}{span}
\newoperator{Stab}
\newoperator{Sym}
%TODO better name (conflicts w/ circle group)
%\newcommand{\T}{^{\mathrm T}} % tranpose TODO where does the \! go?
\newoperator{Tor}
\newoperator{tr}
\newcommand{\bl}{\text{--}}
%
% Algebraic Geometry
\newoperator{Proj}
\newoperator{QCoh}
\newoperator{res} % also complex analysis
\newoperator{Spec}
%
% Algebraic Topology
\newcommand{\Gr}{\mathrm{Gr}} % Grassmannian -- perhaps move to letters.tex
\newcommand{\hdr}{H_{\mathrm{dR}}}
\newcommand{\Cl}{\mathit{C\ell}}
\newcommand{\KO}{\mathit{KO}}
\newcommand{\KU}{\mathit{KU}}
\newcommand{\KR}{\mathit{KR}}
\newcommand{\ko}{\mathit{ko}}
\newcommand{\ku}{\mathit{ku}}
\newcommand{\Sq}{\mathrm{Sq}}
\newcommand{\wH}{\widetilde H}
\DeclareMathOperator*{\colim}{colim} % colimit notation in homotopy theory
\DeclareMathOperator*{\holim}{holim} % homotopy limit
\DeclareMathOperator*{\hocolim}{hocolim} % homotopy colimit
% some Thom spectra
% TODO: maybe a command to define a whole bunch at once
% or a command for Lie groups: define \G, \MG, \MTG
% calling \NewThomSpectrum{G} defines \MG -> \mathit{MG}
% calling \NewMTSpectrum{G} defines \MTG -> \mathit{MTG}
\newcommand{\NewThomSpectrum}[1]{\expandafter\newcommand\csname M#1\endcsname{\mathit{M#1}}}
\newcommand{\NewMTSpectrum}[1]{\expandafter\newcommand\csname MT#1\endcsname{\mathit{MT#1}}}
\newcommand{\BothThomSpectra}[1]{\NewThomSpectrum{#1}\NewMTSpectrum{#1}}
\BothThomSpectra{O}
\BothThomSpectra{SO}
\BothThomSpectra{Spin}
\BothThomSpectra{Pin}
\BothThomSpectra{U} % TODO: I haven't tested these
%\newcommand{\MR}{\mathit{MR}}
%
% Complex analysis
% note: Re and Im changes are technically style changes, but almost everyone uses this notation
\AtBeginDocument{
 \RenewMathOperator{\Re}{Re}
}
\newcommand{\delbar}{\overline\partial}
%
% Topology
\newoperator{codim}
\newoperator{crit}
\newoperator{curl}
\newoperator{Diff}
\RenewMathOperator{\div}{div}
\newoperator{ind}
\newoperator{supp}
%
% TQFT
\newcommand{\Bord}{\cat{Bord}}
\newcommand{\TQFT}{\cat{TQFT}}
\newcommand{\fr}{^{\mathrm{fr}}}
%
% to be continued (e.g. a good argmin and argmax)
% style changes
\pagestyle{plain}
\renewcommand{\qedsymbol}{\small{\ensuremath{\boxtimes}}}
%
\AtBeginDocument{
 % this needs to come after any fonts loaded
 \usepackage{microtype}
}
\usepackage{hyperref}
\hypersetup{
 colorlinks,
 linkcolor={red!50!black},
 citecolor={green!50!black},
 urlcolor={blue!80!black}
}
