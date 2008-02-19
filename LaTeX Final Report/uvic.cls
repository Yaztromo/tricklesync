%%% UVIC.CLS
%%% Michael Roth 2004

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{uvic}[2004/01/01]

%%% OPTIONS

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{report}}
\ProcessOptions

%%% BASE CLASS FILE IS REPORT.CLS

\LoadClass{report}

%%% PDF SUPPORT

\newif\ifpdf
\ifx\pdfoutput\undefined
	\pdffalse
\else
	\pdfoutput=1
	\pdftrue
\fi

%%% GEOMETRY

\setlength{\hoffset}{0pt}
\setlength{\voffset}{0pt}
\setlength{\oddsidemargin}{0.5in}
\setlength{\evensidemargin}{\oddsidemargin}
\setlength{\textwidth}{432pt}
\setlength{\topmargin}{-24pt}
\setlength{\headheight}{12pt}
\setlength{\headsep}{12pt}
\setlength{\textheight}{648pt}
\setlength{\footskip}{24pt}
\setlength{\marginparsep}{12pt}
\setlength{\marginparwidth}{48pt}
\usepackage{layout}
\raggedbottom

% \renewcommand\floatpagefraction{.9}
% \renewcommand\topfraction{.9}
% \renewcommand\bottomfraction{.9}
% \renewcommand\textfraction{.1}
% \setcounter{totalnumber}{50}
% \setcounter{topnumber}{50}
% \setcounter{bottomnumber}{50}

%%% GRAPHICS

\ifpdf
	\RequirePackage[pdftex]{graphicx}
\else
	\RequirePackage[dvips]{graphicx}	% for including EPS 
graphics files
\fi

%%% PAGE NUMBERING (upper right corner)

\renewcommand{\ps@plain}{%
   \renewcommand{\@oddhead}{\hfil\textrm{\thepage}}%
   \renewcommand{\@evenhead}{\@oddhead}%
   \renewcommand{\@evenfoot}{}%
   \renewcommand{\@oddfoot}{}}

%%% ABSTRACT

\renewenvironment{abstract}[1][\normalfont\bfseries\Large]
{\newpage
\thispagestyle{plain}
\addcontentsline{toc}{chapter}{\abstractname}  %- Have to add it
%\noindent {\bf Supervisor:} \the\supervisor \vskip.5in minus.2in
%\vskip6cm \centerline{\Large\bfseries{Supervisory Committee}}
{\vfil\noindent \bfseries{Supervisory Committee} \vskip5mm \makecommittee}
\nopagebreak
\vskip15mm
\begin{center}%
   {{#1\abstractname}\vspace{\z@}}%
   \vskip1em minus.5em
\end{center}}%
%{\vfil\noindent {\bf Examiners:} \vskip0.5in \makecommittee\eject}

%%% ACKNOWLEDGEMENT

\newenvironment{acknowledge}[1][\normalfont\bfseries\Large]
{\newpage
\thispagestyle{plain}
\addcontentsline{toc}{chapter}{Acknowledgements}  %- Have to add it
%\null\vskip.5in minus .2in
\null\vskip.5in
\begin{center}%
   {{#1 Acknowledgements}\vspace{\z@}}%
   \vskip1em minus.5em
\end{center}}%
{\eject}

%%% TITLEPAGE

\def\captoken#1{\expandafter\uppercase\expandafter{\the\csname #1\endcsname}}
\def\lowtoken#1{\expandafter\lowercase\expandafter{\the\csname #1\endcsname}}
\def\addvbox#1#2{\setbox\csname #1\endcsname=\vbox{\unvbox\csname #1\endcsname%
	\vskip1cm \hbox to14cm{\vrule width14cm height.5pt} %\vskip-2mm%
	\hbox to14cm{\hss{#2}\hss}}}
\newtoks\title\title={(title?)}
\newcommand{\titlestyle}{\Large\bfseries}
\newtoks\author        \author={(author?)}
\newcommand{\authorstyle}{\Large\bfseries}
\newtoks\degree        \degree={(degree?)}
\newcommand{\degreestyle}{\Large\bfseries}
\newtoks\thesistype    \thesistype={(thesistype?)}        %- maybe Dissertation
\newtoks\supervisor    \supervisor={(supervisor?)}  %- For the abstract
\newtoks\department    \department={(department?)}
\newtoks\copyrightyear	\copyrightyear={(copyrightyear?)}
\newbox\degreesbox \setbox\degreesbox=\vbox{}
\def\prevdegree#1{\setbox\degreesbox=\vbox{\unvbox\degreesbox%
\vskip1mm\hbox to14cm{\hss {#1}\hss}}}
\newbox\committeebox \setbox\committeebox=\vbox{}
\newcommand{\committeemember}[1]{\addvbox{committeebox}{#1}}
\def\makecommittee{\centerline{\copy\committeebox}}
\def\maketitlepage{%
\thispagestyle{empty}
%\null\vskip-1cm\null\vskip-1cm  %- We need 2 cause latex gobbles the last one
{\baselineskip14pt \parskip0pt \parindent0pt \def\baselinestretch{1}
           \begin{center} {\noindent\titlestyle\the\title} \end{center}
\baselineskip0pt
\vskip1mm \centerline{by}
\vskip5mm \centerline{\authorstyle\the\author}
\vskip2mm \centerline{\box\degreesbox}
\vskip 0pt plus1fil
\vskip4mm \centerline{A \the\thesistype\ Submitted in
		Partial Fulfillment of the}
\vskip1mm \centerline{Requirements for the Degree of}
\vskip4mm \centerline{\degreestyle\the\degree}
\vskip5mm \centerline{in the \the\department}
\vskip 0pt plus2fil
%	  \centerline{We accept this \lowtoken{thesistype} as conforming}
%\vskip1mm \centerline{to the required standard}
%\vskip.5cm \makecommittee
\vskip2mm
\vskip 0pt plus2fil
	  \centerline{\raisebox{0.25ex}{\copyright}\ \the\author, 
\the\copyrightyear}
\vskip3mm \centerline{University of Victoria}
\vskip3mm \centerline{\itshape All rights reserved. This \lowtoken{thesistype}
		      may not be reproduced in whole or in part by}
\vskip0mm \centerline{\itshape photocopy or other means, without the permission
		      of the author.}}
\eject}

%%% Supervisory Committee

\def\captoken#1{\expandafter\uppercase\expandafter{\the\csname #1\endcsname}}
\def\lowtoken#1{\expandafter\lowercase\expandafter{\the\csname #1\endcsname}}
\def\addvbox#1#2{\setbox\csname #1\endcsname=\vbox{\unvbox\csname #1\endcsname%
	\vskip1cm \hbox to14cm{\vrule width14cm height.5pt} %\vskip-2mm%
	\hbox to14cm{\hss{#2}\hss}}}
\newtoks\title\title={(title?)}
%\newcommand{\titlestyle}{\Large\bfseries}
\newtoks\author        \author={(author?)}
%\newcommand{\authorstyle}{\Large\bfseries}
%\newtoks\degree        \degree={(degree?)}
%\newcommand{\degreestyle}{\Large\bfseries}
\newtoks\thesistype    \thesistype={(thesistype?)}        %- maybe Dissertation
\newtoks\supervisor    \supervisor={(supervisor?)}  %- For the abstract
\newtoks\department    \department={(department?)}
\newtoks\copyrightyear	\copyrightyear={(copyrightyear?)}
\newbox\degreeesbox \setbox\degreeesbox=\vbox{}
\def\preevdegree#1{\setbox\degreeesbox=\vbox{\unvbox\degreeesbox%
\vskip1mm\hbox to14cm{\hss {#1}\hss}}}
\newbox\committeebox \setbox\committeebox=\vbox{}
%\newcommand{\committeemember}[1]{\addvbox{committeebox}{#1}}
\def\makecommittee{\centerline{\copy\committeebox}}
\def\makesupervisorycommittee{%
\thispagestyle{plain}
\addcontentsline{toc}{chapter}{Supervisory Committee}  %- Have to add it
%\null\vskip-1cm\null\vskip-1cm  %- We need 2 cause latex gobbles the last one
{\baselineskip14pt \parskip0pt \parindent0pt \def\baselinestretch{1}
           \begin{center} {\noindent\titlestyle\the\title} \end{center}
\baselineskip0pt
\vskip1mm \centerline{by}
\vskip5mm \centerline{\authorstyle\the\author}
\vskip3mm \centerline{BSc, Brock University, 1999}
%\vskip1mm \centerline{MSc, University of Victoria, 2003}
%\vskip2mm \centerline{\box\degreeesbox}
%\vskip 0pt plus1fil
\vskip6cm \centerline{\Large\bfseries{Supervisory Committee}}
%\vskip 0pt plus2fil
\vskip.5cm \makecommittee
\vskip2mm}
\eject}

%%% PARTIAL COPYRIGHT LICENSE

\newtoks\copyrightpagedate\copyrightpagedate={(date)}
\def\makecopyrightpage#1{%-
\chapter*{University of Victoria\\Partial Copyright License}
\thispagestyle{empty}
%
%\vspace*{.5in}
I hereby grant the right to lend my \lowtoken{thesistype} to users
of the University of Victoria Library, and to make single copies only for
such users or in response to a request from the Library of any other
university, or similar institution, on its behalf or for one of its users.
I further agree that permission for extensive copying of this
\lowtoken{thesistype} for scholarly purposes may be granted by me
or a member of the University designated by me. It is understood that
copying or publication of this \lowtoken{thesistype} for financial
gain shall not be allowed without my written permission.

\vspace{.5in}
\noindent
\setbox0=\hbox{Title of \the\thesistype:\hskip.7em\null}%
\hangindent=\wd0 \hangafter=1 {\box0\the\title.\par}
\vspace{1in}
\begin{flushleft}
\noindent\hbox to.6in{Author:\hfil} \rule{3.5in}{.01in} \\
\hskip.7in \the\author \\
\hskip.7in #1 \\
\end{flushleft}
\eject}

%%% WITHHOLDING FORM

\newtoks\withholdpagedate\withholdpagedate={(date)}
\def\makewithholdpage#1{%-  Needs the date as argument
\chapter*{\the\thesistype\ Withholding Form}
\thispagestyle{empty}
%\vspace*{.5in}
At our request, the commencement of the period for which the partial
licence shall operate shall be delayed from #1 for a period of at
least six months.
\vskip1in minus.3in
\begin{flushleft}
\rule{4in}{.01in} \\ (Supervisor) \\ \vspace{.4in}
\rule{4in}{.01in} \\ (Department Chairman) \\ \vspace{.4in}
\rule{4in}{.01in} \\ (Dean of Graduate Studies) \\ \vspace{.4in}
\rule{4in}{.01in} \\ (Signature of Author) \\ \vspace{.4in}
\rule{4in}{.01in} \\ (Date) \\ \vspace{0.4in}
\parbox{4in}{Date Submitted to the Dean's Office:
\leavevmode\leaders\hrule height 0.01in \hfill\kern\z@}
\end{flushleft}
\eject}

%%% BIBLIOGRAPHY

\RequirePackage{afterpage}

\newcommand{\makebibliography}[2]{%
\bibliographystyle{#1}
\afterpage{\addcontentsline{toc}{chapter}{\bibname}}
\bibliography{#2}}

%%% TABLE OF CONTENTS

\renewcommand{\contentsname}{Table of Contents}
\newcommand{\maketableofcontents}{%
\afterpage{\addcontentsline{toc}{chapter}{\contentsname}}
\setcounter{tocdepth}{1}
\tableofcontents}

%%% LIST OF TABLES

\newcommand{\makelistoftables}{%
\afterpage{\addcontentsline{toc}{chapter}{\listtablename}}
\listoftables}

%%% LIST OF FIGURES

\newcommand{\makelistoffigures}{%
\afterpage{\addcontentsline{toc}{chapter}{\listfigurename}}
\listoffigures}

%%% LIST OF ALGORITHMS

\newcommand{\makelistofalgorithms}{%
\afterpage{\addcontentsline{toc}{chapter}{List of Algorithms}}
\listof{algo}{List of Algorithms}}


%%% APPENDICES
