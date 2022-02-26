% What's New in ADVISOR
% 
% 

<center>
User Definable Scaling Relationships
====================================

</center>
Prior to version 3.2, the secondary effects of the component scaling
where assumed to be completely linear and were embedded within the
component block diagrams and in miscellanous script files. In version
3.2, we have introduced user definable scaling relationships within the
component datafiles. This allows users to develop and apply their own
secondary scaling relationships. The primary impacts are still assumed
to be linear. For example, changing fc\_trq\_scale from 1.0 to 1.1 still
means that the torque capability of the engine will increase by 10%.
However, you can now define the relationship between fc\_trq\_scale and
engine mass. Since the change in mass due to an increase in torque
output is not necessarily directly proportional (i.e. you could change
any number of engine parameters to provide more torque with out
significantly changing the engine block and accessories) therefore the
relationship might be defined as fc\_mass=fc\_base\_mass \* 0.25 \*
fc\_trq\_scale. You could also include non-linear relationships like
fc\_mass=fc\_base\_mass\*(0.02\*(fc\_trq\_scale)\^2+0.5\*fc\_trq\_scale)+50
which would provide a engine mass that asymptotically approaches 50 kg
as the fc\_trq\_scale approaches zero and increases via a second order
relationship with increasing torque capability. Since this functionality
has been implemented using inline functions, there really are no
limitations as to the form of the function other than that you include
all of the terms in the equation definition. If you need more
information on using inline functions please refer to the matlab
documentation.  There are a set of required input parameters however you
are not required to use any of them.

<p>
The basic functional relationships are defined in table 1. \
 

<center>
  --------------------- ----------------------- ------------------------------------------------- -------------------------------------------------
  **Component**         **Required Input ** \   **Output**                                        **Default Equation**
                        **Parameters**                                                            

  fuel converter        fc\_spd\_scale \        fc\_mass                                          fc\_mass=(fc\_base\_mass+fc\_acc\_mass)\*  \
                        fc\_trq\_scale \                                                          (c1\*fc\_trq\_scale+c2)\* \
                        fc\_base\_mass \                                                          (c3\*fc\_spd\_scale+c4)+fc\_fuel\_mass \
                        fc\_acc\_mass \                                                           c1=c3=1; c2=c4=0
                        fc\_fuel\_mass                                                            

  energy storage  \     ess\_module\_num \      ess\_mass                                         ess\_mass=(ess\_module\_mass)\*  \
  system (mass)         ess\_cap\_scale \                                                         (c1\*ess\_module\_num+c2)\* \
                        ess\_module\_mass                                                         (c3\*ess\_cap\_scale+c4) \
                                                                                                  c1=c3=1; c2=c4=0

  exhaust system        fc\_pwr\_scale \        ex\_mass                                          ex\_mass=(ex\_mass)\* (c1\*fc\_pwr\_scale+c2) \
                        ex\_mass                                                                  c1=1; c2=0

  motor controller      mc\_spd\_scale \        mc\_mass                                          mc\_mass=(mc\_mass)\*  \
                        mc\_trq\_scale \                                                          (c1\*mc\_trq\_scale+c2)\* \
                        mc\_mass                                                                  (c3\*mc\_spd\_scale+c4) \
                                                                                                  c1=c3=1; c2=c4=0

  generator             gc\_spd\_scale \        gc\_mass                                          gc\_mass=(gc\_mass)\* \
                        gc\_trq\_scale \                                                          (c1\*gc\_trq\_scale+c2)\* \
                        gc\_mass                                                                  (c3\*gc\_spd\_scale+c4) \
                                                                                                  c1=c3=1; c2=c4=0

  transmission          gb\_spd\_scale \        tx\_mass                                          tx\_mass=(fd\_mass+gb\_mass)\*  \
                        gb\_trq\_scale \                                                          (c1\*gb\_trq\_scale+c2)\* \
                        fd\_mass \                                                                (c3\*gb\_spd\_scale+c4) \
                        gb\_mass                                                                  c1=c3=1; c2=c4=0

  energy storage  \     ess\_module\_num \      resistance scale factor  \                        scale\_factor=(c1\*ess\_module\_num+c2)/ \
  system (resistance)   ess\_cap\_scale         (i.e. scaled resistance = base resistance \*  \   (c3\*ess\_cap\_scale+c4) \
                                                f(ess\_module\_num,ess\_cap\_scale)               c1=c3=1; c2=c4=0
  --------------------- ----------------------- ------------------------------------------------- -------------------------------------------------

</center>
How to define your own scaling relationships

To use this functionality, you must define 1) the equation and 2) the
coefficients of the equation.  Within each component file you will find
a variable \*scale\_fun and \*scale\_coef.  The first defines the
equation to be used and the second defines the coefficients of the
equation.  For example in the fuel\_converter file,

% user definable mass scaling function \
fc\_mass\_scale\_fun=inline(’(x(1)\*fc\_trq\_scale+x(2))\*(x(3)\*fc\_spd\_scale+x(4))\*(fc\_base\_mass+fc\_acc\_mass)+fc\_fuel\_mass’,’x’,’fc\_spd\_scale’,’fc\_trq\_scale’,’fc\_base\_mass’,’fc\_acc\_mass’,’fc\_fuel\_mass’);
\
fc\_mass\_scale\_coef=[1 0 1 0]; % coefficients of mass scaling function

To customize this relationship you may either change the coefficient
values or modify the relationship itself.  To change the relationship,
redefine the first string in the fc\_mass\_scale\_fun definition.  **DO
NOT CHANGE** any other portion of this definition.  Your customized
relationship **MUST NOT USE** variables other than those listed in the
rest of the inline function definition.

The easiest way to develop your own relatioship is to create a fit to
empirical data.  For example if we plot the module mass vs. ah capacity
for the four NiMH battery modules in our library manufactured by Ovonic,
Inc. we result in a relationship of the following form:

ess\_mass = ess\_mass \* (c1 \* ess\_cap\_scale + c2) \
where c1=\>\>\> and c2=\>\>\>.

You should use caution in applying user definable scaling
relationships.  Be aware that the relationships are only valid within
the range of data that was used to develop the fit and should be
developed based on similar technology type (e.g. all Li-ion, all SI, all
CI,- not a mixture of CI and SI). \
 

* * * * *

<center>
<p>
[Return to ADVISOR Documentation](advisor_doc.html)

</center>

* * * * *

<p>
Last revised: [8/19/01] tm
