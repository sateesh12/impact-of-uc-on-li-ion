% gclSolve: A standalone version of glcSolve, independent of TOMLAB
%
% Solves general constrained mixed integer global optimizaion problems.
%
% gclSolve.m implements the algorithm DIRECT by Donald R. Jones presented
% in the paper "DIRECT", Encyclopedia of Optimization, Kluwer Academic
% Publishers 1999.
%
% gclSolve solves problems of the form:
%
% min   f(x)
%  x
% s/t   x_L <=   x  <= x_U
%       b_L <= A x  <= b_U
%       c_L <= c(x) <= c_U
%       x(i) integer, for i in I
%
%
% Calling syntax:
%
% function Result = gclSolve(p_f, p_c, x_L, x_U, A, b_L, b_U,...
%                   c_L, c_U, I, GLOBAL, PriLev, varargin)
%
% INPUT PARAMETERS
%
% p_f      Name of m-file computing the function value.
% p_c      Name of m-file computing the nonlinear constraints.
% x_L      Lower bounds for x
% x_U      Upper bounds for x
% A        Linear constraint matrix.
% b_L      Lower bounds for linear constraints.
% b_U      Upper bounds for linear constraints.
% c_L      Lower bounds for nonlinear constraints.
% c_U      Upper bounds for nonlinear constraints.
% I        Set of integer variables, default I=[].
%
% GLOBAL.MaxEval      Number of function evaluations to run, default 200.
% GLOBAL.epsilon      Global/local search weight parameter, default 1E-4.
%
% If restart is wanted, the following fields in GLOBAL should be defined
% and equal the corresonding fields in the Result structure from the
% previous run: 
%
% GLOBAL.C          Matrix with all rectangle centerpoints.
% GLOBAL.D          Vector with distances from centerpoint to the vertices.
% GLOBAL.F          Vector with function values.
% GLOBAL.Split      Split(i,j) = # splits along dimension i of rectangle j
% GLOBAL.T          T(i) is the number of times rectangle i has been trisected.
% GLOBAL.G          Matrix with constraint values for each point.
% GLOBAL.ignoreidx  Rectangles to be ignored in the rect. selection proceedure.
% GLOBAL.I_L        I_L(i,j) is the lower bound for rect. j in integer dim. I(i)
% GLOBAL.I_U        I_U(i,j) is the upper bound for rect. j in integer dim. I(i)
% GLOBAL.feasible   Flag indicating if a feasible point has been found.
% GLOBAL.f_min      Best function value found at a feasible point.
% GLOBAL.s_0        s_0 is used as s(0)
% GLOBAL.s          s(j) is the sum of observed rates of change for constraint j.
% GLOBAL.t          t(i) is the total # splits along dimension i.
%
% PriLev            Printing level:
%                   PriLev >= 0   Warnings  
%                   PriLev >  0   Each iteration info  
%
% OUTPUT PARAMETERS
%        
% Result      Structure with results from optimization:
%    x_k       Matrix with optimal points as columns.
%    f_k       Function value at optimum.
%    c_k       Nonlinear constraints values at x_k
%    Iter      Number of iterations.
%    FuncEv    Number of function evaluations.
%    GLOBAL, special structure field (to make restart possible) containing:
%      C          Matrix with all rectangle centerpoints.
%      D          Vector with distances from centerpoint to the vertices.
%      F          Vector with function values.
%      Split      Split(i,j) = # splits along dimension i of rectangle j
%      T          T(i) is the number of times rectangle i has been trisected.
%      G          Matrix with constraint values for each point.
%      ignoreidx  Rectangles to be ignored in the rect. selection proceedure.
%      I_L        I_L(i,j) is the lower bound for rect. j in integer dim. I(i)
%      I_U        I_U(i,j) is the upper bound for rect. j in integer dim. I(i)
%      feasible   Flag indicating if a feasible point has been found.
%      f_min      Best function value found at a feasible point.
%      s_0        s_0 is used as s(0)
%      s          s(j) is the sum of observed rates of change for constraint j.
%      t          t(i) is the total # splits along dimension i.
%
%
% Kenneth Holmstrom, HKH MatrisAnalys AB, E-mail: hkh@acm.org.
% Copyright (c) 1999 by HKH MatrisAnalys AB, Sweden. $Revision: 1.0 $
% Written Apr 8, 1999.   Last modified Sep 9, 1999.
%