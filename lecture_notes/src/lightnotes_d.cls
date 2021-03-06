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

#include "packages.tex"
#include "macros.tex"

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
